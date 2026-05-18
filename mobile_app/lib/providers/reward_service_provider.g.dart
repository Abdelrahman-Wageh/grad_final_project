// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rewardManagerHash() => r'e18f1a9a6f13699f1cdbaf2caae9483cd2f82158';

/// Reward Manager Provider
///
/// Provides access to reward system with stars and treasures
/// Requirements: 26.1, 26.3
///
/// Copied from [rewardManager].
@ProviderFor(rewardManager)
final rewardManagerProvider = AutoDisposeProvider<RewardManagerV2>.internal(
  rewardManager,
  name: r'rewardManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rewardManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RewardManagerRef = AutoDisposeProviderRef<RewardManagerV2>;
String _$rewardStateHash() => r'cfd8230c969d77afc12e24d62e9515bdf731b43f';

/// Reward State Provider
///
/// Manages the current reward state (stars, treasures, messages)
/// Requirements: 26.1, 26.4
///
/// Copied from [RewardState].
@ProviderFor(RewardState)
final rewardStateProvider =
    AutoDisposeNotifierProvider<RewardState, RewardResult?>.internal(
  RewardState.new,
  name: r'rewardStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$rewardStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RewardState = AutoDisposeNotifier<RewardResult?>;
String _$celebrationStateHash() => r'0a0038ef5935b8728ebdc77464e72cb173a34b1f';

/// Celebration State Provider
///
/// Manages celebration animations and effects
/// Requirements: 26.1, 26.4
///
/// Copied from [CelebrationState].
@ProviderFor(CelebrationState)
final celebrationStateProvider =
    AutoDisposeNotifierProvider<CelebrationState, bool>.internal(
  CelebrationState.new,
  name: r'celebrationStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$celebrationStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CelebrationState = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
