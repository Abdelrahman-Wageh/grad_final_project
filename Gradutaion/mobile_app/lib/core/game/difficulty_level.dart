/// Difficulty levels for procedural game generation
/// Requirements: 23.1, 23.2
enum DifficultyLevel {
  easy,
  medium,
  hard;

  /// Get difficulty multiplier for game parameters
  double get multiplier {
    switch (this) {
      case DifficultyLevel.easy:
        return 0.5;
      case DifficultyLevel.medium:
        return 1.0;
      case DifficultyLevel.hard:
        return 1.5;
    }
  }

  /// Get grid size for spatial games
  int get gridSize {
    switch (this) {
      case DifficultyLevel.easy:
        return 4;
      case DifficultyLevel.medium:
        return 6;
      case DifficultyLevel.hard:
        return 8;
    }
  }

  /// Get max number for math games
  int get maxNumber {
    switch (this) {
      case DifficultyLevel.easy:
        return 10;
      case DifficultyLevel.medium:
        return 20;
      case DifficultyLevel.hard:
        return 50;
    }
  }

  /// Get obstacle density (0.0 - 1.0)
  double get obstacleDensity {
    switch (this) {
      case DifficultyLevel.easy:
        return 0.15;
      case DifficultyLevel.medium:
        return 0.25;
      case DifficultyLevel.hard:
        return 0.35;
    }
  }

  /// Get time limit in seconds (0 = no limit)
  int get timeLimit {
    switch (this) {
      case DifficultyLevel.easy:
        return 0; // No time limit
      case DifficultyLevel.medium:
        return 120; // 2 minutes
      case DifficultyLevel.hard:
        return 60; // 1 minute
    }
  }

  /// Get hint availability
  bool get hintsEnabled {
    switch (this) {
      case DifficultyLevel.easy:
        return true;
      case DifficultyLevel.medium:
        return true;
      case DifficultyLevel.hard:
        return false;
    }
  }

  /// Get display name
  String get displayName {
    switch (this) {
      case DifficultyLevel.easy:
        return 'Easy';
      case DifficultyLevel.medium:
        return 'Medium';
      case DifficultyLevel.hard:
        return 'Hard';
    }
  }

  /// Get display name in Arabic
  String get displayNameArabic {
    switch (this) {
      case DifficultyLevel.easy:
        return 'سهل';
      case DifficultyLevel.medium:
        return 'متوسط';
      case DifficultyLevel.hard:
        return 'صعب';
    }
  }
}
