import 'package:hive/hive.dart';

part 'child_profile.g.dart';

@HiveType(typeId: 7)
class ChildProfile {
  @HiveField(0)
  final String name;
  
  @HiveField(1)
  final int age;
  
  @HiveField(2)
  final String level; // KG1, KG2, Primary
  
  @HiveField(3)
  final String assessment; // Below Average, Average, Above Average
  
  @HiveField(4)
  final List<String> masteredConcepts;
  
  @HiveField(5)
  final List<String> unlockedItems;
  
  @HiveField(6)
  final int totalStars;
  
  @HiveField(7)
  final DateTime createdAt;
  
  @HiveField(8)
  final DateTime lastPlayedAt;
  
  @HiveField(9)
  final Map<String, int> conceptAttempts; // Track attempts per concept for mastery
  
  @HiveField(10)
  final List<double> recentSuccessRates; // Last 10 success rates for adaptive difficulty

  ChildProfile({
    required this.name,
    required this.age,
    required this.level,
    required this.assessment,
    List<String>? masteredConcepts,
    List<String>? unlockedItems,
    this.totalStars = 0,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
    Map<String, int>? conceptAttempts,
    List<double>? recentSuccessRates,
  })  : masteredConcepts = masteredConcepts ?? [],
        unlockedItems = unlockedItems ?? [],
        createdAt = createdAt ?? DateTime.now(),
        lastPlayedAt = lastPlayedAt ?? DateTime.now(),
        conceptAttempts = conceptAttempts ?? {},
        recentSuccessRates = recentSuccessRates ?? [];

  /// Add stars and check for item unlocks
  ChildProfile addStars(int stars) {
    return copyWith(
      totalStars: totalStars + stars,
      lastPlayedAt: DateTime.now(),
    );
  }

  /// Track concept attempt and check for mastery (5 successful attempts)
  ChildProfile trackConceptAttempt(String concept, bool success) {
    final newAttempts = Map<String, int>.from(conceptAttempts);
    final currentAttempts = newAttempts[concept] ?? 0;
    
    if (success) {
      newAttempts[concept] = currentAttempts + 1;
      
      // Check if concept is mastered (5 successful attempts)
      if (newAttempts[concept]! >= 5 && !masteredConcepts.contains(concept)) {
        final newMastered = List<String>.from(masteredConcepts)..add(concept);
        return copyWith(
          masteredConcepts: newMastered,
          conceptAttempts: newAttempts,
          lastPlayedAt: DateTime.now(),
        );
      }
    }
    
    return copyWith(
      conceptAttempts: newAttempts,
      lastPlayedAt: DateTime.now(),
    );
  }

  /// Add success rate for adaptive difficulty
  ChildProfile addSuccessRate(double rate) {
    final newRates = List<double>.from(recentSuccessRates);
    newRates.add(rate);
    
    // Keep only last 10 rates
    if (newRates.length > 10) {
      newRates.removeAt(0);
    }
    
    return copyWith(
      recentSuccessRates: newRates,
      lastPlayedAt: DateTime.now(),
    );
  }

  /// Get average recent success rate
  double getAverageSuccessRate() {
    if (recentSuccessRates.isEmpty) return 0.5;
    return recentSuccessRates.reduce((a, b) => a + b) / recentSuccessRates.length;
  }

  /// Unlock item
  ChildProfile unlockItem(String itemId) {
    if (unlockedItems.contains(itemId)) return this;
    
    final newItems = List<String>.from(unlockedItems)..add(itemId);
    return copyWith(
      unlockedItems: newItems,
      lastPlayedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'level': level,
      'assessment': assessment,
      'masteredConcepts': masteredConcepts.toList(),
      'unlockedItems': unlockedItems,
      'totalStars': totalStars,
      'createdAt': createdAt.toIso8601String(),
      'lastPlayedAt': lastPlayedAt.toIso8601String(),
      'conceptAttempts': conceptAttempts,
      'recentSuccessRates': recentSuccessRates,
    };
  }

  factory ChildProfile.fromJson(Map<String, dynamic> json) {
    return ChildProfile(
      name: json['name'],
      age: json['age'],
      level: json['level'],
      assessment: json['assessment'],
      masteredConcepts: List<String>.from(json['masteredConcepts'] ?? []),
      unlockedItems: List<String>.from(json['unlockedItems'] ?? []),
      totalStars: json['totalStars'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      lastPlayedAt: DateTime.parse(json['lastPlayedAt']),
      conceptAttempts: Map<String, int>.from(json['conceptAttempts'] ?? {}),
      recentSuccessRates: List<double>.from(json['recentSuccessRates'] ?? []),
    );
  }

  ChildProfile copyWith({
    String? name,
    int? age,
    String? level,
    String? assessment,
    List<String>? masteredConcepts,
    List<String>? unlockedItems,
    int? totalStars,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
    Map<String, int>? conceptAttempts,
    List<double>? recentSuccessRates,
  }) {
    return ChildProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      level: level ?? this.level,
      assessment: assessment ?? this.assessment,
      masteredConcepts: masteredConcepts ?? this.masteredConcepts,
      unlockedItems: unlockedItems ?? this.unlockedItems,
      totalStars: totalStars ?? this.totalStars,
      createdAt: createdAt ?? this.createdAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      conceptAttempts: conceptAttempts ?? this.conceptAttempts,
      recentSuccessRates: recentSuccessRates ?? this.recentSuccessRates,
    );
  }
}
