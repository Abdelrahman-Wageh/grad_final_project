/// Groq Service - Integration with Groq API for STT and LLM
/// Provides Speech-to-Text (Whisper) and Language Model (LLaMA) capabilities

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/config/groq_config.dart';

class GroqService {
  final Dio _dio;
  final List<Map<String, String>> _conversationHistory = [];
  
  GroqService() : _dio = Dio(BaseOptions(
    baseUrl: GroqConfig.baseUrl,
    headers: {
      'Authorization': 'Bearer ${GroqConfig.apiKey}',
      'Content-Type': 'application/json',
    },
    connectTimeout: GroqConfig.connectTimeout,
    receiveTimeout: GroqConfig.receiveTimeout,
  ));
  
  /// Speech-to-Text using Whisper
  Future<String> transcribeAudio(Uint8List audioBytes) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          audioBytes,
          filename: 'audio.wav',
        ),
        'model': GroqConfig.whisperModel,
        'language': GroqConfig.sttLanguage,
        'prompt': GroqConfig.sttPrompt,
        'response_format': 'json',
      });
      
      final response = await _dio.post(
        '/audio/transcriptions',
        data: formData,
      );
      
      final text = response.data['text'] as String;
      debugPrint('🎤 Groq STT: $text');
      return text;
    } catch (e) {
      debugPrint('❌ Groq STT Error: $e');
      rethrow;
    }
  }
  
  /// Generate response using LLM
  Future<String> generateResponse(String userMessage, {Map<String, dynamic>? context}) async {
    try {
      // Add user message to history
      _conversationHistory.add({
        'role': 'user',
        'content': userMessage,
      });
      
      // Keep only last 10 messages for context
      if (_conversationHistory.length > 10) {
        _conversationHistory.removeAt(0);
      }
      
      // Build messages with context
      final messages = [
        {'role': 'system', 'content': _buildSystemPrompt(context)},
        ..._conversationHistory,
      ];
      
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': GroqConfig.llmModel,
          'messages': messages,
          'temperature': GroqConfig.temperature,
          'max_tokens': GroqConfig.maxTokens,
          'top_p': GroqConfig.topP,
        },
      );
      
      final assistantMessage = response.data['choices'][0]['message']['content'] as String;
      
      // Add assistant response to history
      _conversationHistory.add({
        'role': 'assistant',
        'content': assistantMessage,
      });
      
      debugPrint('🤖 Groq LLM: $assistantMessage');
      return assistantMessage;
    } catch (e) {
      debugPrint('❌ Groq LLM Error: $e');
      rethrow;
    }
  }
  
  /// Complete Speech-to-Speech pipeline
  Future<String> processSpeechToSpeech(Uint8List audioBytes, {Map<String, dynamic>? context}) async {
    // Step 1: Transcribe audio
    final transcription = await transcribeAudio(audioBytes);
    
    // Step 2: Generate response
    final response = await generateResponse(transcription, context: context);
    
    return response;
  }
  
  /// Build system prompt with context
  String _buildSystemPrompt(Map<String, dynamic>? context) {
    var prompt = GroqConfig.systemPrompt;
    
    if (context != null) {
      // Add game context
      if (context.containsKey('game')) {
        prompt += '\n\nالسياق الحالي: الطفل يلعب لعبة ${context['game']}';
      }
      
      // Add chapter context
      if (context.containsKey('chapter')) {
        prompt += '\nالفصل الحالي: ${context['chapter']}';
      }
      
      // Add stage context
      if (context.containsKey('stage')) {
        prompt += '\nالمرحلة: ${context['stage']}';
      }
      
      // Add last result context
      if (context.containsKey('lastResult')) {
        final result = context['lastResult'];
        if (result == 'success') {
          prompt += '\nالطفل نجح في المحاولة الأخيرة! احتفل معه!';
        } else if (result == 'retry') {
          prompt += '\nالطفل يحاول مرة أخرى. شجعه بطريقة إيجابية!';
        }
      }
    }
    
    return prompt;
  }
  
  /// Clear conversation history
  void clearHistory() {
    _conversationHistory.clear();
    debugPrint('🗑️ Conversation history cleared');
  }
  
  /// Get conversation history
  List<Map<String, String>> getHistory() {
    return List.unmodifiable(_conversationHistory);
  }
  
  /// Test connection
  Future<bool> testConnection() async {
    try {
      final response = await _dio.get('/models');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Groq connection test failed: $e');
      return false;
    }
  }
}
