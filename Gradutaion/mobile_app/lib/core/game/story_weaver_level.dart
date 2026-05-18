import 'level.dart';
import 'difficulty_level.dart';

/// Story Weaver game level
/// Requirements: 18.2, 20.1-20.5
class StoryWeaverLevel extends Level {
  final String category;
  final String story;
  final String correctAnswer;
  final List<String> acceptableAnswers;
  final String? storyArabic;
  final bool isBilingual;

  StoryWeaverLevel({
    required super.id,
    required super.difficulty,
    required this.category,
    required this.story,
    required this.correctAnswer,
    required this.acceptableAnswers,
    this.storyArabic,
    this.isBilingual = false,
    super.createdAt,
  });

  @override
  bool validate() {
    // Story must have [BLANK] placeholder
    if (!story.contains('[BLANK]')) return false;

    // Must have correct answer
    if (correctAnswer.isEmpty) return false;

    // Must have acceptable answers
    if (acceptableAnswers.isEmpty) return false;

    return true;
  }

  /// Check if user's answer is correct (with fuzzy matching)
  /// Requirement 20.2: Fuzzy matching validation
  bool checkAnswer(String userAnswer) {
    final normalized = userAnswer.toLowerCase().trim();

    // Check exact match first
    if (acceptableAnswers
        .any((answer) => answer.toLowerCase().trim() == normalized)) {
      return true;
    }

    // Check fuzzy match (handled by FuzzyMatcher in game logic)
    return false;
  }

  /// Get the story with the answer filled in
  String getCompletedStory(String answer) {
    return story.replaceAll('[BLANK]', answer);
  }

  /// Get the Arabic story with the answer filled in
  String? getCompletedStoryArabic(String answer) {
    return storyArabic?.replaceAll('[BLANK]', answer);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'difficulty': difficulty.name,
      'category': category,
      'story': story,
      'correctAnswer': correctAnswer,
      'acceptableAnswers': acceptableAnswers,
      'storyArabic': storyArabic,
      'isBilingual': isBilingual,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory StoryWeaverLevel.fromJson(Map<String, dynamic> json) {
    return StoryWeaverLevel(
      id: json['id'] as String,
      difficulty: DifficultyLevel.values.firstWhere(
        (d) => d.name == json['difficulty'],
      ),
      category: json['category'] as String,
      story: json['story'] as String,
      correctAnswer: json['correctAnswer'] as String,
      acceptableAnswers: (json['acceptableAnswers'] as List)
          .map((a) => a as String)
          .toList(),
      storyArabic: json['storyArabic'] as String?,
      isBilingual: json['isBilingual'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Get level statistics
  Map<String, dynamic> getStats() {
    return {
      'category': category,
      'storyLength': story.length,
      'acceptableAnswersCount': acceptableAnswers.length,
      'isBilingual': isBilingual,
      'difficulty': difficulty.displayName,
    };
  }
}
