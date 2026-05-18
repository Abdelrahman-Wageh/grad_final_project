import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartino/models/learning_models.dart';
import 'package:smartino/services/learning_service.dart';

// ==================== SERVICE PROVIDERS ====================

/// Provider for the learning service
final learningServiceProvider = Provider<LearningService>((ref) {
  return LearningService();
});

// ==================== COURSE PROVIDERS ====================

/// Get all available courses
final coursesProvider = FutureProvider<List<Course>>((ref) async {
  final service = ref.watch(learningServiceProvider);
  return service.getAllCourses();
});

/// Get courses filtered by subject
final coursesBySubjectProvider =
    FutureProvider.family<List<Course>, SubjectType>((ref, subject) async {
  final service = ref.watch(learningServiceProvider);
  return service.getCoursesBySubject(subject);
});

/// Get specific course details
final courseDetailsProvider =
    FutureProvider.family<Course, String>((ref, courseId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getCourseDetails(courseId);
});

// ==================== LESSON PROVIDERS ====================

/// Get all lessons for a course
final courseLessonsProvider =
    FutureProvider.family<List<Lesson>, String>((ref, courseId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getCourseLessons(courseId);
});

/// Get specific lesson details
final lessonDetailsProvider =
    FutureProvider.family<Lesson, String>((ref, lessonId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getLessonDetails(lessonId);
});

/// State for currently selected lesson
final currentLessonProvider = StateProvider<Lesson?>((ref) => null);

// ==================== QUIZ PROVIDERS ====================

/// Get quiz for a lesson
final lessonQuizProvider =
    FutureProvider.family<Quiz, String>((ref, lessonId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getQuizForLesson(lessonId);
});

/// Get specific quiz details
final quizDetailsProvider =
    FutureProvider.family<Quiz, String>((ref, quizId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getQuizDetails(quizId);
});

/// State for quiz answers during a quiz attempt
final quizAnswersProvider = StateProvider<Map<String, String>>((ref) => {});

/// State for current quiz question index
final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);

/// State for quiz timer
final quizTimerProvider = StateProvider<int>((ref) => 0);

/// Get quiz attempts for a user
final userQuizAttemptsProvider =
    FutureProvider.family<List<QuizAttempt>, String>((ref, userId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getUserQuizAttempts(userId);
});

// ==================== PROGRESS PROVIDERS ====================

/// Get user's overall progress
final userProgressProvider =
    FutureProvider.family<UserProgress, String>((ref, userId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getUserProgress(userId);
});

/// Get lesson progress
final lessonProgressProvider =
    FutureProvider.family<LessonProgress, String>((ref, lessonId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getLessonProgress(lessonId);
});

/// Get course progress
final courseProgressProvider =
    FutureProvider.family<CourseProgress, String>((ref, courseId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getCourseProgress(courseId);
});

/// Get user statistics
final userStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getUserStats(userId);
});

// ==================== REWARDS & BADGES PROVIDERS ====================

/// Get all available badges
final allBadgesProvider = FutureProvider<List<Badge>>((ref) async {
  final service = ref.watch(learningServiceProvider);
  return service.getAllBadges();
});

/// Get badges earned by user
final userBadgesProvider =
    FutureProvider.family<List<EarnedBadge>, String>((ref, userId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getUserBadges(userId);
});

/// Get rewards earned by user
final userRewardsProvider =
    FutureProvider.family<List<Reward>, String>((ref, userId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getUserRewards(userId);
});

/// Get rewards earned today
final todayRewardsProvider =
    FutureProvider.family<List<Reward>, String>((ref, userId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getTodayRewards(userId);
});

// ==================== DAILY CHALLENGE PROVIDERS ====================

/// Get today's daily challenge for user
final todaysChallengeProvider =
    FutureProvider.family<DailyChallenge, String>((ref, userId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getTodaysChallenge(userId);
});

/// Get challenge history
final challengeHistoryProvider =
    FutureProvider.family<List<DailyChallenge>, String>((ref, userId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getChallengeHistory(userId);
});

/// State for challenge answers
final challengeAnswersProvider = StateProvider<Map<String, dynamic>>((ref) => {});

// ==================== LEARNING MAP PROVIDERS ====================

/// Get user's learning map
final learningMapProvider =
    FutureProvider.family<LearningMap, String>((ref, userId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getLearningMap(userId);
});

/// Get all islands
final allIslandsProvider = FutureProvider<List<Island>>((ref) async {
  final service = ref.watch(learningServiceProvider);
  return service.getAllIslands();
});

/// Get specific island details
final islandDetailsProvider =
    FutureProvider.family<Island, String>((ref, islandId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getIslandDetails(islandId);
});

/// State for currently selected island
final currentIslandProvider = StateProvider<Island?>((ref) => null);

// ==================== USER PROFILE PROVIDERS ====================

/// Get user profile
final userProfileProvider =
    FutureProvider.family<UserProfile, String>((ref, userId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getUserProfile(userId);
});

/// Watch user profile updates
final userProfileWatchProvider = StreamProvider.family((ref, String userId) {
  final service = ref.watch(learningServiceProvider);
  return service.watchUserProfile(userId);
});

/// Get user inventory
final userInventoryProvider =
    FutureProvider.family<List<UserInventoryItem>, String>((ref, userId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getUserInventory(userId);
});

// ==================== PARENT DASHBOARD PROVIDERS ====================

/// Get student dashboard for parents
final studentDashboardProvider =
    FutureProvider.family<StudentDashboard, String>((ref, studentId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getStudentDashboard(studentId);
});

/// Get daily stats for student
final studentDailyStatsProvider =
    FutureProvider.family<List<DailyStudyStats>, String>((ref, studentId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getStudentDailyStats(studentId);
});

/// Watch student dashboard updates
final studentDashboardWatchProvider =
    StreamProvider.family((ref, String studentId) {
  final service = ref.watch(learningServiceProvider);
  return service.watchStudentDashboard(studentId);
});

// ==================== SHOP PROVIDERS ====================

/// Get all shop items
final shopItemsProvider = FutureProvider<List<ShopItem>>((ref) async {
  final service = ref.watch(learningServiceProvider);
  return service.getShopItems();
});

/// Get shop items by type
final shopItemsByTypeProvider =
    FutureProvider.family<List<ShopItem>, ShopItemType>((ref, itemType) async {
  final service = ref.watch(learningServiceProvider);
  return service.getShopItemsByType(itemType);
});

/// Get shop items by category
final shopItemsByCategoryProvider =
    FutureProvider.family<List<ShopItem>, String>((ref, category) async {
  final service = ref.watch(learningServiceProvider);
  return service.getShopItemsByCategory(category);
});

// ==================== AVATAR CUSTOMIZATION PROVIDERS ====================

/// State for avatar customization editor
final avatarCustomizationProvider =
    StateProvider<AvatarCustomization>((ref) {
  return AvatarCustomization(
    avatarId: 'default',
    outfit: 'default',
  );
});

/// Get available avatar options
final avatarOptionsProvider = FutureProvider<Map<String, List<String>>>((ref) async {
  final service = ref.watch(learningServiceProvider);
  return service.getAvatarOptions();
});

// ==================== OFFLINE MODE PROVIDERS ====================

/// Get offline content package
final offlineContentProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getOfflineContent(userId);
});

/// State for offline mode
final offlineModeProvider = StateProvider<bool>((ref) => false);

/// Sync offline data
final syncOfflineDataProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>(
        (ref, data) async {
  final service = ref.watch(learningServiceProvider);
  return service.syncOfflineData(data);
});

// ==================== NOTIFICATION PROVIDERS ====================

/// Watch for new rewards
final rewardNotificationProvider =
    StreamProvider.family((ref, String userId) {
  final service = ref.watch(learningServiceProvider);
  return service.watchRewardNotifications(userId);
});

/// Watch for badge notifications
final badgeNotificationProvider =
    StreamProvider.family((ref, String userId) {
  final service = ref.watch(learningServiceProvider);
  return service.watchBadgeNotifications(userId);
});

// ==================== UI STATE PROVIDERS ====================

/// State for showing reward animation
final showRewardAnimationProvider = StateProvider<bool>((ref) => false);

/// State for new badge to display
final newBadgeProvider = StateProvider<Badge?>((ref) => null);

/// State for loading state
final isLoadingProvider = StateProvider<bool>((ref) => false);

/// State for error messages
final errorMessageProvider = StateProvider<String?>((ref) => null);

// ==================== COMPUTED PROVIDERS ====================

/// Get total coins and gems
final userCurrencyProvider = FutureProvider.family<
    Map<String, int>,
    String>((ref, userId) async {
  final profile = await ref.watch(userProfileProvider(userId).future);
  return {
    'coins': profile.totalCoins,
    'gems': profile.totalGems,
  };
});

/// Get completion percentage for a course
final courseCompletionProvider =
    FutureProvider.family<double, String>((ref, courseId) async {
  final progress = await ref.watch(courseProgressProvider(courseId).future);
  return progress.completionPercentage;
});

/// Get user's achievement summary
final achievementSummaryProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final progress = await ref.watch(userProgressProvider(userId).future);
  final badges = await ref.watch(userBadgesProvider(userId).future);
  
  return {
    'level': progress.currentLevel,
    'totalPoints': progress.totalPoints,
    'badgesCount': badges.length,
    'streak': progress.currentStreakDays,
  };
});

/// Get recommended next lesson
final nextLessonProvider =
    FutureProvider.family<Lesson?, String>((ref, userId) async {
  final service = ref.watch(learningServiceProvider);
  return service.getRecommendedNextLesson(userId);
});

/// Get learning statistics summary
final learningStatsSummaryProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final progress = await ref.watch(userProgressProvider(userId).future);
  final stats = await ref.watch(userStatsProvider(userId).future);
  
  return {
    'lessonCompleted': progress.totalLessonsCompleted,
    'coursesCompleted': progress.totalCoursesCompleted,
    'studyTimeHours': progress.totalStudyTimeMinutes ~/ 60,
    'currentLevel': progress.currentLevel,
    'streak': progress.currentStreakDays,
    ...stats,
  };
});
