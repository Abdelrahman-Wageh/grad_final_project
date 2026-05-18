import 'dart:math';
import 'level.dart';
import 'difficulty_level.dart';
import '../../data/models/child_profile.dart';

/// Abstract base class for procedural level generation
/// Requirements: 18.1, 18.2, 18.3, 18.4
abstract class LevelGenerator<T extends Level> {
  final Random random;

  LevelGenerator({Random? random}) : random = random ?? Random();

  /// Generate a new level based on difficulty and profile
  /// Requirement 18.1, 18.2, 18.3
  /// Can be async for generators that need to load resources
  dynamic generateLevel(DifficultyLevel difficulty, ChildProfile profile);

  /// Validate that the generated level is solvable
  /// Requirement 18.5
  bool validateLevel(T level);

  /// Adjust difficulty based on recent performance
  /// Requirements: 23.1, 23.2
  DifficultyLevel adjustDifficulty(List<bool> recentAttempts) {
    if (recentAttempts.isEmpty) {
      return DifficultyLevel.easy;
    }

    // Calculate success rate from last 5 attempts
    final last5 = recentAttempts.length > 5
        ? recentAttempts.sublist(recentAttempts.length - 5)
        : recentAttempts;

    final successCount = last5.where((success) => success).length;
    final successRate = successCount / last5.length;

    // Requirement 23.1: Increase difficulty if > 90%
    if (successRate > 0.9) {
      return DifficultyLevel.hard;
    }
    // Requirement 23.2: Decrease difficulty if < 40%
    else if (successRate < 0.4) {
      return DifficultyLevel.easy;
    }
    // Stay at medium
    else {
      return DifficultyLevel.medium;
    }
  }

  /// Get encouraging message for difficulty adjustment
  /// Requirement 23.5
  String getDifficultyAdjustmentMessage(
      DifficultyLevel oldLevel, DifficultyLevel newLevel) {
    if (newLevel.index > oldLevel.index) {
      // Difficulty increased
      return "You're doing great! Let's try something new! 🌟";
    } else if (newLevel.index < oldLevel.index) {
      // Difficulty decreased
      return "Let's practice a bit more together! 💪";
    } else {
      // No change
      return "You're doing amazing! Keep going! ⭐";
    }
  }

  /// Generate random position within grid bounds
  Position randomPosition(int gridSize) {
    return Position(
      random.nextInt(gridSize),
      random.nextInt(gridSize),
    );
  }

  /// Check if position is within grid bounds
  bool isInBounds(Position pos, int gridSize) {
    return pos.x >= 0 && pos.x < gridSize && pos.y >= 0 && pos.y < gridSize;
  }

  /// Generate unique ID for level
  String generateLevelId() {
    return 'level_${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(10000)}';
  }
}

/// Result of level generation attempt
class LevelGenerationResult<T extends Level> {
  final T? level;
  final bool success;
  final String? errorMessage;
  final int attempts;

  LevelGenerationResult({
    this.level,
    required this.success,
    this.errorMessage,
    required this.attempts,
  });

  factory LevelGenerationResult.success(T level, int attempts) {
    return LevelGenerationResult(
      level: level,
      success: true,
      attempts: attempts,
    );
  }

  factory LevelGenerationResult.failure(String error, int attempts) {
    return LevelGenerationResult(
      success: false,
      errorMessage: error,
      attempts: attempts,
    );
  }
}
