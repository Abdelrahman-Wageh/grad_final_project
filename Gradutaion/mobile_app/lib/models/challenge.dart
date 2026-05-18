import 'package:hive/hive.dart';

part 'challenge.g.dart';

@HiveType(typeId: 4)
enum ChallengeType {
  @HiveField(0)
  vocabulary,
  
  @HiveField(1)
  sentence,
  
  @HiveField(2)
  counting,
  
  @HiveField(3)
  colorRecognition,
  
  @HiveField(4)
  shapeRecognition,
  
  @HiveField(5)
  animalSound,
  
  @HiveField(6)
  drawing,
  
  @HiveField(7)
  memory,
  
  @HiveField(8)
  cumulative,
}

@HiveType(typeId: 5)
enum DifficultyLevel {
  @HiveField(0)
  easy,
  
  @HiveField(1)
  medium,
  
  @HiveField(2)
  hard,
}

@HiveType(typeId: 6)
class Challenge {
  @HiveField(0)
  final ChallengeType type;
  
  @HiveField(1)
  final String prompt;
  
  @HiveField(2)
  final String expectedAnswer;
  
  @HiveField(3)
  final List<String> alternativeAnswers;
  
  @HiveField(4)
  final DifficultyLevel difficulty;
  
  @HiveField(5)
  final Map<String, dynamic> data;

  Challenge({
    required this.type,
    required this.prompt,
    required this.expectedAnswer,
    this.alternativeAnswers = const [],
    required this.difficulty,
    this.data = const {},
  });

  /// Check if the provided answer is correct using fuzzy matching
  /// Allows up to 2 character differences (Levenshtein distance)
  bool isCorrect(String answer) {
    final normalizedAnswer = answer.trim().toLowerCase();
    final normalizedExpected = expectedAnswer.trim().toLowerCase();
    
    // Exact match
    if (normalizedAnswer == normalizedExpected) {
      return true;
    }
    
    // Check alternative answers
    for (final alt in alternativeAnswers) {
      if (normalizedAnswer == alt.trim().toLowerCase()) {
        return true;
      }
    }
    
    // Fuzzy matching with Levenshtein distance <= 2
    final distance = _levenshteinDistance(normalizedAnswer, normalizedExpected);
    return distance <= 2;
  }

  /// Calculate Levenshtein distance between two strings
  int _levenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    List<int> previousRow = List.generate(s2.length + 1, (i) => i);
    
    for (int i = 0; i < s1.length; i++) {
      List<int> currentRow = [i + 1];
      
      for (int j = 0; j < s2.length; j++) {
        int insertions = previousRow[j + 1] + 1;
        int deletions = currentRow[j] + 1;
        int substitutions = previousRow[j] + (s1[i] != s2[j] ? 1 : 0);
        
        currentRow.add([insertions, deletions, substitutions].reduce((a, b) => a < b ? a : b));
      }
      
      previousRow = currentRow;
    }
    
    return previousRow.last;
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'prompt': prompt,
      'expectedAnswer': expectedAnswer,
      'alternativeAnswers': alternativeAnswers,
      'difficulty': difficulty.toString(),
      'data': data,
    };
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      type: ChallengeType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => ChallengeType.vocabulary,
      ),
      prompt: json['prompt'],
      expectedAnswer: json['expectedAnswer'],
      alternativeAnswers: List<String>.from(json['alternativeAnswers'] ?? []),
      difficulty: DifficultyLevel.values.firstWhere(
        (e) => e.toString() == json['difficulty'],
        orElse: () => DifficultyLevel.medium,
      ),
      data: Map<String, dynamic>.from(json['data'] ?? {}),
    );
  }

  Challenge copyWith({
    ChallengeType? type,
    String? prompt,
    String? expectedAnswer,
    List<String>? alternativeAnswers,
    DifficultyLevel? difficulty,
    Map<String, dynamic>? data,
  }) {
    return Challenge(
      type: type ?? this.type,
      prompt: prompt ?? this.prompt,
      expectedAnswer: expectedAnswer ?? this.expectedAnswer,
      alternativeAnswers: alternativeAnswers ?? this.alternativeAnswers,
      difficulty: difficulty ?? this.difficulty,
      data: data ?? this.data,
    );
  }
}
