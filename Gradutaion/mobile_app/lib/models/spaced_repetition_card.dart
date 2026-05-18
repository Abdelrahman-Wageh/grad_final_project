import 'package:hive/hive.dart';

part 'spaced_repetition_card.g.dart';

/// Spaced Repetition Card for SM-2 algorithm
/// Tracks learning progress for individual concepts
@HiveType(typeId: 5)
class SpacedRepetitionCard extends HiveObject {
  /// Unique identifier
  @HiveField(0)
  String id;

  /// Profile ID this card belongs to
  @HiveField(1)
  String profileId;

  /// Concept being learned (e.g., "color_red", "number_5", "letter_alef")
  @HiveField(2)
  String concept;

  /// Number of times reviewed
  @HiveField(3)
  int repetitions;

  /// Interval in days until next review
  @HiveField(4)
  int interval;

  /// Ease factor (difficulty multiplier)
  /// Default: 2.5, Range: 1.3 - 2.5+
  @HiveField(5)
  double easeFactor;

  /// Next review date
  @HiveField(6)
  DateTime nextReview;

  /// Last review date
  @HiveField(7)
  DateTime? lastReview;

  /// Quality of last response (0-5)
  /// 0: Complete blackout
  /// 1: Incorrect, but familiar
  /// 2: Incorrect, but easy to recall
  /// 3: Correct, but difficult
  /// 4: Correct, with hesitation
  /// 5: Perfect recall
  @HiveField(8)
  int? lastQuality;

  /// Total number of times this card was reviewed
  @HiveField(9)
  int totalReviews;

  /// Number of times answered correctly
  @HiveField(10)
  int correctCount;

  /// Timestamp when card was created
  @HiveField(11)
  DateTime createdAt;

  SpacedRepetitionCard({
    required this.id,
    required this.profileId,
    required this.concept,
    this.repetitions = 0,
    this.interval = 1,
    this.easeFactor = 2.5,
    DateTime? nextReview,
    this.lastReview,
    this.lastQuality,
    this.totalReviews = 0,
    this.correctCount = 0,
    DateTime? createdAt,
  })  : nextReview = nextReview ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  /// Calculate success rate
  double get successRate {
    if (totalReviews == 0) return 0.0;
    return correctCount / totalReviews;
  }

  /// Check if card is due for review
  bool get isDue {
    return DateTime.now().isAfter(nextReview);
  }

  /// Days until next review
  int get daysUntilReview {
    final now = DateTime.now();
    if (now.isAfter(nextReview)) return 0;
    return nextReview.difference(now).inDays;
  }

  /// Update card based on SM-2 algorithm
  /// 
  /// Quality scale:
  /// - 0-2: Incorrect (reset interval)
  /// - 3-5: Correct (increase interval)
  void updateWithQuality(int quality) {
    assert(quality >= 0 && quality <= 5, 'Quality must be between 0 and 5');

    lastQuality = quality;
    lastReview = DateTime.now();
    totalReviews++;

    if (quality >= 3) {
      // Correct answer
      correctCount++;

      if (repetitions == 0) {
        interval = 1;
      } else if (repetitions == 1) {
        interval = 6;
      } else {
        interval = (interval * easeFactor).round();
      }

      repetitions++;
    } else {
      // Incorrect answer - reset
      repetitions = 0;
      interval = 1;
    }

    // Update ease factor
    easeFactor = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));

    // Clamp ease factor to minimum 1.3
    if (easeFactor < 1.3) {
      easeFactor = 1.3;
    }

    // Schedule next review
    nextReview = DateTime.now().add(Duration(days: interval));

    // Save to Hive
    save();
  }

  /// Create a copy with updated fields
  SpacedRepetitionCard copyWith({
    String? id,
    String? profileId,
    String? concept,
    int? repetitions,
    int? interval,
    double? easeFactor,
    DateTime? nextReview,
    DateTime? lastReview,
    int? lastQuality,
    int? totalReviews,
    int? correctCount,
    DateTime? createdAt,
  }) {
    return SpacedRepetitionCard(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      concept: concept ?? this.concept,
      repetitions: repetitions ?? this.repetitions,
      interval: interval ?? this.interval,
      easeFactor: easeFactor ?? this.easeFactor,
      nextReview: nextReview ?? this.nextReview,
      lastReview: lastReview ?? this.lastReview,
      lastQuality: lastQuality ?? this.lastQuality,
      totalReviews: totalReviews ?? this.totalReviews,
      correctCount: correctCount ?? this.correctCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'SpacedRepetitionCard(concept: $concept, interval: $interval days, '
           'easeFactor: ${easeFactor.toStringAsFixed(2)}, '
           'successRate: ${(successRate * 100).toStringAsFixed(1)}%, '
           'isDue: $isDue)';
  }
}
