/// ElevenLabs Service - High-quality TTS for Egyptian Arabic
/// Provides text-to-speech with caching and fallback to local TTS

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' if (dart.library.html) 'elevenlabs_stub.dart' as io;
import 'dart:html' as html if (dart.library.io) 'elevenlabs_stub.dart';
import '../../core/config/elevenlabs_config.dart';

class ElevenLabsService {
  final Dio _dio;
  final FlutterTts _localTts;
  final Map<String, String> _cache = {};  // Text -> Audio file path
  bool _isAvailable = false;
  
  ElevenLabsService()
      : _dio = Dio(BaseOptions(
          baseUrl: ElevenLabsConfig.baseUrl,
          headers: {
            'xi-api-key': ElevenLabsConfig.apiKey,
            'Content-Type': 'application/json',
          },
          connectTimeout: ElevenLabsConfig.connectTimeout,
          receiveTimeout: ElevenLabsConfig.receiveTimeout,
        )),
        _localTts = FlutterTts() {
    _initializeLocalTts();
    _checkAvailability();
  }
  
  /// Initialize local TTS as fallback
  Future<void> _initializeLocalTts() async {
    await _localTts.setLanguage('ar-EG'); // Egyptian Arabic
    await _localTts.setSpeechRate(0.5); // Slower for children
    await _localTts.setVolume(1.0);
    await _localTts.setPitch(1.2); // Slightly higher pitch for friendliness
  }
  
  /// Check if ElevenLabs is available
  Future<void> _checkAvailability() async {
    try {
      if (ElevenLabsConfig.apiKey == 'YOUR_ELEVENLABS_API_KEY') {
        _isAvailable = false;
        debugPrint('⚠️ ElevenLabs: API key not configured, using local TTS');
        return;
      }
      
      final response = await _dio.get('/voices');
      _isAvailable = response.statusCode == 200;
      debugPrint('✅ ElevenLabs: Available');
    } catch (e) {
      _isAvailable = false;
      debugPrint('⚠️ ElevenLabs: Not available, using local TTS - $e');
    }
  }
  
  /// Generate speech from text
  Future<String?> textToSpeech(String text) async {
    // Check cache first
    if (_cache.containsKey(text)) {
      final cachedPath = _cache[text]!;
      if (kIsWeb) return cachedPath; // On web, it's a blob URL
      if (await io.File(cachedPath).exists()) {
        debugPrint('🔊 Using cached audio for: $text');
        return cachedPath;
      }
    }
    
    // Try ElevenLabs if available
    if (_isAvailable) {
      try {
        return await _generateWithElevenLabs(text);
      } catch (e) {
        debugPrint('❌ ElevenLabs TTS Error: $e, falling back to local');
      }
    }
    
    // Fallback to local TTS
    return await _generateWithLocalTts(text);
  }
  
  /// Generate speech using ElevenLabs API
  Future<String> _generateWithElevenLabs(String text) async {
    final response = await _dio.post(
      '/text-to-speech/${ElevenLabsConfig.voiceId}',
      data: {
        'text': text,
        'model_id': ElevenLabsConfig.modelId,
        'voice_settings': {
          'stability': ElevenLabsConfig.stability,
          'similarity_boost': ElevenLabsConfig.similarityBoost,
          'style': ElevenLabsConfig.style,
          'use_speaker_boost': ElevenLabsConfig.useSpeakerBoost,
        },
      },
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    
    if (kIsWeb) {
      // On web, create a blob URL
      final blob = html.Blob([response.data], 'audio/mpeg');
      final url = html.Url.createObjectUrlFromBlob(blob);
      _cache[text] = url;
      debugPrint('🔊 ElevenLabs TTS generated (Web): $text');
      return url;
    } else {
      // Save audio to file
      final directory = await path_provider.getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/tts_$timestamp.mp3';
      
      final file = io.File(filePath);
      await file.writeAsBytes(response.data);
      
      // Cache the result
      _cache[text] = filePath;
      
      debugPrint('🔊 ElevenLabs TTS generated: $text');
      return filePath;
    }
  }
  
  /// Generate speech using local TTS (fallback)
  Future<String?> _generateWithLocalTts(String text) async {
    try {
      // Local TTS doesn't return file path, it plays directly
      // For consistency, we'll return null and handle playback separately
      await _localTts.speak(text);
      debugPrint('🔊 Local TTS speaking: $text');
      return null; // Indicates local TTS was used
    } catch (e) {
      debugPrint('❌ Local TTS Error: $e');
      return null;
    }
  }
  
  /// Speak text directly (uses appropriate TTS)
  Future<void> speak(String text) async {
    final audioPath = await textToSpeech(text);
    
    if (audioPath != null) {
      // ElevenLabs audio file - play using audio player
      // This will be handled by the caller
      debugPrint('🔊 Audio file ready: $audioPath');
    } else {
      // Local TTS already spoke
      debugPrint('🔊 Local TTS completed');
    }
  }
  
  /// Stop speaking
  Future<void> stop() async {
    await _localTts.stop();
  }
  
  /// Get available voices from ElevenLabs
  Future<List<Map<String, dynamic>>> getVoices() async {
    try {
      final response = await _dio.get('/voices');
      return List<Map<String, dynamic>>.from(response.data['voices']);
    } catch (e) {
      debugPrint('❌ ElevenLabs Get Voices Error: $e');
      return [];
    }
  }
  
  /// Pre-cache common phrases
  Future<void> preCacheCommonPhrases() async {
    if (!_isAvailable) return;
    
    debugPrint('🔄 Pre-caching common phrases...');
    for (final phrase in ElevenLabsConfig.commonPhrases) {
      try {
        await textToSpeech(phrase);
      } catch (e) {
        debugPrint('⚠️ Failed to cache phrase: $phrase');
      }
    }
    debugPrint('✅ Common phrases cached');
  }
  
  /// Clear cache
  Future<void> clearCache() async {
    for (final path in _cache.values) {
      if (kIsWeb) continue; // Can't delete blob URLs this way
      try {
        await io.File(path).delete();
      } catch (e) {
        debugPrint('⚠️ Failed to delete cached file: $e');
      }
    }
    _cache.clear();
    debugPrint('🗑️ TTS cache cleared');
  }
  
  /// Check if service is available
  bool get isAvailable => _isAvailable;
  
  /// Get cache size
  int get cacheSize => _cache.length;
}
