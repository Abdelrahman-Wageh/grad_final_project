import 'dart:math';
import 'package:smartino/data/models/child_profile.dart';
import 'package:smartino/models/spaced_repetition_card.dart';
import 'package:smartino/core/game/difficulty_level.dart';

/// Random generators for property-based testing
/// Implements Requirements: Task 32 (Property-Based Tests)
class TestGenerators {
  static final Random _random = Random();

  /// Generate random string
  static String randomString({int minLength = 1, int maxLength = 20}) {
    final length = minLength + _random.nextInt(maxLength - minLength + 1);
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(_random.nextInt(chars.length)),
      ),
    );
  }

  /// Generate random Arabic string
  static String randomArabicString({int minLength = 1, int maxLength = 20}) {
    final length = minLength + _random.nextInt(maxLength - minLength + 1);
    const arabicChars = 'ابتثجحخدذرزسشصضطظعغفقكلمنهوي';
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => arabicChars.codeUnitAt(_random.nextInt(arabicChars.length)),
      ),
    );
  }

  /// Generate random integer
  static int randomInt({int min = 0, int max = 100}) {
    return min + _random.nextInt(max - min + 1);
  }

  /// Generate random double
  static double randomDouble({double min = 0.0, double max = 1.0}) {
    return min + _random.nextDouble() * (max - min);
  }

  /// Generate random boolean
  static bool randomBool() {
    return _random.nextBool();
  }

  /// Generate random difficulty level
  static DifficultyLevel randomDifficultyLevel() {
    final levels = DifficultyLevel.values;
    return levels[_random.nextInt(levels.length)];
  }

  /// Generate random child profile
  static ChildProfile randomChildProfile() {
    return ChildProfile(
      id: randomString(minLength: 5, maxLength: 10),
      name: randomArabicString(minLength: 3, maxLength: 15),
      age: randomInt(min: 4, max: 8),
      level: randomString(minLength: 3, maxLength: 5),
      assessment: randomString(minLength: 5, maxLength: 15),
      totalStars: randomInt(min: 0, max: 1000),
      masteredConcepts: List.generate(
        randomInt(min: 0, max: 50),
        (_) => randomString(minLength: 3, maxLength: 10),
      ),
      unlockedItems: List.generate(
        randomInt(min: 0, max: 20),
        (_) => randomString(minLength: 3, maxLength: 10),
      ),
      totalPlayTimeMinutes: randomInt(min: 0, max: 10000),
      currentDifficulty: randomDifficultyLevel(),
      recentGameResults: List.generate(
        randomInt(min: 0, max: 10),
        (_) => randomBool(),
      ),
    );
  }

  /// Generate random spaced repetition card
  static SpacedRepetitionCard randomSpacedRepetitionCard() {
    return SpacedRepetitionCard(
      id: randomString(minLength: 5, maxLength: 10),
      profileId: randomString(minLength: 5, maxLength: 10),
      concept: randomString(minLength: 3, maxLength: 20),
      repetitions: randomInt(min: 0, max: 10),
      interval: randomInt(min: 1, max: 365),
      easeFactor: randomDouble(min: 1.3, max: 2.5),
      nextReview: DateTime.now().add(
        Duration(days: randomInt(min: 0, max: 365)),
      ),
    );
  }

  /// Generate list of random items
  static List<T> randomList<T>(T Function() generator, {int minLength = 0, int maxLength = 10}) {
    final length = minLength + _random.nextInt(maxLength - minLength + 1);
    return List.generate(length, (_) => generator());
  }

  /// Generate random grid position
  static (int, int) randomGridPosition({int maxX = 10, int maxY = 10}) {
    return (randomInt(min: 0, max: maxX - 1), randomInt(min: 0, max: maxY - 1));
  }

  /// Generate random math problem
  static (int, int, int) randomMathProblem({int maxNumber = 20}) {
    final a = randomInt(min: 1, max: maxNumber);
    final b = randomInt(min: 1, max: maxNumber);
    final result = a + b;
    return (a, b, result);
  }

  /// Generate random success rate (0.0 to 1.0)
  static double randomSuccessRate() {
    return randomDouble(min: 0.0, max: 1.0);
  }

  /// Generate random game results
  static List<bool> randomGameResults({int count = 5}) {
    return List.generate(count, (_) => randomBool());
  }
}
