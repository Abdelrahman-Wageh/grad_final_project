import 'package:flutter/services.dart';
import '../data/models/child_profile.dart';
import 'local_storage_service.dart';

/// Manages rewards, stars, and positive reinforcement
/// 
/// Implements Harvard-backed positive psychology principles:
/// - Always encouraging, never negative
/// - Celebrates successes with stars and treasures
/// - Reframes errors as learning opportunities
/// 
/// Requirements: 4.1, 4.3, 5.1, 5.2, 25.5
class RewardManagerV2 {
  final LocalStorageService _storage;

  // Treasure unlock threshold
  static const int STARS_PER_TREASURE = 5;

  // Available treasures (unlockable items for Smartino)
  static const List<String> AVAILABLE_TREASURES = [
    'wizard_hat',
    'magic_wand',
    'rainbow_cape',
    'star_glasses',
    'crown',
    'butterfly_wings',
    'superhero_mask',
    'fairy_wand',
    'pirate_hat',
    'astronaut_helmet',
    'dragon_wings',
    'unicorn_horn',
    'ninja_headband',
    'princess_tiara',
    'robot_antenna',
  ];

  RewardManagerV2(this._storage);

  /// Handles correct answer with star award and celebration
  /// 
  /// Requirements: 5.1
  Future<RewardResult> handleCorrectAnswer(ChildProfile profile) async {
    // Award star
    profile.stars++;
    
    // Play sound effect (ready for implementation)
    await _playStarSound();
    
    // Haptic feedback
    await HapticFeedback.mediumImpact();
    
    // Check for treasure unlock
    String? unlockedTreasure;
    if (profile.stars % STARS_PER_TREASURE == 0) {
      unlockedTreasure = await _unlockNextTreasure(profile);
    }
    
    // Save profile
    await _storage.saveProfile(profile);
    
    return RewardResult(
      starsAwarded: 1,
      totalStars: profile.stars,
      treasureUnlocked: unlockedTreasure,
      encouragingMessage: _getSuccessMessage(),
      shouldCelebrate: unlockedTreasure != null,
    );
  }

  /// Handles incorrect answer with positive reinforcement
  /// 
  /// NEVER uses negative words like "wrong" or "incorrect"
  /// Always encouraging and supportive
  /// 
  /// Requirements: 4.1, 4.3, 25.5
  Future<RewardResult> handleIncorrectAnswer(ChildProfile profile) async {
    // Gentle haptic feedback
    await HapticFeedback.lightImpact();
    
    // Save profile (no star deduction)
    await _storage.saveProfile(profile);
    
    return RewardResult(
      starsAwarded: 0,
      totalStars: profile.stars,
      treasureUnlocked: null,
      encouragingMessage: _getEncouragingMessage(),
      shouldCelebrate: false,
    );
  }

  /// Unlocks the next treasure for the child
  /// 
  /// Requirements: 5.1, 5.2
  Future<String?> _unlockNextTreasure(ChildProfile profile) async {
    // Find next unlockable treasure
    final unlockedCount = profile.unlockedTreasures.length;
    
    if (unlockedCount >= AVAILABLE_TREASURES.length) {
      // All treasures unlocked - award bonus stars instead
      profile.stars += 5;
      return null;
    }
    
    final nextTreasure = AVAILABLE_TREASURES[unlockedCount];
    profile.unlockTreasure(nextTreasure);
    
    // Play celebration sound
    await _playCelebrationSound();
    
    // Heavy haptic feedback for big achievement
    await HapticFeedback.heavyImpact();
    
    return nextTreasure;
  }

  /// Gets a random success message
  /// 
  /// Always positive and encouraging
  String _getSuccessMessage() {
    final messages = [
      "Amazing! You're a star! ⭐",
      "Fantastic work! 🌟",
      "You did it! So proud of you! 🎉",
      "Brilliant! Keep shining! ✨",
      "Wow! You're so smart! 🧠",
      "Perfect! You're incredible! 💫",
      "Excellent! You're a champion! 🏆",
      "Wonderful! You're amazing! 🎊",
      "Superb! You're a genius! 🌈",
      "Outstanding! You rock! 🎸",
    ];
    
    return messages[DateTime.now().millisecond % messages.length];
  }

  /// Gets a random encouraging message for errors
  /// 
  /// NEVER negative - always supportive and encouraging
  /// 
  /// Requirements: 4.1, 4.3, 25.5
  String _getEncouragingMessage() {
    final messages = [
      "So close! Try once more! 💪",
      "Almost there! You've got this! 🌟",
      "Great try! Let's do it together! 🤝",
      "Nice effort! One more time! 🎯",
      "You're learning! Keep going! 📚",
      "Good thinking! Try again! 💭",
      "I believe in you! Let's try! 🌈",
      "You're doing great! Once more! ⭐",
      "So smart! Let's figure it out! 🧩",
      "Awesome try! We'll get it! 🚀",
    ];
    
    return messages[DateTime.now().millisecond % messages.length];
  }

  /// Plays star award sound effect
  /// 
  /// Requirements: 5.1
  Future<void> _playStarSound() async {
    // TODO: Implement with audio player
    // await AudioPlayer().play('assets/sounds/star_ding.mp3');
  }

  /// Plays celebration sound effect
  /// 
  /// Requirements: 5.1
  Future<void> _playCelebrationSound() async {
    // TODO: Implement with audio player
    // await AudioPlayer().play('assets/sounds/celebration.mp3');
  }

  /// Gets treasure display name
  String getTreasureDisplayName(String treasureId) {
    final names = {
      'wizard_hat': 'Wizard Hat 🧙',
      'magic_wand': 'Magic Wand ✨',
      'rainbow_cape': 'Rainbow Cape 🌈',
      'star_glasses': 'Star Glasses ⭐',
      'crown': 'Royal Crown 👑',
      'butterfly_wings': 'Butterfly Wings 🦋',
      'superhero_mask': 'Superhero Mask 🦸',
      'fairy_wand': 'Fairy Wand 🧚',
      'pirate_hat': 'Pirate Hat 🏴‍☠️',
      'astronaut_helmet': 'Astronaut Helmet 🚀',
      'dragon_wings': 'Dragon Wings 🐉',
      'unicorn_horn': 'Unicorn Horn 🦄',
      'ninja_headband': 'Ninja Headband 🥷',
      'princess_tiara': 'Princess Tiara 👸',
      'robot_antenna': 'Robot Antenna 🤖',
    };
    
    return names[treasureId] ?? treasureId;
  }

  /// Gets progress towards next treasure
  TreasureProgress getTreasureProgress(ChildProfile profile) {
    final starsToNext = STARS_PER_TREASURE - (profile.stars % STARS_PER_TREASURE);
    final progress = (profile.stars % STARS_PER_TREASURE) / STARS_PER_TREASURE;
    
    return TreasureProgress(
      currentStars: profile.stars,
      starsToNextTreasure: starsToNext,
      progress: progress,
      totalTreasuresUnlocked: profile.unlockedTreasures.length,
      totalTreasuresAvailable: AVAILABLE_TREASURES.length,
    );
  }

  /// Gets next treasure to unlock
  String? getNextTreasure(ChildProfile profile) {
    final unlockedCount = profile.unlockedTreasures.length;
    
    if (unlockedCount >= AVAILABLE_TREASURES.length) {
      return null; // All unlocked
    }
    
    return AVAILABLE_TREASURES[unlockedCount];
  }

  /// Checks if child has unlocked all treasures
  bool hasUnlockedAllTreasures(ChildProfile profile) {
    return profile.unlockedTreasures.length >= AVAILABLE_TREASURES.length;
  }
}

/// Result of a reward action
class RewardResult {
  final int starsAwarded;
  final int totalStars;
  final String? treasureUnlocked;
  final String encouragingMessage;
  final bool shouldCelebrate;

  RewardResult({
    required this.starsAwarded,
    required this.totalStars,
    this.treasureUnlocked,
    required this.encouragingMessage,
    required this.shouldCelebrate,
  });
}

/// Progress towards next treasure
class TreasureProgress {
  final int currentStars;
  final int starsToNextTreasure;
  final double progress; // 0.0 to 1.0
  final int totalTreasuresUnlocked;
  final int totalTreasuresAvailable;

  TreasureProgress({
    required this.currentStars,
    required this.starsToNextTreasure,
    required this.progress,
    required this.totalTreasuresUnlocked,
    required this.totalTreasuresAvailable,
  });

  /// Gets a child-friendly progress message
  String getProgressMessage() {
    if (starsToNextTreasure == 1) {
      return "Just 1 more star for a treasure! 🎁";
    } else if (starsToNextTreasure <= 2) {
      return "Only $starsToNextTreasure stars until treasure! 🌟";
    } else {
      return "$starsToNextTreasure stars to next treasure! ⭐";
    }
  }
}
