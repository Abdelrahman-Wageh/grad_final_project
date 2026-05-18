import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartino/models/learning_models.dart';
import 'package:smartino/providers/learning_providers.dart';
import 'package:smartino/screens/quiz_result_screen.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final Quiz quiz;
  final String userId;

  const QuizScreen({
    Key? key,
    required this.quiz,
    required this.userId,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _currentQuestionIndex = 0;
  late Map<String, String> _answers;
  late int _remainingSeconds;
  late DateTime _startTime;
  bool _quizSubmitted = false;

  @override
  void initState() {
    super.initState();
    _answers = {};
    _remainingSeconds = widget.quiz.totalTimeSeconds;
    _startTime = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _remainingSeconds--);
        if (_remainingSeconds > 0) {
          _startTimer();
        } else {
          _submitQuiz();
        }
      }
    });
  }

  Future<void> _submitQuiz() async {
    if (_quizSubmitted) return;

    setState(() => _quizSubmitted = true);

    final timeSpent = DateTime.now().difference(_startTime).inSeconds;

    try {
      final service = ref.read(learningServiceProvider);
      final result = await service.submitQuiz(
        quizId: widget.quiz.quizId,
        userId: widget.userId,
        answers: _answers,
        timeSpentSeconds: timeSpent,
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => QuizResultScreen(
              quizId: widget.quiz.quizId,
              scorePercentage: result['score_percentage'] ?? 0.0,
              passed: result['passed'] ?? false,
              totalQuestions: widget.quiz.questions.length,
              correctAnswers: _calculateCorrectAnswers(),
              rewards: result['rewards_earned'],
              badges: result['badges_earned'],
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting quiz: $e')),
      );
    }
  }

  int _calculateCorrectAnswers() {
    int correct = 0;
    for (var question in widget.quiz.questions) {
      final selectedAnswer = _answers[question.questionId];
      final correctOption =
          question.options.firstWhere((o) => o.isCorrect, orElse: () => null);
      if (selectedAnswer == correctOption?.optionId) {
        correct++;
      }
    }
    return correct;
  }

  @override
  Widget build(BuildContext context) {
    if (_quizSubmitted) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1a237e).withOpacity(0.8),
                Color(0xFF0d47a1).withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ),
      );
    }

    final currentQuestion = widget.quiz.questions[_currentQuestionIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a237e).withOpacity(0.8),
              Color(0xFF0d47a1).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ==================== HEADER ====================
              _buildHeader(),

              // ==================== PROGRESS ====================
              _buildProgressBar(),

              // ==================== TIMER ====================
              _buildTimer(),

              // ==================== QUESTION ====================
              Expanded(
                child: _buildQuestion(currentQuestion),
              ),

              // ==================== CONTROLS ====================
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Column(
            children: [
              Text(
                widget.quiz.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Question ${_currentQuestionIndex + 1} of ${widget.quiz.questions.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.4)),
            ),
            child: Text(
              _formatTime(_remainingSeconds),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / widget.quiz.questions.length,
          minHeight: 8,
          backgroundColor: Colors.white.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation(Colors.green),
        ),
      ),
    );
  }

  Widget _buildTimer() {
    final isWarning = _remainingSeconds < 30;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isWarning
            ? Colors.red.withOpacity(0.2)
            : Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWarning
              ? Colors.red.withOpacity(0.4)
              : Colors.blue.withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer,
            color: isWarning ? Colors.red : Colors.blue,
          ),
          SizedBox(width: 8),
          Text(
            'Time Remaining: ${_formatTime(_remainingSeconds)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isWarning ? Colors.red : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(QuizQuestion question) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (question.questionImageUrl != null)
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.only(bottom: 16),
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 60,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                Text(
                  question.questionText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Answer options
          Text(
            'Select your answer:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 12),
          ...question.options.map((option) {
            final isSelected = _answers[question.questionId] == option.optionId;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _answers[question.questionId] = option.optionId;
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.green.withOpacity(0.3)
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Colors.green.withOpacity(0.6)
                        : Colors.white.withOpacity(0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.green
                            : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                      child: isSelected
                          ? Icon(Icons.check, size: 16, color: Colors.white)
                          : SizedBox.shrink(),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (option.imageUrl != null)
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              margin: EdgeInsets.only(bottom: 8),
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                            ),
                          Text(
                            option.text,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          if (question.hints.isNotEmpty) ...[
            SizedBox(height: 20),
            ExpansionTile(
              title: Text(
                '💡 Need a hint?',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              collapsedTextColor: Colors.amber,
              collapsedIconColor: Colors.amber,
              children: [
                Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.withOpacity(0.4)),
                  ),
                  child: Text(
                    question.hints.join('\n\n'),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildControls() {
    final isAnswered = _answers.containsKey(
        widget.quiz.questions[_currentQuestionIndex].questionId);
    final isLastQuestion =
        _currentQuestionIndex == widget.quiz.questions.length - 1;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _currentQuestionIndex == 0
                  ? null
                  : () {
                      setState(() => _currentQuestionIndex--);
                    },
              icon: Icon(Icons.arrow_back),
              label: Text('Previous'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: !isAnswered
                  ? null
                  : isLastQuestion
                      ? _submitQuiz
                      : () {
                          setState(() => _currentQuestionIndex++);
                        },
              icon: Icon(isLastQuestion ? Icons.check : Icons.arrow_forward),
              label: Text(isLastQuestion ? 'Submit' : 'Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isAnswered ? Colors.green : Colors.grey,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
