import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'level_generator.dart';
import 'story_weaver_level.dart';
import 'difficulty_level.dart';
import '../../data/models/child_profile.dart';
import '../../utils/fuzzy_matcher.dart';

/// Procedural generator for Story Weaver levels
/// Requirements: 18.2, 20.5
class StoryWeaverGenerator extends LevelGenerator<StoryWeaverLevel> {
  Map<String, dynamic>? _templates;
  bool _isLoaded = false;

  StoryWeaverGenerator({super.random});

  /// Load templates from JSON file
  /// Requirement 18.2: Load templates from JSON file
  Future<void> loadTemplates() async {
    if (_isLoaded) return;

    try {
      final jsonString =
          await rootBundle.loadString('assets/data/story_templates.json');
      _templates = json.decode(jsonString) as Map<String, dynamic>;
      _isLoaded = true;
    } catch (e) {
      // Fallback to hardcoded templates if file not found
      _templates = _getDefaultTemplates();
      _isLoaded = true;
    }
  }

  @override
  Future<StoryWeaverLevel> generateLevel(
    DifficultyLevel difficulty,
    ChildProfile profile,
  ) async {
    await loadTemplates();

    // Requirement 18.2: Randomly select category and word
    final category = _selectCategory(difficulty);
    final word = _selectWord(category);
    final template = _selectTemplate(category);

    // Generate story with blank
    final story = template;

    // Create fuzzy match list
    final acceptableAnswers = _getFuzzyMatches(word, category);

    // Get Arabic version if bilingual
    final storyArabic = _selectTemplateArabic(category);

    return StoryWeaverLevel(
      id: generateLevelId(),
      difficulty: difficulty,
      category: category,
      story: story,
      correctAnswer: word,
      acceptableAnswers: acceptableAnswers,
      storyArabic: storyArabic,
      isBilingual: profile.preferredLanguage == 'bilingual',
    );
  }

  @override
  bool validateLevel(StoryWeaverLevel level) {
    return level.validate();
  }

  /// Select category based on difficulty
  String _selectCategory(DifficultyLevel difficulty) {
    final categories = _templates?.keys.toList() ?? ['animals', 'colors'];

    switch (difficulty) {
      case DifficultyLevel.easy:
        // Easy: animals, colors, objects
        final easyCategories = categories
            .where((c) => ['animals', 'colors', 'objects'].contains(c))
            .toList();
        return easyCategories[random.nextInt(easyCategories.length)];

      case DifficultyLevel.medium:
        // Medium: all categories except actions
        final mediumCategories =
            categories.where((c) => c != 'actions').toList();
        return mediumCategories[random.nextInt(mediumCategories.length)];

      case DifficultyLevel.hard:
        // Hard: all categories
        return categories[random.nextInt(categories.length)];
    }
  }

  /// Select random word from category
  String _selectWord(String category) {
    final categoryData = _templates?[category] as Map<String, dynamic>?;
    final words = categoryData?['words'] as List<dynamic>? ?? ['word'];

    return words[random.nextInt(words.length)] as String;
  }

  /// Select random template from category
  String _selectTemplate(String category) {
    final categoryData = _templates?[category] as Map<String, dynamic>?;
    final templates =
        categoryData?['templates'] as List<dynamic>? ?? ['[BLANK]'];

    return templates[random.nextInt(templates.length)] as String;
  }

  /// Select random Arabic template from category
  String? _selectTemplateArabic(String category) {
    final categoryData = _templates?[category] as Map<String, dynamic>?;
    final templates = categoryData?['templates_ar'] as List<dynamic>?;

    if (templates == null || templates.isEmpty) return null;

    return templates[random.nextInt(templates.length)] as String;
  }

  /// Get fuzzy matches for a word
  /// Requirement 20.2: Create fuzzy match list
  List<String> _getFuzzyMatches(String word, String category) {
    final matches = <String>[word];

    // Add the word itself
    matches.add(word.toLowerCase());
    matches.add(word.toUpperCase());

    // Add common variations
    final categoryData = _templates?[category] as Map<String, dynamic>?;
    final allWords = categoryData?['words'] as List<dynamic>? ?? [];

    // Add phonetically similar words
    for (final otherWord in allWords) {
      final wordStr = otherWord as String;
      if (FuzzyMatcher.isPhoneticallyClose(word, wordStr)) {
        matches.add(wordStr);
      }
    }

    // Remove duplicates
    return matches.toSet().toList();
  }

  /// Get default templates if JSON file not found
  Map<String, dynamic> _getDefaultTemplates() {
    return {
      'animals': {
        'words': ['cat', 'dog', 'bird', 'fish', 'rabbit'],
        'templates': [
          'Smartino sees a [BLANK] in the forest!',
          'The [BLANK] is playing with Smartino.',
          'Look! A friendly [BLANK] wants to say hello!',
        ],
        'templates_ar': [
          'سمارتينو يرى [BLANK] في الغابة!',
          '[BLANK] يلعب مع سمارتينو.',
        ],
      },
      'colors': {
        'words': ['red', 'blue', 'green', 'yellow', 'purple'],
        'templates': [
          'Smartino loves the [BLANK] flower!',
          'The sky is [BLANK] today.',
          'Look at the [BLANK] butterfly!',
        ],
        'templates_ar': [
          'سمارتينو يحب الزهرة [BLANK]!',
          'السماء [BLANK] اليوم.',
        ],
      },
      'objects': {
        'words': ['ball', 'book', 'toy', 'star', 'moon'],
        'templates': [
          'Smartino found a [BLANK]!',
          'The [BLANK] is shining bright.',
          'Look at the beautiful [BLANK]!',
        ],
        'templates_ar': [
          'سمارتينو وجد [BLANK]!',
          '[BLANK] يلمع بشدة.',
        ],
      },
    };
  }

  /// Generate level with specific word (for testing)
  Future<StoryWeaverLevel> generateCustomLevel({
    required DifficultyLevel difficulty,
    required String category,
    required String word,
  }) async {
    await loadTemplates();

    final template = _selectTemplate(category);
    final acceptableAnswers = _getFuzzyMatches(word, category);
    final storyArabic = _selectTemplateArabic(category);

    return StoryWeaverLevel(
      id: generateLevelId(),
      difficulty: difficulty,
      category: category,
      story: template,
      correctAnswer: word,
      acceptableAnswers: acceptableAnswers,
      storyArabic: storyArabic,
      isBilingual: false,
    );
  }
}
