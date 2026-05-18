import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Modern, Enterprise-Grade API Service for Smartino
/// Provides a clean, well-documented interface for all backend communication
class ModernApiService {
  final Dio _dio;
  static const String _baseUrl = 'https://api.smartino.app';
  static const Duration _timeout = Duration(seconds: 30);

  ModernApiService({Dio? dio}) : _dio = dio ?? Dio() {
    _setupDio();
  }

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: _timeout,
      receiveTimeout: _timeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'Smartino-Mobile/2.0',
      },
      validateStatus: (status) => status != null && status < 500,
    );

    // Add interceptors for logging, error handling, and retry logic
    _dio.interceptors.addAll([
      _LoggingInterceptor(),
      _ErrorHandlingInterceptor(),
      _RetryInterceptor(_dio),
    ]);
  }

  // ==================== USER ENDPOINTS ====================

  /// Get user profile with achievements
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('/v1/users/$userId/profile');
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Update user progress
  Future<Map<String, dynamic>> updateUserProgress(
    String userId,
    Map<String, dynamic> progressData,
  ) async {
    try {
      final response = await _dio.put(
        '/v1/users/$userId/progress',
        data: progressData,
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== GAME ENDPOINTS ====================

  /// Get available games with metadata
  Future<List<Map<String, dynamic>>> getGames() async {
    try {
      final response = await _dio.get('/v1/games');
      final data = _handleResponse(response);
      return List<Map<String, dynamic>>.from(data['games'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  /// Start a new game session
  Future<Map<String, dynamic>> startGameSession({
    required String gameId,
    required String userId,
    required int difficulty,
  }) async {
    try {
      final response = await _dio.post(
        '/v1/games/$gameId/session',
        data: {
          'user_id': userId,
          'difficulty': difficulty,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Submit game result
  Future<Map<String, dynamic>> submitGameResult({
    required String sessionId,
    required int score,
    required Duration playTime,
    required Map<String, dynamic> metrics,
  }) async {
    try {
      final response = await _dio.post(
        '/v1/games/sessions/$sessionId/result',
        data: {
          'score': score,
          'play_time_seconds': playTime.inSeconds,
          'metrics': metrics,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== AI COMPANION ENDPOINTS ====================

  /// Get AI companion response with context awareness
  Future<Map<String, dynamic>> getCompanionResponse({
    required String userMessage,
    required String userId,
    required String context,
    Uint8List? audioData,
  }) async {
    try {
      final data = {
        'message': userMessage,
        'user_id': userId,
        'context': context,
        'timestamp': DateTime.now().toIso8601String(),
      };

      if (audioData != null) {
        data['audio_base64'] = base64Encode(audioData);
      }

      final response = await _dio.post(
        '/v1/ai/companion/response',
        data: data,
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Get character personality info
  Future<Map<String, dynamic>> getCharacterPersonality(String characterId) async {
    try {
      final response = await _dio.get('/v1/characters/$characterId/personality');
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== LEARNING PATHS ENDPOINTS ====================

  /// Get personalized learning path
  Future<Map<String, dynamic>> getLearningPath(String userId) async {
    try {
      final response = await _dio.get('/v1/users/$userId/learning-path');
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Get curriculum content
  Future<List<Map<String, dynamic>>> getCurriculumContent({
    required int level,
    required String language,
  }) async {
    try {
      final response = await _dio.get(
        '/v1/curriculum/content',
        queryParameters: {
          'level': level,
          'language': language,
        },
      );
      final data = _handleResponse(response);
      return List<Map<String, dynamic>>.from(data['content'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== ACHIEVEMENT ENDPOINTS ====================

  /// Get user achievements
  Future<List<Map<String, dynamic>>> getAchievements(String userId) async {
    try {
      final response = await _dio.get('/v1/users/$userId/achievements');
      final data = _handleResponse(response);
      return List<Map<String, dynamic>>.from(data['achievements'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  /// Unlock achievement
  Future<Map<String, dynamic>> unlockAchievement({
    required String userId,
    required String achievementId,
  }) async {
    try {
      final response = await _dio.post(
        '/v1/users/$userId/achievements/$achievementId/unlock',
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== REWARDS ENDPOINTS ====================

  /// Get daily rewards
  Future<Map<String, dynamic>> getDailyRewards(String userId) async {
    try {
      final response = await _dio.get('/v1/users/$userId/daily-rewards');
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Claim daily reward
  Future<Map<String, dynamic>> claimDailyReward(String userId) async {
    try {
      final response = await _dio.post(
        '/v1/users/$userId/daily-rewards/claim',
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== LEADERBOARD ENDPOINTS ====================

  /// Get leaderboard
  Future<List<Map<String, dynamic>>> getLeaderboard({
    int limit = 50,
    String period = 'weekly',
  }) async {
    try {
      final response = await _dio.get(
        '/v1/leaderboard',
        queryParameters: {
          'limit': limit,
          'period': period,
        },
      );
      final data = _handleResponse(response);
      return List<Map<String, dynamic>>.from(data['entries'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== SOCIAL ENDPOINTS ====================

  /// Get friend list
  Future<List<Map<String, dynamic>>> getFriends(String userId) async {
    try {
      final response = await _dio.get('/v1/users/$userId/friends');
      final data = _handleResponse(response);
      return List<Map<String, dynamic>>.from(data['friends'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  /// Send challenge to friend
  Future<Map<String, dynamic>> sendChallenge({
    required String fromUserId,
    required String toUserId,
    required String gameId,
  }) async {
    try {
      final response = await _dio.post(
        '/v1/challenges',
        data: {
          'from_user_id': fromUserId,
          'to_user_id': toUserId,
          'game_id': gameId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== PARENT ENDPOINTS ====================

  /// Get child progress report
  Future<Map<String, dynamic>> getChildProgressReport(String childId) async {
    try {
      final response = await _dio.get('/v1/parents/children/$childId/progress');
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Get activity summary
  Future<Map<String, dynamic>> getActivitySummary(
    String childId, {
    int daysBack = 7,
  }) async {
    try {
      final response = await _dio.get(
        '/v1/parents/children/$childId/activity',
        queryParameters: {'days': daysBack},
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== ANALYTICS ENDPOINTS ====================

  /// Track user event
  Future<void> trackEvent({
    required String userId,
    required String eventName,
    Map<String, dynamic>? eventData,
  }) async {
    try {
      await _dio.post(
        '/v1/analytics/events',
        data: {
          'user_id': userId,
          'event_name': eventName,
          'event_data': eventData ?? {},
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }

  // ==================== HEALTH CHECK ====================

  /// Health check endpoint
  Future<bool> healthCheck() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ==================== RESPONSE HANDLING ====================

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == null || response.statusCode! >= 400) {
      throw ApiException(
        statusCode: response.statusCode ?? 0,
        message: response.data?['error'] ?? 'Unknown error occurred',
      );
    }

    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }

    throw ApiException(message: 'Invalid response format');
  }
}

// ==================== INTERCEPTORS ====================

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('📤 API Request: ${options.method} ${options.path}');
      print('   Headers: ${options.headers}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('📥 API Response: ${response.statusCode} ${response.requestOptions.path}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('❌ API Error: ${err.response?.statusCode} - ${err.message}');
    }
    super.onError(err, handler);
  }
}

class _ErrorHandlingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message = 'Network error';

    if (err.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout - Check your internet connection';
    } else if (err.type == DioExceptionType.receiveTimeout) {
      message = 'Response timeout - Server is taking too long';
    } else if (err.response?.statusCode == 401) {
      message = 'Unauthorized - Please log in again';
    } else if (err.response?.statusCode == 403) {
      message = 'Forbidden - You do not have permission';
    } else if (err.response?.statusCode == 404) {
      message = 'Not found - Resource does not exist';
    } else if (err.response?.statusCode == 429) {
      message = 'Too many requests - Please try again later';
    } else if (err.response?.statusCode == null) {
      message = 'No internet connection';
    }

    handler.next(err);
  }
}

class _RetryInterceptor extends Interceptor {
  final Dio dio;
  static const int _maxRetries = 3;
  static const List<int> _retryStatusCodes = [408, 429, 500, 502, 503, 504];

  _RetryInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    final retryCount = (err.requestOptions.extra['retryCount'] ?? 0) as int;
    if (retryCount >= _maxRetries) {
      return handler.next(err);
    }

    final delay = _calculateBackoff(retryCount);
    await Future.delayed(delay);

    try {
      err.requestOptions.extra['retryCount'] = retryCount + 1;
      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } catch (e) {
      return handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.response?.statusCode != null &&
        _retryStatusCodes.contains(err.response?.statusCode);
  }

  Duration _calculateBackoff(int retryCount) {
    return Duration(milliseconds: (100 * (retryCount + 1)));
  }
}

// ==================== EXCEPTIONS ====================

/// Custom exception for API errors
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic originalException;

  ApiException({
    this.statusCode = 0,
    required this.message,
    this.originalException,
  });

  @override
  String toString() => 'ApiException: [$statusCode] $message';
}
