import 'package:flutter_test/flutter_test.dart';
import 'package:smartino/services/spaced_repetition_manager.dart';
import 'package:smartino/models/spaced_repetition_card.dart';
import 'test_generators.dart';

/// Property-Based Tests for Spaced Repetition
/// **Feature: smartino-transformation, Property 13: Spaced Repetition Interval Correctness**
/// **Validates: Requirements 22.1**
void main() {
  group('Property 13: Spaced Repetition Interval Correctness', () {
    late SpacedRepetitionManager manager;

    setUp(() {
      manager = SpacedRepetitionManager();
    });

    test('Property: Correct answer increases interval', () {
      // Run 100 iterations with random inputs
      for (int i = 0; i < 100; i++) {
        final card = TestGenerators.randomSpacedRepetitionCard();
        final initialInterval = card.interval;

        // Update with good quality (4 or 5)
        final quality = TestGenerators.randomInt(min: 4, max: 5);
        final updatedCard = manager.updateCard(card, quality);

        // Property: Good quality should increase interval
        expect(
          updatedCard.interval >= initialInterval,
          true,
          reason: 'Correct answer should increase or maintain interval',
        );
      }
    });

    test('Property: Incorrect answer resets interval', () {
      // Run 100 iterations with random inputs
      for (int i = 0; i < 100; i++) {
        final card = TestGenerators.randomSpacedRepetitionCard();
        card.interval = TestGenerators.randomInt(min: 10, max: 100);

        // Update with poor quality (0, 1, or 2)
        final quality = TestGenerators.randomInt(min: 0, max: 2);
        final updatedCard = manager.updateCard(card, quality);

        // Property: Poor quality should reset interval to 1
        expect(
          updatedCard.interval,
          1,
          reason: 'Incorrect answer should reset interval to 1',
        );
      }
    });

    test('Property: Ease factor stays within bounds', () {
      // Run 100 iterations with random inputs
      for (int i = 0; i < 100; i++) {
        final card = TestGenerators.randomSpacedRepetitionCard();
        final quality = TestGenerators.randomInt(min: 0, max: 5);

        final updatedCard = manager.updateCard(card, quality);

        // Property: Ease factor should stay >= 1.3
        expect(
          updatedCard.easeFactor >= 1.3,
          true,
          reason: 'Ease factor should never go below 1.3',
        );
      }
    });

    test('Property: Repetitions increase on success', () {
      // Run 100 iterations with random inputs
      for (int i = 0; i < 100; i++) {
        final card = TestGenerators.randomSpacedRepetitionCard();
        final initialReps = card.repetitions;

        // Update with quality >= 3 (success)
        final quality = TestGenerators.randomInt(min: 3, max: 5);
        final updatedCard = manager.updateCard(card, quality);

        // Property: Success should increase repetitions
        expect(
          updatedCard.repetitions >= initialReps,
          true,
          reason: 'Success should increase repetitions',
        );
      }
    });

    test('Property: Repetitions reset on failure', () {
      // Run 100 iterations with random inputs
      for (int i = 0; i < 100; i++) {
        final card = TestGenerators.randomSpacedRepetitionCard();
        card.repetitions = TestGenerators.randomInt(min: 5, max: 20);

        // Update with quality < 3 (failure)
        final quality = TestGenerators.randomInt(min: 0, max: 2);
        final updatedCard = manager.updateCard(card, quality);

        // Property: Failure should reset repetitions to 0
        expect(
          updatedCard.repetitions,
          0,
          reason: 'Failure should reset repetitions to 0',
        );
      }
    });

    test('Property: Next review date is in the future', () {
      // Run 100 iterations with random inputs
      for (int i = 0; i < 100; i++) {
        final card = TestGenerators.randomSpacedRepetitionCard();
        final quality = TestGenerators.randomInt(min: 0, max: 5);

        final now = DateTime.now();
        final updatedCard = manager.updateCard(card, quality);

        // Property: Next review should be in the future
        expect(
          updatedCard.nextReview.isAfter(now) || updatedCard.nextReview.isAtSameMomentAs(now),
          true,
          reason: 'Next review should be in the future or now',
        );
      }
    });

    test('Property: SM-2 algorithm is deterministic', () {
      // Run 100 iterations
      for (int i = 0; i < 100; i++) {
        final card = TestGenerators.randomSpacedRepetitionCard();
        final quality = TestGenerators.randomInt(min: 0, max: 5);

        // Update twice with same input
        final updated1 = manager.updateCard(card, quality);
        final updated2 = manager.updateCard(card, quality);

        // Property: Same input should produce same output
        expect(updated1.interval, updated2.interval);
        expect(updated1.easeFactor, updated2.easeFactor);
        expect(updated1.repetitions, updated2.repetitions);
      }
    });
  });
}
