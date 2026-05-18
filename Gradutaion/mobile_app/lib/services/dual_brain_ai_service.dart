import 'package:flutter/foundation.dart';
import '../core/config/dev_settings.dart';
import '../models/message.dart';
import 'local_ai_service.dart';

/// NLU (Natural Language Understanding) result
class NLUResult {
  final String intent;
  final Map<String, dynamic> entities;
  final double confidence;
  final String response;

  NLUResult({
    required this.intent,
    required this.entities,
    required this.confidence,
    required this.response,
  });
}

/// Dual Brain AI Service
/// 
/// Implements two AI modes:
/// - NLU Mode: Rule-based, fast (<50ms), for game logic
/// - LLM Mode: Generative, slower (~500ms), for open conversation
/// 
/// Requirements: 24.5
class DualBrainAIService {
  static final DualBrainAIService _instance = DualBrainAIService._internal();
  factory DualBrainAIService() => _instance;
  DualBrainAIService._internal();

  final LocalAIService _aiService = LocalAIService();
  
  /// Current AI mode
  AIMode _currentMode = AIMode.nlu;

  /// Fuzzy matching threshold (Levenshtein distance)
  static const int _fuzzyThreshold = 2;

  // ============================================================================
  // MODE MANAGEMENT
  // ============================================================================

  /// Get current AI mode
  AIMode get currentMode => _currentMode;

  /// Set AI mode
  void setMode(AIMode mode) {
    _currentMode = mode;
    if (kDebugMode) {
      print('🧠 AI Mode switched to: ${mode == AIMode.nlu ? "NLU (Rule-Based)" : "LLM (Generative)"}');
    }
  }

  /// Toggle between modes
  void toggleMode() {
    setMode(_currentMode == AIMode.nlu ? AIMode.llm : AIMode.nlu);
  }

  // ============================================================================
  // UNIFIED INTERFACE
  // ============================================================================

  /// Process input using current AI mode
  /// 
  /// Routes to NLU or LLM based on current mode
  /// Requirements: 24.5
  Future<String> processInput({
    required String input,
    String? context,
    List<Message>? conversationHistory,
  }) async {
    if (_currentMode == AIMode.nlu) {
      // NLU Mode: Fast rule-based processing
      final result = await processNLU(input, context: context);
      return result.response;
    } else {
      // LLM Mode: Generative conversation
      final result = await processLLM(
        input,
        conversationHistory: conversationHistory,
      );
      return result.text;
    }
  }

  // ============================================================================
  // NLU MODE (Rule-Based)
  // ============================================================================

  /// Process input using NLU (rule-based) mode
  /// 
  /// Fast response time (<50ms)
  /// Uses keyword matching and fuzzy matching
  /// Requirements: 24.5
  Future<NLUResult> processNLU(String input, {String? context}) async {
    final startTime = DateTime.now();

    // Normalize input
    final normalizedInput = _normalizeArabic(input.toLowerCase().trim());

    // Intent detection with keyword matching
    final intent = _detectIntent(normalizedInput, context);
    final entities = _extractEntities(normalizedInput, intent);
    final response = _generateNLUResponse(intent, entities, context);

    final duration = DateTime.now().difference(startTime);
    
    if (kDebugMode) {
      print('🎯 NLU: "$input" → Intent: $intent (${duration.inMilliseconds}ms)');
    }

    return NLUResult(
      intent: intent,
      entities: entities,
      confidence: 0.85,
      response: response,
    );
  }

  /// Detect intent from input
  String _detectIntent(String input, String? context) {
    // Color recognition
    if (_containsAny(input, ['أحمر', 'احمر', 'red'])) return 'color_red';
    if (_containsAny(input, ['أزرق', 'ازرق', 'blue'])) return 'color_blue';
    if (_containsAny(input, ['أخضر', 'اخضر', 'green'])) return 'color_green';
    if (_containsAny(input, ['أصفر', 'اصفر', 'yellow'])) return 'color_yellow';
    if (_containsAny(input, ['برتقالي', 'orange'])) return 'color_orange';
    if (_containsAny(input, ['بنفسجي', 'purple'])) return 'color_purple';

    // Number recognition
    if (_containsAny(input, ['واحد', '1', 'one'])) return 'number_1';
    if (_containsAny(input, ['اتنين', 'اثنين', '2', 'two'])) return 'number_2';
    if (_containsAny(input, ['تلاتة', 'ثلاثة', '3', 'three'])) return 'number_3';
    if (_containsAny(input, ['أربعة', 'اربعة', '4', 'four'])) return 'number_4';
    if (_containsAny(input, ['خمسة', '5', 'five'])) return 'number_5';

    // Animal recognition
    if (_containsAny(input, ['قطة', 'قط', 'cat'])) return 'animal_cat';
    if (_containsAny(input, ['كلب', 'dog'])) return 'animal_dog';
    if (_containsAny(input, ['أسد', 'اسد', 'lion'])) return 'animal_lion';
    if (_containsAny(input, ['فيل', 'elephant'])) return 'animal_elephant';
    if (_containsAny(input, ['أرنب', 'ارنب', 'rabbit'])) return 'animal_rabbit';

    // Direction commands (for Code Commander game)
    if (_containsAny(input, ['فوق', 'up', 'أعلى', 'اعلى'])) return 'direction_up';
    if (_containsAny(input, ['تحت', 'down', 'أسفل', 'اسفل'])) return 'direction_down';
    if (_containsAny(input, ['يمين', 'right'])) return 'direction_right';
    if (_containsAny(input, ['شمال', 'left'])) return 'direction_left';

    // Game actions
    if (_containsAny(input, ['ابدأ', 'ابدا', 'start', 'العب', 'العب'])) return 'action_start';
    if (_containsAny(input, ['توقف', 'stop', 'pause'])) return 'action_pause';
    if (_containsAny(input, ['مساعدة', 'help', 'ساعدني'])) return 'action_help';
    if (_containsAny(input, ['تاني', 'again', 'مرة تانية'])) return 'action_retry';

    // Greetings
    if (_containsAny(input, ['مرحبا', 'أهلا', 'اهلا', 'hello', 'hi'])) return 'greeting';
    if (_containsAny(input, ['شكرا', 'thanks'])) return 'thanks';
    if (_containsAny(input, ['مع السلامة', 'bye'])) return 'goodbye';

    // Affirmations
    if (_containsAny(input, ['نعم', 'yes', 'أيوة', 'ايوة', 'آه'])) return 'affirmative';
    if (_containsAny(input, ['لا', 'no', 'لأ'])) return 'negative';

    return 'unknown';
  }

  /// Extract entities from input
  Map<String, dynamic> _extractEntities(String input, String intent) {
    final entities = <String, dynamic>{};

    // Extract numbers
    final numberMatch = RegExp(r'\d+').firstMatch(input);
    if (numberMatch != null) {
      entities['number'] = int.parse(numberMatch.group(0)!);
    }

    // Extract colors (already detected in intent)
    if (intent.startsWith('color_')) {
      entities['color'] = intent.substring(6);
    }

    // Extract animals (already detected in intent)
    if (intent.startsWith('animal_')) {
      entities['animal'] = intent.substring(7);
    }

    // Extract directions (already detected in intent)
    if (intent.startsWith('direction_')) {
      entities['direction'] = intent.substring(10);
    }

    return entities;
  }

  /// Generate NLU response
  String _generateNLUResponse(
    String intent,
    Map<String, dynamic> entities,
    String? context,
  ) {
    // Color responses
    if (intent.startsWith('color_')) {
      final color = entities['color'] as String;
      return 'برافو! ده لون $color! 🎨';
    }

    // Number responses
    if (intent.startsWith('number_')) {
      final number = intent.substring(7);
      return 'عظيم! ده رقم $number! 🔢';
    }

    // Animal responses
    if (intent.startsWith('animal_')) {
      final animal = entities['animal'] as String;
      return 'صح! ده $animal! 🐾';
    }

    // Direction responses
    if (intent.startsWith('direction_')) {
      final direction = entities['direction'] as String;
      return 'تمام! هنروح $direction! ➡️';
    }

    // Action responses
    if (intent == 'action_start') return 'يلا بينا نلعب! 🎮';
    if (intent == 'action_pause') return 'خلاص، هنوقف شوية 🛑';
    if (intent == 'action_help') return 'أنا هنا أساعدك! قولي محتاج إيه؟ 💡';
    if (intent == 'action_retry') return 'تمام! يلا نجرب تاني! 🔄';

    // Social responses
    if (intent == 'greeting') return 'أهلاً! أنا سمارتينو، صديقك الذكي! 👋';
    if (intent == 'thanks') return 'العفو! أنا سعيد إني ساعدتك! 😊';
    if (intent == 'goodbye') return 'مع السلامة! نلعب تاني قريب! 👋';

    // Affirmations
    if (intent == 'affirmative') return 'تمام! يلا بينا! ✅';
    if (intent == 'negative') return 'ماشي، مفيش مشكلة! ❌';

    // Unknown
    return 'مش فاهم قصدك إيه، ممكن تقول تاني؟ 🤔';
  }

  /// Check if input contains any of the keywords
  bool _containsAny(String input, List<String> keywords) {
    for (final keyword in keywords) {
      if (input.contains(keyword)) return true;
      
      // Fuzzy matching
      if (_fuzzyMatch(input, keyword)) return true;
    }
    return false;
  }

  /// Fuzzy match using Levenshtein distance
  bool _fuzzyMatch(String input, String keyword) {
    // Split input into words
    final words = input.split(' ');
    
    for (final word in words) {
      final distance = _levenshteinDistance(word, keyword);
      if (distance <= _fuzzyThreshold) return true;
    }
    
    return false;
  }

  /// Calculate Levenshtein distance
  int _levenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    final matrix = List.generate(
      s1.length + 1,
      (i) => List.filled(s2.length + 1, 0),
    );

    for (var i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }

    for (var j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    for (var i = 1; i <= s1.length; i++) {
      for (var j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1, // deletion
          matrix[i][j - 1] + 1, // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[s1.length][s2.length];
  }

  /// Normalize Arabic text
  String _normalizeArabic(String text) {
    return text
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }

  // ============================================================================
  // LLM MODE (Generative)
  // ============================================================================

  /// Process input using LLM (generative) mode
  /// 
  /// Uses Qwen for open conversation
  /// Maintains conversation context
  /// Response time ~500ms acceptable
  /// Requirements: 24.5, 16.3
  Future<LLMResponse> processLLM(
    String input, {
    List<Message>? conversationHistory,
    String? systemPrompt,
  }) async {
    return await _aiService.generateResponse(
      prompt: input,
      conversationHistory: conversationHistory,
      systemPrompt: systemPrompt,
      temperature: 0.8,
      maxTokens: 150,
    );
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Initialize AI service
  Future<bool> initialize() async {
    return await _aiService.initialize();
  }

  /// Check if initialized
  bool get isInitialized => _aiService.isInitialized;

  /// Get model info
  Map<String, dynamic>? get modelInfo => _aiService.modelInfo;
}
