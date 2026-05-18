import 'dart:ui';
import 'level.dart';
import 'difficulty_level.dart';

/// Potion Shop game level
/// Requirements: 18.3, 21.1-21.5
class PotionShopLevel extends Level {
  final int potionA;
  final int potionB;
  final int target;
  final String operation; // '+', '-', '*'
  final Color colorA;
  final Color colorB;
  final Color? resultColor;

  PotionShopLevel({
    required super.id,
    required super.difficulty,
    required this.potionA,
    required this.potionB,
    required this.target,
    required this.operation,
    required this.colorA,
    required this.colorB,
    this.resultColor,
    super.createdAt,
  });

  @override
  bool validate() {
    // Validate math equation
    switch (operation) {
      case '+':
        return potionA + potionB == target;
      case '-':
        return potionA - potionB == target;
      case '*':
        return potionA * potionB == target;
      default:
        return false;
    }
  }

  /// Check if user's answer is correct
  bool checkAnswer(int userAnswer) {
    return userAnswer == target;
  }

  /// Get the equation as a string
  String getEquation() {
    return '$potionA $operation $potionB = ?';
  }

  /// Get the solution
  String getSolution() {
    return '$potionA $operation $potionB = $target';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'difficulty': difficulty.name,
      'potionA': potionA,
      'potionB': potionB,
      'target': target,
      'operation': operation,
      'colorA': colorA.value,
      'colorB': colorB.value,
      'resultColor': resultColor?.value,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PotionShopLevel.fromJson(Map<String, dynamic> json) {
    return PotionShopLevel(
      id: json['id'] as String,
      difficulty: DifficultyLevel.values.firstWhere(
        (d) => d.name == json['difficulty'],
      ),
      potionA: json['potionA'] as int,
      potionB: json['potionB'] as int,
      target: json['target'] as int,
      operation: json['operation'] as String,
      colorA: Color(json['colorA'] as int),
      colorB: Color(json['colorB'] as int),
      resultColor:
          json['resultColor'] != null ? Color(json['resultColor'] as int) : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Get level statistics
  Map<String, dynamic> getStats() {
    return {
      'potionA': potionA,
      'potionB': potionB,
      'target': target,
      'operation': operation,
      'difficulty': difficulty.displayName,
    };
  }
}
