/// AI Orchestrator - Coordinates all AI services
/// Manages Speech-to-Speech pipeline with cloud/local/hybrid modes

import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io' if (dart.library.html) '../../services/ai/elevenlabs_stub.dart' as io;
import '../../services/ai/groq_service.dart';
import '../../services/ai/elevenlabs_service.dart';
import '../../services/local_ai_service.dart';
import '../../services/local_storage_service.dart';

enum AIMode {
  cloud,    // Groq + ElevenLabs
  local,    // On-device models
  hybrid,   // Cloud with local fallback (default)
}

class AIOrchestrator {
  final GroqService _groqService;
  final ElevenLabsService _elevenLabsService;
  final LocalAIService _localAIService;
  final LocalStorageService _storage;
  final AudioPlayer _audioPlayer;
  
  AIMode _currentMode = AIMode.hybrid;
  bool _isProcessing = false;
  int _cloudFailures = 0;
  static const int _maxCloudFailures = 3;
  
  AIOrchestrator({
    required GroqService groqService,
    required ElevenLabsService elevenLabsService,
    required LocalAIService localAIService,
    required LocalStorageService storage,
  })  : _groqService = groqService,
        _elevenLabsService = elevenLabsService,
        _localAIService = localAIService,
        _storage = storage,
        _audioPlayer = AudioPlayer();
  
  /// Process voice input end-to-end (Speech-to-Speech)
  Future<Map<String, dynamic>> processVoiceInput(
    Uint8List audioBytes, {
    Map<String, dynamic>? context,
  }) async {
    if (_isProcessing) {
      debugPrint('⚠️ Already processing, ignoring new input');
      return {'success': false, 'error': 'Already processing'};
    }
    
    _isProcessing = true;
    
    try {
      String responseText;
      String? audioPath;
      bool usedCloud = false;
      
      // Try cloud processing
      if (_currentMode == AIMode.cloud || _currentMode == AIMode.hybrid) {
        try {
          // Step 1: STT with Groq Whisper
          debugPrint('🎤 Processing with Groq STT...');
          final transcription = await _groqService.transcribeAudio(audioBytes);
          
          // Step 2: LLM with Groq
          debugPrint('🤖 Generating response with Groq LLM...');
          final transcriptionText = transcription ?? ''; // Handle null case
          responseText = await _groqService.generateResponse(
            transcriptionText,
            context: context,
          ) ?? ''; // Handle null response
          
          // Step 3: TTS with ElevenLabs
          debugPrint('🔊 Generating speech with ElevenLabs...');
          audioPath = await _elevenLabsService.textToSpeech(responseText) ?? ''; // Handle null audioPath
          
          usedCloud = true;
          _cloudFailures = 0; // Reset failure counter
          
        } catch (e) {
          debugPrint('❌ Cloud processing failed: $e');
          _cloudFailures++;
          
          if (_currentMode == AIMode.hybrid) {
            debugPrint('🔄 Falling back to local processing...');
            final localResult = await _processLocally(audioBytes, context);
            responseText = localResult['text'] ?? ''; // Handle null
            audioPath = localResult['audioPath'];
            usedCloud = false;
          } else {
            rethrow;
          }
        }
      } else {
        // Local processing
        final localResult = await _processLocally(audioBytes, context);
        responseText = localResult['text'] ?? ''; // Handle null
        audioPath = localResult['audioPath'];
        usedCloud = false;
      }
      
      // Play response
      if (audioPath != null) {
        if (kIsWeb || audioPath.startsWith('blob:') || audioPath.startsWith('http')) {
          await _audioPlayer.play(UrlSource(audioPath));
        } else {
          await _audioPlayer.play(DeviceFileSource(audioPath));
        }
      }
      
      // Save to conversation history
      await _saveConversation(responseText, usedCloud);
      
      // Auto-switch to local if too many cloud failures
      if (_cloudFailures >= _maxCloudFailures && _currentMode == AIMode.hybrid) {
        debugPrint('⚠️ Too many cloud failures, switching to local mode');
        _currentMode = AIMode.local;
      }
      
      return {
        'success': true,
        'text': responseText,
        'audioPath': audioPath,
        'mode': usedCloud ? 'cloud' : 'local',
      };
      
    } catch (e) {
      debugPrint('❌ AI Orchestrator error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    } finally {
      _isProcessing = false;
    }
  }
  
  /// Process with local AI models
  Future<Map<String, String?>> _processLocally(
    Uint8List audioBytes,
    Map<String, dynamic>? context,
  ) async {
    // Use local AI service
    final responseText = await _localAIService.processAudio(audioBytes);
    final audioPath = await _localAIService.textToSpeech(responseText);
    
    return {
      'text': responseText ?? '', // Handle null
      'audioPath': audioPath,
    };
  }
  
  /// Generate text response (without audio input)
  Future<String> generateTextResponse(
    String userMessage, {
    Map<String, dynamic>? context,
  }) async {
    try {
      if (_currentMode == AIMode.cloud || _currentMode == AIMode.hybrid) {
        try {
          return await _groqService.generateResponse(userMessage, context: context);
        } catch (e) {
          if (_currentMode == AIMode.hybrid) {
            debugPrint('🔄 Falling back to local LLM...');
            return await _localAIService.generateTextResponse(userMessage);
          }
          rethrow;
        }
      } else {
        return await _localAIService.generateTextResponse(userMessage);
      }
    } catch (e) {
      debugPrint('❌ Text response error: $e');
      return 'عذراً، حصل خطأ. حاول تاني!';
    }
  }
  
  /// Speak text (TTS only)
  Future<void> speakText(String text) async {
    try {
      if (_currentMode == AIMode.cloud || _currentMode == AIMode.hybrid) {
        try {
          final audioPath = await _elevenLabsService.textToSpeech(text);
          if (audioPath != null) {
            if (kIsWeb || audioPath.startsWith('blob:') || audioPath.startsWith('http')) {
              await _audioPlayer.play(UrlSource(audioPath));
            } else {
              await _audioPlayer.play(DeviceFileSource(audioPath));
            }
          }
        } catch (e) {
          if (_currentMode == AIMode.hybrid) {
            debugPrint('🔄 Falling back to local TTS...');
            await _localAIService.textToSpeech(text);
          }
        }
      } else {
        await _localAIService.textToSpeech(text);
      }
    } catch (e) {
      debugPrint('❌ Speak text error: $e');
    }
  }
  
  /// Set AI mode
  void setMode(AIMode mode) {
    _currentMode = mode;
    _cloudFailures = 0; // Reset failures when mode changes
    debugPrint('🔧 AI Mode changed to: $mode');
  }
  
  /// Get current mode
  AIMode getMode() => _currentMode;
  
  /// Check if processing
  bool get isProcessing => _isProcessing;
  
  /// Get cloud failure count
  int get cloudFailures => _cloudFailures;
  
  /// Save conversation to storage
  Future<void> _saveConversation(String text, bool usedCloud) async {
    await _storage.saveConversation({
      'text': text,
      'timestamp': DateTime.now().toIso8601String(),
      'mode': usedCloud ? 'cloud' : 'local',
    });
  }
  
  /// Clear conversation history
  Future<void> clearHistory() async {
    _groqService.clearHistory();
    await _storage.clearConversations();
    debugPrint('🗑️ Conversation history cleared');
  }
  
  /// Pre-cache common phrases
  Future<void> preCacheCommonPhrases() async {
    await _elevenLabsService.preCacheCommonPhrases();
  }
  
  /// Test connection to cloud services
  Future<Map<String, bool>> testConnections() async {
    return {
      'groq': await _groqService.testConnection(),
      'elevenlabs': _elevenLabsService.isAvailable,
    };
  }
  
  /// Dispose resources
  void dispose() {
    _audioPlayer.dispose();
  }
}
