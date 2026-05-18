/// Story Generator - Creates AI-generated stories related to games
/// Uses Groq LLM to generate Egyptian-themed educational stories

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../services/ai/groq_service.dart';
import 'models/story.dart';

class StoryGenerator {
  final GroqService _groqService;
  final _uuid = const Uuid();
  
  StoryGenerator(this._groqService);
  
  /// Generate a story based on theme and game context
  Future<Story> generateStory({
    required StoryTheme theme,
    required String difficulty,
    String? gameContext,
    List<String>? learningObjectives,
  }) async {
    try {
      // Build prompt for story generation
      final prompt = _buildStoryPrompt(theme, difficulty, gameContext, learningObjectives);
      
      // Generate story using LLM
      final storyText = await _groqService.generateResponse(prompt);
      
      // Parse story into segments
      final segments = _parseStorySegments(storyText);
      
      // Create story object
      return Story(
        id: _uuid.v4(),
        titleAr: _generateTitle(theme, 'ar'),
        titleEn: _generateTitle(theme, 'en'),
        theme: theme.id,
        segments: segments,
        difficulty: difficulty,
        learningObjectives: learningObjectives ?? _getDefaultObjectives(theme),
      );
    } catch (e) {
      debugPrint('❌ Story generation error: $e');
      // Fallback to template story
      return _getFallbackStory(theme);
    }
  }
  
  /// Build prompt for story generation
  String _buildStoryPrompt(
    StoryTheme theme,
    String difficulty,
    String? gameContext,
    List<String>? objectives,
  ) {
    return '''
اكتب قصة قصيرة للأطفال (4-8 سنوات) باللهجة المصرية عن فرفور الكلب الذكي.

الموضوع: ${theme.nameAr}
المستوى: $difficulty
${gameContext != null ? 'سياق اللعبة: $gameContext' : ''}
${objectives != null ? 'أهداف التعلم: ${objectives.join(', ')}' : ''}

متطلبات القصة:
1. القصة تكون في مكان مصري مشهور (القاهرة، الإسكندرية، الأقصر، إلخ)
2. فرفور هو البطل ويتعلم شيء جديد
3. استخدم كلمات بسيطة ومناسبة للأطفال
4. اجعل القصة مرتبطة بموضوع ${theme.nameAr}
5. القصة تكون 4-5 فقرات قصيرة
6. كل فقرة تبدأ بـ [SEGMENT]
7. استخدم إيموجي مناسب في كل فقرة
8. القصة تكون تعليمية وممتعة
9. النهاية تكون إيجابية ومشجعة

مثال على التنسيق:
[SEGMENT] فرفور راح القاهرة... 🏙️
[SEGMENT] شاف حاجة جميلة... ⭐
[SEGMENT] اتعلم درس مهم... 📚
[SEGMENT] فرفور فرح جداً! 🎉

ابدأ القصة الآن:
''';
  }
  
  /// Parse story text into segments
  List<StorySegment> _parseStorySegments(String storyText) {
    final segments = <StorySegment>[];
    final parts = storyText.split('[SEGMENT]');
    
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.isEmpty) continue;
      
      segments.add(StorySegment(
        textAr: trimmed,
        textEn: '', // Translation can be added later
      ));
    }
    
    // If parsing failed, create single segment
    if (segments.isEmpty) {
      segments.add(StorySegment(
        textAr: storyText,
        textEn: '',
      ));
    }
    
    return segments;
  }
  
  /// Generate title based on theme
  String _generateTitle(StoryTheme theme, String language) {
    if (language == 'ar') {
      switch (theme) {
        case StoryTheme.colors:
          return 'مغامرة فرفور الملونة';
        case StoryTheme.numbers:
          return 'فرفور يتعلم الأرقام';
        case StoryTheme.letters:
          return 'فرفور والحروف السحرية';
        case StoryTheme.shapes:
          return 'فرفور يكتشف الأشكال';
        case StoryTheme.animals:
          return 'فرفور وأصدقاء الحيوانات';
        case StoryTheme.adventure:
          return 'مغامرة فرفور الكبيرة';
        case StoryTheme.friendship:
          return 'فرفور والصداقة';
        case StoryTheme.problemSolving:
          return 'فرفور يحل المشكلة';
      }
    } else {
      switch (theme) {
        case StoryTheme.colors:
          return "Farfour's Colorful Adventure";
        case StoryTheme.numbers:
          return 'Farfour Learns Numbers';
        case StoryTheme.letters:
          return 'Farfour and the Magic Letters';
        case StoryTheme.shapes:
          return 'Farfour Discovers Shapes';
        case StoryTheme.animals:
          return 'Farfour and Animal Friends';
        case StoryTheme.adventure:
          return "Farfour's Big Adventure";
        case StoryTheme.friendship:
          return 'Farfour and Friendship';
        case StoryTheme.problemSolving:
          return 'Farfour Solves the Problem';
      }
    }
  }
  
  /// Get default learning objectives for theme
  List<String> _getDefaultObjectives(StoryTheme theme) {
    switch (theme) {
      case StoryTheme.colors:
        return ['تعلم الألوان الأساسية', 'التعرف على الألوان في البيئة'];
      case StoryTheme.numbers:
        return ['تعلم الأرقام من 1 إلى 10', 'العد والحساب'];
      case StoryTheme.letters:
        return ['تعلم الحروف العربية', 'نطق الحروف'];
      case StoryTheme.shapes:
        return ['تعلم الأشكال الهندسية', 'التعرف على الأشكال'];
      case StoryTheme.animals:
        return ['تعلم أسماء الحيوانات', 'أصوات الحيوانات'];
      case StoryTheme.adventure:
        return ['الشجاعة', 'الاستكشاف'];
      case StoryTheme.friendship:
        return ['قيمة الصداقة', 'التعاون'];
      case StoryTheme.problemSolving:
        return ['التفكير المنطقي', 'حل المشكلات'];
    }
  }
  
  /// Get fallback story from templates
  Story _getFallbackStory(StoryTheme theme) {
    switch (theme) {
      case StoryTheme.colors:
        return EgyptianStoryTemplates.colorAdventure();
      case StoryTheme.numbers:
        return EgyptianStoryTemplates.numberAdventure();
      case StoryTheme.letters:
        return EgyptianStoryTemplates.letterAdventure();
      case StoryTheme.shapes:
        return EgyptianStoryTemplates.shapeAdventure();
      case StoryTheme.problemSolving:
        return EgyptianStoryTemplates.mazeAdventure();
      default:
        return EgyptianStoryTemplates.colorAdventure();
    }
  }
  
  /// Generate story related to specific game
  Future<Story> generateGameRelatedStory({
    required String gameName,
    required String difficulty,
    Map<String, dynamic>? gameProgress,
  }) async {
    // Map game to theme
    final theme = _mapGameToTheme(gameName);
    
    // Build game context
    final gameContext = _buildGameContext(gameName, gameProgress);
    
    // Generate story
    return generateStory(
      theme: theme,
      difficulty: difficulty,
      gameContext: gameContext,
    );
  }
  
  /// Map game name to story theme
  StoryTheme _mapGameToTheme(String gameName) {
    if (gameName.contains('color') || gameName.contains('لون')) {
      return StoryTheme.colors;
    } else if (gameName.contains('number') || gameName.contains('رقم')) {
      return StoryTheme.numbers;
    } else if (gameName.contains('letter') || gameName.contains('حرف')) {
      return StoryTheme.letters;
    } else if (gameName.contains('shape') || gameName.contains('شكل')) {
      return StoryTheme.shapes;
    } else if (gameName.contains('maze') || gameName.contains('متاهة')) {
      return StoryTheme.problemSolving;
    } else {
      return StoryTheme.adventure;
    }
  }
  
  /// Build game context for story generation
  String _buildGameContext(String gameName, Map<String, dynamic>? progress) {
    var context = 'الطفل يلعب لعبة $gameName';
    
    if (progress != null) {
      if (progress.containsKey('level')) {
        context += ' في المستوى ${progress['level']}';
      }
      if (progress.containsKey('stars')) {
        context += ' وحصل على ${progress['stars']} نجوم';
      }
    }
    
    return context;
  }
}
