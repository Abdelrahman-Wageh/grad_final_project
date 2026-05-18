/// Fast Crowd Game
/// 
/// A letter matching game where children select the correct letter from a crowd.
/// Inspired by Antura's FastCrowd game.
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

class FastCrowdGame extends StatefulWidget {
  final String stageId;
  final List<String> targetLetters;
  final int targetScore;

  const FastCrowdGame({
    Key? key,
    required this.stageId,
    required this.targetLetters,
    this.targetScore = 10,
  }) : super(key: key);

  @override
  State<FastCrowdGame> createState() => _FastCrowdGameState();
}

class _FastCrowdGameState extends State<FastCrowdGame>
    with TickerProviderStateMixin {
  final Random _random = Random();
  final SoundManager _soundManager = SoundManager();
  
  String _currentTargetLetter = '';
  List<LetterCard> _letterCards = [];
  int _score = 0;
  int _mistakes = 0;
  int _totalAttempts = 0;
  bool _isGameOver = false;
  int _currentRound = 0;
  
  late AnimationController _shakeController;
  
  // Arabic letters
  static const List<String> arabicLetters = [
    'أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش',
    'ص', 'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'ه', 'و', 'ي'
  ];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _startNewRound();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _startNewRound() {
    if (_isGameOver) return;
    
    setState(() {
      _currentRound++;
      _currentTargetLetter = widget.targetLetters[_random.nextInt(widget.targetLetters.length)];
      
      // Play target letter sound
      _soundManager.playLetterSound(_currentTargetLetter);
      
      // Create 6-9 letter cards
      final cardCount = 6 + _random.nextInt(4);
      _letterCards = [];
      
      // Add correct letter (1-3 times)
      final correctCount = 1 + _random.nextInt(3);
      for (int i = 0; i < correctCount; i++) {
        _letterCards.add(LetterCard(
          id: 'correct_$i',
          letter: _currentTargetLetter,
          isCorrect: true,
        ));
      }
      
      // Fill with wrong letters
      while (_letterCards.length < cardCount) {
        final wrongLetter = arabicLetters[_random.nextInt(arabicLetters.length)];
        if (wrongLetter != _currentTargetLetter) {
          _letterCards.add(LetterCard(
            id: 'wrong_${_letterCards.length}',
            letter: wrongLetter,
            isCorrect: false,
          ));
        }
      }
      
      // Shuffle
      _letterCards.shuffle(_random);
    });
  }

  void _onLetterTap(LetterCard card) {
    if (_isGameOver || card.isSelected) return;
    
    setState(() {
      _totalAttempts++;
      card.isSelected = true;
      
      if (card.isCorrect) {
        // Correct answer
        _score++;
        _soundManager.playCorrectAnswer();
        _soundManager.playLetterSound(card.letter);
        CelebrationUtils.showFloatingStars(context);
        
        // Check if all correct letters are found
        final allCorrectFound = _letterCards
            .where((c) => c.isCorrect)
            .every((c) => c.isSelected);
        
        if (allCorrectFound) {
          // Move to next round after delay
          Future.delayed(const Duration(milliseconds: 800), () {
            if (_score >= widget.targetScore) {
              _endGame(true);
            } else {
              _startNewRound();
            }
          });
        }
      } else {
        // Wrong answer
        _mistakes++;
        _soundManager.playSoundEffect(SoundEffect.buttonTap);
        _shakeController.forward(from: 0);
        
        // Reset selection after delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              card.isSelected = false;
            });
          }
        });
      }
    });
  }

  void _endGame(bool won) {
    setState(() {
      _isGameOver = true;
    });
    
    if (won) {
      CelebrationUtils.showCelebration(context);
      _soundManager.playSoundEffect(SoundEffect.celebration);
    }
    
    final accuracy = _totalAttempts > 0 ? (_score / _totalAttempts * 100) : 0;
    final stars = ProgressionManager.calculateStars(
      correctAnswers: _score,
      totalQuestions: _totalAttempts,
      mistakes: _totalAttempts - _score,
      timeTaken: Duration(seconds: 0), // Add actual time tracking if needed
    );
    
    _showResultsDialog(won, accuracy.toInt(), stars);
  }

  void _showResultsDialog(bool won, int accuracy, int stars) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          won ? 'رائع! 🎉' : 'حاول تاني',
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
              Navigator.of(context).pop();
              Navigator.of(context).pop();
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
      _score = 0;
      _mistakes = 0;
      _totalAttempts = 0;
      _currentRound = 0;
      _isGameOver = false;
      _startNewRound();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              SmartinoColors.primary,
              SmartinoColors.accent,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              _buildTopBar(),
              
              // Target letter display
              _buildTargetDisplay(),
              
              // Letter cards grid
              Expanded(
                child: _buildLetterGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Spacer(),
          _buildStatItem(Icons.star, '$_score / ${widget.targetScore}', SmartinoColors.gold),
          const SizedBox(width: 16),
          _buildStatItem(Icons.close, '$_mistakes', SmartinoColors.error),
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
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTargetDisplay() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'اختار كل الحروف:',
            style: SmartinoTypography.titleLarge.copyWith(
              color: SmartinoColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _currentTargetLetter,
            style: SmartinoTypography.displayLarge.copyWith(
              color: SmartinoColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 56,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale(delay: 100.ms);
  }

  Widget _buildLetterGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: _letterCards.length,
      itemBuilder: (context, index) {
        return _buildLetterCard(_letterCards[index], index);
      },
    );
  }

  Widget _buildLetterCard(LetterCard card, int index) {
    return GestureDetector(
      onTap: () => _onLetterTap(card),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: card.isSelected
              ? (card.isCorrect ? SmartinoColors.success : SmartinoColors.error)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            card.letter,
            style: SmartinoTypography.displayMedium.copyWith(
              color: card.isSelected ? Colors.white : SmartinoColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ).animate(
        target: card.isSelected && !card.isCorrect ? 1 : 0,
      ).shake(duration: 500.ms),
    ).animate().scale(delay: (index * 50).ms);
  }
}

class LetterCard {
  final String id;
  final String letter;
  final bool isCorrect;
  bool isSelected;

  LetterCard({
    required this.id,
    required this.letter,
    required this.isCorrect,
    this.isSelected = false,
  });
}
