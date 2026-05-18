/// Advanced Sound Manager
/// 
/// Unity-level audio management system for Smartino.
/// Handles music, SFX, voice lines, and spatial audio.

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../assets/asset_manager.dart';

class AdvancedSoundManager {
  // Singleton pattern
  static final AdvancedSoundManager _instance = AdvancedSoundManager._internal();
  factory AdvancedSoundManager() => _instance;
  AdvancedSoundManager._internal();

  // Audio players
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _voicePlayer = AudioPlayer();
  final AudioPlayer _ambientPlayer = AudioPlayer();
  
  // Volume settings
  double _masterVolume = 1.0;
  double _musicVolume = 0.7;
  double _sfxVolume = 0.8;
  double _voiceVolume = 1.0;
  double _ambientVolume = 0.5;
  
  // State
  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;
  bool _isVoiceEnabled = true;
  String? _currentMusic;
  
  // Audio pools for rapid playback
  final Map<String, AudioPlayer> _sfxPool = {};
  final int _maxPoolSize = 10;
  
  // ==================== INITIALIZATION ====================
  
  Future<void> initialize() async {
    // Set audio modes
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
    await _voicePlayer.setReleaseMode(ReleaseMode.stop);
    await _ambientPlayer.setReleaseMode(ReleaseMode.loop);
    
    // Set initial volumes
    await _updateVolumes();
    
    if (kDebugMode) {
      print('AdvancedSoundManager initialized');
    }
  }
  
  Future<void> _updateVolumes() async {
    await _musicPlayer.setVolume(_musicVolume * _masterVolume);
    await _sfxPlayer.setVolume(_sfxVolume * _masterVolume);
    await _voicePlayer.setVolume(_voiceVolume * _masterVolume);
    await _ambientPlayer.setVolume(_ambientVolume * _masterVolume);
  }
  
  // ==================== MUSIC ====================
  
  /// Play background music
  Future<void> playMusic(String musicPath, {bool fadeIn = true}) async {
    if (!_isMusicEnabled) return;
    if (_currentMusic == musicPath) return;
    
    try {
      if (fadeIn) {
        await _fadeOutMusic();
      } else {
        await _musicPlayer.stop();
      }
      
      await _musicPlayer.play(AssetSource(musicPath));
      _currentMusic = musicPath;
      
      if (fadeIn) {
        await _fadeInMusic();
      }
      
      if (kDebugMode) {
        print('Playing music: $musicPath');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing music: $e');
      }
    }
  }
  
  /// Stop music
  Future<void> stopMusic({bool fadeOut = true}) async {
    if (fadeOut) {
      await _fadeOutMusic();
    } else {
      await _musicPlayer.stop();
    }
    _currentMusic = null;
  }
  
  /// Pause music
  Future<void> pauseMusic() async {
    await _musicPlayer.pause();
  }
  
  /// Resume music
  Future<void> resumeMusic() async {
    if (_isMusicEnabled) {
      await _musicPlayer.resume();
    }
  }
  
  /// Fade in music
  Future<void> _fadeInMusic() async {
    const steps = 20;
    const duration = Duration(milliseconds: 1500);
    final stepDuration = duration.inMilliseconds ~/ steps;
    
    for (int i = 0; i <= steps; i++) {
      final volume = (i / steps) * _musicVolume * _masterVolume;
      await _musicPlayer.setVolume(volume);
      await Future.delayed(Duration(milliseconds: stepDuration));
    }
  }
  
  /// Fade out music
  Future<void> _fadeOutMusic() async {
    const steps = 20;
    const duration = Duration(milliseconds: 1000);
    final stepDuration = duration.inMilliseconds ~/ steps;
    
    for (int i = steps; i >= 0; i--) {
      final volume = (i / steps) * _musicVolume * _masterVolume;
      await _musicPlayer.setVolume(volume);
      await Future.delayed(Duration(milliseconds: stepDuration));
    }
    
    await _musicPlayer.stop();
  }
  
  // ==================== SOUND EFFECTS ====================
  
  /// Play sound effect
  Future<void> playSfx(String sfxPath, {double volume = 1.0}) async {
    if (!_isSfxEnabled) return;
    
    try {
      // Use pool for rapid playback
      final player = _getAvailablePlayer(sfxPath);
      await player.setVolume(volume * _sfxVolume * _masterVolume);
      await player.play(AssetSource(sfxPath));
      
      if (kDebugMode) {
        print('Playing SFX: $sfxPath');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing SFX: $e');
      }
    }
  }
  
  /// Play UI sound
  Future<void> playUiSound(String soundType) async {
    switch (soundType) {
      case 'tap':
        await playSfx(AssetManager.sfxTap);
        break;
      case 'button':
        await playSfx(AssetManager.sfxButton);
        break;
      case 'swipe':
        await playSfx(AssetManager.sfxSwipe);
        break;
      case 'pop':
        await playSfx(AssetManager.sfxPop);
        break;
    }
  }
  
  /// Play game sound
  Future<void> playGameSound(String soundType) async {
    switch (soundType) {
      case 'correct':
        await playSfx(AssetManager.sfxCorrect);
        break;
      case 'wrong':
        await playSfx(AssetManager.sfxWrong);
        break;
      case 'star':
        await playSfx(AssetManager.sfxStar);
        break;
      case 'celebration':
        await playSfx(AssetManager.sfxCelebration);
        break;
      case 'balloon_pop':
        await playSfx(AssetManager.sfxBalloonPop);
        break;
      case 'letter_place':
        await playSfx(AssetManager.sfxLetterPlace);
        break;
      case 'word_complete':
        await playSfx(AssetManager.sfxWordComplete);
        break;
    }
  }
  
  /// Get available player from pool
  AudioPlayer _getAvailablePlayer(String key) {
    // Check if player exists and is not playing
    if (_sfxPool.containsKey(key)) {
      final player = _sfxPool[key]!;
      if (player.state != PlayerState.playing) {
        return player;
      }
    }
    
    // Create new player if pool not full
    if (_sfxPool.length < _maxPoolSize) {
      final player = AudioPlayer();
      player.setReleaseMode(ReleaseMode.stop);
      _sfxPool[key] = player;
      return player;
    }
    
    // Return default player
    return _sfxPlayer;
  }
  
  // ==================== VOICE LINES ====================
  
  /// Play voice line
  Future<void> playVoiceLine(String voiceType, {VoidCallback? onComplete}) async {
    if (!_isVoiceEnabled) return;
    
    try {
      final voicePath = AssetManager.getVoiceLineAsset(voiceType);
      await _voicePlayer.stop();
      await _voicePlayer.play(AssetSource(voicePath));
      
      if (onComplete != null) {
        _voicePlayer.onPlayerComplete.listen((_) {
          onComplete();
        });
      }
      
      if (kDebugMode) {
        print('Playing voice: $voiceType');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing voice: $e');
      }
    }
  }
  
  /// Play encouragement voice
  Future<void> playEncouragement(bool isCorrect) async {
    if (isCorrect) {
      final encouragements = ['bravo', 'excellent', 'great', 'well_done'];
      final random = (DateTime.now().millisecondsSinceEpoch % encouragements.length);
      await playVoiceLine(encouragements[random]);
    } else {
      await playVoiceLine('try_again');
    }
  }
  
  /// Stop voice
  Future<void> stopVoice() async {
    await _voicePlayer.stop();
  }
  
  // ==================== AMBIENT SOUNDS ====================
  
  /// Play ambient sound
  Future<void> playAmbient(String ambientPath) async {
    try {
      await _ambientPlayer.play(AssetSource(ambientPath));
      
      if (kDebugMode) {
        print('Playing ambient: $ambientPath');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing ambient: $e');
      }
    }
  }
  
  /// Stop ambient
  Future<void> stopAmbient({bool fadeOut = true}) async {
    if (fadeOut) {
      await _fadeOutAmbient();
    } else {
      await _ambientPlayer.stop();
    }
  }
  
  Future<void> _fadeOutAmbient() async {
    const steps = 15;
    const duration = Duration(milliseconds: 800);
    final stepDuration = duration.inMilliseconds ~/ steps;
    
    for (int i = steps; i >= 0; i--) {
      final volume = (i / steps) * _ambientVolume * _masterVolume;
      await _ambientPlayer.setVolume(volume);
      await Future.delayed(Duration(milliseconds: stepDuration));
    }
    
    await _ambientPlayer.stop();
  }
  
  // ==================== VOLUME CONTROL ====================
  
  /// Set master volume
  Future<void> setMasterVolume(double volume) async {
    _masterVolume = volume.clamp(0.0, 1.0);
    await _updateVolumes();
  }
  
  /// Set music volume
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    await _musicPlayer.setVolume(_musicVolume * _masterVolume);
  }
  
  /// Set SFX volume
  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);
    await _sfxPlayer.setVolume(_sfxVolume * _masterVolume);
  }
  
  /// Set voice volume
  Future<void> setVoiceVolume(double volume) async {
    _voiceVolume = volume.clamp(0.0, 1.0);
    await _voicePlayer.setVolume(_voiceVolume * _masterVolume);
  }
  
  // ==================== ENABLE/DISABLE ====================
  
  /// Enable/disable music
  void setMusicEnabled(bool enabled) {
    _isMusicEnabled = enabled;
    if (!enabled) {
      stopMusic(fadeOut: false);
    }
  }
  
  /// Enable/disable SFX
  void setSfxEnabled(bool enabled) {
    _isSfxEnabled = enabled;
  }
  
  /// Enable/disable voice
  void setVoiceEnabled(bool enabled) {
    _isVoiceEnabled = enabled;
    if (!enabled) {
      stopVoice();
    }
  }
  
  // ==================== CLEANUP ====================
  
  /// Dispose all players
  Future<void> dispose() async {
    await _musicPlayer.dispose();
    await _sfxPlayer.dispose();
    await _voicePlayer.dispose();
    await _ambientPlayer.dispose();
    
    for (final player in _sfxPool.values) {
      await player.dispose();
    }
    _sfxPool.clear();
  }
  
  // ==================== GETTERS ====================
  
  double get masterVolume => _masterVolume;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  double get voiceVolume => _voiceVolume;
  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSfxEnabled => _isSfxEnabled;
  bool get isVoiceEnabled => _isVoiceEnabled;
  String? get currentMusic => _currentMusic;
}

/// Sound presets for common scenarios
class SoundPresets {
  static final AdvancedSoundManager _soundManager = AdvancedSoundManager();
  
  /// Play game start sounds
  static Future<void> gameStart() async {
    await _soundManager.playMusic(AssetManager.musicGame);
    await _soundManager.playVoiceLine('lets_play');
  }
  
  /// Play game end sounds
  static Future<void> gameEnd(bool won) async {
    if (won) {
      await _soundManager.playMusic(AssetManager.musicVictory);
      await _soundManager.playGameSound('celebration');
      await _soundManager.playVoiceLine('excellent');
    }
  }
  
  /// Play correct answer sounds
  static Future<void> correctAnswer() async {
    await _soundManager.playGameSound('correct');
    await _soundManager.playEncouragement(true);
  }
  
  /// Play wrong answer sounds
  static Future<void> wrongAnswer() async {
    await _soundManager.playGameSound('wrong');
    await _soundManager.playEncouragement(false);
  }
  
  /// Play star earned sound
  static Future<void> starEarned() async {
    await _soundManager.playGameSound('star');
  }
}
