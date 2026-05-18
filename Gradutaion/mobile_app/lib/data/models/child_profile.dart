import 'package:hive/hive.dart';
import '../../core/game/difficulty_level.dart';

part 'child_profile.g.dart';

@HiveType(typeId: 0)
class ChildProfile extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int age;

  @HiveField(3)
  String level; // KG1, KG2, Primary

  @HiveField(4)
  String assessment; // below_average, average, above_average

  @HiveField(5)
  String difficultyLevel; // easy, medium, hard

  @HiveField(6)
  List<String> masteredConcepts;

  @HiveField(7)
  Map<String, int> conceptProgress;

  @HiveField(8)
  int stars;

  @HiveField(9)
  List<String> unlockedItems;

  @HiveField(10)
  String currentChapter;

  @HiveField(11)
  String currentStage;

  @HiveField(12)
  DateTime lastPlayed;

  @HiveField(13)
  int totalPlayTimeMinutes;

  @HiveField(14)
  List<bool> recentAttempts;

  @HiveField(15)
  Map<String, int> wordsLearned; // date -> count

  @HiveField(16)
  Map<String, int> timePlayedPerDay; // date -> minutes

  /// Conversation history IDs (references to ConversationHistory objects)
  @HiveField(17)
  List<String> conversationHistoryIds;

  /// Spaced repetition card IDs (references to SpacedRepetitionCard objects)
  @HiveField(18)
  List<String> spacedRepetitionCardIds;

  /// Unlocked treasures and rewards
  @HiveField(19)
  List<String> unlockedTreasures;

  /// Current streak (consecutive days played)
  @HiveField(20)
  int currentStreak;

  /// Longest streak achieved
  @HiveField(21)
  int longestStreak;

  /// Last sync timestamp (for offline conflict resolution)
  @HiveField(22)
  DateTime? lastSyncedAt;

  /// Preferred language (Arabic, English, or Bilingual)
  @HiveField(23)
  String preferredLanguage;

  /// Recent game results for difficulty adaptation
  @HiveField(24)
  List<bool> recentGameResults;

  /// Needs sync flag for offline conflict resolution
  @HiveField(25)
  bool needsSync;

  ChildProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.level,
    required this.assessment,
    this.difficultyLevel = 'medium',
    List<String>? masteredConcepts,
    Map<String, int>? conceptProgress,
    this.stars = 0,
    List<String>? unlockedItems,
    this.currentChapter = 'chapter_1',
    this.currentStage = 'chapter_1_stage_1',
    DateTime? lastPlayed,
    this.totalPlayTimeMinutes = 0,
    List<bool>? recentAttempts,
    Map<String, int>? wordsLearned,
    Map<String, int>? timePlayedPerDay,
    List<String>? conversationHistoryIds,
    List<String>? spacedRepetitionCardIds,
    List<String>? unlockedTreasures,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastSyncedAt,
    this.preferredLanguage = 'bilingual',
    List<bool>? recentGameResults,
    this.needsSync = false,
  })  : masteredConcepts = masteredConcepts ?? [],
        recentGameResults = recentGameResults ?? [],
        conceptProgress = conceptProgress ?? {},
        unlockedItems = unlockedItems ?? [],
        lastPlayed = lastPlayed ?? DateTime.now(),
        recentAttempts = recentAttempts ?? [],
        wordsLearned = wordsLearned ?? {},
        timePlayedPerDay = timePlayedPerDay ?? {},
        conversationHistoryIds = conversationHistoryIds ?? [],
        spacedRepetitionCardIds = spacedRepetitionCardIds ?? [],
        unlockedTreasures = unlockedTreasures ?? [];

  /// Get current difficulty as enum
  DifficultyLevel get currentDifficulty {
    switch (difficultyLevel.toLowerCase()) {
      case 'easy':
        return DifficultyLevel.easy;
      case 'hard':
        return DifficultyLevel.hard;
      case 'medium':
      default:
        return DifficultyLevel.medium;
    }
  }

  /// Set difficulty from enum
  set currentDifficulty(DifficultyLevel level) {
    difficultyLevel = level.toString().split('.').last;
  }

  /// Get assessment level for difficulty adapter
  String get assessmentLevel => assessment;

  /// Get total stars (alias for stars field)
  int get totalStars => stars;

  /// Set total stars (alias for stars field)
  set totalStars(int value) {
    stars = value;
  }

  double getRecentSuccessRate({int last = 10}) {
    if (recentAttempts.isEmpty) return 0.5;
    
    List<bool> recent = recentAttempts.length > last
        ? recentAttempts.sublist(recentAttempts.length - last)
        : recentAttempts;
    
    int correct = recent.where((a) => a).length;
    return correct / recent.length;
  }

  void addAttempt(bool isCorrect) {
    recentAttempts.add(isCorrect);
    if (recentAttempts.length > 20) {
      recentAttempts.removeAt(0);
    }
  }

  void addWordLearned() {
    String today = DateTime.now().toIso8601String().split('T')[0];
    wordsLearned[today] = (wordsLearned[today] ?? 0) + 1;
  }

  void addPlayTime(int minutes) {
    String today = DateTime.now().toIso8601String().split('T')[0];
    timePlayedPerDay[today] = (timePlayedPerDay[today] ?? 0) + minutes;
    totalPlayTimeMinutes += minutes;
  }

  /// Add conversation history reference
  void addConversationHistory(String conversationId) {
    if (!conversationHistoryIds.contains(conversationId)) {
      conversationHistoryIds.add(conversationId);
    }
  }

  /// Add spaced repetition card reference
  void addSpacedRepetitionCard(String cardId) {
    if (!spacedRepetitionCardIds.contains(cardId)) {
      spacedRepetitionCardIds.add(cardId);
    }
  }

  /// Unlock a treasure
  void unlockTreasure(String treasureId) {
    if (!unlockedTreasures.contains(treasureId)) {
      unlockedTreasures.add(treasureId);
    }
  }

  /// Update streak based on last played date
  void updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastPlayedDate = DateTime(lastPlayed.year, lastPlayed.month, lastPlayed.day);
    
    final daysDifference = today.difference(lastPlayedDate).inDays;
    
    if (daysDifference == 0) {
      // Same day, no change
      return;
    } else if (daysDifference == 1) {
      // Consecutive day, increment streak
      currentStreak++;
      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }
    } else {
      // Streak broken, reset
      currentStreak = 1;
    }
    
    lastPlayed = now;
  }

  /// Mark as synced
  void markAsSynced() {
    lastSyncedAt = DateTime.now();
  }
}
