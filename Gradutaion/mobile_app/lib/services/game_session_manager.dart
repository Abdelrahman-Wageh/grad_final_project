import '../data/models/child_profile.dart';
import '../core/game/difficulty_level.dart';
import 'spaced_repetition_manager.dart';
import 'difficulty_adapter.dart';
import 'local_storage_service.dart';

/// Manages game sessions with spaced repetition and dynamic difficulty
/// 
/// Coordinates between games, spaced repetition, and difficulty adaptation
/// to create an optimal learning experience.
/// 
/// Requirements: 22.1-22.5, 23.1-23.5
class GameSessionManager {
  final SpacedRepetitionManager _srManager;
  final DifficultyAdapter _difficultyAdapter;
  final LocalStorageService _storage;

  GameSessionManager(
    this._srManager,
    this._difficultyAdapter,
    this._storage,
  );

  /// Starts a new game session
  /// 
  /// Returns the recommended difficulty level and any concepts due for review
  Future<GameSession> startSession(ChildProfile profile) async {
    // Get cards due for review
    final dueCards = await _srManager.getCardsForReview(profile.id);

    // Calculate recommended difficulty
    final recommendedDifficulty = _difficultyAdapter.calculateDifficulty(
      profile,
      profile.recentAttempts,
    );

    // Check if difficulty should be adjusted
    final shouldAdjust = _difficultyAdapter.shouldAdjustDifficulty(
      profile.recentAttempts,
    );

    String? notificationMessage;
    if (shouldAdjust && recommendedDifficulty != profile.currentDifficulty) {
      notificationMessage = _difficultyAdapter.getNotificationMessage(
        profile.currentDifficulty,
        recommendedDifficulty,
      );

      // Update profile difficulty
      profile.currentDifficulty = recommendedDifficulty;
      await _storage.saveProfile(profile);
    }

    // Get visual hints and complexity params
    final hints = _difficultyAdapter.getVisualHints(recommendedDifficulty);
    final complexity = _difficultyAdapter.getComplexityParams(recommendedDifficulty);

    return GameSession(
      profile: profile,
      difficulty: recommendedDifficulty,
      dueCards: dueCards,
      visualHints: hints,
      complexityParams: complexity,
      difficultyChangedMessage: notificationMessage,
    );
  }

  /// Ends a game session and records the result
  /// 
  /// Updates spaced repetition cards and difficulty tracking
  Future<GameSessionResult> endSession({
    required ChildProfile profile,
    required String concept,
    required bool isCorrect,
    required int performanceQuality, // 0-5 for SR
  }) async {
    // Update profile attempts
    profile.addAttempt(isCorrect);

    // Update spaced repetition card
    final cards = await _srManager.getCardsForReview(profile.id);
    final existingCard = cards.where((c) => c.concept == concept).firstOrNull;

    if (existingCard != null) {
      // Update existing card
      await _srManager.updateCard(existingCard, performanceQuality);
    } else {
      // Schedule new concept for review
      await _srManager.scheduleReview(profile.id, concept);
    }

    // Save updated profile
    await _storage.saveProfile(profile);

    // Get updated stats
    final srStats = await _srManager.getStats(profile.id);

    return GameSessionResult(
      isCorrect: isCorrect,
      conceptReviewed: concept,
      nextReviewDate: existingCard?.nextReview,
      spacedRepetitionStats: srStats,
    );
  }

  /// Gets a summary of the child's learning progress
  Future<LearningProgress> getProgress(ChildProfile profile) async {
    final srStats = await _srManager.getStats(profile.id);
    final successRate = profile.getRecentSuccessRate(last: 10);

    return LearningProgress(
      currentDifficulty: profile.currentDifficulty,
      successRate: successRate,
      totalConcepts: srStats.totalCards,
      masteredConcepts: srStats.mastered,
      learningConcepts: srStats.learning,
      newConcepts: srStats.new_,
      dueToday: srStats.dueToday,
      stars: profile.stars,
      currentStreak: profile.currentStreak,
    );
  }
}

/// Represents an active game session
class GameSession {
  final ChildProfile profile;
  final DifficultyLevel difficulty;
  final List dueCards;
  final VisualHints visualHints;
  final ComplexityParams complexityParams;
  final String? difficultyChangedMessage;

  GameSession({
    required this.profile,
    required this.difficulty,
    required this.dueCards,
    required this.visualHints,
    required this.complexityParams,
    this.difficultyChangedMessage,
  });
}

/// Result of a completed game session
class GameSessionResult {
  final bool isCorrect;
  final String conceptReviewed;
  final DateTime? nextReviewDate;
  final dynamic spacedRepetitionStats;

  GameSessionResult({
    required this.isCorrect,
    required this.conceptReviewed,
    this.nextReviewDate,
    required this.spacedRepetitionStats,
  });
}

/// Overall learning progress summary
class LearningProgress {
  final DifficultyLevel currentDifficulty;
  final double successRate;
  final int totalConcepts;
  final int masteredConcepts;
  final int learningConcepts;
  final int newConcepts;
  final int dueToday;
  final int stars;
  final int currentStreak;

  LearningProgress({
    required this.currentDifficulty,
    required this.successRate,
    required this.totalConcepts,
    required this.masteredConcepts,
    required this.learningConcepts,
    required this.newConcepts,
    required this.dueToday,
    required this.stars,
    required this.currentStreak,
  });

  /// Get a child-friendly progress message
  String getProgressMessage() {
    if (successRate >= 0.9) {
      return "You're a superstar! 🌟 Keep up the amazing work!";
    } else if (successRate >= 0.7) {
      return "Great job! 🎉 You're learning so much!";
    } else if (successRate >= 0.5) {
      return "You're doing well! 💪 Keep practicing!";
    } else {
      return "Let's learn together! 🌈 You've got this!";
    }
  }
}
