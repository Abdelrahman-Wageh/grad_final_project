import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/reward_manager_v2.dart';
import '../data/models/child_profile.dart';
import 'storage_service_provider.dart';

part 'reward_service_provider.g.dart';

/// Reward Manager Provider
/// 
/// Provides access to reward system with stars and treasures
/// Requirements: 26.1, 26.3
@riverpod
RewardManagerV2 rewardManager(RewardManagerRef ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return RewardManagerV2(storage);
}

/// Reward State Provider
/// 
/// Manages the current reward state (stars, treasures, messages)
/// Requirements: 26.1, 26.4
@riverpod
class RewardState extends _$RewardState {
  @override
  RewardResult? build() {
    return null;
  }

  /// Handle a correct answer
  /// 
  /// Awards stars and checks for treasure unlocks
  /// Requirements: 5.1, 5.2, 26.2
  Future<void> handleCorrectAnswer(ChildProfile profile) async {
    final manager = ref.read(rewardManagerProvider);
    final result = await manager.handleCorrectAnswer(profile);
    state = result;
  }

  /// Handle an incorrect answer
  /// 
  /// Provides positive reinforcement message
  /// Requirements: 4.1, 4.3, 25.5, 26.2
  Future<void> handleIncorrectAnswer(ChildProfile profile) async {
    final manager = ref.read(rewardManagerProvider);
    final result = await manager.handleIncorrectAnswer(profile);
    state = result;
  }

  /// Clear the current reward state
  void clearReward() {
    state = null;
  }
}

/// Celebration State Provider
/// 
/// Manages celebration animations and effects
/// Requirements: 26.1, 26.4
@riverpod
class CelebrationState extends _$CelebrationState {
  @override
  bool build() {
    return false;
  }

  /// Trigger celebration
  void celebrate() {
    state = true;
  }

  /// End celebration
  void endCelebration() {
    state = false;
  }
}
