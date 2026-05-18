/// Missing Letter Game
/// 
/// A word building game where children complete words by selecting the missing letter.
/// Inspired by Antura's MissingLetter game.
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

class MissingLetterGame extends StatefulWidget {
  final String stageId;
  final List<String> targetLetters;
  final int targetScore;

  const MissingLetterGame({
    Key? key,
    required this.stageId,
    required this.targetLetters,
    this.targetScore = 8,
  }) : super(key: key);

  @override
  State<MissingLetterGame> createState() => _MissingLetterGameState();
}

class _MissingLetterGameState extends State<MissingLetterGame> {
  final Random _random = Random();
  final SoundManager _soundManager = SoundManager();
  
  late WordPuzzle _currentPuzzle;
  List<String> _letterOptions = [];
  int _score = 0;
  int _mistakes = 0;
  int _totalAttempts = 0;
  bool _isGameOver = false;
  String? _selectedLetter;
  
  // Simple Arabic words for the game
  static const List<Map<String, dynamic>> arabicWords = [
    {'word': 'كتاب', 'meaning': 'book'},
    {'word': 'قلم', 'meaning': 'pen'},
    {'word': 'بيت', 'meaning': 'house'},
    {'word': 'ولد', 'meaning': 'boy'},
    {'word': 'بنت', 'meaning': 'girl'},
    {'word': 'شمس', 'meaning': 'sun'},
    {'word': 'قمر', 'meaning': 'moon'},
    {'word': 'ماء', 'meaning': 'water'},
    {'word': 'نار', 'meaning': 'fire'},
    {'word': 'باب', 'meaning': 'door'},
    {'word': 'شباك', 'meaning': 'window'},
    {'word': 'كرسي', 'meaning': 'chair'},
    {'word': 'طاولة', 'meaning': 'table'},
    {'word': 'سيارة', 'meaning': 'car'},
    {'word': 'طائرة', 'meaning': 'plane'},
  ];
  
  static const List<String> arabicLetters = [
    'أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش',
    'ص', 'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'ه', 'و', 'ي'
  ];

  @override
  void initState() {
    super.initState();
    _startNewPuzzle();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _startNewPuzzle() {
    if (_isGameOver) return;
    
    setState(() {
      _selectedLetter = null;
      
      // Select a random word
      final wordData = arabicWords[_random.nextInt(arabicWords.length)];
      final word = wordData['word'] as String;
      final meaning = wordData['meaning'] as String;
      
      // Select a random position to hide
      final missingIndex = _random.nextInt(word.length);
      final missingLetter = word[missingIndex];
      
      // Play sound of the missing letter
      _soundManager.playLetterSound(missingLetter);
      
      // Create puzzle
      _currentPuzzle = WordPuzzle(
        word: word,
        meaning: meaning,
        missingIndex: missingIndex,
        missingLetter: missingLetter,
      );
      
      // Create letter options (correct + 3 wrong)
      _letterOptions = [missingLetter];
      
      while (_letterOptions.length < 4) {
        final randomLetter = arabicLetters[_random.nextInt(arabicLetters.length)];
        if (!_letterOptions.contains(randomLetter)) {
          _letterOptions.add(randomLetter);
        }
      }
      
      _letterOptions.shuffle(_random);
    });
  }

  void _onLetterSelect(String letter) {
    if (_isGameOver || _selectedLetter != null) return;
    
    setState(() {
      _selectedLetter = letter;
      _totalAttempts++;
      
      // Play letter sound
      _soundManager.playLetterSound(letter);
      
      if (letter == _currentPuzzle.missingLetter) {
        // Correct answer
        _score++;
        _soundManager.playCorrectAnswer();
        CelebrationUtils.showFloatingStars(context);
        
        // Move to next puzzle after delay
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (_score >= widget.targetScore) {
            _endGame(true);
          } else {
            _startNewPuzzle();
          }
        });
      } else {
        // Wrong answer
        _mistakes++;
        _soundManager.playSoundEffect(SoundEffect.buttonTap);
        
        // Reset after delay
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _selectedLetter = null;
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
          won ? 'ممتاز! 🎉' : 'حاول تاني',
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
      _isGameOver = false;
      _startNewPuzzle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              SmartinoColors.accent,
              SmartinoColors.accent.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              _buildTopBar(),
              
              const SizedBox(height: 20),
              
              // Instructions
              _buildInstructions(),
              
              const SizedBox(height: 30),
              
              // Word display
              _buildWordDisplay(),
              
              const SizedBox(height: 20),
              
              // Meaning hint
              _buildMeaningHint(),
              
              const Spacer(),
              
              // Letter options
              _buildLetterOptions(),
              
              const SizedBox(height: 40),
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

  Widget _buildInstructions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'اختار الحرف الناقص لإكمال الكلمة',
        style: SmartinoTypography.titleMedium.copyWith(
          color: SmartinoColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildWordDisplay() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_currentPuzzle.word.length, (index) {
          final isMissing = index == _currentPuzzle.missingIndex;
          final letter = isMissing
              ? (_selectedLetter ?? '_')
              : _currentPuzzle.word[index];
          
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: isMissing
                  ? (_selectedLetter != null
                      ? (_selectedLetter == _currentPuzzle.missingLetter
                          ? SmartinoColors.success.withOpacity(0.2)
                          : SmartinoColors.error.withOpacity(0.2))
                      : SmartinoColors.primary.withOpacity(0.1))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isMissing
                  ? Border.all(
                      color: SmartinoColors.primary,
                      width: 2,
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                letter,
                style: SmartinoTypography.displayMedium.copyWith(
                  color: isMissing
                      ? SmartinoColors.primary
                      : SmartinoColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    ).animate().scale(duration: 400.ms);
  }

  Widget _buildMeaningHint() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: SmartinoColors.warning,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'معناها: ${_currentPuzzle.meaning}',
            style: SmartinoTypography.bodyLarge.copyWith(
              color: SmartinoColors.textSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildLetterOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _letterOptions.map((letter) {
          final isSelected = letter == _selectedLetter;
          final isCorrect = letter == _currentPuzzle.missingLetter;
          
          return GestureDetector(
            onTap: () => _onLetterSelect(letter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: isSelected
                    ? (isCorrect ? SmartinoColors.success : SmartinoColors.error)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                  letter,
                  style: SmartinoTypography.displaySmall.copyWith(
                    color: isSelected ? Colors.white : SmartinoColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ).animate(
              target: isSelected && !isCorrect ? 1 : 0,
            ).shake(duration: 500.ms),
          );
        }).toList(),
      ),
    );
  }
}

class WordPuzzle {
  final String word;
  final String meaning;
  final int missingIndex;
  final String missingLetter;

  WordPuzzle({
    required this.word,
    required this.meaning,
    required this.missingIndex,
    required this.missingLetter,
  });
}
