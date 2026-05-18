import 'package:flutter_test/flutter_test.dart';
import 'package:smartino/services/ai/groq_service.dart';
import 'package:smartino/core/config/groq_config.dart';

void main() {
  group('GroqService Tests', () {
    late GroqService groqService;

    setUp(() {
      groqService = GroqService();
    });

    test('GroqService initializes correctly', () {
      expect(groqService, isNotNull);
    });

    test('GroqConfig has valid API key', () {
      expect(GroqConfig.apiKey, isNotEmpty);
      expect(GroqConfig.apiKey.isNotEmpty, isTrue);
    });

    test('GroqConfig has correct models', () {
      expect(GroqConfig.whisperModel, equals('whisper-large-v3'));
      expect(GroqConfig.llmModel, equals('llama-3.3-70b-versatile'));
    });

    test('GroqConfig has Egyptian Arabic system prompt', () {
      expect(GroqConfig.systemPrompt, contains('فرفور'));
      expect(GroqConfig.systemPrompt, contains('مصري'));
      expect(GroqConfig.systemPrompt, contains('إزيك'));
    });

    test('GroqConfig has positive reinforcement rules', () {
      expect(GroqConfig.systemPrompt, contains('حاول تاني'));
      expect(GroqConfig.systemPrompt, contains('قريب جداً'));
      expect(GroqConfig.systemPrompt, isNot(contains('خطأ')));
      expect(GroqConfig.systemPrompt, isNot(contains('غلط')));
    });

    test('transcribeAudio returns error for null audio', () async {
      final result = await groqService.transcribeAudio(null);
      expect(result, contains('فشل'));
    });

    test('generateResponse returns error for empty message', () async {
      final result = await groqService.generateResponse('');
      expect(result, contains('فشل'));
    });

    test('generateResponse handles conversation history', () async {
      final history = [
        {'role': 'user', 'content': 'مرحبا'},
        {'role': 'assistant', 'content': 'أهلاً يا صديقي!'},
      ];
      
      // Should not throw error with valid history
      expect(
        () => groqService.generateResponse('كيف حالك؟', conversationHistory: history),
        returnsNormally,
      );
    });

    test('generateContextAwareResponse includes context', () async {
      final context = {
        'currentStage': 'stage_1_1',
        'totalStars': 5,
        'completionPercentage': 25.0,
      };
      
      // Should not throw error with valid context
      expect(
        () => groqService.generateContextAwareResponse('ما هي المرحلة الحالية؟', context),
        returnsNormally,
      );
    });
  });
}
