import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:vibration/vibration.dart';
import '../../theme/app_theme.dart';
import '../../data/curriculum/curriculum_data.dart';
import 'dart:math';

/// Chapter 3: Magic Numbers Castle - Complete Game Implementation
/// Child Psychology: Positive reinforcement, visual counting, cumulative learning
/// 
/// Stage 1: Vocabulary - Learn numbers 1-10
/// Stage 2: Sentences - Form number sentences
/// Stage 3: Cumulative - Count colored objects
class NumberLearningGame extends StatefulWidget {
  final String childName;
  final int currentStage;

  const NumberLearningGame({
    Key? key,
    required this.childName,
    this.currentStage = 1,
  }) : super(key: key);

  @override
  State<NumberLearningGame> createState() => _NumberLearningGameState();
}

class _NumberLearningGameState extends State<NumberLearningGame>
    with TickerProviderStateMixin {
  late AnimationController _mascotController;
  late AnimationController _countController;
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _currentStage = 1;
  int _stars = 0;
  int _currentItemIndex = 0;
  bool _isListening = false;
  String _feedback = '';
  int _displayCount = 0;

  late List<Map<String, dynamic>> _stageItems;
  late String _stageType;
  
  final Map<String, String> _objectEmojis = {
    'apple': '🍎',
    'car': '🚗',
    'star': '⭐',
    'tree': '🌳',
    'ball': '⚽',
    'flower': '🌸',
  };

  @override
  void initState() {
    super.initState();
    _currentStage = widget.currentStage;
    
    _mascotController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _countController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _confettiController = ConfettiController(
      duration: Duration(seconds: 2),
    );

    _loadStageData();
    _speakIntroduction();
  }
  
  void _loadStageData() {
    final chapter3 = CurriculumData.chapter3;
    final stages = chapter3['stages'] as List;
    final stageData = stages[_currentStage - 1];
    
    _stageType = stageData['type'];
    
    switch (_stageType) {
      case 'vocabulary':
        _stageItems = (stageData['words'] as List).cast<Map<String, dynamic>>();
        break;
      case 'sentences':
        _stageItems = (stageData['sentences'] as List).cast<Map<String, dynamic>>();
        break;
      case 'cumulative':
        _stageItems = (stageData['combinations'] as List).cast<Map<String, dynamic>>();
        break;
    }
  }

  @override
  void dispose() {
    _mascotController.dispose();
    _countController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _speakIntroduction() async {
    await Future.delayed(Duration(milliseconds: 500));
    String message;
    switch (_currentStage) {
      case 1:
        message = 'مرحباً ${widget.childName}! دعنا نتعلم الأرقام السحرية!';
        break;
      case 2:
        message = 'رائع ${widget.childName}! الآن دعنا نتعلم جمل الأرقام!';
        break;
      case 3:
        message = 'ممتاز ${widget.childName}! الآن دعنا نعد الأشياء الملونة!';
        break;
      default:
        message = 'مرحباً ${widget.childName}!';
    }
    setState(() {
      _feedback = message;
    });
  }

  void _handleItemTap(Map<String, dynamic> itemData) async {
    if (_isListening) return;

    setState(() {
      _isListening = true;
    });

    // Update display count
    if (_stageType == 'vocabulary') {
      setState(() {
        _displayCount = itemData['value'];
      });
    } else if (_stageType == 'cumulative') {
      setState(() {
        _displayCount = itemData['count'];
      });
    }

    // Animate counting
    _countController.forward(from: 0);

    // Play success sound
    try {
      await _audioPlayer.play(AssetSource('sounds/sfx/correct.mp3'));
    } catch (e) {
      // Sound file not found
    }

    // Haptic feedback
    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 100);
      }
    } catch (e) {
      // Vibration not supported
    }

    // Award star
    setState(() {
      _stars++;
      _feedback = 'برافو ${widget.childName}! ${itemData['ar']}!';
    });

    // Show confetti
    _confettiController.play();

    // Wait and move to next item
    await Future.delayed(Duration(seconds: 2));

    if (_currentItemIndex < _stageItems.length - 1) {
      setState(() {
        _currentItemIndex++;
        _displayCount = 0;
        _isListening = false;
      });
      _countController.reset();
    } else {
      _showStageCompletionDialog();
    }
  }
  
  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Color(0xFFFF5252);
      case 'blue':
        return Color(0xFF448AFF);
      case 'green':
        return Color(0xFF69F0AE);
      case 'yellow':
        return Color(0xFFFFD740);
      default:
        return AppTheme.magicalPurple;
    }
  }

  void _showStageCompletionDialog() {
    final isLastStage = _currentStage >= 3;
    
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
                isLastStage 
                  ? 'لقد أكملت قلعة الأرقام السحرية!' 
                  : 'لقد أكملت المرحلة $_currentStage!',
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
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (isLastStage) {
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      _currentStage++;
                      _currentItemIndex = 0;
                      _stars = 0;
                      _displayCount = 0;
                      _loadStageData();
                      _speakIntroduction();
                    });
                  }
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
                  isLastStage ? 'إنهاء' : 'المرحلة التالية',
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
                  Color(0xFFE8EAF6),
                  Color(0xFFFFF9C4),
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
                // Header with stars
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 32),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
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
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '$_stars',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().scale(),
                    ],
                  ),
                ),

                // Mascot with speech bubble
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Speech bubble
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 32),
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
                        ).animate().fadeIn().slideY(begin: -0.2),

                        SizedBox(height: 20),

                        // Animated mascot
                        AnimatedBuilder(
                          animation: _mascotController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + (_mascotController.value * 0.05),
                              child: Text(
                                '🧙‍♂️',
                                style: TextStyle(fontSize: 120),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Visual counting display
                Expanded(
                  flex: 2,
                  child: Center(
                    child: _buildCountingDisplay(),
                  ),
                ),

                // Number selection buttons
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _stageType == 'vocabulary' ? 5 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _stageItems.length,
                      itemBuilder: (context, index) {
                        final itemData = _stageItems[index];
                        final isCurrentItem = index == _currentItemIndex;
                        
                        return GestureDetector(
                          onTap: isCurrentItem
                              ? () => _handleItemTap(itemData)
                              : null,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.magicalPurple,
                                  AppTheme.magicalPurpleLight,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isCurrentItem
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.magicalPurple.withOpacity(0.5),
                                  blurRadius: isCurrentItem ? 20 : 10,
                                  spreadRadius: isCurrentItem ? 5 : 0,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_stageType == 'vocabulary')
                                    Text(
                                      itemData['value'].toString(),
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  else if (_stageType == 'cumulative')
                                    Text(
                                      _objectEmojis[itemData['object']] ?? '⚽',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  SizedBox(height: 4),
                                  Text(
                                    itemData['ar'],
                                    style: TextStyle(
                                      fontSize: _stageType == 'sentences' ? 14 : 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                ],
                              ),
                            ),
                          ).animate(
                            target: isCurrentItem ? 1 : 0,
                          ).scale(
                            duration: 300.ms,
                            begin: Offset(1, 1),
                            end: Offset(1.1, 1.1),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountingDisplay() {
    if (_displayCount == 0) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 3,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Text(
            '?',
            style: TextStyle(
              fontSize: 80,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // Display objects based on count
    String displayObject = '⭐';
    Color displayColor = AppTheme.sunnyYellow;
    
    if (_stageType == 'cumulative' && _currentItemIndex < _stageItems.length) {
      final currentItem = _stageItems[_currentItemIndex];
      displayObject = _objectEmojis[currentItem['object']] ?? '⭐';
      displayColor = _getColorFromName(currentItem['color']);
    }

    return AnimatedBuilder(
      animation: _countController,
      builder: (context, child) {
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: List.generate(
            _displayCount,
            (index) => Transform.scale(
              scale: _countController.value,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: displayColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    displayObject,
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
