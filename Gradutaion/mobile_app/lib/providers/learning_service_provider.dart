import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/spaced_repetition_manager.dart';
import '../services/difficulty_adapter.dart';
import '../models/spaced_repetition_card.dart';
import '../data/models/child_profile.dart';
import '../core/game/difficulty_level.dart';
import 'storage_service_provider.dart';

part 'learning_service_provider.g.dart';

/// Spaced Repetition Manager Provider
/// 
/// Provides access to SM-2 algorithm for optimized learning retention
/// Requirements: 26.1, 26.3
@riverpod
SpacedRepetitionManager spacedRepetitionManager(
  SpacedRepetitionManagerRef ref,
) {
  final storage = ref.watch(localStorageServiceProvider);
  return SpacedRepetitionManager(storage);
}

/// Difficulty Adapter Provider
/// 
/// Provides access to adaptive difficulty system
/// Requirements: 26.1, 26.3
@riverpod
DifficultyAdapter difficultyAdapter(DifficultyAdapterRef ref) {
  return DifficultyAdapter();
}

/// Cards Due for Review Provider
/// 
/// Provides cards that are due for review for the current profile
/// Requirements: 26.1, 26.4
@riverpod
class CardsDueForReview extends _$CardsDueForReview {
  @override
  Future<List<SpacedRepetitionCard>> build(String profileId) async {
    final srManager = ref.watch(spacedRepetitionManagerProvider);
    return await srManager.getCardsForReview(profileId);
  }

  /// Refresh the cards due for review
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final srManager = ref.read(spacedRepetitionManagerProvider);
      return await srManager.getCardsForReview(profileId);
    });
  }
}

/// Recommended Difficulty Provider
/// 
/// Calculates the recommended difficulty for the current profile
/// Requirements: 26.1, 26.4
@riverpod
class RecommendedDifficulty extends _$RecommendedDifficulty {
  @override
  DifficultyLevel build(ChildProfile profile) {
    final adapter = ref.watch(difficultyAdapterProvider);
    return adapter.calculateDifficulty(profile, profile.recentAttempts);
  }

  /// Recalculate difficulty
  void recalculate(ChildProfile profile) {
    final adapter = ref.read(difficultyAdapterProvider);
    state = adapter.calculateDifficulty(profile, profile.recentAttempts);
  }
}
