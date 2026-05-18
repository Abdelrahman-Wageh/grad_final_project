// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$soundManagerHash() => r'e5c9cae5e2990736d34e4552a5fd95ddc41a14cb';

/// Sound Manager Provider
///
/// Provides access to sound effects and music
/// Requirements: 26.1, 26.3
///
/// Copied from [soundManager].
@ProviderFor(soundManager)
final soundManagerProvider = AutoDisposeProvider<SoundManager>.internal(
  soundManager,
  name: r'soundManagerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$soundManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SoundManagerRef = AutoDisposeProviderRef<SoundManager>;
String _$performanceOptimizerHash() =>
    r'77c078eea5fb7ce1dc3815deef078e0c06b52d4c';

/// Performance Optimizer Provider
///
/// Provides access to performance monitoring and optimization
/// Requirements: 26.1, 26.3
///
/// Copied from [performanceOptimizer].
@ProviderFor(performanceOptimizer)
final performanceOptimizerProvider =
    AutoDisposeProvider<PerformanceOptimizer>.internal(
  performanceOptimizer,
  name: r'performanceOptimizerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$performanceOptimizerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PerformanceOptimizerRef = AutoDisposeProviderRef<PerformanceOptimizer>;
String _$soundSettingsHash() => r'e25828d8042ea6f9d27afad80d7e7f398ea4ef32';

/// Sound Settings Provider
///
/// Manages sound and music settings
/// Requirements: 14.5, 26.1, 26.4
///
/// Copied from [SoundSettings].
@ProviderFor(SoundSettings)
final soundSettingsProvider =
    AutoDisposeNotifierProvider<SoundSettings, SoundSettingsState>.internal(
  SoundSettings.new,
  name: r'soundSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$soundSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SoundSettings = AutoDisposeNotifier<SoundSettingsState>;
String _$hapticSettingsHash() => r'7d710208da759a48ec015038cfb640cc73b9cd34';

/// Haptic Settings Provider
///
/// Manages haptic feedback settings
/// Requirements: 10.3, 25.3, 26.1, 26.4
///
/// Copied from [HapticSettings].
@ProviderFor(HapticSettings)
final hapticSettingsProvider =
    AutoDisposeNotifierProvider<HapticSettings, bool>.internal(
  HapticSettings.new,
  name: r'hapticSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hapticSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HapticSettings = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
