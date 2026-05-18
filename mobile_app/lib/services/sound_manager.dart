/// Sound Manager Service
/// 
/// Manages all sound effects and background music for Smartino.
/// Provides easy-to-use interface for playing sounds with haptic feedback.
/// 
/// Requirements: 14.1, 14.2, 14.3, 14.4, 14.5 (Sound system)

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
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

  // Audio players
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _letterPlayer = AudioPlayer();

  // Sound effect paths
  static const Map<SoundEffect, String> _soundPaths = {
    SoundEffect.starDing: 'sounds/sfx/star_ding.mp3',
    SoundEffect.celebration: 'sounds/sfx/celebration.mp3',
    SoundEffect.whoosh: 'sounds/sfx/whoosh.mp3',
    SoundEffect.buttonTap: 'sounds/sfx/button_tap.mp3',
    SoundEffect.treasureUnlock: 'sounds/sfx/treasure_unlock.mp3',
    SoundEffect.correctAnswer: 'sounds/sfx/correct_answer.mp3',
    SoundEffect.encouragement: 'sounds/sfx/encouragement.mp3',
    SoundEffect.levelComplete: 'sounds/sfx/level_complete.mp3',
  };

  // Background music paths
  static const Map<BackgroundMusic, String> _musicPaths = {
    BackgroundMusic.mainMenu: 'sounds/music/main_menu.mp3',
    BackgroundMusic.gameplay: 'sounds/music/gameplay.mp3',
    BackgroundMusic.friendTab: 'sounds/music/friend_tab.mp3',
    BackgroundMusic.celebration: 'sounds/music/celebration.mp3',
  };

  // Letter sound mapping
  static const Map<String, String> _letterSounds = {
    'أ': 'letters/ا.mp4',
    'ب': 'letters/ب.mp4',
    'ت': 'letters/ت.mp4',
    'ج': 'letters/ج.mp4',
    'ح': 'letters/ح.mp4',
    'خ': 'letters/خ.mp4',
    'د': 'letters/د.mp4',
    'ذ': 'letters/ذ.mp4',
    'ر': 'letters/ر.mp4',
    'ز': 'letters/ز.mp4',
    'س': 'letters/س.mp4',
    'ش': 'letters/ش.mp4',
    'ص': 'letters/ص.mp4',
    'ض': 'letters/ض.mp4',
    'ط': 'letters/ط.mp4',
    'ظ': 'letters/ظ.mp4',
    'ع': 'letters/ع.mp4',
    'غ': 'letters/غ.mp4',
    'ف': 'letters/ف.mp4',
    'ق': 'letters/ق.mp4',
    'ل': 'letters/ل.mp4',
    'م': 'letters/م.mp4',
    'ن': 'letters/ن.mp4',
    'ه': 'letters/ه.mp4',
    'و': 'letters/و.mp4',
    'ي': 'letters/ي.mp4',
  };

  /// Initialize sound manager
  Future<void> initialize() async {
    await _loadSettings();
    developer.log('Sound manager initialized');
  }

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEffectsEnabled = prefs.getBool('sound_effects_enabled') ?? true;
    _musicEnabled = prefs.getBool('music_enabled') ?? true;
    _soundVolume = prefs.getDouble('sound_volume') ?? 1.0;
    _musicVolume = prefs.getDouble('music_volume') ?? 0.7;
    
    await _sfxPlayer.setVolume(_soundVolume);
    await _letterPlayer.setVolume(_soundVolume);
    await _musicPlayer.setVolume(_musicVolume);
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
      final path = _soundPaths[effect]!;
      await _sfxPlayer.play(AssetSource(path));
      
      if (withHaptic) {
        _playHaptic(hapticType);
      }
    } catch (e) {
      developer.log('Error playing sound effect: $e');
    }
  }

  /// Play letter sound
  Future<void> playLetterSound(String letter) async {
    if (!_soundEffectsEnabled) return;

    try {
      final path = _letterSounds[letter];
      if (path != null) {
        await _letterPlayer.play(AssetSource(path));
        developer.log('Playing letter sound: $letter');
      } else {
        developer.log('No sound file for letter: $letter');
      }
    } catch (e) {
      developer.log('Error playing letter sound: $e');
    }
  }

  /// Play audio from a local file path (e.g., ElevenLabs TTS result)
  Future<void> playLocalFile(String filePath) async {
    try {
      await _letterPlayer.play(DeviceFileSource(filePath));
      developer.log('Playing local file: $filePath');
    } catch (e) {
      developer.log('Error playing local file: $e');
    }
  }

  /// Stop all active audio
  Future<void> stopAll() async {
    try {
      await _sfxPlayer.stop();
      await _letterPlayer.stop();
      await _musicPlayer.stop();
    } catch (e) {
      developer.log('Error stopping all audio: $e');
    }
  }

  /// Play background music
  Future<void> playBackgroundMusic(BackgroundMusic music) async {
    if (!_musicEnabled) return;

    try {
      final path = _musicPaths[music]!;
      await _musicPlayer.play(AssetSource(path));
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      developer.log('Error playing background music: $e');
    }
  }

  /// Stop background music
  Future<void> stopBackgroundMusic() async {
    try {
      await _musicPlayer.stop();
    } catch (e) {
      developer.log('Error stopping background music: $e');
    }
  }

  /// Pause background music
  Future<void> pauseBackgroundMusic() async {
    try {
      await _musicPlayer.pause();
    } catch (e) {
      developer.log('Error pausing background music: $e');
    }
  }

  /// Resume background music
  Future<void> resumeBackgroundMusic() async {
    try {
      await _musicPlayer.resume();
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
    if (!enabled) await stopBackgroundMusic();
  }

  Future<void> setSoundVolume(double volume) async {
    _soundVolume = volume.clamp(0.0, 1.0);
    await _sfxPlayer.setVolume(_soundVolume);
    await _letterPlayer.setVolume(_soundVolume);
    await _saveSettings();
  }

  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    await _musicPlayer.setVolume(_musicVolume);
    await _saveSettings();
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _sfxPlayer.dispose();
    await _musicPlayer.dispose();
    await _letterPlayer.dispose();
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
  Future<void> playStarAward() async {
    await playSoundEffect(SoundEffect.starDing, hapticType: HapticFeedbackType.medium);
  }

  Future<void> playTreasureUnlock() async {
    await playSoundEffect(SoundEffect.treasureUnlock, hapticType: HapticFeedbackType.heavy);
  }

  Future<void> playCorrectAnswer() async {
    await playSoundEffect(SoundEffect.correctAnswer, hapticType: HapticFeedbackType.light);
  }

  Future<void> playEncouragement() async {
    await playSoundEffect(SoundEffect.encouragement, hapticType: HapticFeedbackType.light);
  }

  Future<void> playButtonTap() async {
    await playSoundEffect(SoundEffect.buttonTap, hapticType: HapticFeedbackType.selection);
  }
}
