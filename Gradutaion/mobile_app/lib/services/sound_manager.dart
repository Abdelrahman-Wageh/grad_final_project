/// Sound Manager Service
/// 
/// Manages all sound effects and background music for Smartino.
/// Provides easy-to-use interface for playing sounds with haptic feedback.
/// 
/// Requirements: 14.1, 14.2, 14.3, 14.4, 14.5 (Sound system)

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

enum SoundEffect {
  starDing,
  celebration,
  whoosh,
  buttonTap,
  treasureUnlock,
  correctAnswer,
  encouragement,
  levelComplete,
}

enum BackgroundMusic {
  mainMenu,
  gameplay,
  friendTab,
  celebration,
}

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  // Settings
  bool _soundEffectsEnabled = true;
  bool _musicEnabled = true;
  double _soundVolume = 1.0;
  double _musicVolume = 0.7;

  // TODO: Replace with actual audio player when assets are ready
  // final AudioPlayer _sfxPlayer = AudioPlayer();
  // final AudioPlayer _musicPlayer = AudioPlayer();

  // Sound effect paths (ready for implementation)
  static const Map<SoundEffect, String> _soundPaths = {
    SoundEffect.starDing: 'assets/sounds/star_ding.mp3',
    SoundEffect.celebration: 'assets/sounds/celebration.mp3',
    SoundEffect.whoosh: 'assets/sounds/whoosh.mp3',
    SoundEffect.buttonTap: 'assets/sounds/button_tap.mp3',
    SoundEffect.treasureUnlock: 'assets/sounds/treasure_unlock.mp3',
    SoundEffect.correctAnswer: 'assets/sounds/correct_answer.mp3',
    SoundEffect.encouragement: 'assets/sounds/encouragement.mp3',
    SoundEffect.levelComplete: 'assets/sounds/level_complete.mp3',
  };

  // Background music paths
  static const Map<BackgroundMusic, String> _musicPaths = {
    BackgroundMusic.mainMenu: 'assets/music/main_menu.mp3',
    BackgroundMusic.gameplay: 'assets/music/gameplay.mp3',
    BackgroundMusic.friendTab: 'assets/music/friend_tab.mp3',
    BackgroundMusic.celebration: 'assets/music/celebration.mp3',
  };

  /// Initialize sound manager
  Future<void> initialize() async {
    await _loadSettings();
    developer.log('Sound manager initialized');
    developer.log('Sound effects: $_soundEffectsEnabled, Music: $_musicEnabled');
  }

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEffectsEnabled = prefs.getBool('sound_effects_enabled') ?? true;
    _musicEnabled = prefs.getBool('music_enabled') ?? true;
    _soundVolume = prefs.getDouble('sound_volume') ?? 1.0;
    _musicVolume = prefs.getDouble('music_volume') ?? 0.7;
  }

  /// Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_effects_enabled', _soundEffectsEnabled);
    await prefs.setBool('music_enabled', _musicEnabled);
    await prefs.setDouble('sound_volume', _soundVolume);
    await prefs.setDouble('music_volume', _musicVolume);
  }

  /// Play sound effect
  Future<void> playSoundEffect(
    SoundEffect effect, {
    bool withHaptic = true,
    HapticFeedbackType hapticType = HapticFeedbackType.light,
  }) async {
    if (!_soundEffectsEnabled) return;

    try {
      // TODO: Implement actual audio playback when assets are ready
      // final path = _soundPaths[effect]!;
      // await _sfxPlayer.play(AssetSource(path), volume: _soundVolume);
      
      developer.log('Playing sound effect: $effect');

      // Play haptic feedback
      if (withHaptic) {
        _playHaptic(hapticType);
      }
    } catch (e) {
      developer.log('Error playing sound effect: $e');
    }
  }

  /// Play background music
  Future<void> playBackgroundMusic(BackgroundMusic music) async {
    if (!_musicEnabled) return;

    try {
      // TODO: Implement actual music playback when assets are ready
      // final path = _musicPaths[music]!;
      // await _musicPlayer.play(AssetSource(path), volume: _musicVolume);
      // await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      
      developer.log('Playing background music: $music');
    } catch (e) {
      developer.log('Error playing background music: $e');
    }
  }

  /// Stop background music
  Future<void> stopBackgroundMusic() async {
    try {
      // TODO: Implement when audio player is ready
      // await _musicPlayer.stop();
      developer.log('Stopped background music');
    } catch (e) {
      developer.log('Error stopping background music: $e');
    }
  }

  /// Pause background music
  Future<void> pauseBackgroundMusic() async {
    try {
      // TODO: Implement when audio player is ready
      // await _musicPlayer.pause();
      developer.log('Paused background music');
    } catch (e) {
      developer.log('Error pausing background music: $e');
    }
  }

  /// Resume background music
  Future<void> resumeBackgroundMusic() async {
    try {
      // TODO: Implement when audio player is ready
      // await _musicPlayer.resume();
      developer.log('Resumed background music');
    } catch (e) {
      developer.log('Error resuming background music: $e');
    }
  }

  /// Play haptic feedback
  void _playHaptic(HapticFeedbackType type) {
    switch (type) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }

  // Getters
  bool get soundEffectsEnabled => _soundEffectsEnabled;
  bool get musicEnabled => _musicEnabled;
  double get soundVolume => _soundVolume;
  double get musicVolume => _musicVolume;

  // Setters with persistence
  Future<void> setSoundEffectsEnabled(bool enabled) async {
    _soundEffectsEnabled = enabled;
    await _saveSettings();
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    await _saveSettings();
    
    if (!enabled) {
      await stopBackgroundMusic();
    }
  }

  Future<void> setSoundVolume(double volume) async {
    _soundVolume = volume.clamp(0.0, 1.0);
    await _saveSettings();
  }

  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    await _saveSettings();
    
    // TODO: Update music player volume when implemented
    // await _musicPlayer.setVolume(_musicVolume);
  }

  /// Dispose resources
  Future<void> dispose() async {
    // TODO: Dispose audio players when implemented
    // await _sfxPlayer.dispose();
    // await _musicPlayer.dispose();
  }
}

enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
}

/// Convenience methods for common sound + haptic combinations
extension SoundManagerExtensions on SoundManager {
  /// Play star award sound with medium haptic
  Future<void> playStarAward() async {
    await playSoundEffect(
      SoundEffect.starDing,
      hapticType: HapticFeedbackType.medium,
    );
  }

  /// Play treasure unlock with heavy haptic
  Future<void> playTreasureUnlock() async {
    await playSoundEffect(
      SoundEffect.treasureUnlock,
      hapticType: HapticFeedbackType.heavy,
    );
  }

  /// Play correct answer with light haptic
  Future<void> playCorrectAnswer() async {
    await playSoundEffect(
      SoundEffect.correctAnswer,
      hapticType: HapticFeedbackType.light,
    );
  }

  /// Play encouragement with light haptic
  Future<void> playEncouragement() async {
    await playSoundEffect(
      SoundEffect.encouragement,
      hapticType: HapticFeedbackType.light,
    );
  }

  /// Play button tap with selection haptic
  Future<void> playButtonTap() async {
    await playSoundEffect(
      SoundEffect.buttonTap,
      hapticType: HapticFeedbackType.selection,
    );
  }
}
