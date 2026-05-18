/// Smartino Super-App - Stage Progress Model
/// Tracks progress for each learning stage
/// Requirements: 1.4, 1.5

import 'package:hive/hive.dart';

part 'stage_progress.g.dart';

@HiveType(typeId: 10)
class StageProgress extends HiveObject {
  @HiveField(0)
  final String stageId;
  
  @HiveField(1)
  final int stars; // Stars earned in last attempt (0-3)
  
  @HiveField(2)
  final int bestStars; // Best stars ever earned (0-3)
  
  @HiveField(3)
  final bool isCompleted;
  
  @HiveField(4)
  final int attempts; // Number of times played
  
  @HiveField(5)
  final DateTime lastPlayedAt;
  
  @HiveField(6)
  final int correctAnswers;
  
  @HiveField(7)
  final int totalQuestions;
  
  @HiveField(8)
  final Duration? bestTime; // Best completion time
  
  StageProgress({
    required this.stageId,
    required this.stars,
    required this.bestStars,
    required this.isCompleted,
    required this.attempts,
    required this.lastPlayedAt,
    required this.correctAnswers,
    required this.totalQuestions,
    this.bestTime,
  });
  
  /// Calculate accuracy percentage
  double get accuracy {
    if (totalQuestions == 0) return 0.0;
    return correctAnswers / totalQuestions;
  }
  
  /// Get accuracy as percentage string
  String get accuracyPercentage {
    return '${(accuracy * 100).toStringAsFixed(0)}%';
  }
  
  /// Check if this is a perfect score
  bool get isPerfect {
    return stars == 3 && accuracy == 1.0;
  }
  
  /// Get star emoji representation
  String get starEmoji {
    switch (bestStars) {
      case 3:
        return '⭐⭐⭐';
      case 2:
        return '⭐⭐';
      case 1:
        return '⭐';
      default:
        return '☆☆☆';
    }
  }
  
  /// Copy with method for updates
  StageProgress copyWith({
    String? stageId,
    int? stars,
    int? bestStars,
    bool? isCompleted,
    int? attempts,
    DateTime? lastPlayedAt,
    int? correctAnswers,
    int? totalQuestions,
    Duration? bestTime,
  }) {
    return StageProgress(
      stageId: stageId ?? this.stageId,
      stars: stars ?? this.stars,
      bestStars: bestStars ?? this.bestStars,
      isCompleted: isCompleted ?? this.isCompleted,
      attempts: attempts ?? this.attempts,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      bestTime: bestTime ?? this.bestTime,
    );
  }
  
  @override
  String toString() {
    return 'StageProgress(stageId: $stageId, stars: $stars/$bestStars, accuracy: $accuracyPercentage, attempts: $attempts)';
  }
}
