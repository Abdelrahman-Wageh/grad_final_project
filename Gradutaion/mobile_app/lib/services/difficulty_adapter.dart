import '../core/game/difficulty_level.dart';
import '../data/models/child_profile.dart';

/// Adapts game difficulty based on child's performance
/// 
/// Tracks recent game results and adjusts difficulty to maintain
/// optimal challenge level (40-90% success rate).
/// 
/// Requirements: 23.1, 23.2, 23.3, 23.4, 23.5
class DifficultyAdapter {
  static const int _windowSize = 5; // Track last 5 games
  static const double _increaseThreshold = 0.9; // 90% success
  static const double _decreaseThreshold = 0.4; // 40% success

  /// Calculates recommended difficulty based on recent performance
  /// 
  /// Requirements: 23.1, 23.2
  DifficultyLevel calculateDifficulty(
    ChildProfile profile,
    List<bool> recentAttempts,
  ) {
    if (recentAttempts.isEmpty) {
      // No history - use profile's initial assessment
      return _getInitialDifficulty(profile);
    }

    // Take last N attempts
    final window = recentAttempts.length > _windowSize
        ? recentAttempts.sublist(recentAttempts.length - _windowSize)
        : recentAttempts;

    final successRate = _calculateSuccessRate(window);
    final currentDifficulty = profile.currentDifficulty;

    // Adjust difficulty based on success rate
    if (successRate > _increaseThreshold && 
        currentDifficulty != DifficultyLevel.hard) {
      return _increaseDifficulty(currentDifficulty);
    } else if (successRate < _decreaseThreshold && 
               currentDifficulty != DifficultyLevel.easy) {
      return _decreaseDifficulty(currentDifficulty);
    }

    return currentDifficulty;
  }

  /// Gets initial difficulty based on profile assessment
  DifficultyLevel _getInitialDifficulty(ChildProfile profile) {
    switch (profile.assessmentLevel) {
      case 'below_average':
        return DifficultyLevel.easy;
      case 'average':
        return DifficultyLevel.medium;
      case 'above_average':
        return DifficultyLevel.hard;
      default:
        return DifficultyLevel.medium;
    }
  }

  /// Calculates success rate from recent attempts
  double _calculateSuccessRate(List<bool> attempts) {
    if (attempts.isEmpty) return 0.5;
    final successes = attempts.where((success) => success).length;
    return successes / attempts.length;
  }

  /// Increases difficulty level
  DifficultyLevel _increaseDifficulty(DifficultyLevel current) {
    switch (current) {
      case DifficultyLevel.easy:
        return DifficultyLevel.medium;
      case DifficultyLevel.medium:
        return DifficultyLevel.hard;
      case DifficultyLevel.hard:
        return DifficultyLevel.hard;
    }
  }

  /// Decreases difficulty level
  DifficultyLevel _decreaseDifficulty(DifficultyLevel current) {
    switch (current) {
      case DifficultyLevel.easy:
        return DifficultyLevel.easy;
      case DifficultyLevel.medium:
        return DifficultyLevel.easy;
      case DifficultyLevel.hard:
        return DifficultyLevel.medium;
    }
  }

  /// Gets encouraging notification message for difficulty change
  /// 
  /// Requirements: 23.5
  String getNotificationMessage(
    DifficultyLevel oldDifficulty,
    DifficultyLevel newDifficulty,
  ) {
    if (newDifficulty.index > oldDifficulty.index) {
      // Difficulty increased
      return _getIncreaseMessage();
    } else if (newDifficulty.index < oldDifficulty.index) {
      // Difficulty decreased
      return _getDecreaseMessage();
    }
    return '';
  }

  String _getIncreaseMessage() {
    final messages = [
      "You're doing great! Let's try something new! 🌟",
      "Wow! You're ready for a bigger challenge! 🚀",
      "Amazing work! Time to level up! ⭐",
      "You're so smart! Let's make it more fun! 🎉",
      "Fantastic! Ready for the next adventure? 🎮",
    ];
    return messages[DateTime.now().millisecond % messages.length];
  }

  String _getDecreaseMessage() {
    final messages = [
      "Let's practice a bit more together! 💪",
      "No worries! We'll take it step by step! 🌈",
      "Let's try this way - it'll be fun! 🎨",
      "Great effort! Let's make it easier! 😊",
      "You're doing well! Let's try this! 🌟",
    ];
    return messages[DateTime.now().millisecond % messages.length];
  }

  /// Gets visual hints configuration for current difficulty
  /// 
  /// Requirements: 23.3
  VisualHints getVisualHints(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return VisualHints(
          showPathHighlight: true,
          showColorCoding: true,
          showAnimatedArrows: true,
          showNumberHints: true,
        );
      case DifficultyLevel.medium:
        return VisualHints(
          showPathHighlight: false,
          showColorCoding: true,
          showAnimatedArrows: false,
          showNumberHints: true,
        );
      case DifficultyLevel.hard:
        return VisualHints(
          showPathHighlight: false,
          showColorCoding: false,
          showAnimatedArrows: false,
          showNumberHints: false,
        );
    }
  }

  /// Gets complexity parameters for current difficulty
  /// 
  /// Requirements: 23.4
  ComplexityParams getComplexityParams(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return ComplexityParams(
          gridSize: 4,
          obstacleCount: 2,
          maxNumber: 10,
          timeLimit: null, // No time limit
          allowedMistakes: 3,
        );
      case DifficultyLevel.medium:
        return ComplexityParams(
          gridSize: 6,
          obstacleCount: 4,
          maxNumber: 20,
          timeLimit: 120, // 2 minutes
          allowedMistakes: 2,
        );
      case DifficultyLevel.hard:
        return ComplexityParams(
          gridSize: 8,
          obstacleCount: 8,
          maxNumber: 50,
          timeLimit: 90, // 1.5 minutes
          allowedMistakes: 1,
        );
    }
  }

  /// Checks if difficulty should be adjusted
  bool shouldAdjustDifficulty(List<bool> recentAttempts) {
    if (recentAttempts.length < _windowSize) {
      return false; // Not enough data
    }

    final window = recentAttempts.sublist(recentAttempts.length - _windowSize);
    final successRate = _calculateSuccessRate(window);

    return successRate > _increaseThreshold || 
           successRate < _decreaseThreshold;
  }
}

/// Visual hints configuration for different difficulty levels
/// 
/// Requirements: 23.3
class VisualHints {
  final bool showPathHighlight;
  final bool showColorCoding;
  final bool showAnimatedArrows;
  final bool showNumberHints;

  VisualHints({
    required this.showPathHighlight,
    required this.showColorCoding,
    required this.showAnimatedArrows,
    required this.showNumberHints,
  });
}

/// Complexity parameters for different difficulty levels
/// 
/// Requirements: 23.4
class ComplexityParams {
  final int gridSize;
  final int obstacleCount;
  final int maxNumber;
  final int? timeLimit; // seconds, null = no limit
  final int allowedMistakes;

  ComplexityParams({
    required this.gridSize,
    required this.obstacleCount,
    required this.maxNumber,
    required this.timeLimit,
    required this.allowedMistakes,
  });
}
