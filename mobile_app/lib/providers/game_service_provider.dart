import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/game_session_manager.dart';
import '../services/spaced_repetition_manager.dart';
import '../services/difficulty_adapter.dart';
import '../services/local_storage_service.dart';
import '../data/models/child_profile.dart';
import 'storage_service_provider.dart';
import 'learning_service_provider.dart';

part 'game_service_provider.g.dart';

/// Game Session Manager Provider
/// 
/// Manages game sessions with spaced repetition and dynamic difficulty
/// Requirements: 26.1, 26.2, 26.3
@riverpod
class GameSession extends _$GameSession {
  GameSessionManager? _manager;

  @override
  GameSessionManager build() {
    // Get dependencies from other providers
    final srManager = ref.watch(spacedRepetitionManagerProvider);
    final difficultyAdapter = ref.watch(difficultyAdapterProvider);
    final storage = ref.watch(localStorageServiceProvider);

    _manager = GameSessionManager(srManager, difficultyAdapter, storage);
    return _manager!;
  }

  /// Start a new game session
  /// 
  /// Returns recommended difficulty and concepts due for review
  /// Requirements: 22.1-22.5, 23.1-23.5, 26.2
  Future<GameSession> startSession(ChildProfile profile) async {
    await state.startSession(profile);
    return this;
  }

  /// End a game session and record the result
  /// 
  /// Updates spaced repetition cards and difficulty tracking
  /// Requirements: 22.1-22.5, 23.1-23.5, 26.2
  Future<GameSessionResult> endSession({
    required ChildProfile profile,
    required String concept,
    required bool isCorrect,
    required int performanceQuality,
  }) async {
    return await state.endSession(
      profile: profile,
      concept: concept,
      isCorrect: isCorrect,
      performanceQuality: performanceQuality,
    );
  }
}

/// Current game session state
/// 
/// Tracks the active game session for the current profile
@riverpod
class CurrentGameSession extends _$CurrentGameSession {
  @override
  GameSession? build() {
    return null;
  }

  /// Set the current game session
  void setSession(GameSession session) {
    state = session;
  }

  /// Clear the current game session
  void clearSession() {
    state = null;
  }
}
