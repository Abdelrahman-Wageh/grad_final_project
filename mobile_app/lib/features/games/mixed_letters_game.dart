/// Mixed Letters Game
/// 
/// A word unscrambling game where children arrange letters to form words.
/// Inspired by Antura's MixedLetters game.
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

class MixedLettersGame extends StatefulWidget {
  final String stageId;
  final List<String> targetLetters;
  final int targetScore;

  const MixedLettersGame({
    Key? key,
    required this.stageId,
    required this.targetLetters,
    this.targetScore = 8,
  }) : super(key: key);

  @override
  State<MixedLettersGame> createState() => _MixedLettersGameState();
}

class _MixedLettersGameState extends State<MixedLettersGame> {
  final Random _random = Random();
  final SoundManager _soundManager = SoundManager();
  
  late String _targetWord;
  late String _wordMeaning;
  List<LetterTile> _mixedLetters = [];
  List<LetterTile?> _answerSlots = [];
  int _score = 0;
  int _mistakes = 0;
  int _totalAttempts = 0;
  bool _isGameOver = false;
  bool _isChecking = false;
  
  // Simple Arabic words
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
    {'word': 'سيارة', 'meaning': 'car'},
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
      _isChecking = false;
      
      // Select random word
      final wordData = arabicWords[_random.nextInt(arabicWords.length)];
      _targetWord = wordData['word'] as String;
      _wordMeaning = wordData['meaning'] as String;
      
      // Create letter tiles
      _mixedLetters = [];
      for (int i = 0; i < _targetWord.length; i++) {
        _mixedLetters.add(LetterTile(
          id: 'letter_$i',
          letter: _targetWord[i],
          originalIndex: i,
        ));
      }
      
      // Shuffle letters
      _mixedLetters.shuffle(_random);
      
      // Create empty answer slots
      _answerSlots = List.filled(_targetWord.length, null);
    });
  }

  void _onLetterTap(LetterTile tile) {
    if (_isGameOver || _isChecking) return;
    
    setState(() {
      // Find first empty slot
      final emptyIndex = _answerSlots.indexWhere((slot) => slot == null);
      if (emptyIndex != -1) {
        _answerSlots[emptyIndex] = tile;
        _mixedLetters.remove(tile);
        _soundManager.playSoundEffect(SoundEffect.buttonTap);
        _soundManager.playLetterSound(tile.letter);
        
        // Check if all slots filled
        if (_answerSlots.every((slot) => slot != null)) {
          _checkAnswer();
        }
      }
    });
  }

  void _onSlotTap(int index) {
    if (_isGameOver || _isChecking) return;
    
    setState(() {
      final tile = _answerSlots[index];
      if (tile != null) {
        _answerSlots[index] = null;
        _mixedLetters.add(tile);
        _soundManager.playSoundEffect(SoundEffect.buttonTap);
      }
    });
  }

  void _checkAnswer() {
    setState(() {
      _isChecking = true;
      _totalAttempts++;
    });
    
    // Build answer string
    final answer = _answerSlots.map((tile) => tile!.letter).join();
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (answer == _targetWord) {
        // Correct!
        _score++;
        _soundManager.playCorrectAnswer();
        CelebrationUtils.showCelebration(context);
        
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (_score >= widget.targetScore) {
            _endGame(true);
          } else {
            _startNewPuzzle();
          }
        });
      } else {
        // Wrong
        _mistakes++;
        _soundManager.playSoundEffect(SoundEffect.buttonTap);
        
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              // Return all letters to mixed area
              _mixedLetters.addAll(_answerSlots.whereType<LetterTile>());
              _answerSlots = List.filled(_targetWord.length, null);
              _isChecking = false;
            });
          }
        });
      }
    });
  }

  void _onHintTap() {
    if (_isGameOver || _isChecking) return;
    
    // Find first incorrect slot
    for (int i = 0; i < _answerSlots.length; i++) {
      final correctLetter = _targetWord[i];
      final currentTile = _answerSlots[i];
      
      if (currentTile == null || currentTile.letter != correctLetter) {
        // Find correct tile in mixed letters
        final correctTile = _mixedLetters.firstWhere(
          (tile) => tile.letter == correctLetter && tile.originalIndex == i,
          orElse: () => _mixedLetters.first,
        );
        
        setState(() {
          // Return current tile if any
          if (currentTile != null) {
            _mixedLetters.add(currentTile);
          }
          
          // Place correct tile
          _answerSlots[i] = correctTile;
          _mixedLetters.remove(correctTile);
          _soundManager.playSoundEffect(SoundEffect.treasureUnlock); // Using treasureUnlock as hint sound
          _soundManager.playLetterSound(correctTile.letter);
        });
        
        break;
      }
    }
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
          won ? 'برافو! 🎉' : 'حاول تاني',
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              SmartinoColors.success,
              SmartinoColors.success.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 20),
              _buildInstructions(),
              const SizedBox(height: 30),
              _buildAnswerSlots(),
              const SizedBox(height: 20),
              _buildMeaningHint(),
              const Spacer(),
              _buildMixedLetters(),
              const SizedBox(height: 20),
              _buildHintButton(),
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
        'رتب الحروف لتكوين الكلمة الصحيحة',
        style: SmartinoTypography.titleMedium.copyWith(
          color: SmartinoColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildAnswerSlots() {
    final isCorrect = _isChecking && 
        _answerSlots.every((slot) => slot != null) &&
        _answerSlots.map((tile) => tile!.letter).join() == _targetWord;
    final isWrong = _isChecking && !isCorrect;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
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
        children: List.generate(_answerSlots.length, (index) {
          final tile = _answerSlots[index];
          
          return GestureDetector(
            onTap: () => _onSlotTap(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: tile != null
                    ? (isCorrect
                        ? SmartinoColors.success.withOpacity(0.2)
                        : (isWrong
                            ? SmartinoColors.error.withOpacity(0.2)
                            : SmartinoColors.primary.withOpacity(0.1)))
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: tile != null
                      ? (isCorrect
                          ? SmartinoColors.success
                          : (isWrong
                              ? SmartinoColors.error
                              : SmartinoColors.primary))
                      : Colors.grey.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  tile?.letter ?? '',
                  style: SmartinoTypography.displayMedium.copyWith(
                    color: SmartinoColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ).animate(
              target: isWrong ? 1 : 0,
            ).shake(duration: 500.ms),
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
            'معناها: $_wordMeaning',
            style: SmartinoTypography.bodyLarge.copyWith(
              color: SmartinoColors.textSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildMixedLetters() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: _mixedLetters.map((tile) {
          return GestureDetector(
            onTap: () => _onLetterTap(tile),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  tile.letter,
                  style: SmartinoTypography.displaySmall.copyWith(
                    color: SmartinoColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ).animate().scale(duration: 200.ms),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHintButton() {
    return SmartinoButton(
      text: 'مساعدة 💡',
      onPressed: _onHintTap,
      type: SmartinoButtonType.secondary,
      size: SmartinoButtonSize.medium,
    );
  }
}

class LetterTile {
  final String id;
  final String letter;
  final int originalIndex;

  LetterTile({
    required this.id,
    required this.letter,
    required this.originalIndex,
  });
}
