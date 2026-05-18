import 'package:hive/hive.dart';
import '../models/spaced_repetition_card.dart';
import 'local_storage_service.dart';

/// Manages spaced repetition learning using the SM-2 algorithm
/// 
/// The SM-2 algorithm optimizes review timing based on performance:
/// - Quality 0-2: Reset card (failed)
/// - Quality 3-5: Increase interval (passed)
/// 
/// Requirements: 22.1, 22.2, 22.3, 22.4, 22.5
class SpacedRepetitionManager {
  final LocalStorageService _storage;

  SpacedRepetitionManager(this._storage);

  /// Updates a card based on performance quality (0-5)
  /// 
  /// Quality scale:
  /// - 0: Complete blackout
  /// - 1: Incorrect, but familiar
  /// - 2: Incorrect, but easy to recall
  /// - 3: Correct, but difficult
  /// - 4: Correct, with hesitation
  /// - 5: Perfect recall
  /// 
  /// Requirements: 22.1, 22.2, 22.3
  Future<SpacedRepetitionCard> updateCard(
    SpacedRepetitionCard card,
    int quality,
  ) async {
    assert(quality >= 0 && quality <= 5, 'Quality must be between 0 and 5');

    SpacedRepetitionCard updatedCard;

    if (quality < 3) {
      // Failed - reset the card
      updatedCard = card.copyWith(
        repetitions: 0,
        interval: 1,
        easeFactor: card.easeFactor,
        nextReview: DateTime.now().add(const Duration(days: 1)),
        lastReview: DateTime.now(),
      );
    } else {
      // Passed - calculate new values using SM-2
      final newEaseFactor = _calculateEaseFactor(card.easeFactor, quality);
      final newRepetitions = card.repetitions + 1;
      final newInterval = _calculateInterval(
        card.interval,
        newRepetitions,
        newEaseFactor,
      );

      updatedCard = card.copyWith(
        repetitions: newRepetitions,
        interval: newInterval,
        easeFactor: newEaseFactor,
        nextReview: DateTime.now().add(Duration(days: newInterval)),
        lastReview: DateTime.now(),
      );
    }

    // Persist to Hive
    await _storage.updateCard(card.profileId, updatedCard);

    return updatedCard;
  }

  /// Calculates new ease factor using SM-2 formula
  /// 
  /// Formula: EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
  /// Minimum ease factor: 1.3
  double _calculateEaseFactor(double currentEF, int quality) {
    final newEF = currentEF + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    return newEF < 1.3 ? 1.3 : newEF;
  }

  /// Calculates new interval using SM-2 algorithm
  /// 
  /// - First repetition: 1 day
  /// - Second repetition: 6 days
  /// - Subsequent: previous interval * ease factor
  int _calculateInterval(int currentInterval, int repetitions, double easeFactor) {
    if (repetitions == 1) {
      return 1;
    } else if (repetitions == 2) {
      return 6;
    } else {
      return (currentInterval * easeFactor).round();
    }
  }

  /// Gets all cards due for review for a profile
  /// 
  /// Requirements: 22.4, 22.5
  Future<List<SpacedRepetitionCard>> getCardsForReview(String profileId) async {
    final allCards = await _storage.getCardsForReview(profileId);
    final now = DateTime.now();

    // Filter cards where nextReview is today or earlier
    return allCards.where((card) {
      return card.nextReview.isBefore(now) || 
             card.nextReview.isAtSameMomentAs(now);
    }).toList();
  }

  /// Schedules a new concept for review
  /// 
  /// Requirements: 22.5
  Future<SpacedRepetitionCard> scheduleReview(
    String profileId,
    String concept,
  ) async {
    final card = SpacedRepetitionCard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      profileId: profileId,
      concept: concept,
      repetitions: 0,
      interval: 1,
      easeFactor: 2.5, // Default ease factor
      nextReview: DateTime.now().add(const Duration(days: 1)),
      lastReview: DateTime.now(),
    );

    await _storage.updateCard(profileId, card);
    return card;
  }

  /// Gets statistics for a profile's spaced repetition progress
  Future<SpacedRepetitionStats> getStats(String profileId) async {
    final allCards = await _storage.getCardsForReview(profileId);
    final now = DateTime.now();

    final dueToday = allCards.where((card) {
      return card.nextReview.isBefore(now) || 
             card.nextReview.isAtSameMomentAs(now);
    }).length;

    final mastered = allCards.where((card) => card.repetitions >= 5).length;
    final learning = allCards.where((card) => 
      card.repetitions > 0 && card.repetitions < 5
    ).length;
    final new_ = allCards.where((card) => card.repetitions == 0).length;

    return SpacedRepetitionStats(
      totalCards: allCards.length,
      dueToday: dueToday,
      mastered: mastered,
      learning: learning,
      new_: new_,
    );
  }
}

/// Statistics for spaced repetition progress
class SpacedRepetitionStats {
  final int totalCards;
  final int dueToday;
  final int mastered;
  final int learning;
  final int new_;

  SpacedRepetitionStats({
    required this.totalCards,
    required this.dueToday,
    required this.mastered,
    required this.learning,
    required this.new_,
  });
}
