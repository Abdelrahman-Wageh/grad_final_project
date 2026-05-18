/// Asset Manager
/// 
/// Centralized asset management system for graphics, sounds, and animations.
/// Inspired by Antura's Unity asset management but adapted for Flutter.

import 'package:flutter/material.dart';

class AssetManager {
  // Singleton pattern
  static final AssetManager _instance = AssetManager._internal();
  factory AssetManager() => _instance;
  AssetManager._internal();

  // ==================== GRAPHICS ====================
  
  /// Character Assets (Farfour)
  static const String farfourIdle = 'assets/characters/farfour/idle.png';
  static const String farfourHappy = 'assets/characters/farfour/happy.png';
  static const String farfourExcited = 'assets/characters/farfour/excited.png';
  static const String farfourThinking = 'assets/characters/farfour/thinking.png';
  static const String farfourSad = 'assets/characters/farfour/sad.png';
  static const String farfourCelebrating = 'assets/characters/farfour/celebrating.png';
  static const String farfourSpeaking = 'assets/characters/farfour/speaking.png';
  static const String farfourSleeping = 'assets/characters/farfour/sleeping.png';
  
  /// Background Assets
  static const String bgPyramids = 'assets/images/backgrounds/pyramids.png';
  static const String bgCairo = 'assets/images/backgrounds/cairo.png';
  static const String bgNile = 'assets/images/backgrounds/nile.png';
  static const String bgDesert = 'assets/images/backgrounds/desert.png';
  static const String bgGarden = 'assets/images/backgrounds/garden.png';
  static const String bgSky = 'assets/images/backgrounds/sky.png';
  
  /// Game Assets - Letter Balloons
  static const String balloonRed = 'assets/images/games/balloons/balloon_red.png';
  static const String balloonBlue = 'assets/images/games/balloons/balloon_blue.png';
  static const String balloonGreen = 'assets/images/games/balloons/balloon_green.png';
  static const String balloonYellow = 'assets/images/games/balloons/balloon_yellow.png';
  static const String balloonPurple = 'assets/images/games/balloons/balloon_purple.png';
  static const String balloonPink = 'assets/images/games/balloons/balloon_pink.png';
  
  /// Game Assets - Fast Crowd
  static const String crowdCard = 'assets/images/games/crowd/card.png';
  static const String crowdBackground = 'assets/images/games/crowd/background.png';
  
  /// Game Assets - Missing Letter
  static const String letterSlot = 'assets/images/games/missing_letter/slot.png';
  static const String letterTile = 'assets/images/games/missing_letter/tile.png';
  
  /// Game Assets - Mixed Letters
  static const String mixedTile = 'assets/images/games/mixed_letters/tile.png';
  static const String mixedSlot = 'assets/images/games/mixed_letters/slot.png';
  
  /// Game Assets - Reading
  static const String bookOpen = 'assets/images/games/reading/book_open.png';
  static const String bookClosed = 'assets/images/games/reading/book_closed.png';
  
  /// UI Elements
  static const String starEmpty = 'assets/images/ui/star_empty.png';
  static const String starFilled = 'assets/images/ui/star_filled.png';
  static const String starGold = 'assets/images/ui/star_gold.png';
  static const String buttonNormal = 'assets/images/ui/button_normal.png';
  static const String buttonPressed = 'assets/images/ui/button_pressed.png';
  static const String buttonDisabled = 'assets/images/ui/button_disabled.png';
  
  /// Icons
  static const String iconGame = 'assets/images/icons/game.png';
  static const String iconStory = 'assets/images/icons/story.png';
  static const String iconFriend = 'assets/images/icons/friend.png';
  static const String iconParent = 'assets/images/icons/parent.png';
  static const String iconSettings = 'assets/images/icons/settings.png';
  
  /// Particles & Effects
  static const String particleConfetti = 'assets/images/particles/confetti.png';
  static const String particleStar = 'assets/images/particles/star.png';
  static const String particleSparkle = 'assets/images/particles/sparkle.png';
  static const String particleHeart = 'assets/images/particles/heart.png';
  
  // ==================== SOUNDS ====================
  
  /// Music
  static const String musicMenu = 'assets/sounds/music/menu.mp3';
  static const String musicGame = 'assets/sounds/music/game.mp3';
  static const String musicStory = 'assets/sounds/music/story.mp3';
  static const String musicVictory = 'assets/sounds/music/victory.mp3';
  
  /// Sound Effects - UI
  static const String sfxTap = 'assets/sounds/sfx/tap.mp3';
  static const String sfxButton = 'assets/sounds/sfx/button.mp3';
  static const String sfxSwipe = 'assets/sounds/sfx/swipe.mp3';
  static const String sfxPop = 'assets/sounds/sfx/pop.mp3';
  
  /// Sound Effects - Game
  static const String sfxCorrect = 'assets/sounds/sfx/correct.mp3';
  static const String sfxWrong = 'assets/sounds/sfx/wrong.mp3';
  static const String sfxStar = 'assets/sounds/sfx/star.mp3';
  static const String sfxCelebration = 'assets/sounds/sfx/celebration.mp3';
  static const String sfxBalloonPop = 'assets/sounds/sfx/balloon_pop.mp3';
  static const String sfxLetterPlace = 'assets/sounds/sfx/letter_place.mp3';
  static const String sfxWordComplete = 'assets/sounds/sfx/word_complete.mp3';
  
  /// Sound Effects - Character
  static const String sfxFarfourHappy = 'assets/sounds/character/farfour_happy.mp3';
  static const String sfxFarfourExcited = 'assets/sounds/character/farfour_excited.mp3';
  static const String sfxFarfourThinking = 'assets/sounds/character/farfour_thinking.mp3';
  static const String sfxFarfourSad = 'assets/sounds/character/farfour_sad.mp3';
  
  /// Voice Lines (Egyptian Arabic)
  static const String voiceBravo = 'assets/sounds/voices/bravo.mp3';
  static const String voiceExcellent = 'assets/sounds/voices/excellent.mp3';
  static const String voiceTryAgain = 'assets/sounds/voices/try_again.mp3';
  static const String voiceGreat = 'assets/sounds/voices/great.mp3';
  static const String voiceWellDone = 'assets/sounds/voices/well_done.mp3';
  static const String voiceLetsPlay = 'assets/sounds/voices/lets_play.mp3';
  static const String voiceHello = 'assets/sounds/voices/hello.mp3';
  
  // ==================== ANIMATIONS ====================
  
  /// Lottie Animations
  static const String animConfetti = 'assets/animations/confetti.json';
  static const String animStars = 'assets/animations/stars.json';
  static const String animFireworks = 'assets/animations/fireworks.json';
  static const String animSparkles = 'assets/animations/sparkles.json';
  static const String animLoading = 'assets/animations/loading.json';
  static const String animSuccess = 'assets/animations/success.json';
  static const String animError = 'assets/animations/error.json';
  
  /// Character Animations
  static const String animFarfourWalk = 'assets/animations/farfour/walk.json';
  static const String animFarfourJump = 'assets/animations/farfour/jump.json';
  static const String animFarfourDance = 'assets/animations/farfour/dance.json';
  static const String animFarfourWave = 'assets/animations/farfour/wave.json';
  
  // ==================== HELPER METHODS ====================
  
  /// Get character asset by mood
  static String getCharacterAsset(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return farfourHappy;
      case 'excited':
        return farfourExcited;
      case 'thinking':
        return farfourThinking;
      case 'sad':
        return farfourSad;
      case 'celebrating':
        return farfourCelebrating;
      case 'speaking':
        return farfourSpeaking;
      case 'sleeping':
        return farfourSleeping;
      default:
        return farfourIdle;
    }
  }
  
  /// Get balloon asset by color
  static String getBalloonAsset(Color color) {
    if (color == Colors.red) return balloonRed;
    if (color == Colors.blue) return balloonBlue;
    if (color == Colors.green) return balloonGreen;
    if (color == Colors.yellow) return balloonYellow;
    if (color == Colors.purple) return balloonPurple;
    if (color == Colors.pink) return balloonPink;
    return balloonRed; // Default
  }
  
  /// Get background asset by theme
  static String getBackgroundAsset(String theme) {
    switch (theme.toLowerCase()) {
      case 'pyramids':
        return bgPyramids;
      case 'cairo':
        return bgCairo;
      case 'nile':
        return bgNile;
      case 'desert':
        return bgDesert;
      case 'garden':
        return bgGarden;
      default:
        return bgSky;
    }
  }
  
  /// Get voice line asset
  static String getVoiceLineAsset(String type) {
    switch (type.toLowerCase()) {
      case 'bravo':
        return voiceBravo;
      case 'excellent':
        return voiceExcellent;
      case 'try_again':
        return voiceTryAgain;
      case 'great':
        return voiceGreat;
      case 'well_done':
        return voiceWellDone;
      case 'lets_play':
        return voiceLetsPlay;
      case 'hello':
        return voiceHello;
      default:
        return voiceBravo;
    }
  }
  
  /// Preload critical assets
  static Future<void> preloadCriticalAssets(BuildContext context) async {
    // Preload character assets
    await precacheImage(AssetImage(farfourIdle), context);
    await precacheImage(AssetImage(farfourHappy), context);
    await precacheImage(AssetImage(farfourExcited), context);
    
    // Preload UI elements
    await precacheImage(AssetImage(starEmpty), context);
    await precacheImage(AssetImage(starFilled), context);
    await precacheImage(AssetImage(starGold), context);
    
    // Preload backgrounds
    await precacheImage(AssetImage(bgSky), context);
    await precacheImage(AssetImage(bgPyramids), context);
  }
  
  /// Get all assets for pubspec.yaml
  static List<String> getAllAssets() {
    return [
      // Characters
      'assets/characters/farfour/',
      
      // Backgrounds
      'assets/images/backgrounds/',
      
      // Game assets
      'assets/images/games/balloons/',
      'assets/images/games/crowd/',
      'assets/images/games/missing_letter/',
      'assets/images/games/mixed_letters/',
      'assets/images/games/reading/',
      
      // UI
      'assets/images/ui/',
      'assets/images/icons/',
      'assets/images/particles/',
      
      // Sounds
      'assets/sounds/music/',
      'assets/sounds/sfx/',
      'assets/sounds/character/',
      'assets/sounds/voices/',
      
      // Animations
      'assets/animations/',
      'assets/animations/farfour/',
    ];
  }
}

/// Asset Categories for organization
enum AssetCategory {
  character,
  background,
  game,
  ui,
  sound,
  music,
  voice,
  animation,
}

/// Asset Quality Settings
class AssetQuality {
  static const String high = 'high';
  static const String medium = 'medium';
  static const String low = 'low';
  
  static String getCurrentQuality() {
    // TODO: Implement based on device capabilities
    return high;
  }
}
