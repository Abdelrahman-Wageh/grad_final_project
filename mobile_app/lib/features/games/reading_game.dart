/// Reading Game
/// 
/// A sentence reading game where children read and understand Arabic sentences.
/// Inspired by Antura's ReadingGame.
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

class ReadingGame extends StatefulWidget {
  final String stageId;
  final List<String> targetLetters;
  final int targetScore;

  const ReadingGame({
    Key? key,
    required this.stageId,
    required this.targetLetters,
    this.targetScore = 6,
  }) : super(key: key);

  @override
  State<ReadingGame> createState() => _ReadingGameState();
}

class _ReadingGameState extends State<ReadingGame> {
  final Random _random = Random();
  final SoundManager _soundManager = SoundManager();
  
  late ReadingQuestion _currentQuestion;
  int _score = 0;
  int _mistakes = 0;
  int _totalAttempts = 0;
  bool _isGameOver = false;
  String? _selectedAnswer;
  
  // Egyptian-themed reading questions
  static const List<Map<String, dynamic>> readingQuestions = [
    {
      'sentence': 'فرفور يحب الأهرامات',
      'question': 'ماذا يحب فرفور؟',
      'correct': 'الأهرامات',
      'wrong': ['القلعة', 'البحر', 'الجبل'],
    },
    {
      'sentence': 'القاهرة مدينة كبيرة',
      'question': 'كيف القاهرة؟',
      'correct': 'كبيرة',
      'wrong': ['صغيرة', 'بعيدة', 'قريبة'],
    },
    {
      'sentence': 'النيل نهر جميل',
      'question': 'ما هو النيل؟',
      'correct': 'نهر',
      'wrong': ['بحر', 'جبل', 'صحراء'],
    },
    {
      'sentence': 'فرفور يلعب في الحديقة',
      'question': 'أين يلعب فرفور؟',
      'correct': 'الحديقة',
      'wrong': ['البيت', 'المدرسة', 'الشارع'],
    },
    {
      'sentence': 'الشمس مشرقة اليوم',
      'question': 'كيف الشمس؟',
      'correct': 'مشرقة',
      'wrong': ['غائبة', 'باردة', 'صغيرة'],
    },
    {
      'sentence': 'أحمد يقرأ كتاب',
      'question': 'ماذا يفعل أحمد؟',
      'correct': 'يقرأ',
      'wrong': ['يكتب', 'يلعب', 'ينام'],
    },
    {
      'sentence': 'فاطمة تحب الرسم',
      'question': 'ماذا تحب فاطمة؟',
      'correct': 'الرسم',
      'wrong': ['الغناء', 'الطبخ', 'الرقص'],
    },
    {
      'sentence': 'القطة تجري بسرعة',
      'question': 'كيف تجري القطة؟',
      'correct': 'بسرعة',
      'wrong': ['ببطء', 'بهدوء', 'بصعوبة'],
    },
    {
      'sentence': 'الطائر يطير عالياً',
      'question': 'كيف يطير الطائر؟',
      'correct': 'عالياً',
      'wrong': ['منخفضاً', 'بطيئاً', 'قريباً'],
    },
    {
      'sentence': 'محمد يأكل تفاحة',
      'question': 'ماذا يأكل محمد؟',
      'correct': 'تفاحة',
      'wrong': ['موزة', 'برتقالة', 'عنب'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _startNewQuestion();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _startNewQuestion() {
    if (_isGameOver) return;
    
    setState(() {
      _selectedAnswer = null;
      
      // Select random question
      final questionData = readingQuestions[_random.nextInt(readingQuestions.length)];
      
      // Create answer options
      final wrongAnswers = List<String>.from(questionData['wrong'] as List);
      wrongAnswers.shuffle(_random);
      
      final allAnswers = [
        questionData['correct'] as String,
        ...wrongAnswers.take(2),
      ];
      allAnswers.shuffle(_random);
      
      _currentQuestion = ReadingQuestion(
        sentence: questionData['sentence'] as String,
        question: questionData['question'] as String,
        correctAnswer: questionData['correct'] as String,
        allAnswers: allAnswers,
      );
    });
  }

  void _onAnswerSelect(String answer) {
    if (_isGameOver || _selectedAnswer != null) return;
    
    setState(() {
      _selectedAnswer = answer;
      _totalAttempts++;
      
      if (answer == _currentQuestion.correctAnswer) {
        // Correct!
        _score++;
        _soundManager.playCorrectAnswer();
        CelebrationUtils.showFloatingStars(context);
        
        // If the answer is a single Arabic character, play its sound
        if (answer.length == 1 && widget.targetLetters.contains(answer)) {
          _soundManager.playLetterSound(answer);
        }
        
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (_score >= widget.targetScore) {
            _endGame(true);
          } else {
            _startNewQuestion();
          }
        });
      } else {
        // Wrong
        _mistakes++;
        _soundManager.playSoundEffect(SoundEffect.buttonTap);
        
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            setState(() {
              _selectedAnswer = null;
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
          won ? 'عظيم! 🎉' : 'حاول تاني',
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
      _startNewQuestion();
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
              SmartinoColors.warning,
              SmartinoColors.warning.withOpacity(0.7),
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
              _buildSentenceCard(),
              const SizedBox(height: 30),
              _buildQuestionCard(),
              const Spacer(),
              _buildAnswerOptions(),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book,
            color: SmartinoColors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            'اقرأ الجملة وأجب على السؤال',
            style: SmartinoTypography.titleMedium.copyWith(
              color: SmartinoColors.textPrimary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildSentenceCard() {
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
      child: Column(
        children: [
          Icon(
            Icons.auto_stories,
            color: SmartinoColors.primary,
            size: 32,
          ),
          const SizedBox(height: 16),
          Text(
            _currentQuestion.sentence,
            style: SmartinoTypography.displaySmall.copyWith(
              color: SmartinoColors.textPrimary,
              fontWeight: FontWeight.bold,
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).scale(delay: 100.ms);
  }

  Widget _buildQuestionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SmartinoColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: SmartinoColors.primary,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.help_outline,
            color: SmartinoColors.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              _currentQuestion.question,
              style: SmartinoTypography.titleLarge.copyWith(
                color: SmartinoColors.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildAnswerOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: _currentQuestion.allAnswers.map((answer) {
          final isSelected = answer == _selectedAnswer;
          final isCorrect = answer == _currentQuestion.correctAnswer;
          final showResult = isSelected;
          
          return GestureDetector(
            onTap: () => _onAnswerSelect(answer),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: showResult
                    ? (isCorrect ? SmartinoColors.success : SmartinoColors.error)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: showResult
                      ? (isCorrect ? SmartinoColors.success : SmartinoColors.error)
                      : SmartinoColors.primary.withOpacity(0.3),
                  width: 2,
                ),
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
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: showResult
                          ? Colors.white.withOpacity(0.3)
                          : SmartinoColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        showResult
                            ? (isCorrect ? Icons.check : Icons.close)
                            : Icons.radio_button_unchecked,
                        color: showResult
                            ? Colors.white
                            : SmartinoColors.primary,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      answer,
                      style: SmartinoTypography.titleLarge.copyWith(
                        color: showResult ? Colors.white : SmartinoColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
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

class ReadingQuestion {
  final String sentence;
  final String question;
  final String correctAnswer;
  final List<String> allAnswers;

  ReadingQuestion({
    required this.sentence,
    required this.question,
    required this.correctAnswer,
    required this.allAnswers,
  });
}
