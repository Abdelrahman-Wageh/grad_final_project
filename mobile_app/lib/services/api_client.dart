/// API Client for Whispering Woods FastAPI backend.
/// Handles all network calls with retries, backoff, and dry-run support.

import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/game_state.dart';
import '../utils/app_constants.dart';

class ApiClient {
  final Dio _dio;
  bool _dryRunMode = false;
  
  ApiClient() : _dio = Dio() {
    // Use dynamic URL getter that handles Android emulator
    _dio.options.baseUrl = AppConstants.apiBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    
    // Add retry interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode != null &&
              error.response!.statusCode! >= 500) {
            // Retry on server errors
            final retryCount = error.requestOptions.extra['retryCount'] ?? 0;
            if (retryCount < 3) {
              await Future.delayed(Duration(seconds: retryCount + 1));
              error.requestOptions.extra['retryCount'] = retryCount + 1;
              try {
                final response = await _dio.fetch(error.requestOptions);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }
  
  void setDryRun(bool enabled) {
    _dryRunMode = enabled;
  }
  
  bool get isDryRun => _dryRunMode;
  
  /// Main pipeline endpoint: STT → NLU → TTS
  Future<AdventureSpeechResponse> adventureSpeech({
    required Uint8List audioBytes,
    required String audioFormat,
    required GameState gameState,
    String? playerId,
    String? characterType,
  }) async {
    if (_dryRunMode) {
      return _getDryRunAdventureSpeech(gameState);
    }
    
    try {
      // Encode audio to base64
      final audioBase64 = base64Encode(audioBytes);
      
      final response = await _dio.post(
        '/api/adventure_speech',
        data: {
          'audio_base64': audioBase64,
          'audio_format': audioFormat,
          'game_state': {
            'state': gameState.name,
            'context': 'general',
            'level': 1,
            'state_data': {},
          },
          'player_id': playerId,
          'character_type': characterType,
        },
      );
      
      return AdventureSpeechResponse.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Adventure speech API error: ${e.message}');
      // Fallback to offline response
      return _getOfflineAdventureSpeech(gameState);
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return _getOfflineAdventureSpeech(gameState);
    }
  }
  
  /// Drawing recognition endpoint
  Future<DrawResponse> recognizeDrawing({
    required Uint8List imageBytes,
    required String challenge,
    GameState? gameState,
    String? playerId,
  }) async {
    if (_dryRunMode) {
      return _getDryRunDrawResponse(challenge);
    }
    
    try {
      // Encode image to base64
      final imageBase64 = base64Encode(imageBytes);
      
      final response = await _dio.post(
        '/api/draw',
        data: {
          'image_base64': imageBase64,
          'challenge': challenge,
          'game_state': gameState != null
              ? {
                  'state': gameState.name,
                  'context': 'general',
                  'level': 1,
                  'state_data': {},
                }
              : null,
          'player_id': playerId,
        },
      );
      
      return DrawResponse.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Draw recognition API error: ${e.message}');
      return _getOfflineDrawResponse(challenge);
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return _getOfflineDrawResponse(challenge);
    }
  }
  
  /// Health check
  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await _dio.get('/api/health');
      return response.data;
    } catch (e) {
      debugPrint('Health check failed: $e');
      return {
        'status': 'unknown',
        'dry_run_mode': true,
      };
    }
  }
  
  // Dry-run responses
  AdventureSpeechResponse _getDryRunAdventureSpeech(GameState gameState) {
    final responses = {
      'FOREST_ADVENTURE': 'أهلاً! هيا نستكشف الغابة السحرية معاً!',
      'NUMBER_GATE_PUZZLE': 'ابحث عن الأرقام! هم موجودين في كل مكان!',
      'default': 'أهلاً وسهلاً! أنا هنا لمساعدتك!',
    };
    
    final responseText = responses[gameState.name] ?? responses['default']!;
    
    return AdventureSpeechResponse(
      audioBase64: '', // Placeholder - would be actual audio in real mode
      audioFormat: 'wav',
      textResponse: responseText,
      responseKey: 'DRY_RUN_RESPONSE',
      confidence: 0.9,
      processingTimeMs: 100.0,
    );
  }
  
  AdventureSpeechResponse _getOfflineAdventureSpeech(GameState gameState) {
    // Offline fallback - same as dry-run for now
    return _getDryRunAdventureSpeech(gameState);
  }
  
  DrawResponse _getDryRunDrawResponse(String challenge) {
    final challengeClean = challenge.replaceAll('DRAW_', '').toLowerCase();
    return DrawResponse(
      prediction: challengeClean,
      confidence: 0.85,
      isCorrect: true,
      responseKey: 'DRAW_SUCCESS',
      textResponse: 'ممتاز! رسمت ذلك بشكل رائع!',
    );
  }
  
  DrawResponse _getOfflineDrawResponse(String challenge) {
    return _getDryRunDrawResponse(challenge);
  }
}

/// Response models
class AdventureSpeechResponse {
  final String audioBase64;
  final String audioFormat;
  final String textResponse;
  final String responseKey;
  final double confidence;
  final double processingTimeMs;
  
  AdventureSpeechResponse({
    required this.audioBase64,
    required this.audioFormat,
    required this.textResponse,
    required this.responseKey,
    required this.confidence,
    required this.processingTimeMs,
  });
  
  factory AdventureSpeechResponse.fromJson(Map<String, dynamic> json) {
    final metadata = json['metadata'] as Map<String, dynamic>;
    return AdventureSpeechResponse(
      audioBase64: json['audio_base64'] as String,
      audioFormat: json['audio_format'] as String,
      textResponse: json['text_response'] as String,
      responseKey: metadata['response_key'] as String,
      confidence: (metadata['confidence'] as num).toDouble(),
      processingTimeMs: (metadata['processing_time_ms'] as num? ?? 0).toDouble(),
    );
  }
  
  Uint8List get audioBytes => base64Decode(audioBase64);
}

class DrawResponse {
  final String prediction;
  final double confidence;
  final bool isCorrect;
  final String responseKey;
  final String textResponse;
  
  DrawResponse({
    required this.prediction,
    required this.confidence,
    required this.isCorrect,
    required this.responseKey,
    required this.textResponse,
  });
  
  factory DrawResponse.fromJson(Map<String, dynamic> json) {
    return DrawResponse(
      prediction: json['prediction'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      isCorrect: json['is_correct'] as bool,
      responseKey: json['response_key'] as String,
      textResponse: json['text_response'] as String,
    );
  }
}

