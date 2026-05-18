/// Smartino Super-App - Assessment System
/// Handles quizzes, evaluations, and adaptive difficulty
/// Requirements: 1.6, 1.7

import 'package:flutter/foundation.dart';
import 'dart:math';

/// Assessment types
enum AssessmentType {
  multipleChoice,
  matching,
  fillInBlank,
  speaking,
  listening,
  drawing,
}

/// Difficulty levels
enum DifficultyLevel {
  easy,
  medium,
  hard,
}

/// Assessment question model
class AssessmentQuestion {
  final String id;
  final AssessmentType type;
  final String questionAr;
  final String questionEn;
  final String? audioUrl;
  final String? imageUrl;
  final List<String> options; // For multiple choice
  final String correctAnswer;
  final Map<String, String>? matchingPairs; // For matching
  final DifficultyLevel difficulty;
  
  AssessmentQuestion({
    required this.id,
    required this.type,
    required this.questionAr,
    required this.questionEn,
    this.audioUrl,
    this.imageUrl,
    this.options = const [],
    required this.correctAnswer,
    this.matchingPairs,
    this.difficulty = DifficultyLevel.medium,
  });
}

/// Assessment result
class AssessmentResult {
  final String assessmentId;
  final int totalQuestions;
  final int correctAnswers;
  final int mistakes;
  final Duration timeTaken;
  final Map<String, bool> questionResults; // questionId -> isCorrect
  final DifficultyLevel difficulty;
  final DateTime completedAt;
  
  AssessmentResult({
    required this.assessmentId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.mistakes,
    required this.timeTaken,
    required this.questionResults,
    required this.difficulty,
    required this.completedAt,
  });
  
  double get accuracy => totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;
  
  String get accuracyPercentage => '${(accuracy * 100).toStringAsFixed(0)}%';
  
  bool get isPassed => accuracy >= 0.7; // 70% to pass
  
  String get grade {
    if (accuracy >= 0.9) return 'ممتاز'; // Excellent
    if (accuracy >= 0.8) return 'جيد جداً'; // Very Good
    if (accuracy >= 0.7) return 'جيد'; // Good
    if (accuracy >= 0.6) return 'مقبول'; // Acceptable
    return 'حاول تاني'; // Try Again
  }
}

/// Assessment System
class AssessmentSystem {
  final Random _random = Random();
  
  /// Generate assessment questions based on stage and difficulty
  List<AssessmentQuestion> generateAssessment({
    required String stageId,
    required String topic,
    required DifficultyLevel difficulty,
    int questionCount = 10,
  }) {
    // This is a template - actual questions should come from curriculum data
    final questions = <AssessmentQuestion>[];
    
    // Generate questions based on topic
    if (topic.contains('letter') || topic.contains('حرف')) {
      questions.addAll(_generateLetterQuestions(difficulty, questionCount));
    } else if (topic.contains('number') || topic.contains('رقم')) {
      questions.addAll(_generateNumberQuestions(difficulty, questionCount));
    } else if (topic.contains('color') || topic.contains('لون')) {
      questions.addAll(_generateColorQuestions(difficulty, questionCount));
    } else if (topic.contains('word') || topic.contains('كلمة')) {
      questions.addAll(_generateWordQuestions(difficulty, questionCount));
    }
    
    return questions;
  }
  
  /// Generate letter recognition questions
  List<AssessmentQuestion> _generateLetterQuestions(
    DifficultyLevel difficulty,
    int count,
  ) {
    final questions = <AssessmentQuestion>[];
    final arabicLetters = ['أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر'];
    
    for (int i = 0; i < count; i++) {
      final correctLetter = arabicLetters[_random.nextInt(arabicLetters.length)];
      final wrongLetters = arabicLetters.where((l) => l != correctLetter).toList()..shuffle();
      
      questions.add(AssessmentQuestion(
        id: 'letter_$i',
        type: AssessmentType.multipleChoice,
        questionAr: 'اختر الحرف: $correctLetter',
        questionEn: 'Choose the letter: $correctLetter',
        options: [correctLetter, ...wrongLetters.take(3)],
        correctAnswer: correctLetter,
        difficulty: difficulty,
      ));
    }
    
    return questions;
  }
  
  /// Generate number questions
  List<AssessmentQuestion> _generateNumberQuestions(
    DifficultyLevel difficulty,
    int count,
  ) {
    final questions = <AssessmentQuestion>[];
    final maxNumber = difficulty == DifficultyLevel.easy ? 10 : 
                     difficulty == DifficultyLevel.medium ? 20 : 50;
    
    for (int i = 0; i < count; i++) {
      final correctNumber = _random.nextInt(maxNumber) + 1;
      final wrongNumbers = List.generate(3, (_) => _random.nextInt(maxNumber) + 1)
          .where((n) => n != correctNumber)
          .toList();
      
      questions.add(AssessmentQuestion(
        id: 'number_$i',
        type: AssessmentType.multipleChoice,
        questionAr: 'اختر الرقم: $correctNumber',
        questionEn: 'Choose the number: $correctNumber',
        options: [correctNumber.toString(), ...wrongNumbers.map((n) => n.toString())],
        correctAnswer: correctNumber.toString(),
        difficulty: difficulty,
      ));
    }
    
    return questions;
  }
  
  /// Generate color questions
  List<AssessmentQuestion> _generateColorQuestions(
    DifficultyLevel difficulty,
    int count,
  ) {
    final questions = <AssessmentQuestion>[];
    final colors = {
      'أحمر': 'Red',
      'أزرق': 'Blue',
      'أخضر': 'Green',
      'أصفر': 'Yellow',
      'برتقالي': 'Orange',
      'بنفسجي': 'Purple',
      'وردي': 'Pink',
      'بني': 'Brown',
    };
    
    final colorList = colors.keys.toList();
    
    for (int i = 0; i < count; i++) {
      final correctColor = colorList[_random.nextInt(colorList.length)];
      final wrongColors = colorList.where((c) => c != correctColor).toList()..shuffle();
      
      questions.add(AssessmentQuestion(
        id: 'color_$i',
        type: AssessmentType.multipleChoice,
        questionAr: 'ما هو اللون؟',
        questionEn: 'What is the color?',
        options: [correctColor, ...wrongColors.take(3)],
        correctAnswer: correctColor,
        difficulty: difficulty,
      ));
    }
    
    return questions;
  }
  
  /// Generate word questions
  List<AssessmentQuestion> _generateWordQuestions(
    DifficultyLevel difficulty,
    int count,
  ) {
    final questions = <AssessmentQuestion>[];
    final words = {
      'قطة': 'Cat',
      'كلب': 'Dog',
      'بيت': 'House',
      'شجرة': 'Tree',
      'كتاب': 'Book',
      'قلم': 'Pen',
      'ماء': 'Water',
      'شمس': 'Sun',
    };
    
    final wordList = words.keys.toList();
    
    for (int i = 0; i < count; i++) {
      final correctWord = wordList[_random.nextInt(wordList.length)];
      final wrongWords = wordList.where((w) => w != correctWord).toList()..shuffle();
      
      questions.add(AssessmentQuestion(
        id: 'word_$i',
        type: AssessmentType.multipleChoice,
        questionAr: 'اختر الكلمة الصحيحة',
        questionEn: 'Choose the correct word',
        options: [correctWord, ...wrongWords.take(3)],
        correctAnswer: correctWord,
        difficulty: difficulty,
      ));
    }
    
    return questions;
  }
  
  /// Evaluate assessment and return result
  AssessmentResult evaluateAssessment({
    required String assessmentId,
    required List<AssessmentQuestion> questions,
    required Map<String, String> userAnswers,
    required Duration timeTaken,
    required DifficultyLevel difficulty,
  }) {
    final questionResults = <String, bool>{};
    int correctAnswers = 0;
    
    for (var question in questions) {
      final userAnswer = userAnswers[question.id];
      final isCorrect = userAnswer == question.correctAnswer;
      
      questionResults[question.id] = isCorrect;
      if (isCorrect) correctAnswers++;
    }
    
    final mistakes = questions.length - correctAnswers;
    
    return AssessmentResult(
      assessmentId: assessmentId,
      totalQuestions: questions.length,
      correctAnswers: correctAnswers,
      mistakes: mistakes,
      timeTaken: timeTaken,
      questionResults: questionResults,
      difficulty: difficulty,
      completedAt: DateTime.now(),
    );
  }
  
  /// Determine next difficulty level based on performance
  DifficultyLevel getNextDifficulty({
    required DifficultyLevel currentDifficulty,
    required double accuracy,
    required int consecutiveSuccesses,
  }) {
    // Increase difficulty if performing well
    if (accuracy >= 0.9 && consecutiveSuccesses >= 3) {
      if (currentDifficulty == DifficultyLevel.easy) {
        return DifficultyLevel.medium;
      } else if (currentDifficulty == DifficultyLevel.medium) {
        return DifficultyLevel.hard;
      }
    }
    
    // Decrease difficulty if struggling
    if (accuracy < 0.6) {
      if (currentDifficulty == DifficultyLevel.hard) {
        return DifficultyLevel.medium;
      } else if (currentDifficulty == DifficultyLevel.medium) {
        return DifficultyLevel.easy;
      }
    }
    
    return currentDifficulty;
  }
  
  /// Get encouraging feedback based on performance
  String getFeedback({
    required double accuracy,
    required bool isPassed,
    required int stars,
  }) {
    if (stars == 3) {
      return 'رائع جداً! أنت بطل! 🌟';
    } else if (stars == 2) {
      return 'ممتاز! استمر كده! 👏';
    } else if (stars == 1) {
      return 'جيد! حاول تاني عشان تحسن أكتر! 💪';
    } else if (isPassed) {
      return 'كويس! تقدر تعمل أحسن من كده! 😊';
    } else {
      return 'حاول تاني! أنا متأكد إنك هتنجح! 🎯';
    }
  }
}
