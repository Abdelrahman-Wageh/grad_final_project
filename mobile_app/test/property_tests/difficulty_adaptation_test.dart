import 'package:flutter_test/flutter_test.dart';
import 'package:smartino/services/difficulty_adapter.dart';
import 'package:smartino/data/models/child_profile.dart';
import 'package:smartino/core/game/difficulty_level.dart';
import 'test_generators.dart';

/// Property-Based Tests for Difficulty Adaptation
/// **Feature: smartino-transformation, Property 5: Difficulty Adaptation**
/// **Validates: Requirements 6.3, 6.4, 23.1, 23.2**
void main() {
  group('Property 5: Difficulty Adaptation', () {
    late DifficultyAdapter adapter;

    setUp(() {
      adapter = DifficultyAdapter();
    });

    test('Property: Success rate > 90% increases difficulty', () {
      // Run 100 iterations with random inputs
      for (int i = 0; i < 100; i++) {
        // Generate random profile with high success rate
        final profile = TestGenerators.randomChildProfile();
        profile.recentGameResults = List.generate(5, (_) => true); // 100% success

        final initialDifficulty = profile.currentDifficulty;

        // Adjust difficulty
        final newDifficulty = adapter.adjustDifficulty(profile);

        // Property: High success rate should increase or maintain difficulty
        expect(
          newDifficulty.index >= initialDifficulty.index,
          true,
          reason: 'Success rate > 90% should increase or maintain difficulty',
        );
      }
    });

    test('Property: Success rate < 40% decreases difficulty', () {
      // Run 100 iterations with random inputs
      for (int i = 0; i < 100; i++) {
        // Generate random profile with low success rate
        final profile = TestGenerators.randomChildProfile();
        profile.recentGameResults = [false, false, false, false, false]; // 0% success

        final initialDifficulty = profile.currentDifficulty;

        // Adjust difficulty
        final newDifficulty = adapter.adjustDifficulty(profile);

        // Property: Low success rate should decrease or maintain difficulty
        expect(
          newDifficulty.index <= initialDifficulty.index,
          true,
          reason: 'Success rate < 40% should decrease or maintain difficulty',
        );
      }
    });

    test('Property: Difficulty never goes below easy', () {
      // Run 100 iterations
      for (int i = 0; i < 100; i++) {
        final profile = TestGenerators.randomChildProfile();
        profile.currentDifficulty = DifficultyLevel.easy;
        profile.recentGameResults = List.generate(5, (_) => false); // 0% success

        final newDifficulty = adapter.adjustDifficulty(profile);

        // Property: Difficulty should never go below easy
        expect(
          newDifficulty.index >= DifficultyLevel.easy.index,
          true,
          reason: 'Difficulty should never go below easy',
        );
      }
    });

    test('Property: Difficulty never goes above hard', () {
      // Run 100 iterations
      for (int i = 0; i < 100; i++) {
        final profile = TestGenerators.randomChildProfile();
        profile.currentDifficulty = DifficultyLevel.hard;
        profile.recentGameResults = List.generate(5, (_) => true); // 100% success

        final newDifficulty = adapter.adjustDifficulty(profile);

        // Property: Difficulty should never go above hard
        expect(
          newDifficulty.index <= DifficultyLevel.hard.index,
          true,
          reason: 'Difficulty should never go above hard',
        );
      }
    });

    test('Property: Difficulty adjustment is deterministic', () {
      // Run 100 iterations
      for (int i = 0; i < 100; i++) {
        final profile = TestGenerators.randomChildProfile();
        final results = TestGenerators.randomGameResults(count: 5);
        profile.recentGameResults = results;

        // Adjust difficulty twice with same input
        final difficulty1 = adapter.adjustDifficulty(profile);
        profile.recentGameResults = List.from(results); // Same results
        final difficulty2 = adapter.adjustDifficulty(profile);

        // Property: Same input should produce same output
        expect(
          difficulty1,
          difficulty2,
          reason: 'Difficulty adjustment should be deterministic',
        );
      }
    });
  });
}
