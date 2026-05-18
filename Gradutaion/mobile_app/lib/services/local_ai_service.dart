import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../core/config/dev_settings.dart';
import '../models/message.dart';

/// Result from STT transcription
class TranscriptionResult {
  final String text;
  final double confidence;
  final String language;
  final String model;

  TranscriptionResult({
    required this.text,
    required this.confidence,
    required this.language,
    required this.model,
  });

  factory TranscriptionResult.fromJson(Map<String, dynamic> json) {
    return TranscriptionResult(
      text: json['text'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      language: json['language'] as String,
      model: json['model'] as String,
    );
  }
}

/// Result from TTS synthesis with visemes for lip-sync
class SynthesisResult {
  final Uint8List audioData;
  final List<Viseme> visemes;
  final int durationMs;

  SynthesisResult({
    required this.audioData,
    required this.visemes,
    required this.durationMs,
  });
}

/// Viseme for lip-sync animation
class Viseme {
  final String phoneme;
  final int timestampMs;
  final int durationMs;
  final String mouthShape;

  Viseme({
    required this.phoneme,
    required this.timestampMs,
    required this.durationMs,
    required this.mouthShape,
  });

  factory Viseme.fromJson(Map<String, dynamic> json) {
    return Viseme(
      phoneme: json['phoneme'] as String,
      timestampMs: json['timestamp_ms'] as int,
      durationMs: json['duration_ms'] as int,
      mouthShape: json['mouth_shape'] as String,
    );
  }
}

/// LLM response with metadata
class LLMResponse {
  final String text;
  final int responseTimeMs;
  final int tokenCount;
  final String model;

  LLMResponse({
    required this.text,
    required this.responseTimeMs,
    required this.tokenCount,
    required this.model,
  });

  factory LLMResponse.fromJson(Map<String, dynamic> json) {
    return LLMResponse(
      text: json['text'] as String,
      responseTimeMs: json['response_time_ms'] as int,
      tokenCount: json['token_count'] as int,
      model: json['model'] as String,
    );
  }
}

/// Local AI Service for Whisper STT, Qwen LLM, and Coqui TTS
/// 
/// Communicates with Python backend running local AI models:
/// - Whisper: E:\Projects\Models\Whisper\whisper-small-egyptian-arabic
/// - Qwen: E:\Projects\Models\LLMs\Qwen\Qwen3-4B-ggfu
/// - Coqui TTS: E:\Projects\Models\TTS
class LocalAIService {
  static final LocalAIService _instance = LocalAIService._internal();
  factory LocalAIService() => _instance;
  LocalAIService._internal();

  /// Backend base URL (configurable)
  String _baseUrl = 'http://localhost:8000';

  /// Timeout for AI operations
  static const Duration _timeout = Duration(seconds: 30);

  /// HTTP client
  final http.Client _client = http.Client();

  /// Model initialization status
  bool _isInitialized = false;
  Map<String, dynamic>? _modelInfo;

  /// Set backend URL
  void setBaseUrl(String url) {
    _baseUrl = url;
    _isInitialized = false;
  }

  /// Get backend URL
  String get baseUrl => _baseUrl;

  // ============================================================================
  // INITIALIZATION & HEALTH CHECKS
  // ============================================================================

  /// Initialize AI service and validate model paths
  /// 
  /// Validates that backend is running and models are loaded
  /// Requirements: 24.4
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      if (kDebugMode) {
        print('=== LocalAIService Initialization ===');
        print('Backend URL: $_baseUrl');
      }

      // Check backend health
      final healthResponse = await _client
          .get(Uri.parse('$_baseUrl/health'))
          .timeout(_timeout);

      if (healthResponse.statusCode != 200) {
        if (kDebugMode) {
          print('❌ Backend health check failed: ${healthResponse.statusCode}');
        }
        return false;
      }

      final healthData = json.decode(healthResponse.body) as Map<String, dynamic>;
      
      if (kDebugMode) {
        print('✅ Backend is healthy');
        print('Services: ${healthData['services']}');
        print('Dry Run Mode: ${healthData['dry_run_mode']}');
      }

      // Get model info
      _modelInfo = healthData['services'] as Map<String, dynamic>?;
      _isInitialized = true;

      if (kDebugMode) {
        print('✅ LocalAIService initialized successfully');
        print('=====================================');
      }

      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ LocalAIService initialization failed: $e');
        print('Stack trace: $stackTrace');
      }
      return false;
    }
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Get model information
  Map<String, dynamic>? get modelInfo => _modelInfo;

  /// Validate model paths (checks if models exist at configured paths)
  /// Requirements: 24.4
  Future<Map<String, bool>> validateModelPaths() async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl/api/models/validate'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return {
          'whisper': data['whisper'] as bool? ?? false,
          'qwen': data['qwen'] as bool? ?? false,
          'tts': data['tts'] as bool? ?? false,
        };
      }

      return {'whisper': false, 'qwen': false, 'tts': false};
    } catch (e) {
      if (kDebugMode) {
        print('Model path validation failed: $e');
      }
      return {'whisper': false, 'qwen': false, 'tts': false};
    }
  }

  // ============================================================================
  // WHISPER STT (Speech-to-Text)
  // ============================================================================

  /// Transcribe audio to text using Whisper
  /// 
  /// Model: E:\Projects\Models\Whisper\whisper-small-egyptian-arabic
  /// Handles Egyptian Arabic dialect
  /// Requirements: 24.1, 16.2
  Future<TranscriptionResult> transcribeAudio(Uint8List audioData) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final startTime = DateTime.now();

      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/api/stt/transcribe'),
      );

      // Add audio file
      request.files.add(http.MultipartFile.fromBytes(
        'audio',
        audioData,
        filename: 'audio.wav',
      ));

      // Send request
      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        throw Exception('STT failed: ${response.statusCode} - ${response.body}');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final result = TranscriptionResult.fromJson(data);

      final duration = DateTime.now().difference(startTime);
      if (kDebugMode) {
        print('🎤 STT: "${result.text}" (${duration.inMilliseconds}ms, confidence: ${result.confidence})');
      }

      return result;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ STT error: $e');
        print('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  // ============================================================================
  // QWEN LLM (Language Model)
  // ============================================================================

  /// Generate response using Qwen LLM
  /// 
  /// Model: E:\Projects\Models\LLMs\Qwen\Qwen3-4B-ggfu
  /// Includes conversation history for context
  /// Requirements: 24.2, 16.3
  Future<LLMResponse> generateResponse({
    required String prompt,
    List<Message>? conversationHistory,
    String? systemPrompt,
    double temperature = 0.8,
    int maxTokens = 150,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final startTime = DateTime.now();

      // Build conversation context
      final messages = <Map<String, String>>[];

      // Add system prompt
      if (systemPrompt != null) {
        messages.add({
          'role': 'system',
          'content': systemPrompt,
        });
      } else {
        // Default child-friendly system prompt
        messages.add({
          'role': 'system',
          'content': 'أنت سمارتينو، روبوت مصري لطيف وذكي عمره 7 سنين. '
              'أنت صديق الأطفال وبتساعدهم يتعلموا ويلعبوا. '
              'كلامك بسيط ومرح وإيجابي دايماً. '
              'ما تقولش أبداً "غلط" أو "خطأ"، قول "قريب جداً!" أو "جرب تاني!"',
        });
      }

      // Add conversation history
      if (conversationHistory != null) {
        for (final msg in conversationHistory) {
          messages.add({
            'role': msg.role == MessageRole.user ? 'user' : 'assistant',
            'content': msg.content,
          });
        }
      }

      // Add current prompt
      messages.add({
        'role': 'user',
        'content': prompt,
      });

      // Send request
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/api/llm/generate'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'messages': messages,
              'temperature': temperature,
              'max_tokens': maxTokens,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception('LLM failed: ${response.statusCode} - ${response.body}');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final result = LLMResponse.fromJson(data);

      final duration = DateTime.now().difference(startTime);
      if (kDebugMode) {
        print('🤖 LLM: "${result.text}" (${duration.inMilliseconds}ms, ${result.tokenCount} tokens)');
      }

      return result;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ LLM error: $e');
        print('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  // ============================================================================
  // COQUI TTS (Text-to-Speech with Visemes)
  // ============================================================================

  /// Synthesize speech from text with viseme data for lip-sync
  /// 
  /// Model: E:\Projects\Models\TTS
  /// Returns audio data + visemes for Rive animation
  /// Requirements: 24.3, 16.4, 16.5
  Future<SynthesisResult> synthesizeSpeech({
    required String text,
    double speed = 1.0,
    double pitch = 1.0,
    double volume = 1.0,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final startTime = DateTime.now();

      // Send request
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/api/tts/synthesize'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'text': text,
              'speed': speed,
              'pitch': pitch,
              'volume': volume,
              'include_visemes': true,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception('TTS failed: ${response.statusCode} - ${response.body}');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;

      // Decode audio data
      final audioBase64 = data['audio'] as String;
      final audioData = base64.decode(audioBase64);

      // Parse visemes
      final visemesJson = data['visemes'] as List<dynamic>?;
      final visemes = visemesJson
              ?.map((v) => Viseme.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [];

      final durationMs = data['duration_ms'] as int;

      final duration = DateTime.now().difference(startTime);
      if (kDebugMode) {
        print('🔊 TTS: "${text}" (${duration.inMilliseconds}ms, ${visemes.length} visemes)');
      }

      return SynthesisResult(
        audioData: audioData,
        visemes: visemes,
        durationMs: durationMs,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ TTS error: $e');
        print('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}
