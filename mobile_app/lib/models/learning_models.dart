import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'learning_models.g.dart';

// ==================== ENUMS ====================

enum DifficultyLevel { easy, medium, hard }

enum SubjectType { math, science, english, arabic, artAndCraft, lifeSkills, coding }

enum BadgeType {
  firstLesson,
  perfectScore,
  quickThinker,
  helperHard,
  explorer,
  superLearner
}

enum ShopItemType { avatarClothes, avatarAccessories, avatarSkin, avatarHair, avatar, powerUp }

enum IslandType {
  numbersWorld,
  multiplicationForest,
  divisionCastle,
  alphabetIsland,
  scienceLab,
  codingGalaxy
}

// ==================== COURSE & LESSON ====================

@HiveType(typeId: 20)
@JsonSerializable()
class LessonCharacter {
  @HiveField(0)
  final String characterId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String avatarUrl;

  @HiveField(3)
  final String personality;

  @HiveField(4)
  final String greeting;

  @HiveField(5)
  final List<String> encouragementPhrases;

  LessonCharacter({
    required this.characterId,
    required this.name,
    required this.avatarUrl,
    required this.personality,
    required this.greeting,
    this.encouragementPhrases = const [],
  });

  factory LessonCharacter.fromJson(Map<String, dynamic> json) =>
      _$LessonCharacterFromJson(json);
  Map<String, dynamic> toJson() => _$LessonCharacterToJson(this);
}

@HiveType(typeId: 21)
@JsonSerializable()
class LessonContent {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final List<String> learningObjectives;

  @HiveField(3)
  final List<Map<String, dynamic>> contentSections;

  @HiveField(4)
  final LessonCharacter character;

  @HiveField(5)
  final int estimatedDurationMinutes;

  @HiveField(6)
  final List<Map<String, dynamic>> interactiveElements;

  LessonContent({
    required this.title,
    required this.description,
    required this.learningObjectives,
    required this.contentSections,
    required this.character,
    required this.estimatedDurationMinutes,
    this.interactiveElements = const [],
  });

  factory LessonContent.fromJson(Map<String, dynamic> json) =>
      _$LessonContentFromJson(json);
  Map<String, dynamic> toJson() => _$LessonContentToJson(this);
}

@HiveType(typeId: 22)
@JsonSerializable()
class Lesson {
  @HiveField(0)
  final String lessonId;

  @HiveField(1)
  final String courseId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final int order;

  @HiveField(4)
  @JsonKey(unknownEnumValue: DifficultyLevel.easy)
  final DifficultyLevel difficulty;

  @HiveField(5)
  final String thumbnailUrl;

  @HiveField(6)
  final LessonContent content;

  @HiveField(7)
  final bool isLocked;

  @HiveField(8)
  final String? unlockRequirement;

  @HiveField(9)
  final DateTime createdAt;

  Lesson({
    required this.lessonId,
    required this.courseId,
    required this.title,
    required this.order,
    required this.difficulty,
    required this.thumbnailUrl,
    required this.content,
    this.isLocked = false,
    this.unlockRequirement,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
  Map<String, dynamic> toJson() => _$LessonToJson(this);
}

@HiveType(typeId: 23)
@JsonSerializable()
class Course {
  @HiveField(0)
  final String courseId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  @JsonKey(unknownEnumValue: SubjectType.math)
  final SubjectType subject;

  @HiveField(4)
  @JsonKey(unknownEnumValue: DifficultyLevel.easy)
  final DifficultyLevel difficulty;

  @HiveField(5)
  final String iconUrl;

  @HiveField(6)
  final String colorCode;

  @HiveField(7)
  final List<Lesson> lessons;

  @HiveField(8)
  final int totalDurationMinutes;

  @HiveField(9)
  final String ageRange;

  @HiveField(10)
  final List<String> learningOutcomes;

  @HiveField(11)
  final DateTime createdAt;

  Course({
    required this.courseId,
    required this.title,
    required this.description,
    required this.subject,
    required this.difficulty,
    required this.iconUrl,
    this.colorCode = '#6366F1',
    this.lessons = const [],
    required this.totalDurationMinutes,
    required this.ageRange,
    required this.learningOutcomes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);
}

// ==================== QUIZ & QUESTIONS ====================

@HiveType(typeId: 24)
@JsonSerializable()
class QuizOption {
  @HiveField(0)
  final String optionId;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final bool isCorrect;

  @HiveField(3)
  final String feedback;

  @HiveField(4)
  final String? imageUrl;

  QuizOption({
    required this.optionId,
    required this.text,
    required this.isCorrect,
    required this.feedback,
    this.imageUrl,
  });

  factory QuizOption.fromJson(Map<String, dynamic> json) =>
      _$QuizOptionFromJson(json);
  Map<String, dynamic> toJson() => _$QuizOptionToJson(this);
}

@HiveType(typeId: 25)
@JsonSerializable()
class QuizQuestion {
  @HiveField(0)
  final String questionId;

  @HiveField(1)
  final String quizId;

  @HiveField(2)
  final int order;

  @HiveField(3)
  final String questionText;

  @HiveField(4)
  final String? questionImageUrl;

  @HiveField(5)
  final String questionType;

  @HiveField(6)
  final List<QuizOption> options;

  @HiveField(7)
  final int? timeLimitSeconds;

  @HiveField(8)
  @JsonKey(unknownEnumValue: DifficultyLevel.easy)
  final DifficultyLevel difficulty;

  @HiveField(9)
  final List<String> hints;

  QuizQuestion({
    required this.questionId,
    required this.quizId,
    required this.order,
    required this.questionText,
    this.questionImageUrl,
    this.questionType = 'multiple_choice',
    required this.options,
    this.timeLimitSeconds,
    required this.difficulty,
    this.hints = const [],
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuizQuestionToJson(this);
}

@HiveType(typeId: 26)
@JsonSerializable()
class Quiz {
  @HiveField(0)
  final String quizId;

  @HiveField(1)
  final String lessonId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final List<QuizQuestion> questions;

  @HiveField(5)
  final int passingScorePercentage;

  @HiveField(6)
  final int totalTimeSeconds;

  @HiveField(7)
  final bool shuffleQuestions;

  @HiveField(8)
  final bool showScoreImmediately;

  @HiveField(9)
  final bool retakeAllowed;

  @HiveField(10)
  final int? maxRetakes;

  Quiz({
    required this.quizId,
    required this.lessonId,
    required this.title,
    required this.description,
    required this.questions,
    this.passingScorePercentage = 70,
    required this.totalTimeSeconds,
    this.shuffleQuestions = true,
    this.showScoreImmediately = true,
    this.retakeAllowed = true,
    this.maxRetakes,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
  Map<String, dynamic> toJson() => _$QuizToJson(this);
}

@HiveType(typeId: 27)
@JsonSerializable()
class QuizAttempt {
  @HiveField(0)
  final String attemptId;

  @HiveField(1)
  final String quizId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final double scorePercentage;

  @HiveField(4)
  final Map<String, String> answers;

  @HiveField(5)
  final int timeSpentSeconds;

  @HiveField(6)
  final bool passed;

  @HiveField(7)
  final DateTime attemptedAt;

  QuizAttempt({
    required this.attemptId,
    required this.quizId,
    required this.userId,
    required this.scorePercentage,
    required this.answers,
    required this.timeSpentSeconds,
    required this.passed,
    DateTime? attemptedAt,
  }) : attemptedAt = attemptedAt ?? DateTime.now();

  factory QuizAttempt.fromJson(Map<String, dynamic> json) =>
      _$QuizAttemptFromJson(json);
  Map<String, dynamic> toJson() => _$QuizAttemptToJson(this);
}

// ==================== REWARDS & BADGES ====================

@HiveType(typeId: 28)
@JsonSerializable()
class Badge {
  @HiveField(0)
  final String badgeId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String iconUrl;

  @HiveField(4)
  @JsonKey(unknownEnumValue: BadgeType.explorer)
  final BadgeType badgeType;

  @HiveField(5)
  final String requirement;

  @HiveField(6)
  final String rarity;

  @HiveField(7)
  final int pointsValue;

  Badge({
    required this.badgeId,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.badgeType,
    required this.requirement,
    this.rarity = 'common',
    this.pointsValue = 10,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
  Map<String, dynamic> toJson() => _$BadgeToJson(this);
}

@HiveType(typeId: 29)
@JsonSerializable()
class EarnedBadge {
  @HiveField(0)
  final String earnedId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String badgeId;

  @HiveField(3)
  final Badge badge;

  @HiveField(4)
  final DateTime earnedAt;

  EarnedBadge({
    required this.earnedId,
    required this.userId,
    required this.badgeId,
    required this.badge,
    DateTime? earnedAt,
  }) : earnedAt = earnedAt ?? DateTime.now();

  factory EarnedBadge.fromJson(Map<String, dynamic> json) =>
      _$EarnedBadgeFromJson(json);
  Map<String, dynamic> toJson() => _$EarnedBadgeToJson(this);
}

@HiveType(typeId: 30)
@JsonSerializable()
class Reward {
  @HiveField(0)
  final String rewardId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final int coinsEarned;

  @HiveField(4)
  final int gemsEarned;

  @HiveField(5)
  final int pointsEarned;

  @HiveField(6)
  final String reason;

  @HiveField(7)
  final DateTime earnedAt;

  Reward({
    required this.rewardId,
    required this.userId,
    required this.title,
    this.coinsEarned = 0,
    this.gemsEarned = 0,
    this.pointsEarned = 0,
    required this.reason,
    DateTime? earnedAt,
  }) : earnedAt = earnedAt ?? DateTime.now();

  factory Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);
  Map<String, dynamic> toJson() => _$RewardToJson(this);
}

// ==================== PROGRESS TRACKING ====================

@HiveType(typeId: 31)
@JsonSerializable()
class LessonProgress {
  @HiveField(0)
  final String lessonId;

  @HiveField(1)
  double completionPercentage;

  @HiveField(2)
  bool completed;

  @HiveField(3)
  double? quizScore;

  @HiveField(4)
  int attempts;

  @HiveField(5)
  int timeSpentSeconds;

  @HiveField(6)
  DateTime? startedAt;

  @HiveField(7)
  DateTime? completedAt;

  LessonProgress({
    required this.lessonId,
    this.completionPercentage = 0,
    this.completed = false,
    this.quizScore,
    this.attempts = 0,
    this.timeSpentSeconds = 0,
    this.startedAt,
    this.completedAt,
  });

  factory LessonProgress.fromJson(Map<String, dynamic> json) =>
      _$LessonProgressFromJson(json);
  Map<String, dynamic> toJson() => _$LessonProgressToJson(this);
}

@HiveType(typeId: 32)
@JsonSerializable()
class CourseProgress {
  @HiveField(0)
  final String courseId;

  @HiveField(1)
  int lessonsCompleted;

  @HiveField(2)
  final int totalLessons;

  @HiveField(3)
  double completionPercentage;

  @HiveField(4)
  double averageScore;

  @HiveField(5)
  int totalTimeMinutes;

  @HiveField(6)
  DateTime? startedAt;

  @HiveField(7)
  DateTime? completedAt;

  CourseProgress({
    required this.courseId,
    this.lessonsCompleted = 0,
    required this.totalLessons,
    this.completionPercentage = 0,
    this.averageScore = 0,
    this.totalTimeMinutes = 0,
    this.startedAt,
    this.completedAt,
  });

  factory CourseProgress.fromJson(Map<String, dynamic> json) =>
      _$CourseProgressFromJson(json);
  Map<String, dynamic> toJson() => _$CourseProgressToJson(this);
}

@HiveType(typeId: 33)
@JsonSerializable()
class UserProgress {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  int totalLessonsCompleted;

  @HiveField(2)
  int totalCoursesCompleted;

  @HiveField(3)
  int totalStudyTimeMinutes;

  @HiveField(4)
  int currentStreakDays;

  @HiveField(5)
  int longestStreakDays;

  @HiveField(6)
  int totalPoints;

  @HiveField(7)
  int currentLevel;

  @HiveField(8)
  int badgesEarned;

  @HiveField(9)
  List<CourseProgress> courseProgress;

  @HiveField(10)
  List<LessonProgress> lessonProgress;

  @HiveField(11)
  DateTime? lastActivityAt;

  UserProgress({
    required this.userId,
    this.totalLessonsCompleted = 0,
    this.totalCoursesCompleted = 0,
    this.totalStudyTimeMinutes = 0,
    this.currentStreakDays = 0,
    this.longestStreakDays = 0,
    this.totalPoints = 0,
    this.currentLevel = 1,
    this.badgesEarned = 0,
    this.courseProgress = const [],
    this.lessonProgress = const [],
    this.lastActivityAt,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);
  Map<String, dynamic> toJson() => _$UserProgressToJson(this);
}

// ==================== USER PROFILE & AVATAR ====================

@HiveType(typeId: 34)
@JsonSerializable()
class AvatarCustomization {
  @HiveField(0)
  String avatarId;

  @HiveField(1)
  String outfit;

  @HiveField(2)
  List<String> accessories;

  @HiveField(3)
  String skinTone;

  @HiveField(4)
  String hairStyle;

  @HiveField(5)
  String hairColor;

  @HiveField(6)
  Map<String, String> facialFeatures;

  AvatarCustomization({
    required this.avatarId,
    this.outfit = 'default',
    this.accessories = const [],
    this.skinTone = 'medium',
    this.hairStyle = 'default',
    this.hairColor = 'brown',
    this.facialFeatures = const {},
  });

  factory AvatarCustomization.fromJson(Map<String, dynamic> json) =>
      _$AvatarCustomizationFromJson(json);
  Map<String, dynamic> toJson() => _$AvatarCustomizationToJson(this);
}

@HiveType(typeId: 35)
@JsonSerializable()
class UserProfile {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  String name;

  @HiveField(2)
  int age;

  @HiveField(3)
  AvatarCustomization avatar;

  @HiveField(4)
  int totalCoins;

  @HiveField(5)
  int totalGems;

  @HiveField(6)
  Map<String, int> inventory;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  DateTime? lastLoginAt;

  @HiveField(9)
  bool dailyChallengeCompletedToday;

  @HiveField(10)
  bool offlineMode;

  UserProfile({
    required this.userId,
    required this.name,
    required this.age,
    required this.avatar,
    this.totalCoins = 100,
    this.totalGems = 0,
    this.inventory = const {},
    DateTime? createdAt,
    this.lastLoginAt,
    this.dailyChallengeCompletedToday = false,
    this.offlineMode = false,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

// ==================== DAILY CHALLENGE ====================

@HiveType(typeId: 36)
@JsonSerializable()
class DailyChallenge {
  @HiveField(0)
  final String challengeId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final String challengeType;

  @HiveField(4)
  final String title;

  @HiveField(5)
  final String description;

  @HiveField(6)
  @JsonKey(unknownEnumValue: DifficultyLevel.easy)
  final DifficultyLevel difficulty;

  @HiveField(7)
  final int rewardCoins;

  @HiveField(8)
  final int rewardGems;

  @HiveField(9)
  final Map<String, dynamic> content;

  @HiveField(10)
  bool isCompleted;

  @HiveField(11)
  DateTime? completedAt;

  @HiveField(12)
  double? score;

  @HiveField(13)
  final DateTime createdAt;

  DailyChallenge({
    required this.challengeId,
    required this.userId,
    required this.date,
    required this.challengeType,
    required this.title,
    required this.description,
    required this.difficulty,
    this.rewardCoins = 50,
    this.rewardGems = 5,
    required this.content,
    this.isCompleted = false,
    this.completedAt,
    this.score,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory DailyChallenge.fromJson(Map<String, dynamic> json) =>
      _$DailyChallengeFromJson(json);
  Map<String, dynamic> toJson() => _$DailyChallengeToJson(this);
}

// ==================== LEARNING MAP ====================

@HiveType(typeId: 37)
@JsonSerializable()
class Island {
  @HiveField(0)
  final String islandId;

  @HiveField(1)
  @JsonKey(unknownEnumValue: IslandType.numbersWorld)
  final IslandType islandType;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String themeImageUrl;

  @HiveField(5)
  final int levelNumber;

  @HiveField(6)
  final List<String> courses;

  @HiveField(7)
  bool isUnlocked;

  @HiveField(8)
  final String unlockRequirement;

  Island({
    required this.islandId,
    required this.islandType,
    required this.name,
    required this.description,
    required this.themeImageUrl,
    required this.levelNumber,
    this.courses = const [],
    this.isUnlocked = false,
    required this.unlockRequirement,
  });

  factory Island.fromJson(Map<String, dynamic> json) => _$IslandFromJson(json);
  Map<String, dynamic> toJson() => _$IslandToJson(this);
}

@HiveType(typeId: 38)
@JsonSerializable()
class LearningMap {
  @HiveField(0)
  final String mapId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final List<Island> islands;

  @HiveField(3)
  int currentIsland;

  @HiveField(4)
  int completedIslands;

  @HiveField(5)
  final int totalIslands;

  LearningMap({
    required this.mapId,
    required this.userId,
    required this.islands,
    this.currentIsland = 0,
    this.completedIslands = 0,
    required this.totalIslands,
  });

  factory LearningMap.fromJson(Map<String, dynamic> json) =>
      _$LearningMapFromJson(json);
  Map<String, dynamic> toJson() => _$LearningMapToJson(this);
}

// ==================== PARENT DASHBOARD ====================

@HiveType(typeId: 39)
@JsonSerializable()
class DailyStudyStats {
  @HiveField(0)
  final String date;

  @HiveField(1)
  int studyTimeMinutes;

  @HiveField(2)
  int lessonsCompleted;

  @HiveField(3)
  double quizScoreAverage;

  @HiveField(4)
  int badgesEarned;

  DailyStudyStats({
    required this.date,
    this.studyTimeMinutes = 0,
    this.lessonsCompleted = 0,
    this.quizScoreAverage = 0,
    this.badgesEarned = 0,
  });

  factory DailyStudyStats.fromJson(Map<String, dynamic> json) =>
      _$DailyStudyStatsFromJson(json);
  Map<String, dynamic> toJson() => _$DailyStudyStatsToJson(this);
}

@HiveType(typeId: 40)
@JsonSerializable()
class StudentDashboard {
  @HiveField(0)
  final String studentId;

  @HiveField(1)
  final String studentName;

  @HiveField(2)
  int totalStudyTimeHours;

  @HiveField(3)
  int lessonsCompleted;

  @HiveField(4)
  int coursesInProgress;

  @HiveField(5)
  double averageScore;

  @HiveField(6)
  int currentStreak;

  @HiveField(7)
  int totalBadges;

  @HiveField(8)
  List<DailyStudyStats> dailyStats7Days;

  @HiveField(9)
  List<Map<String, dynamic>> recentLessons;

  @HiveField(10)
  Map<String, double> learningAreas;

  StudentDashboard({
    required this.studentId,
    required this.studentName,
    this.totalStudyTimeHours = 0,
    this.lessonsCompleted = 0,
    this.coursesInProgress = 0,
    this.averageScore = 0,
    this.currentStreak = 0,
    this.totalBadges = 0,
    this.dailyStats7Days = const [],
    this.recentLessons = const [],
    this.learningAreas = const {},
  });

  factory StudentDashboard.fromJson(Map<String, dynamic> json) =>
      _$StudentDashboardFromJson(json);
  Map<String, dynamic> toJson() => _$StudentDashboardToJson(this);
}

// ==================== SHOP ====================

@HiveType(typeId: 41)
@JsonSerializable()
class ShopItem {
  @HiveField(0)
  final String itemId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  @JsonKey(unknownEnumValue: ShopItemType.powerUp)
  final ShopItemType itemType;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  int? priceCoins;

  @HiveField(6)
  int? priceGems;

  @HiveField(7)
  final String rarity;

  @HiveField(8)
  final String category;

  @HiveField(9)
  final bool isLimited;

  @HiveField(10)
  int? stock;

  ShopItem({
    required this.itemId,
    required this.name,
    required this.description,
    required this.itemType,
    required this.imageUrl,
    this.priceCoins,
    this.priceGems,
    this.rarity = 'common',
    required this.category,
    this.isLimited = false,
    this.stock,
  });

  factory ShopItem.fromJson(Map<String, dynamic> json) =>
      _$ShopItemFromJson(json);
  Map<String, dynamic> toJson() => _$ShopItemToJson(this);
}

@HiveType(typeId: 42)
@JsonSerializable()
class UserInventoryItem {
  @HiveField(0)
  final String inventoryId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String itemId;

  @HiveField(3)
  int quantity;

  @HiveField(4)
  final DateTime purchasedAt;

  UserInventoryItem({
    required this.inventoryId,
    required this.userId,
    required this.itemId,
    this.quantity = 1,
    DateTime? purchasedAt,
  }) : purchasedAt = purchasedAt ?? DateTime.now();

  factory UserInventoryItem.fromJson(Map<String, dynamic> json) =>
      _$UserInventoryItemFromJson(json);
  Map<String, dynamic> toJson() => _$UserInventoryItemToJson(this);
}
