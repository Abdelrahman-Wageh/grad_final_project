/// Daily Challenge Service
/// Generates and manages daily challenges to encourage retention
library;

import 'dart:math';
import 'package:hive/hive.dart';

enum ChallengeType {
  learnWords,
  playTime,
  earnStars,
  completeChapter,
  practiceVoice,
}

class DailyChallenge {
  final String id;
  final DateTime date;
  final String descriptionEn;
  final String descriptionAr;
  final ChallengeType type;
  final int targetCount;
  int currentCount;
  bool isCompleted;
  final int bonusStars;

  DailyChallenge({
    required this.id,
    required this.date,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.type,
    required this.targetCount,
    this.currentCount = 0,
    this.isCompleted = false,
    this.bonusStars = 3,
  });

  double get progress => currentCount / targetCount;

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'descriptionEn': descriptionEn,
        'descriptionAr': descriptionAr,
        'type': type.toString(),
        'targetCount': targetCount,
        'currentCount': currentCount,
        'isCompleted': isCompleted,
        'bonusStars': bonusStars,
      };

  factory DailyChallenge.fromJson(Map<String, dynamic> json) {
    return DailyChallenge(
      id: json['id'],
      date: DateTime.parse(json['date']),
      descriptionEn: json['descriptionEn'],
      descriptionAr: json['descriptionAr'],
      type: ChallengeType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      targetCount: json['targetCount'],
      currentCount: json['currentCount'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      bonusStars: json['bonusStars'] ?? 3,
    );
  }
}

class DailyChallengeService {
  static const String BOX_NAME = 'daily_challenges';
  late Box _box;

  Future<void> initialize() async {
    _box = await Hive.openBox(BOX_NAME);
  }

  /// Get today's challenge (or generate if doesn't exist)
  Future<DailyChallenge> getTodayChallenge() async {
    String today = _getTodayKey();
    
    if (_box.containsKey(today)) {
      return DailyChallenge.fromJson(
        Map<String, dynamic>.from(_box.get(today)),
      );
    }

    // Generate new challenge
    DailyChallenge challenge = _generateChallenge();
    await _box.put(today, challenge.toJson());
    return challenge;
  }

  /// Update challenge progress
  Future<void> updateProgress(ChallengeType type, int increment) async {
    DailyChallenge challenge = await getTodayChallenge();
    
    if (challenge.type == type && !challenge.isCompleted) {
      challenge.currentCount += increment;
      
      if (challenge.currentCount >= challenge.targetCount) {
        challenge.isCompleted = true;
      }
      
      await _box.put(_getTodayKey(), challenge.toJson());
    }
  }

  /// Check if challenge is completed
  Future<bool> isTodayChallengeCompleted() async {
    DailyChallenge challenge = await getTodayChallenge();
    return challenge.isCompleted;
  }

  /// Get challenge history
  Future<List<DailyChallenge>> getChallengeHistory({int days = 7}) async {
    List<DailyChallenge> history = [];
    DateTime now = DateTime.now();
    
    for (int i = 0; i < days; i++) {
      DateTime date = now.subtract(Duration(days: i));
      String key = _getDateKey(date);
      
      if (_box.containsKey(key)) {
        history.add(
          DailyChallenge.fromJson(
            Map<String, dynamic>.from(_box.get(key)),
          ),
        );
      }
    }
    
    return history;
  }

  /// Get completion streak
  Future<int> getCompletionStreak() async {
    int streak = 0;
    DateTime now = DateTime.now();
    
    for (int i = 0; i < 365; i++) {
      DateTime date = now.subtract(Duration(days: i));
      String key = _getDateKey(date);
      
      if (_box.containsKey(key)) {
        DailyChallenge challenge = DailyChallenge.fromJson(
          Map<String, dynamic>.from(_box.get(key)),
        );
        
        if (challenge.isCompleted) {
          streak++;
        } else {
          break;
        }
      } else {
        break;
      }
    }
    
    return streak;
  }

  String _getTodayKey() {
    return _getDateKey(DateTime.now());
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  DailyChallenge _generateChallenge() {
    Random random = Random();
    ChallengeType type = ChallengeType.values[random.nextInt(ChallengeType.values.length)];
    
    String descriptionEn;
    String descriptionAr;
    int targetCount;
    int bonusStars;

    switch (type) {
      case ChallengeType.learnWords:
        targetCount = 5 + random.nextInt(6); // 5-10 words
        descriptionEn = 'Learn $targetCount new words today';
        descriptionAr = 'تعلم $targetCount كلمات جديدة اليوم';
        bonusStars = 3;
        break;
        
      case ChallengeType.playTime:
        targetCount = 10 + random.nextInt(11); // 10-20 minutes
        descriptionEn = 'Play for $targetCount minutes today';
        descriptionAr = 'العب لمدة $targetCount دقيقة اليوم';
        bonusStars = 2;
        break;
        
      case ChallengeType.earnStars:
        targetCount = 5 + random.nextInt(6); // 5-10 stars
        descriptionEn = 'Earn $targetCount stars today';
        descriptionAr = 'احصل على $targetCount نجوم اليوم';
        bonusStars = 3;
        break;
        
      case ChallengeType.completeChapter:
        targetCount = 1;
        descriptionEn = 'Complete 1 chapter stage today';
        descriptionAr = 'أكمل مرحلة واحدة من الفصل اليوم';
        bonusStars = 5;
        break;
        
      case ChallengeType.practiceVoice:
        targetCount = 3 + random.nextInt(5); // 3-7 times
        descriptionEn = 'Practice voice $targetCount times today';
        descriptionAr = 'تدرب على الصوت $targetCount مرات اليوم';
        bonusStars = 2;
        break;
    }

    return DailyChallenge(
      id: 'challenge_${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
      type: type,
      targetCount: targetCount,
      bonusStars: bonusStars,
    );
  }
}
