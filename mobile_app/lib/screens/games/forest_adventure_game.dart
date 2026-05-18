import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:vibration/vibration.dart';
import '../../theme/app_theme.dart';
import 'dart:math';

/// Forest Adventure Exploration Game - Objective-based exploration
/// Child Psychology: Discovery learning, exploration, achievement
class ForestAdventureGame extends StatefulWidget {
  final String childName;

  const ForestAdventureGame({
    Key? key,
    required this.childName,
  }) : super(key: key);

  @override
  State<ForestAdventureGame> createState() => _ForestAdventureGameState();
}

class _ForestAdventureGameState extends State<ForestAdventureGame>
    with TickerProviderStateMixin {
  late AnimationController _mascotController;
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _stars = 0;
  int _completedObjectives = 0;
  String _feedback = '';
  Set<String> _discoveredItems = {};
  
  final List<ForestObject> _forestObjects = [
    ForestObject(
      id: 'tree1',
      emoji: '🌳',
      nameAr: 'شجرة كبيرة',
      nameEn: 'Big Tree',
      x: 0.2,
      y: 0.3,
      reward: 'أوراق خضراء',
      rewardEmoji: '🍃',
    ),
    ForestObject(
      id: 'flower1',
      emoji: '🌸',
      nameAr: 'زهرة جميلة',
      nameEn: 'Beautiful Flower',
      x: 0.7,
      y: 0.4,
      reward: 'رحيق حلو',
      rewardEmoji: '🍯',
    ),
    ForestObject(
      id: 'mushroom1',
      emoji: '🍄',
      nameAr: 'فطر سحري',
      nameEn: 'Magic Mushroom',
      x: 0.5,
      y: 0.6,
      reward: 'غبار سحري',
      rewardEmoji: '✨',
    ),
    ForestObject(
      id: 'butterfly1',
      emoji: '🦋',
      nameAr: 'فراشة ملونة',
      nameEn: 'Colorful Butterfly',
      x: 0.3,
      y: 0.2,
      reward: 'أجنحة ملونة',
      rewardEmoji: '🌈',
    ),
    ForestObject(
      id: 'bird1',
      emoji: '🐦',
      nameAr: 'عصفور مغرد',
      nameEn: 'Singing Bird',
      x: 0.8,
      y: 0.25,
      reward: 'أغنية جميلة',
      rewardEmoji: '🎵',
    ),
    ForestObject(
      id: 'rabbit1',
      emoji: '🐰',
      nameAr: 'أرنب سريع',
      nameEn: 'Fast Rabbit',
      x: 0.6,
      y: 0.7,
      reward: 'جزرة برتقالية',
      rewardEmoji: '🥕',
    ),
    ForestObject(
      id: 'treasure1',
      emoji: '💎',
      nameAr: 'كنز مخفي',
      nameEn: 'Hidden Treasure',
      x: 0.4,
      y: 0.8,
      reward: 'جوهرة نادرة',
      rewardEmoji: '💎',
    ),
    ForestObject(
      id: 'fountain1',
      emoji: '⛲',
      nameAr: 'نافورة سحرية',
      nameEn: 'Magic Fountain',
      x: 0.5,
      y: 0.5,
      reward: 'ماء سحري',
      rewardEmoji: '💧',
    ),
  ];

  final List<Quest> _quests = [
    Quest(
      id: 'find_tree',
      titleAr: 'ابحث عن الشجرة الكبيرة',
      titleEn: 'Find the Big Tree',
      targetId: 'tree1',
      rewardStars: 2,
    ),
    Quest(
      id: 'find_flower',
      titleAr: 'اكتشف الزهرة الجميلة',
      titleEn: 'Discover the Beautiful Flower',
      targetId: 'flower1',
      rewardStars: 2,
    ),
    Quest(
      id: 'find_mushroom',
      titleAr: 'اعثر على الفطر السحري',
      titleEn: 'Find the Magic Mushroom',
      targetId: 'mushroom1',
      rewardStars: 2,
    ),
    Quest(
      id: 'find_butterfly',
      titleAr: 'اصطد الفراشة الملونة',
      titleEn: 'Catch the Colorful Butterfly',
      targetId: 'butterfly1',
      rewardStars: 3,
    ),
    Quest(
      id: 'find_treasure',
      titleAr: 'اكتشف الكنز المخفي',
      titleEn: 'Discover the Hidden Treasure',
      targetId: 'treasure1',
      rewardStars: 5,
    ),
  ];

  int _currentQuestIndex = 0;

  @override
  void initState() {
    super.initState();
    
    _mascotController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _confettiController = ConfettiController(
      duration: Duration(seconds: 2),
    );

    _speakIntroduction();
  }

  @override
  void dispose() {
    _mascotController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _speakIntroduction() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _feedback = 'مرحباً ${widget.childName}! دعنا نستكشف الغابة السحرية!';
    });
  }

  void _handleObjectTap(ForestObject object) async {
    if (_discoveredItems.contains(object.id)) {
      setState(() {
        _feedback = 'لقد اكتشفت هذا من قبل!';
      });
      return;
    }

    // Mark as discovered
    setState(() {
      _discoveredItems.add(object.id);
    });

    // Check if this completes current quest
    if (_currentQuestIndex < _quests.length) {
      final currentQuest = _quests[_currentQuestIndex];
      if (currentQuest.targetId == object.id) {
        // Quest completed!
        try {
          await _audioPlayer.play(AssetSource('sounds/sfx/correct.mp3'));
        } catch (e) {}

        try {
          if (await Vibration.hasVibrator() ?? false) {
            Vibration.vibrate(duration: 100);
          }
        } catch (e) {}

        setState(() {
          _stars += currentQuest.rewardStars;
          _completedObjectives++;
          _feedback = 'رائع ${widget.childName}! وجدت ${object.nameAr}! حصلت على ${object.rewardEmoji} ${object.reward}!';
        });

        _confettiController.play();

        await Future.delayed(Duration(seconds: 2));

        if (_currentQuestIndex < _quests.length - 1) {
          setState(() {
            _currentQuestIndex++;
            _feedback = _quests[_currentQuestIndex].titleAr;
          });
        } else {
          _showCompletionDialog();
        }
      } else {
        // Found something but not the quest target
        setState(() {
          _feedback = 'وجدت ${object.nameAr}! لكن ابحث عن ${_quests[_currentQuestIndex].titleAr}';
        });
      }
    } else {
      // Free exploration after quests
      setState(() {
        _feedback = 'اكتشفت ${object.nameAr}! ${object.rewardEmoji}';
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: AppTheme.magicalGradient,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🎉',
                style: TextStyle(fontSize: 80),
              ).animate().scale(duration: 500.ms),
              SizedBox(height: 16),
              Text(
                'رائع ${widget.childName}!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 8),
              Text(
                'لقد أكملت جميع المهام في الغابة السحرية!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: AppTheme.sunnyYellow, size: 40),
                  SizedBox(width: 8),
                  Text(
                    '$_stars',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'اكتشفت ${_discoveredItems.length} من ${_forestObjects.length} أشياء!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.sunnyYellow,
                  foregroundColor: AppTheme.textDark,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'إنهاء',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF87CEEB),
                  Color(0xFF98D8C8),
                  Color(0xFF6BCF7F),
                ],
              ),
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: [
                AppTheme.magicalPurple,
                AppTheme.sunnyYellow,
                AppTheme.leafGreen,
                Colors.red,
                Colors.blue,
              ],
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header with stars and objectives
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 32, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: AppTheme.leafGreen,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '$_completedObjectives/${_quests.length}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: AppTheme.sunnyYellow,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '$_stars',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).animate().fadeIn().scale(),
                    ],
                  ),
                ),

                // Current quest display
                if (_currentQuestIndex < _quests.length)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.explore,
                          color: AppTheme.magicalPurple,
                          size: 32,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _quests[_currentQuestIndex].titleAr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: -0.2),

                SizedBox(height: 16),

                // Forest exploration area
                Expanded(
                  child: Stack(
                    children: [
                      // Forest objects
                      ..._forestObjects.map((object) {
                        final isDiscovered = _discoveredItems.contains(object.id);
                        return Positioned(
                          left: object.x * screenSize.width - 40,
                          top: object.y * (screenSize.height * 0.6) - 40,
                          child: GestureDetector(
                            onTap: () => _handleObjectTap(object),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: isDiscovered
                                    ? Colors.white.withOpacity(0.3)
                                    : Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: isDiscovered
                                        ? Colors.green.withOpacity(0.5)
                                        : Colors.black.withOpacity(0.2),
                                    blurRadius: isDiscovered ? 20 : 10,
                                    spreadRadius: isDiscovered ? 5 : 0,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  object.emoji,
                                  style: TextStyle(
                                    fontSize: 50,
                                    color: isDiscovered
                                        ? Colors.white.withOpacity(0.5)
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ).animate(
                              onPlay: (controller) => controller.repeat(),
                            ).scale(
                              begin: Offset(1, 1),
                              end: Offset(1.1, 1.1),
                              duration: 1500.ms,
                              curve: Curves.easeInOut,
                            ).then().scale(
                              begin: Offset(1.1, 1.1),
                              end: Offset(1, 1),
                              duration: 1500.ms,
                              curve: Curves.easeInOut,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),

                // Feedback area
                Container(
                  margin: EdgeInsets.all(24),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    _feedback,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ).animate().fadeIn().slideY(begin: 0.2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Data models
class ForestObject {
  final String id;
  final String emoji;
  final String nameAr;
  final String nameEn;
  final double x; // 0.0 to 1.0
  final double y; // 0.0 to 1.0
  final String reward;
  final String rewardEmoji;

  ForestObject({
    required this.id,
    required this.emoji,
    required this.nameAr,
    required this.nameEn,
    required this.x,
    required this.y,
    required this.reward,
    required this.rewardEmoji,
  });
}

class Quest {
  final String id;
  final String titleAr;
  final String titleEn;
  final String targetId;
  final int rewardStars;

  Quest({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.targetId,
    required this.rewardStars,
  });
}
