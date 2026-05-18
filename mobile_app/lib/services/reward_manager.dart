/// Reward Manager
/// Handles star awards, treasure unlocks, and positive reinforcement
/// Harvard-backed psychology: Only positive feedback, never negative
library;

import 'package:flutter/material.dart';
import '../data/models/child_profile.dart';
import '../widgets/smartino_mascot.dart';
import 'dart:math';

class RewardManager {
  static const int STARS_PER_TREASURE = 5;
  static const int MAX_STARS_DISPLAY = 100;

  // Available items to unlock (in order)
  static final List<UnlockedItem> availableItems = [
    // Hats
    UnlockedItem(
      id: 'hat_wizard',
      nameEn: 'Wizard Hat',
      nameAr: 'قبعة الساحر',
      type: ItemType.hat,
      emoji: '🎩',
      position: Offset(0.3, 0.1),
      starsRequired: 5,
      unlockedAt: DateTime.now(),
    ),
    UnlockedItem(
      id: 'hat_crown',
      nameEn: 'Crown',
      nameAr: 'تاج',
      type: ItemType.hat,
      emoji: '👑',
      position: Offset(0.3, 0.1),
      starsRequired: 10,
      unlockedAt: DateTime.now(),
    ),
    UnlockedItem(
      id: 'hat_party',
      nameEn: 'Party Hat',
      nameAr: 'قبعة الحفلة',
      type: ItemType.hat,
      emoji: '🎉',
      position: Offset(0.3, 0.1),
      starsRequired: 15,
      unlockedAt: DateTime.now(),
    ),
    
    // Wands
    UnlockedItem(
      id: 'wand_magic',
      nameEn: 'Magic Wand',
      nameAr: 'عصا سحرية',
      type: ItemType.wand,
      emoji: '🪄',
      position: Offset(0.7, 0.5),
      starsRequired: 20,
      unlockedAt: DateTime.now(),
    ),
    UnlockedItem(
      id: 'wand_star',
      nameEn: 'Star Wand',
      nameAr: 'عصا النجوم',
      type: ItemType.wand,
      emoji: '⭐',
      position: Offset(0.7, 0.5),
      starsRequired: 25,
      unlockedAt: DateTime.now(),
    ),
    
    // Accessories
    UnlockedItem(
      id: 'glasses_cool',
      nameEn: 'Cool Glasses',
      nameAr: 'نظارة رائعة',
      type: ItemType.glasses,
      emoji: '😎',
      position: Offset(0.4, 0.4),
      starsRequired: 30,
      unlockedAt: DateTime.now(),
    ),
    UnlockedItem(
      id: 'cape_hero',
      nameEn: 'Hero Cape',
      nameAr: 'عباءة البطل',
      type: ItemType.cape,
      emoji: '🦸',
      position: Offset(0.3, 0.6),
      starsRequired: 35,
      unlockedAt: DateTime.now(),
    ),
    
    // Special items
    UnlockedItem(
      id: 'accessory_medal',
      nameEn: 'Gold Medal',
      nameAr: 'ميدالية ذهبية',
      type: ItemType.accessory,
      emoji: '🏅',
      position: Offset(0.5, 0.7),
      starsRequired: 40,
      unlockedAt: DateTime.now(),
    ),
    UnlockedItem(
      id: 'accessory_trophy',
      nameEn: 'Trophy',
      nameAr: 'كأس',
      type: ItemType.accessory,
      emoji: '🏆',
      position: Offset(0.5, 0.8),
      starsRequired: 50,
      unlockedAt: DateTime.now(),
    ),
  ];

  // Positive encouragement messages (NEVER negative)
  static final List<String> encouragementMessages = [
    'رائع! أنت تتحسن! 🌟',
    'قريب جداً! حاول مرة أخرى! 💪',
    'أنت تفعلها بشكل رائع! 🎯',
    'استمر! أنت على الطريق الصحيح! 🚀',
    'ممتاز! دعنا نحاول مرة أخرى! ⭐',
    'أنت ذكي جداً! 🧠',
    'تقريباً هناك! 🎨',
    'أحسنت! استمر! 🎪',
  ];

  static final List<String> successMessages = [
    'برافو {name}! 🎉',
    'ممتاز {name}! ⭐',
    'رائع {name}! 🌟',
    'أحسنت {name}! 👏',
    'عظيم {name}! 🎯',
    'مذهل {name}! 🚀',
    'فخور بك {name}! 💪',
    'أنت نجم {name}! ⭐',
  ];

  /// Handle correct answer - award star and check for treasure
  static Future<RewardResult> handleCorrectAnswer({
    required ChildProfile profile,
    required String childName,
  }) async {
    // Award star
    profile.stars++;
    profile.addAttempt(true);

    // Get success message
    String message = successMessages[Random().nextInt(successMessages.length)]
        .replaceAll('{name}', childName);

    // Check if treasure should be unlocked
    UnlockedItem? newItem;
    if (profile.stars % STARS_PER_TREASURE == 0) {
      newItem = getNextItem(profile);
      if (newItem != null) {
        profile.unlockedItems.add(newItem.id);
      }
    }

    return RewardResult(
      success: true,
      message: message,
      starsAwarded: 1,
      totalStars: profile.stars,
      newItem: newItem,
      shouldShowTreasure: newItem != null,
    );
  }

  /// Handle incorrect answer - provide encouragement (NEVER negative)
  static Future<RewardResult> handleIncorrectAnswer({
    required ChildProfile profile,
    required String childName,
  }) async {
    profile.addAttempt(false);

    // Get encouraging message
    String message =
        encouragementMessages[Random().nextInt(encouragementMessages.length)];

    return RewardResult(
      success: false,
      message: message,
      starsAwarded: 0,
      totalStars: profile.stars,
      newItem: null,
      shouldShowTreasure: false,
    );
  }

  /// Get next item to unlock based on stars
  static UnlockedItem? getNextItem(ChildProfile profile) {
    for (var item in availableItems) {
      if (item.starsRequired <= profile.stars &&
          !profile.unlockedItems.contains(item.id)) {
        return item;
      }
    }
    return null;
  }

  /// Get all unlocked items for profile
  static List<UnlockedItem> getUnlockedItems(ChildProfile profile) {
    return availableItems
        .where((item) => profile.unlockedItems.contains(item.id))
        .toList();
  }

  /// Get progress to next treasure
  static int getStarsToNextTreasure(int currentStars) {
    return STARS_PER_TREASURE - (currentStars % STARS_PER_TREASURE);
  }

  /// Show treasure chest animation
  static Future<void> showTreasureAnimation(
    BuildContext context,
    UnlockedItem item,
    String childName,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TreasureChestDialog(
        item: item,
        childName: childName,
      ),
    );
  }
}

class RewardResult {
  final bool success;
  final String message;
  final int starsAwarded;
  final int totalStars;
  final UnlockedItem? newItem;
  final bool shouldShowTreasure;

  RewardResult({
    required this.success,
    required this.message,
    required this.starsAwarded,
    required this.totalStars,
    this.newItem,
    required this.shouldShowTreasure,
  });
}

class TreasureChestDialog extends StatefulWidget {
  final UnlockedItem item;
  final String childName;

  const TreasureChestDialog({
    Key? key,
    required this.item,
    required this.childName,
  }) : super(key: key);

  @override
  State<TreasureChestDialog> createState() => _TreasureChestDialogState();
}

class _TreasureChestDialogState extends State<TreasureChestDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start animation
    Future.delayed(Duration(milliseconds: 500), () {
      _controller.forward();
      setState(() {
        _isOpen = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFD740),
              Color(0xFFFFC107),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Treasure chest
            Text(
              _isOpen ? '📦' : '🎁',
              style: TextStyle(fontSize: 100),
            ),

            SizedBox(height: 20),

            // Item reveal
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Text(
                      widget.item.emoji,
                      style: TextStyle(fontSize: 80),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 20),

            // Congratulations message
            Text(
              'مبروك ${widget.childName}! 🎉',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),

            SizedBox(height: 8),

            Text(
              'لقد حصلت على:',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              textDirection: TextDirection.rtl,
            ),

            SizedBox(height: 8),

            Text(
              widget.item.nameAr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textDirection: TextDirection.rtl,
            ),

            SizedBox(height: 24),

            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFFFFC107),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                'رائع! 🌟',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
