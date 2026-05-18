# Smartino AI Integration Service - Technical Specification

## Overview
This document details the integration of Groq API (Whisper + GPT-OSS-120b) and ElevenLabs TTS into the Smartino super-app for real-time Speech-to-Speech interaction in Egyptian Arabic.

---

## 1. Groq API Integration

### 1.1 API Configuration

```dart
// lib/core/config/groq_config.dart

class GroqConfig {
  // API Credentials
  static const String apiKey = 'REDACTED';
  static const String baseUrl = 'https://api.groq.com/openai/v1';
  
  // Models
  static const String whisperModel = 'whisper-large-v3';
  static const String llmModel = 'openai/gpt-oss-120b';
  
  // STT Settings
  static const String sttLanguage = 'ar';  // Arabic
  static const String sttPrompt = 'Egyptian Arabic dialect, child speech';
  
  // LLM Settings
  static const double temperature = 0.8;  // High creativity for kids
  static const int maxTokens = 150;
  static const double topP = 0.9;
  
  // System Prompt for Egyptian Arabic
  static const String systemPrompt = '''
أنت "فرفور"، صديق الأطفال الذكي والمرح. أنت كلب لطيف يتحدث باللهجة المصرية العامية.

قواعد المحادثة:
1. تحدث دائماً باللهجة المصرية (مثل: إزيك، عامل إيه، تمام، ماشي)
2. كن إيجابياً ومشجعاً دائماً
3. استخدم كلمات بسيطة مناسبة للأطفال (4-8 سنوات)
4. لا تستخدم كلمات "خطأ" أو "غلط"، بل قل "حاول تاني" أو "قريب جداً"
5. اجعل التعلم ممتعاً بالألعاب والقصص
6. استخدم الإيموجي أحياناً 🎉 ⭐ 🌟
7. كن صديقاً حقيقياً، اسأل عن يومهم ومشاعرهم

أمثلة على ردودك:
- "إزيك يا بطل! عامل إيه النهاردة؟"
- "واو! أنت شاطر جداً! 🌟"
- "تمام كده! كمل يا حبيبي!"
- "قريب جداً! حاول تاني، أنا واثق فيك!"
''';
}
```

### 1.2 Groq Service Implementation

```dart
// lib/services/ai/groq_service.dart

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
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
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
      
      return response.data['text'] as String;
    } catch (e) {
      debugPrint('Groq STT Error: $e');
      rethrow;
    }
  }
  
  /// Generate response using GPT-OSS-120b
  Future<String> generateResponse(String userMessage) async {
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
      
      final messages = [
        {'role': 'system', 'content': GroqConfig.systemPrompt},
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
      
      return assistantMessage;
    } catch (e) {
      debugPrint('Groq LLM Error: $e');
      rethrow;
    }
  }
  
  /// Complete Speech-to-Speech pipeline
  Future<String> processSpeechToSpeech(Uint8List audioBytes) async {
    // Step 1: Transcribe audio
    final transcription = await transcribeAudio(audioBytes);
    debugPrint('Transcription: $transcription');
    
    // Step 2: Generate response
    final response = await generateResponse(transcription);
    debugPrint('Response: $response');
    
    return response;
  }
  
  /// Clear conversation history
  void clearHistory() {
    _conversationHistory.clear();
  }
  
  /// Get conversation history
  List<Map<String, String>> getHistory() {
    return List.unmodifiable(_conversationHistory);
  }
}
```



---

## 2. ElevenLabs TTS Integration

### 2.1 ElevenLabs Configuration

```dart
// lib/core/config/elevenlabs_config.dart

class ElevenLabsConfig {
  // API Credentials (to be provided)
  static const String apiKey = 'YOUR_ELEVENLABS_API_KEY';
  static const String baseUrl = 'https://api.elevenlabs.io/v1';
  
  // Voice Settings for Egyptian Arabic Child-Friendly Voice
  static const String voiceId = 'VOICE_ID_TO_BE_SELECTED';  // Select from ElevenLabs library
  
  // Voice Settings
  static const double stability = 0.5;  // Lower = more expressive
  static const double similarityBoost = 0.75;
  static const double style = 0.3;  // Playful style
  static const bool useSpeakerBoost = true;
  
  // Audio Settings
  static const String outputFormat = 'mp3_44100_128';
  static const String modelId = 'eleven_multilingual_v2';  // Supports Arabic
}
```

### 2.2 ElevenLabs Service Implementation

```dart
// lib/services/ai/elevenlabs_service.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../core/config/elevenlabs_config.dart';

class ElevenLabsService {
  final Dio _dio;
  final Map<String, String> _cache = {};  // Text -> Audio file path
  
  ElevenLabsService() : _dio = Dio(BaseOptions(
    baseUrl: ElevenLabsConfig.baseUrl,
    headers: {
      'xi-api-key': ElevenLabsConfig.apiKey,
      'Content-Type': 'application/json',
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
  ));
  
  /// Generate speech from text
  Future<String> textToSpeech(String text) async {
    // Check cache first
    if (_cache.containsKey(text)) {
      final cachedPath = _cache[text]!;
      if (await File(cachedPath).exists()) {
        debugPrint('Using cached audio for: $text');
        return cachedPath;
      }
    }
    
    try {
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
      
      // Save audio to file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/tts_$timestamp.mp3';
      
      final file = File(filePath);
      await file.writeAsBytes(response.data);
      
      // Cache the result
      _cache[text] = filePath;
      
      return filePath;
    } catch (e) {
      debugPrint('ElevenLabs TTS Error: $e');
      rethrow;
    }
  }
  
  /// Get available voices
  Future<List<Map<String, dynamic>>> getVoices() async {
    try {
      final response = await _dio.get('/voices');
      return List<Map<String, dynamic>>.from(response.data['voices']);
    } catch (e) {
      debugPrint('ElevenLabs Get Voices Error: $e');
      rethrow;
    }
  }
  
  /// Clear cache
  Future<void> clearCache() async {
    for (final path in _cache.values) {
      try {
        await File(path).delete();
      } catch (e) {
        debugPrint('Failed to delete cached file: $e');
      }
    }
    _cache.clear();
  }
}
```

---

## 3. Unified AI Orchestrator

### 3.1 AI Orchestrator Implementation

```dart
// lib/core/ai/ai_orchestrator.dart

import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../services/ai/groq_service.dart';
import '../../services/ai/elevenlabs_service.dart';
import '../../services/ai/local_ai_service.dart';
import '../../services/storage/hive_service.dart';

enum AIMode {
  cloud,    // Groq + ElevenLabs
  local,    // On-device models
  hybrid,   // Cloud with local fallback
}

class AIOrchestrator {
  final GroqService _groqService;
  final ElevenLabsService _elevenLabsService;
  final LocalAIService _localAIService;
  final HiveService _storage;
  final AudioPlayer _audioPlayer;
  
  AIMode _currentMode = AIMode.hybrid;
  bool _isProcessing = false;
  
  AIOrchestrator({
    required GroqService groqService,
    required ElevenLabsService elevenLabsService,
    required LocalAIService localAIService,
    required HiveService storage,
  })  : _groqService = groqService,
        _elevenLabsService = elevenLabsService,
        _localAIService = localAIService,
        _storage = storage,
        _audioPlayer = AudioPlayer();
  
  /// Process voice input end-to-end
  Future<void> processVoiceInput(Uint8List audioBytes) async {
    if (_isProcessing) {
      debugPrint('Already processing, ignoring new input');
      return;
    }
    
    _isProcessing = true;
    
    try {
      String responseText;
      String audioPath;
      
      if (_currentMode == AIMode.cloud || _currentMode == AIMode.hybrid) {
        try {
          // Try cloud processing
          responseText = await _groqService.processSpeechToSpeech(audioBytes);
          audioPath = await _elevenLabsService.textToSpeech(responseText);
        } catch (e) {
          if (_currentMode == AIMode.hybrid) {
            debugPrint('Cloud failed, falling back to local: $e');
            responseText = await _localAIService.processAudio(audioBytes);
            audioPath = await _localAIService.textToSpeech(responseText);
          } else {
            rethrow;
          }
        }
      } else {
        // Local processing
        responseText = await _localAIService.processAudio(audioBytes);
        audioPath = await _localAIService.textToSpeech(responseText);
      }
      
      // Play response
      await _audioPlayer.play(DeviceFileSource(audioPath));
      
      // Save to conversation history
      await _saveConversation(responseText);
      
    } finally {
      _isProcessing = false;
    }
  }
  
  /// Set AI mode
  void setMode(AIMode mode) {
    _currentMode = mode;
    debugPrint('AI Mode changed to: $mode');
  }
  
  /// Get current mode
  AIMode getMode() => _currentMode;
  
  /// Check if processing
  bool get isProcessing => _isProcessing;
  
  /// Save conversation to storage
  Future<void> _saveConversation(String text) async {
    await _storage.saveConversation({
      'text': text,
      'timestamp': DateTime.now().toIso8601String(),
      'mode': _currentMode.toString(),
    });
  }
  
  /// Clear conversation history
  Future<void> clearHistory() async {
    _groqService.clearHistory();
    await _storage.clearConversations();
  }
  
  /// Dispose resources
  void dispose() {
    _audioPlayer.dispose();
  }
}
```

---

## 4. Backend Integration

### 4.1 Groq Backend Service

```python
# backend/app/services/groq_service.py

import os
from groq import Groq
from typing import Optional
import logging

logger = logging.getLogger(__name__)

class GroqService:
    """Groq API integration for STT and LLM."""
    
    def __init__(self):
        self.api_key = "REDACTED"
        self.client = Groq(api_key=self.api_key)
        self.conversation_history = []
        
        self.system_prompt = """
أنت "فرفور"، صديق الأطفال الذكي والمرح. أنت كلب لطيف يتحدث باللهجة المصرية العامية.

قواعد المحادثة:
1. تحدث دائماً باللهجة المصرية (مثل: إزيك، عامل إيه، تمام، ماشي)
2. كن إيجابياً ومشجعاً دائماً
3. استخدم كلمات بسيطة مناسبة للأطفال (4-8 سنوات)
4. لا تستخدم كلمات "خطأ" أو "غلط"، بل قل "حاول تاني" أو "قريب جداً"
5. اجعل التعلم ممتعاً بالألعاب والقصص
6. استخدم الإيموجي أحياناً 🎉 ⭐ 🌟
7. كن صديقاً حقيقياً، اسأل عن يومهم ومشاعرهم
"""
    
    async def transcribe_audio(self, audio_file) -> str:
        """Transcribe audio using Whisper."""
        try:
            transcription = self.client.audio.transcriptions.create(
                file=audio_file,
                model="whisper-large-v3",
                language="ar",
                prompt="Egyptian Arabic dialect, child speech",
                response_format="json"
            )
            return transcription.text
        except Exception as e:
            logger.error(f"Groq STT error: {e}")
            raise
    
    async def generate_response(self, user_message: str) -> str:
        """Generate response using GPT-OSS-120b."""
        try:
            # Add user message to history
            self.conversation_history.append({
                "role": "user",
                "content": user_message
            })
            
            # Keep only last 10 messages
            if len(self.conversation_history) > 10:
                self.conversation_history.pop(0)
            
            messages = [
                {"role": "system", "content": self.system_prompt},
                *self.conversation_history
            ]
            
            completion = self.client.chat.completions.create(
                model="openai/gpt-oss-120b",
                messages=messages,
                temperature=0.8,
                max_tokens=150,
                top_p=0.9
            )
            
            assistant_message = completion.choices[0].message.content
            
            # Add assistant response to history
            self.conversation_history.append({
                "role": "assistant",
                "content": assistant_message
            })
            
            return assistant_message
        except Exception as e:
            logger.error(f"Groq LLM error: {e}")
            raise
    
    def clear_history(self):
        """Clear conversation history."""
        self.conversation_history = []

# Global instance
groq_service = GroqService()
```

### 4.2 ElevenLabs Backend Service

```python
# backend/app/services/elevenlabs_service.py

import os
from elevenlabs import generate, set_api_key, Voice, VoiceSettings
from typing import Optional
import logging

logger = logging.getLogger(__name__)

class ElevenLabsService:
    """ElevenLabs TTS integration."""
    
    def __init__(self):
        self.api_key = os.getenv("ELEVENLABS_API_KEY", "YOUR_API_KEY")
        set_api_key(self.api_key)
        
        # Voice settings for child-friendly Egyptian Arabic
        self.voice_id = "VOICE_ID_TO_BE_SELECTED"
        self.voice_settings = VoiceSettings(
            stability=0.5,
            similarity_boost=0.75,
            style=0.3,
            use_speaker_boost=True
        )
    
    async def text_to_speech(self, text: str) -> bytes:
        """Generate speech from text."""
        try:
            audio = generate(
                text=text,
                voice=Voice(
                    voice_id=self.voice_id,
                    settings=self.voice_settings
                ),
                model="eleven_multilingual_v2"
            )
            return audio
        except Exception as e:
            logger.error(f"ElevenLabs TTS error: {e}")
            raise

# Global instance
elevenlabs_service = ElevenLabsService()
```

---

## 5. Usage Examples

### 5.1 Friend Mode Integration

```dart
// lib/features/friend_mode/friend_controller.dart

class FriendController extends ChangeNotifier {
  final AIOrchestrator _aiOrchestrator;
  final AudioRecorder _recorder;
  
  bool _isRecording = false;
  bool _isProcessing = false;
  
  FriendController(this._aiOrchestrator, this._recorder);
  
  Future<void> startConversation() async {
    if (_isRecording || _isProcessing) return;
    
    _isRecording = true;
    notifyListeners();
    
    // Start recording
    await _recorder.start();
    
    // Record for 3 seconds (or until user stops)
    await Future.delayed(const Duration(seconds: 3));
    
    // Stop recording
    final audioPath = await _recorder.stop();
    final audioBytes = await File(audioPath!).readAsBytes();
    
    _isRecording = false;
    _isProcessing = true;
    notifyListeners();
    
    // Process with AI
    await _aiOrchestrator.processVoiceInput(audioBytes);
    
    _isProcessing = false;
    notifyListeners();
  }
  
  bool get isRecording => _isRecording;
  bool get isProcessing => _isProcessing;
}
```

---

## 6. Testing & Validation

### 6.1 Unit Tests

```dart
// test/services/groq_service_test.dart

void main() {
  group('GroqService', () {
    late GroqService groqService;
    
    setUp(() {
      groqService = GroqService();
    });
    
    test('transcribeAudio returns text', () async {
      final audioBytes = await loadTestAudio();
      final result = await groqService.transcribeAudio(audioBytes);
      expect(result, isNotEmpty);
    });
    
    test('generateResponse returns Egyptian Arabic', () async {
      final response = await groqService.generateResponse('إزيك يا فرفور؟');
      expect(response, contains(RegExp(r'(تمام|ماشي|أهلاً)')));
    });
  });
}
```

---

## 7. Performance Optimization

### 7.1 Caching Strategy
- Cache common phrases (greetings, encouragements)
- Cache TTS audio files
- Preload frequently used responses

### 7.2 Response Time Targets
- STT: < 1 second
- LLM: < 1.5 seconds
- TTS: < 0.5 seconds
- **Total**: < 3 seconds end-to-end

### 7.3 Fallback Strategy
1. Try Groq + ElevenLabs (cloud)
2. If fails, use local STT + LLM + TTS
3. If all fails, use pre-recorded responses

---

## 8. Security & Privacy

### 8.1 API Key Management
- Store keys in environment variables
- Never commit keys to version control
- Rotate keys regularly

### 8.2 Data Privacy
- No audio stored on servers
- Conversation history encrypted locally
- Parent can clear all data

### 8.3 Content Filtering
- System prompt enforces child-appropriate content
- Backend validates responses
- Fallback to safe responses if inappropriate

---

**Status**: Ready for Implementation  
**Priority**: High (Core Feature)  
**Dependencies**: Groq API Key (provided), ElevenLabs API Key (pending)
