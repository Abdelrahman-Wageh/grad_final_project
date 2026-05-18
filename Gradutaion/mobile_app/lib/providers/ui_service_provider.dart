import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/sound_manager.dart';
import '../services/performance_optimizer.dart';

part 'ui_service_provider.g.dart';

/// Sound Manager Provider
/// 
/// Provides access to sound effects and music
/// Requirements: 26.1, 26.3
@riverpod
SoundManager soundManager(SoundManagerRef ref) {
  return SoundManager();
}

/// Performance Optimizer Provider
/// 
/// Provides access to performance monitoring and optimization
/// Requirements: 26.1, 26.3
@riverpod
PerformanceOptimizer performanceOptimizer(PerformanceOptimizerRef ref) {
  return PerformanceOptimizer();
}

/// Sound Settings Provider
/// 
/// Manages sound and music settings
/// Requirements: 14.5, 26.1, 26.4
@riverpod
class SoundSettings extends _$SoundSettings {
  @override
  SoundSettingsState build() {
    return SoundSettingsState(
      soundEnabled: true,
      musicEnabled: true,
      volume: 1.0,
    );
  }

  /// Toggle sound effects
  void toggleSound() {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
  }

  /// Toggle background music
  void toggleMusic() {
    state = state.copyWith(musicEnabled: !state.musicEnabled);
  }

  /// Set volume (0.0 to 1.0)
  void setVolume(double volume) {
    state = state.copyWith(volume: volume.clamp(0.0, 1.0));
  }
}

/// Sound settings state
class SoundSettingsState {
  final bool soundEnabled;
  final bool musicEnabled;
  final double volume;

  SoundSettingsState({
    required this.soundEnabled,
    required this.musicEnabled,
    required this.volume,
  });

  SoundSettingsState copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    double? volume,
  }) {
    return SoundSettingsState(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      volume: volume ?? this.volume,
    );
  }
}

/// Haptic Settings Provider
/// 
/// Manages haptic feedback settings
/// Requirements: 10.3, 25.3, 26.1, 26.4
@riverpod
class HapticSettings extends _$HapticSettings {
  @override
  bool build() {
    return true;
  }

  /// Toggle haptic feedback
  void toggle() {
    state = !state;
  }

  /// Enable haptic feedback
  void enable() {
    state = true;
  }

  /// Disable haptic feedback
  void disable() {
    state = false;
  }
}
