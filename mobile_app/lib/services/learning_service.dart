import 'package:smartino/models/learning_models.dart';
import 'package:smartino/services/api_client.dart';
import 'package:smartino/services/local_storage_service.dart';
import 'dart:async';

/// Service for managing all learning-related operations
class LearningService {
  final ApiClient _apiClient = ApiClient();
  final LocalStorageService _storage = LocalStorageService();

  // ==================== COURSES ====================

  /// Get all available courses
  Future<List<Course>> getAllCourses() async {
    try {
      final data = await _apiClient.get('/api/learning/courses');
      final courses = (data['courses'] as List)
          .map((c) => Course.fromJson(c as Map<String, dynamic>))
          .toList();
      
      // Cache locally
      await _storage.saveCourses(courses);
      return courses;
    } catch (e) {
      // Fallback to cached data
      return _storage.getCourses();
    }
  }

  /// Get courses filtered by subject
  Future<List<Course>> getCoursesBySubject(SubjectType subject) async {
    try {
      final data = await _apiClient.get(
        '/api/learning/courses',
        queryParameters: {'subject': subject.name},
      );
      return (data['courses'] as List)
          .map((c) => Course.fromJson(c as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Fallback to local filtering
      final allCourses = await _storage.getCourses();
      return allCourses.where((c) => c.subject == subject).toList();
    }
  }

  /// Get detailed course information
  Future<Course> getCourseDetails(String courseId) async {
    try {
      final data = await _apiClient.get('/api/learning/courses/$courseId');
      return Course.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      // Fallback to cached data
      final courses = await _storage.getCourses();
      return courses.firstWhere((c) => c.courseId == courseId);
    }
  }

  // ==================== LESSONS ====================

  /// Get all lessons for a course
  Future<List<Lesson>> getCourseLessons(String courseId) async {
    try {
      final data = await _apiClient.get(
        '/api/learning/courses/$courseId/lessons',
      );
      return (data as List)
          .map((l) => Lesson.fromJson(l as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Fallback to cached data
      return _storage.getLessonsByCourse(courseId);
    }
  }

  /// Get detailed lesson information
  Future<Lesson> getLessonDetails(String lessonId) async {
    try {
      final data = await _apiClient.get('/api/learning/lessons/$lessonId');
      return Lesson.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      // Fallback to cached data
      return _storage.getLesson(lessonId);
    }
  }

  /// Mark lesson as started
  Future<void> startLesson(String lessonId, String userId) async {
    try {
      await _apiClient.post(
        '/api/learning/lessons/$lessonId/start',
        data: {'user_id': userId},
      );
    } catch (e) {
      print('Error starting lesson: $e');
    }
    
    // Update local progress
    await _storage.startLessonTracking(lessonId, userId);
  }

  /// Mark lesson as completed
  Future<void> completeLesson(
    String lessonId,
    String userId,
    int timeSpentSeconds,
  ) async {
    try {
      await _apiClient.post(
        '/api/learning/lessons/$lessonId/complete',
        data: {
          'user_id': userId,
          'time_spent_seconds': timeSpentSeconds,
        },
      );
    } catch (e) {
      print('Error completing lesson: $e');
    }
    
    // Update local progress
    await _storage.completeLessonTracking(lessonId, userId, timeSpentSeconds);
  }

  // ==================== QUIZ ====================

  /// Get quiz for a lesson
  Future<Quiz> getQuizForLesson(String lessonId) async {
    try {
      final data = await _apiClient.get('/api/learning/quiz',
          queryParameters: {'lesson_id': lessonId});
      return Quiz.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Quiz not found: $e');
    }
  }

  /// Get detailed quiz information
  Future<Quiz> getQuizDetails(String quizId) async {
    try {
      final data = await _apiClient.get('/api/learning/quiz/$quizId');
      return Quiz.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Quiz not found: $e');
    }
  }

  /// Submit quiz answers
  Future<Map<String, dynamic>> submitQuiz({
    required String quizId,
    required String userId,
    required Map<String, String> answers,
    required int timeSpentSeconds,
  }) async {
    try {
      final data = await _apiClient.post(
        '/api/learning/quiz/submit',
        data: {
          'quiz_id': quizId,
          'user_id': userId,
          'answers': answers,
          'time_spent_seconds': timeSpentSeconds,
        },
      );
      
      // Save quiz attempt locally
      if (data['attempt_id'] != null) {
        await _storage.saveQuizAttempt(
          QuizAttempt(
            attemptId: data['attempt_id'],
            quizId: quizId,
            userId: userId,
            scorePercentage: data['score_percentage'],
            answers: answers,
            timeSpentSeconds: timeSpentSeconds,
            passed: data['passed'],
          ),
        );
      }
      
      return data;
    } catch (e) {
      throw Exception('Error submitting quiz: $e');
    }
  }

  /// Get user's quiz attempts
  Future<List<QuizAttempt>> getUserQuizAttempts(String userId) async {
    try {
      final data = await _apiClient.get(
        '/api/learning/quiz/attempts',
        queryParameters: {'user_id': userId},
      );
      return (data as List)
          .map((a) => QuizAttempt.fromJson(a as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Return locally stored attempts
      return _storage.getUserQuizAttempts(userId);
    }
  }

  // ==================== PROGRESS ====================

  /// Get user's overall progress
  Future<UserProgress> getUserProgress(String userId) async {
    try {
      final data = await _apiClient.get('/api/learning/progress/$userId');
      return UserProgress.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      // Return locally stored progress
      return _storage.getUserProgress(userId);
    }
  }

  /// Get lesson progress
  Future<LessonProgress> getLessonProgress(String lessonId) async {
    try {
      final data = await _apiClient.get(
        '/api/learning/progress/lessons/$lessonId',
      );
      return LessonProgress.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      return _storage.getLessonProgress(lessonId);
    }
  }

  /// Get course progress
  Future<CourseProgress> getCourseProgress(String courseId) async {
    try {
      final data = await _apiClient.get(
        '/api/learning/progress/courses/$courseId',
      );
      return CourseProgress.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      return _storage.getCourseProgress(courseId);
    }
  }

  /// Get user statistics
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      return await _apiClient.get('/api/learning/progress/$userId/stats');
    } catch (e) {
      return {};
    }
  }

  // ==================== REWARDS & BADGES ====================

  /// Get all available badges
  Future<List<Badge>> getAllBadges() async {
    try {
      final data = await _apiClient.get('/api/learning/badges');
      return (data as List)
          .map((b) => Badge.fromJson(b as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get badges earned by user
  Future<List<EarnedBadge>> getUserBadges(String userId) async {
    try {
      final data = await _apiClient.get('/api/learning/badges/$userId');
      return (data as List)
          .map((b) => EarnedBadge.fromJson(b as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return _storage.getUserBadges(userId);
    }
  }

  /// Get rewards earned by user
  Future<List<Reward>> getUserRewards(String userId, {int days = 30}) async {
    try {
      final data = await _apiClient.get(
        '/api/learning/rewards/$userId',
        queryParameters: {'days': days},
      );
      return (data as List)
          .map((r) => Reward.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get today's rewards
  Future<List<Reward>> getTodayRewards(String userId) async {
    try {
      final data = await _apiClient.get(
        '/api/learning/rewards/$userId',
        queryParameters: {'days': 1},
      );
      return (data as List)
          .map((r) => Reward.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ==================== DAILY CHALLENGE ====================

  /// Get today's daily challenge
  Future<DailyChallenge> getTodaysChallenge(String userId) async {
    try {
      final data = await _apiClient.get('/api/learning/daily-challenge/$userId');
      return DailyChallenge.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Challenge not found: $e');
    }
  }

  /// Get challenge history
  Future<List<DailyChallenge>> getChallengeHistory(String userId) async {
    try {
      final data = await _apiClient.get(
        '/api/learning/daily-challenge/history/$userId',
      );
      return (data as List)
          .map((c) => DailyChallenge.fromJson(c as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Submit daily challenge
  Future<Map<String, dynamic>> submitDailyChallenge({
    required String challengeId,
    required String userId,
    required Map<String, dynamic> answers,
    required int timeSpentSeconds,
  }) async {
    try {
      return await _apiClient.post(
        '/api/learning/daily-challenge/$challengeId/submit',
        data: {
          'user_id': userId,
          'answers': answers,
          'time_spent_seconds': timeSpentSeconds,
        },
      );
    } catch (e) {
      throw Exception('Error submitting challenge: $e');
    }
  }

  // ==================== LEARNING MAP ====================

  /// Get user's learning map
  Future<LearningMap> getLearningMap(String userId) async {
    try {
      final data = await _apiClient.get('/api/learning/learning-map/$userId');
      return LearningMap.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      return _storage.getLearningMap(userId);
    }
  }

  /// Get all islands
  Future<List<Island>> getAllIslands() async {
    try {
      final data = await _apiClient.get('/api/learning/islands');
      return (data as List)
          .map((i) => Island.fromJson(i as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get island details
  Future<Island> getIslandDetails(String islandId) async {
    try {
      final data = await _apiClient.get('/api/learning/islands/$islandId');
      return Island.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Island not found: $e');
    }
  }

  /// Unlock island
  Future<void> unlockIsland(String islandId, String userId) async {
    try {
      await _apiClient.post(
        '/api/learning/islands/$islandId/unlock',
        data: {'user_id': userId},
      );
    } catch (e) {
      print('Error unlocking island: $e');
    }
  }

  /// Complete island
  Future<void> completeIsland(String islandId, String userId) async {
    try {
      await _apiClient.post(
        '/api/learning/islands/$islandId/complete',
        data: {'user_id': userId},
      );
    } catch (e) {
      print('Error completing island: $e');
    }
  }

  // ==================== USER PROFILE ====================

  /// Get user profile
  Future<UserProfile> getUserProfile(String userId) async {
    try {
      final data = await _apiClient.get('/api/learning/profile/$userId');
      return UserProfile.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      return _storage.getUserProfile(userId);
    }
  }

  /// Watch user profile updates
  Stream<UserProfile> watchUserProfile(String userId) {
    // This would typically use WebSocket or periodic polling
    return Stream.periodic(Duration(seconds: 5), (_) {
      return getUserProfile(userId);
    }).asyncExpand((future) => Stream.fromFuture(future));
  }

  /// Update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await _apiClient.put(
        '/api/learning/profile/${profile.userId}',
        data: profile.toJson(),
      );
    } catch (e) {
      print('Error updating profile: $e');
    }
    
    // Update locally
    await _storage.saveUserProfile(profile);
  }

  /// Get user inventory
  Future<List<UserInventoryItem>> getUserInventory(String userId) async {
    try {
      final data = await _apiClient.get('/api/learning/shop/inventory/$userId');
      return (data as List)
          .map((i) => UserInventoryItem.fromJson(i as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return _storage.getUserInventory(userId);
    }
  }

  // ==================== PARENT DASHBOARD ====================

  /// Get student dashboard for parents
  Future<StudentDashboard> getStudentDashboard(String studentId) async {
    try {
      final data = await _apiClient.get(
        '/api/learning/parent-dashboard/$studentId',
      );
      return StudentDashboard.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Dashboard not found: $e');
    }
  }

  /// Get daily stats for student
  Future<List<DailyStudyStats>> getStudentDailyStats(String studentId) async {
    try {
      final data = await _apiClient.get(
        '/api/learning/parent-dashboard/$studentId/daily-stats',
      );
      return (data as List)
          .map((s) => DailyStudyStats.fromJson(s as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Watch student dashboard updates
  Stream<StudentDashboard> watchStudentDashboard(String studentId) {
    return Stream.periodic(Duration(seconds: 10), (_) {
      return getStudentDashboard(studentId);
    }).asyncExpand((future) => Stream.fromFuture(future));
  }

  // ==================== SHOP ====================

  /// Get all shop items
  Future<List<ShopItem>> getShopItems() async {
    try {
      final data = await _apiClient.get('/api/learning/shop/items');
      return (data as List)
          .map((i) => ShopItem.fromJson(i as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get shop items by type
  Future<List<ShopItem>> getShopItemsByType(ShopItemType itemType) async {
    try {
      final data = await _apiClient.get(
        '/api/learning/shop/items',
        queryParameters: {'item_type': itemType.name},
      );
      return (data as List)
          .map((i) => ShopItem.fromJson(i as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get shop items by category
  Future<List<ShopItem>> getShopItemsByCategory(String category) async {
    try {
      final data = await _apiClient.get(
        '/api/learning/shop/items',
        queryParameters: {'category': category},
      );
      return (data as List)
          .map((i) => ShopItem.fromJson(i as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Purchase item from shop
  Future<Map<String, dynamic>> purchaseItem(
    String userId,
    String itemId, {
    int quantity = 1,
  }) async {
    try {
      return await _apiClient.post(
        '/api/learning/shop/purchase',
        data: {
          'user_id': userId,
          'item_id': itemId,
          'quantity': quantity,
        },
      );
    } catch (e) {
      throw Exception('Purchase failed: $e');
    }
  }

  /// Customize avatar
  Future<void> customizeAvatar(
    String userId,
    AvatarCustomization customization,
  ) async {
    try {
      await _apiClient.post(
        '/api/learning/avatar/customize',
        data: {
          'user_id': userId,
          ...customization.toJson(),
        },
      );
    } catch (e) {
      print('Error customizing avatar: $e');
    }
  }

  /// Get avatar options
  Future<Map<String, List<String>>> getAvatarOptions() async {
    try {
      return await _apiClient.get('/api/learning/avatar/options');
    } catch (e) {
      return {};
    }
  }

  // ==================== OFFLINE MODE ====================

  /// Get offline content package
  Future<Map<String, dynamic>> getOfflineContent(String userId) async {
    try {
      return await _apiClient.get('/api/learning/offline/content/$userId');
    } catch (e) {
      return {};
    }
  }

  /// Sync offline data
  Future<Map<String, dynamic>> syncOfflineData(
    Map<String, dynamic> localData,
  ) async {
    try {
      return await _apiClient.post(
        '/api/learning/offline/sync',
        data: localData,
      );
    } catch (e) {
      throw Exception('Sync failed: $e');
    }
  }

  // ==================== NOTIFICATIONS ====================

  /// Watch reward notifications
  Stream<Reward> watchRewardNotifications(String userId) {
    // This would typically use WebSocket
    return Stream.empty();
  }

  /// Watch badge notifications
  Stream<Badge> watchBadgeNotifications(String userId) {
    // This would typically use WebSocket
    return Stream.empty();
  }

  // ==================== RECOMMENDATIONS ====================

  /// Get recommended next lesson
  Future<Lesson?> getRecommendedNextLesson(String userId) async {
    try {
      final progress = await getUserProgress(userId);
      if (progress.lessonProgress.isEmpty) {
        final courses = await getAllCourses();
        if (courses.isNotEmpty && courses[0].lessons.isNotEmpty) {
          return courses[0].lessons[0];
        }
      } else {
        // Find next uncompleted lesson
        for (var lesson in progress.lessonProgress) {
          if (!lesson.completed) {
            return getLessonDetails(lesson.lessonId);
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
