import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:vibration/vibration.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animated_button.dart';
import '../../data/curriculum/curriculum_data.dart';
import 'dart:math';

/// Chapter 1: City of Lost Colors - Complete Game Implementation
/// Child Psychology: Positive reinforcement, immediate feedback, visual rewards
/// 
/// Stage 1: Vocabulary - Learn basic colors
/// Stage 2: Sentences - Form simple color sentences
/// Stage 3: Cumulative - Combine colors with objects
class ColorLearningGame extends StatefulWidget {
  final String childName;
  final int currentStage;

  const ColorLearningGame({
    Key? key,
    required this.childName,
    this.currentStage = 1,
  }) : super(key: key);

  @override
  State<ColorLearningGame> createState() => _ColorLearningGameState();
}

class _ColorLearningGameState extends State<ColorLearningGame>
    with TickerProviderStateMixin {
  late AnimationController _mascotController;
  late AnimationController _objectController;
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _currentStage = 1;
  int _stars = 0;
  int _currentItemIndex = 0;
  bool _isListening = false;
  String _feedback = '';
  Color _currentColor = Colors.grey;
  String _currentObject = '⚽';

  // Get stage data from curriculum
  late List<Map<String, dynamic>> _stageItems;
  late String _stageType;
  
  final Map<String, String> _objectEmojis = {
    'ball': '⚽',
    'car': '🚗',
    'tree': '🌳',
    'sun': '☀️',
    'apple': '🍎',
    'star': '⭐',
  };

  @override
  void initState() {
    super.initState();
    _currentStage = widget.currentStage;
    
    _mascotController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _objectController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _confettiController = ConfettiController(
      duration: Duration(seconds: 2),
    );

    _loadStageData();
    _currentColor = Colors.grey;
    _speakIntroduction();
  }
  
  void _loadStageData() {
    // TODO: These games need proper data structures
    // For now, using placeholder data
    _stageType = 'vocabulary';
    
    // Placeholder data - replace with actual game data
    _stageItems = [
      {'ar': 'أحمر', 'en': 'Red', 'color': 0xFFFF5252},
      {'ar': 'أزرق', 'en': 'Blue', 'color': 0xFF448AFF},
      {'ar': 'أخضر', 'en': 'Green', 'color': 0xFF69F0AE},
      {'ar': 'أصفر', 'en': 'Yellow', 'color': 0xFFFFD740},
    ];
  }

  @override
  void dispose() {
    _mascotController.dispose();
    _objectController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _speakIntroduction() async {
    await Future.delayed(Duration(milliseconds: 500));
    String message;
    switch (_currentStage) {
      case 1:
        message = 'مرحباً ${widget.childName}! ساعدني في إيجاد الألوان المفقودة!';
        break;
      case 2:
        message = 'رائع ${widget.childName}! الآن دعنا نتعلم جمل الألوان!';
        break;
      case 3:
        message = 'ممتاز ${widget.childName}! الآن دعنا نجمع الألوان مع الأشياء!';
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

    // Update visual based on stage type
    if (_stageType == 'vocabulary' || _stageType == 'sentences') {
      setState(() {
        _currentColor = Color(itemData['color'] ?? 0xFFFF5252);
      });
    } else if (_stageType == 'cumulative') {
      setState(() {
        _currentColor = _getColorFromName(itemData['color']);
        _currentObject = _objectEmojis[itemData['object']] ?? '⚽';
      });
    }

    // Animate object filling with color
    _objectController.forward();

    // Play success sound (with error handling for missing asset)
    try {
      await _audioPlayer.play(AssetSource('sounds/sfx/correct.mp3'));
    } catch (e) {
      // Sound file not found, continue without sound
    }

    // Haptic feedback
    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 100);
      }
    } catch (e) {
      // Vibration not supported, continue without haptic
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
        _currentColor = Colors.grey;
        _isListening = false;
      });
      _objectController.reset();
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
        return Colors.grey;
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
                  ? 'لقد أكملت مدينة الألوان المفقودة!' 
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
                    // Move to next stage
                    setState(() {
                      _currentStage++;
                      _currentItemIndex = 0;
                      _stars = 0;
                      _currentColor = Colors.grey;
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
                  Color(0xFFE3F2FD),
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
                                '🦊',
                                style: TextStyle(fontSize: 120),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Object display area
                Expanded(
                  flex: 2,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _objectController,
                      builder: (context, child) {
                        return Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Color.lerp(
                              Colors.grey.withOpacity(0.3),
                              _currentColor,
                              _objectController.value,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _currentColor.withOpacity(
                                  0.5 * _objectController.value,
                                ),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _currentObject,
                              style: TextStyle(fontSize: 100),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Item selection buttons (dynamic based on stage)
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _stageItems.length,
                      itemBuilder: (context, index) {
                        final itemData = _stageItems[index];
                        final isCurrentItem = index == _currentItemIndex;
                        
                        Color itemColor;
                        if (_stageType == 'vocabulary' || _stageType == 'sentences') {
                          itemColor = Color(itemData['color'] ?? 0xFFFF5252);
                        } else {
                          itemColor = _getColorFromName(itemData['color']);
                        }

                        return GestureDetector(
                          onTap: isCurrentItem
                              ? () => _handleItemTap(itemData)
                              : null,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: itemColor,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isCurrentItem
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: itemColor.withOpacity(0.5),
                                  blurRadius: isCurrentItem ? 20 : 10,
                                  spreadRadius: isCurrentItem ? 5 : 0,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_stageType == 'cumulative')
                                    Text(
                                      _objectEmojis[itemData['object']] ?? '⚽',
                                      style: TextStyle(fontSize: 40),
                                    ),
                                  SizedBox(height: 8),
                                  Text(
                                    itemData['en'],
                                    style: TextStyle(
                                      fontSize: _stageType == 'sentences' ? 16 : 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    itemData['ar'],
                                    style: TextStyle(
                                      fontSize: _stageType == 'sentences' ? 14 : 18,
                                      color: Colors.white,
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
}
