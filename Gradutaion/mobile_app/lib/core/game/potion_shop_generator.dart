import 'dart:math';
import 'dart:ui';
import 'level_generator.dart';
import 'potion_shop_level.dart';
import 'difficulty_level.dart';
import '../../data/models/child_profile.dart';

/// Procedural generator for Potion Shop levels
/// Requirements: 18.3, 21.4, 21.5
class PotionShopGenerator extends LevelGenerator<PotionShopLevel> {
  // Vibrant potion colors
  static const List<Color> potionColors = [
    Color(0xFFE74C3C), // Red
    Color(0xFF3498DB), // Blue
    Color(0xFF2ECC71), // Green
    Color(0xFFF39C12), // Orange
    Color(0xFF9B59B6), // Purple
    Color(0xFFF1C40F), // Yellow
    Color(0xFFE91E63), // Pink
    Color(0xFF00BCD4), // Cyan
  ];

  PotionShopGenerator({super.random});

  @override
  PotionShopLevel generateLevel(
    DifficultyLevel difficulty,
    ChildProfile profile,
  ) {
    // Requirement 21.4: Generate math problems based on difficulty
    final maxNumber = difficulty.maxNumber;
    String operation = '+';
    int potionA, potionB, target;

    switch (difficulty) {
      case DifficultyLevel.easy:
        // Easy: addition up to 10
        potionA = random.nextInt(maxNumber) + 1;
        potionB = random.nextInt(maxNumber - potionA + 1);
        target = potionA + potionB;
        operation = '+';
        break;

      case DifficultyLevel.medium:
        // Medium: addition up to 20
        potionA = random.nextInt(maxNumber) + 1;
        potionB = random.nextInt(maxNumber - potionA + 1);
        target = potionA + potionB;
        operation = '+';
        break;

      case DifficultyLevel.hard:
        // Hard: subtraction, multiplication
        if (random.nextBool()) {
          // Subtraction
          potionA = random.nextInt(maxNumber) + 1;
          potionB = random.nextInt(potionA) + 1;
          target = potionA - potionB;
          operation = '-';
        } else {
          // Multiplication (small numbers)
          potionA = random.nextInt(10) + 1;
          potionB = random.nextInt(10) + 1;
          target = potionA * potionB;
          operation = '*';
        }
        break;
    }

    // Requirement 21.5: Assign random colors to potions
    final colorA = _randomColor();
    final colorB = _randomColor();
    final resultColor = _mixColors(colorA, colorB);

    return PotionShopLevel(
      id: generateLevelId(),
      difficulty: difficulty,
      potionA: potionA,
      potionB: potionB,
      target: target,
      operation: operation,
      colorA: colorA,
      colorB: colorB,
      resultColor: resultColor,
    );
  }

  @override
  bool validateLevel(PotionShopLevel level) {
    return level.validate();
  }

  /// Get random potion color
  Color _randomColor() {
    return potionColors[random.nextInt(potionColors.length)];
  }

  /// Mix two colors (simple blend)
  Color _mixColors(Color a, Color b) {
    return Color.fromARGB(
      255,
      ((a.red + b.red) / 2).round(),
      ((a.green + b.green) / 2).round(),
      ((a.blue + b.blue) / 2).round(),
    );
  }

  /// Generate level with specific parameters (for testing)
  PotionShopLevel generateCustomLevel({
    required DifficultyLevel difficulty,
    required int potionA,
    required int potionB,
    required String operation,
  }) {
    int target;
    switch (operation) {
      case '+':
        target = potionA + potionB;
        break;
      case '-':
        target = potionA - potionB;
        break;
      case '*':
        target = potionA * potionB;
        break;
      default:
        target = potionA + potionB;
    }

    final colorA = _randomColor();
    final colorB = _randomColor();
    final resultColor = _mixColors(colorA, colorB);

    return PotionShopLevel(
      id: generateLevelId(),
      difficulty: difficulty,
      potionA: potionA,
      potionB: potionB,
      target: target,
      operation: operation,
      colorA: colorA,
      colorB: colorB,
      resultColor: resultColor,
    );
  }
}
