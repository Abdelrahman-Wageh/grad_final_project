/// Letter Balloons Game
/// 
/// A simple letter recognition game inspired by Antura's Balloons game.
/// Children tap balloons with the correct letter.
/// 
/// Implements Requirements: Phase 4 - Antura Games Migration

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/smartino_colors.dart';
import '../../theme/smartino_typography.dart';
import '../../widgets/common/smartino_button.dart';
import '../../utils/celebration_utils.dart';
import '../../core/game/progression_manager.dart';
import '../../services/sound_manager.dart';

class LetterBalloonsGame extends StatefulWidget {
  final String stageId;
  final List<String> targetLetters;
  final int targetScore;

  const LetterBalloonsGame({
    Key? key,
    required this.stageId,
    required this.targetLetters,
    this.targetScore = 10,
  }) : super(key: key);

  @override
  State<LetterBalloonsGame> createState() => _LetterBalloonsGameState();
}

class _LetterBalloonsGameState extends State<LetterBalloonsGame>
    with TickerProviderStateMixin {
  final Random _random = Random();
  final SoundManager _soundManager = SoundManager();
  
  List<Balloon> _balloons = [];
  String _currentTargetLetter = '';
  int _score = 0;
  int _mistakes = 0;
  int _totalAttempts = 0;
  bool _isGameOver = false;
  
  late AnimationController _spawnController;
  
  // Arabic letters for the game
  static const List<String> arabicLetters = [
    'أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش',
    'ص', 'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'ه', 'و', 'ي'
  ];

  @override
  void initState() {
    super.initState();
    _currentTargetLetter = widget.targetLetters[0];
    _spawnController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    _spawnController.addListener(_spawnBalloons);
    
    // Play the target letter sound at start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _soundManager.playLetterSound(_currentTargetLetter);
    });
  }

  @override
  void dispose() {
    _spawnController.dispose();
    super.dispose();
  }

  void _spawnBalloons() {
    if (_isGameOver) return;
    
    // Spawn a new balloon every 2 seconds
    if (_spawnController.value < 0.1 && _balloons.length < 5) {
      setState(() {
        // 70% chance of correct letter, 30% chance of wrong letter
        final isCorrect = _random.nextDouble() < 0.7;
        final letter = isCorrect
            ? _currentTargetLetter
            : arabicLetters[_random.nextInt(arabicLetters.length)];
        
        _balloons.add(Balloon(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          letter: letter,
          isCorrect: letter == _currentTargetLetter,
          x: _random.nextDouble() * 0.8 + 0.1, // 10-90% of screen width
          y: 1.2, // Start below screen
          color: _getRandomColor(),
        ));
      });
    }
    
    // Move balloons up
    setState(() {
      _balloons = _balloons.map((balloon) {
        return balloon.copyWith(y: balloon.y - 0.01);
      }).where((balloon) => balloon.y > -0.2).toList(); // Remove balloons that went off screen
    });
  }

  Color _getRandomColor() {
    final colors = [
      SmartinoColors.primary,
      SmartinoColors.accent,
      SmartinoColors.success,
      SmartinoColors.warning,
      Colors.purple,
      Colors.pink,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  void _onBalloonTap(Balloon balloon) {
    if (_isGameOver) return;
    
    setState(() {
      _totalAttempts++;
      
      if (balloon.isCorrect) {
        // Correct answer
        _score++;
        _soundManager.playCorrectAnswer();
        _soundManager.playLetterSound(balloon.letter);
        CelebrationUtils.showFloatingStars(context);
        
        // Remove the tapped balloon
        _balloons.removeWhere((b) => b.id == balloon.id);
        
        // Check if game is won
        if (_score >= widget.targetScore) {
          _endGame(true);
        }
      } else {
        // Wrong answer
        _mistakes++;
        _soundManager.playSoundEffect(SoundEffect.buttonTap);
        
        // Shake the balloon
        // (Animation would be added here)
      }
    });
  }

  void _endGame(bool won) {
    setState(() {
      _isGameOver = true;
      _spawnController.stop();
    });
    
    if (won) {
      CelebrationUtils.showCelebration(context);
      _soundManager.playSoundEffect(SoundEffect.celebration);
    }
    
    // Calculate accuracy and stars
    final accuracy = _totalAttempts > 0 ? (_score / _totalAttempts * 100) : 0;
    final stars = ProgressionManager.calculateStars(
      correctAnswers: _score,
      totalQuestions: _totalAttempts,
      mistakes: _totalAttempts - _score,
      timeTaken: Duration(seconds: 0), // Add actual time tracking if needed
    );
    
    // Show results dialog
    _showResultsDialog(won, accuracy.toInt(), stars);
  }

  void _showResultsDialog(bool won, int accuracy, int stars) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          won ? 'أحسنت! 🎉' : 'حاول مرة أخرى',
          style: SmartinoTypography.displaySmall.copyWith(
            color: won ? SmartinoColors.success : SmartinoColors.warning,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'النتيجة: $_score / ${widget.targetScore}',
              style: SmartinoTypography.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'الدقة: $accuracy%',
              style: SmartinoTypography.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  index < stars ? Icons.star : Icons.star_border,
                  color: SmartinoColors.gold,
                  size: 40,
                );
              }),
            ),
          ],
        ),
        actions: [
          SmartinoButton(
            text: 'العودة',
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close game
            },
            type: SmartinoButtonType.secondary,
          ),
          if (!won)
            SmartinoButton(
              text: 'إعادة المحاولة',
              onPressed: () {
                Navigator.of(context).pop();
                _restartGame();
              },
            ),
        ],
      ),
    );
  }

  void _restartGame() {
    setState(() {
      _balloons.clear();
      _score = 0;
      _mistakes = 0;
      _totalAttempts = 0;
      _isGameOver = false;
      _spawnController.repeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              SmartinoColors.skyBlue,
              SmartinoColors.skyBlue.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Game area
              Positioned.fill(
                child: Stack(
                  children: _balloons.map((balloon) {
                    return Positioned(
                      left: balloon.x * size.width - 40,
                      top: balloon.y * size.height - 40,
                      child: GestureDetector(
                        onTap: () => _onBalloonTap(balloon),
                        child: _buildBalloon(balloon),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              // Top bar
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: _buildTopBar(),
              ),
              
              // Target letter display
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: _buildTargetDisplay(),
              ),
              
              // Back button
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalloon(Balloon balloon) {
    return Container(
      width: 80,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Balloon body
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: balloon.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                balloon.letter,
                style: SmartinoTypography.displayLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Balloon string
          Positioned(
            bottom: 0,
            child: Container(
              width: 2,
              height: 20,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    ).animate().scale(duration: 300.ms);
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.star, '$_score / ${widget.targetScore}', SmartinoColors.gold),
          _buildStatItem(Icons.close, '$_mistakes', SmartinoColors.error),
          _buildStatItem(Icons.check_circle, '${(_totalAttempts > 0 ? (_score / _totalAttempts * 100).toInt() : 0)}%', SmartinoColors.success),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          text,
          style: SmartinoTypography.titleSmall.copyWith(
            color: SmartinoColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTargetDisplay() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'اضغط على البالونات التي تحتوي على:',
            style: SmartinoTypography.bodyLarge.copyWith(
              color: SmartinoColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _currentTargetLetter,
            style: SmartinoTypography.displayLarge.copyWith(
              color: SmartinoColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 48,
            ),
          ),
        ],
      ),
    );
  }
}

class Balloon {
  final String id;
  final String letter;
  final bool isCorrect;
  final double x; // 0-1 (percentage of screen width)
  final double y; // 0-1 (percentage of screen height)
  final Color color;

  Balloon({
    required this.id,
    required this.letter,
    required this.isCorrect,
    required this.x,
    required this.y,
    required this.color,
  });

  Balloon copyWith({
    String? id,
    String? letter,
    bool? isCorrect,
    double? x,
    double? y,
    Color? color,
  }) {
    return Balloon(
      id: id ?? this.id,
      letter: letter ?? this.letter,
      isCorrect: isCorrect ?? this.isCorrect,
      x: x ?? this.x,
      y: y ?? this.y,
      color: color ?? this.color,
    );
  }
}
