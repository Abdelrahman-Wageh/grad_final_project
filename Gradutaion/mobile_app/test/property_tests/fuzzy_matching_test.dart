import 'package:flutter_test/flutter_test.dart';
import 'package:smartino/utils/fuzzy_matcher.dart';
import 'test_generators.dart';

/// Property-Based Tests for Fuzzy Matching
/// **Feature: smartino-transformation, Property 16: Fuzzy Matching Tolerance**
/// **Validates: Requirements 20.2**
void main() {
  group('Property 16: Fuzzy Matching Tolerance', () {
    test('Property: Identical strings always match', () {
      // Run 100 iterations with random inputs
      for (int i = 0; i < 100; i++) {
        final word = TestGenerators.randomString(minLength: 3, maxLength: 15);

        final matches = FuzzyMatcher.matches(word, word);

        // Property: Identical strings should always match
        expect(
          matches,
          true,
          reason: 'Identical strings should always match',
        );
      }
    });

    test('Property: Empty strings do not match non-empty', () {
      // Run 100 iterations
      for (int i = 0; i < 100; i++) {
        final word = TestGenerators.randomString(minLength: 1, maxLength: 15);

        final matches = FuzzyMatcher.matches('', word);

        // Property: Empty string should not match non-empty
        expect(
          matches,
          false,
          reason: 'Empty string should not match non-empty string',
        );
      }
    });

    test('Property: Single character difference matches', () {
      // Run 100 iterations
      for (int i = 0; i < 100; i++) {
        final word = TestGenerators.randomString(minLength: 3, maxLength: 15);
        // Create variant with one character changed
        final chars = word.split('');
        if (chars.isNotEmpty) {
          chars[0] = chars[0] == 'a' ? 'b' : 'a';
          final variant = chars.join();

          final matches = FuzzyMatcher.matches(word, variant);

          // Property: Single character difference should match (distance <= 2)
          expect(
            matches,
            true,
            reason: 'Single character difference should match',
          );
        }
      }
    });

    test('Property: Case insensitive matching', () {
      // Run 100 iterations
      for (int i = 0; i < 100; i++) {
        final word = TestGenerators.randomString(minLength: 3, maxLength: 15);
        final uppercase = word.toUpperCase();
        final lowercase = word.toLowerCase();

        final matches = FuzzyMatcher.matches(uppercase, lowercase);

        // Property: Case should not affect matching
        expect(
          matches,
          true,
          reason: 'Matching should be case insensitive',
        );
      }
    });

    test('Property: Matching is symmetric', () {
      // Run 100 iterations
      for (int i = 0; i < 100; i++) {
        final word1 = TestGenerators.randomString(minLength: 3, maxLength: 15);
        final word2 = TestGenerators.randomString(minLength: 3, maxLength: 15);

        final matches1 = FuzzyMatcher.matches(word1, word2);
        final matches2 = FuzzyMatcher.matches(word2, word1);

        // Property: Matching should be symmetric
        expect(
          matches1,
          matches2,
          reason: 'Fuzzy matching should be symmetric',
        );
      }
    });

    test('Property: Distance is non-negative', () {
      // Run 100 iterations
      for (int i = 0; i < 100; i++) {
        final word1 = TestGenerators.randomString(minLength: 1, maxLength: 15);
        final word2 = TestGenerators.randomString(minLength: 1, maxLength: 15);

        final distance = FuzzyMatcher.levenshteinDistance(word1, word2);

        // Property: Distance should always be non-negative
        expect(
          distance >= 0,
          true,
          reason: 'Levenshtein distance should be non-negative',
        );
      }
    });

    test('Property: Distance is zero for identical strings', () {
      // Run 100 iterations
      for (int i = 0; i < 100; i++) {
        final word = TestGenerators.randomString(minLength: 1, maxLength: 15);

        final distance = FuzzyMatcher.levenshteinDistance(word, word);

        // Property: Distance should be zero for identical strings
        expect(
          distance,
          0,
          reason: 'Distance should be zero for identical strings',
        );
      }
    });

    test('Property: Distance satisfies triangle inequality', () {
      // Run 100 iterations
      for (int i = 0; i < 100; i++) {
        final word1 = TestGenerators.randomString(minLength: 1, maxLength: 10);
        final word2 = TestGenerators.randomString(minLength: 1, maxLength: 10);
        final word3 = TestGenerators.randomString(minLength: 1, maxLength: 10);

        final d12 = FuzzyMatcher.levenshteinDistance(word1, word2);
        final d23 = FuzzyMatcher.levenshteinDistance(word2, word3);
        final d13 = FuzzyMatcher.levenshteinDistance(word1, word3);

        // Property: Triangle inequality d(a,c) <= d(a,b) + d(b,c)
        expect(
          d13 <= d12 + d23,
          true,
          reason: 'Distance should satisfy triangle inequality',
        );
      }
    });
  });
}
