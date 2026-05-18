import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mascot_service_provider.g.dart';

/// Mascot mood states
enum MascotMood {
  idle,
  happy,
  thinking,
  excited,
  listening,
  sad,
}

/// Mascot State Provider
/// 
/// Manages the mascot's mood and animation state
/// Requirements: 17.6, 26.1, 26.4
@riverpod
class MascotState extends _$MascotState {
  @override
  MascotMood build() {
    return MascotMood.idle;
  }

  /// Set mascot mood
  /// 
  /// Updates the mascot's emotional state and triggers animations
  /// Requirements: 17.6, 26.2
  void setMood(MascotMood mood) {
    state = mood;
  }

  /// Reset to idle mood
  void resetToIdle() {
    state = MascotMood.idle;
  }

  /// Set mood to happy (after correct answer)
  void setHappy() {
    state = MascotMood.happy;
  }

  /// Set mood to thinking (during processing)
  void setThinking() {
    state = MascotMood.thinking;
  }

  /// Set mood to excited (during celebration)
  void setExcited() {
    state = MascotMood.excited;
  }

  /// Set mood to listening (during voice input)
  void setListening() {
    state = MascotMood.listening;
  }

  /// Set mood to sad (gentle, for encouragement)
  void setSad() {
    state = MascotMood.sad;
  }
}

/// Mascot Visibility Provider
/// 
/// Controls whether the mascot overlay is visible
/// Requirements: 17.7, 26.1, 26.4
@riverpod
class MascotVisibility extends _$MascotVisibility {
  @override
  bool build() {
    return true;
  }

  /// Show the mascot
  void show() {
    state = true;
  }

  /// Hide the mascot
  void hide() {
    state = false;
  }

  /// Toggle mascot visibility
  void toggle() {
    state = !state;
  }
}
