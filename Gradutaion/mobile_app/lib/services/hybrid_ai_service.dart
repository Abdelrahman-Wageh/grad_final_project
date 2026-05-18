/// Hybrid AI Service
/// Automatically switches between online (backend) and offline (local) AI
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'hybrid_connectivity_service.dart';

class HybridAIService extends ChangeNotifier {
  final HybridConnectivityService _connectivity;
  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _stt = stt.SpeechToText();
  
  bool _sttInitialized = false;
  bool _ttsInitialized = false;
  
  HybridAIService(this._connectivity) {
    _initializeOfflineAI();
  }
  
  Future<void> _initializeOfflineAI() async {
    // Initialize TTS
    try {
      await _tts.setLanguage('ar-EG');
      await _tts.setSpeechRate(0.5); // Slower for children
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.2); // Higher pitch for friendly voice
      _ttsInitialized = true;
      if (kDebugMode) print('✅ TTS initialized');
    } catch (e) {
      if (kDebugMode) print('⚠️ TTS initialization failed: $e');
    }
    
    // Initialize STT
    try {
      _sttInitialized = await _stt.initialize(
        onError: (error) => debugPrint('STT Error: $error'),
        onStatus: (status) => debugPrint('STT Status: $status'),
      );
      if (kDebugMode) print('✅ STT initialized: $_sttInitialized');
    } catch (e) {
      if (kDebugMode) print('⚠️ STT initialization failed: $e');
    }
  }
  
  /// Process voice input (hybrid: online if available, offline fallback)
  Future<String> processVoice({String language = 'ar-EG'}) async {
    if (_connectivity.isOnline) {
      try {
        return await _processVoiceOnline(language);
      } catch (e) {
        if (kDebugMode) print('Online STT failed, falling back to offline: $e');
        return await _processVoiceOffline(language);
      }
    } else {
      return await _processVoiceOffline(language);
    }
  }
  
  Future<String> _processVoiceOnline(String language) async {
    // TODO: Implement backend API call
    throw UnimplementedError('Online STT not yet implemented');
  }
  
  Future<String> _processVoiceOffline(String language) async {
    if (!_sttInitialized) {
      throw Exception('STT not initialized');
    }
    
    final completer = Completer<String>();
    
    await _stt.listen(
      onResult: (result) {
        if (result.finalResult) {
          completer.complete(result.recognizedWords);
        }
      },
      localeId: language,
      listenFor: const Duration(seconds: 5),
      pauseFor: const Duration(seconds: 3),
    );
    
    return completer.future;
  }
  
  /// Speak text (hybrid: online for advanced, offline for basic)
  Future<void> speak(String text, {String? childName}) async {
    // Personalize with child's name
    String personalizedText = childName != null 
        ? text.replaceAll('{name}', childName)
        : text;
    
    if (_connectivity.isOnline) {
      try {
        await _speakOnline(personalizedText);
        return;
      } catch (e) {
        if (kDebugMode) print('Online TTS failed, falling back to offline: $e');
      }
    }
    
    await _speakOffline(personalizedText);
  }
  
  Future<void> _speakOnline(String text) async {
    // TODO: Implement backend XTTS API call for voice cloning
    throw UnimplementedError('Online TTS not yet implemented');
  }
  
  Future<void> _speakOffline(String text) async {
    if (!_ttsInitialized) {
      throw Exception('TTS not initialized');
    }
    
    await _tts.speak(text);
  }
  
  /// Stop speaking
  Future<void> stop() async {
    await _tts.stop();
    await _stt.stop();
  }
  
  /// Check if services are ready
  bool get isReady => _ttsInitialized && _sttInitialized;
  
  @override
  void dispose() {
    _tts.stop();
    _stt.stop();
    super.dispose();
  }
}
