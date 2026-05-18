import 'dart:math';

/// Fuzzy matching utility using Levenshtein distance
/// Requirements: 20.2
class FuzzyMatcher {
  /// Calculate Levenshtein distance between two strings
  /// Returns the minimum number of single-character edits needed
  static int levenshteinDistance(String s1, String s2) {
    // Normalize strings (lowercase, trim)
    final str1 = s1.toLowerCase().trim();
    final str2 = s2.toLowerCase().trim();

    if (str1 == str2) return 0;
    if (str1.isEmpty) return str2.length;
    if (str2.isEmpty) return str1.length;

    // Create distance matrix
    final matrix = List.generate(
      str1.length + 1,
      (i) => List.filled(str2.length + 1, 0),
    );

    // Initialize first row and column
    for (int i = 0; i <= str1.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= str2.length; j++) {
      matrix[0][j] = j;
    }

    // Fill matrix
    for (int i = 1; i <= str1.length; i++) {
      for (int j = 1; j <= str2.length; j++) {
        final cost = str1[i - 1] == str2[j - 1] ? 0 : 1;

        matrix[i][j] = min(
          min(
            matrix[i - 1][j] + 1, // deletion
            matrix[i][j - 1] + 1, // insertion
          ),
          matrix[i - 1][j - 1] + cost, // substitution
        );
      }
    }

    return matrix[str1.length][str2.length];
  }

  /// Check if two strings match within tolerance
  /// Requirement 20.2: Accept answers within distance ≤ 2
  static bool matches(String input, String target, {int tolerance = 2}) {
    final distance = levenshteinDistance(input, target);
    return distance <= tolerance;
  }

  /// Find all matching words from a list
  static List<String> findMatches(
    String input,
    List<String> candidates, {
    int tolerance = 2,
  }) {
    return candidates
        .where((candidate) => matches(input, candidate, tolerance: tolerance))
        .toList();
  }

  /// Get the best match from a list of candidates
  /// Returns null if no match within tolerance
  static String? getBestMatch(
    String input,
    List<String> candidates, {
    int tolerance = 2,
  }) {
    if (candidates.isEmpty) return null;

    String? bestMatch;
    int bestDistance = tolerance + 1;

    for (final candidate in candidates) {
      final distance = levenshteinDistance(input, candidate);
      if (distance < bestDistance) {
        bestDistance = distance;
        bestMatch = candidate;
      }
    }

    return bestDistance <= tolerance ? bestMatch : null;
  }

  /// Normalize Arabic text for better matching
  static String normalizeArabic(String text) {
    return text
        .toLowerCase()
        .trim()
        // Remove Arabic diacritics
        .replaceAll(RegExp(r'[\u064B-\u065F]'), '')
        // Normalize Alef variations
        .replaceAll(RegExp(r'[إأآا]'), 'ا')
        // Normalize Teh Marbuta
        .replaceAll('ة', 'ه');
  }

  /// Check if input matches target with Arabic normalization
  static bool matchesArabic(String input, String target, {int tolerance = 2}) {
    final normalizedInput = normalizeArabic(input);
    final normalizedTarget = normalizeArabic(target);
    return matches(normalizedInput, normalizedTarget, tolerance: tolerance);
  }

  /// Calculate similarity percentage (0.0 to 1.0)
  static double similarity(String s1, String s2) {
    final maxLength = max(s1.length, s2.length);
    if (maxLength == 0) return 1.0;

    final distance = levenshteinDistance(s1, s2);
    return 1.0 - (distance / maxLength);
  }

  /// Check if input is phonetically similar (simple heuristic)
  static bool isPhoneticallyClose(String input, String target) {
    // Remove vowels for phonetic comparison
    final consonantsInput = input
        .toLowerCase()
        .replaceAll(RegExp(r'[aeiouAEIOU]'), '')
        .trim();
    final consonantsTarget = target
        .toLowerCase()
        .replaceAll(RegExp(r'[aeiouAEIOU]'), '')
        .trim();

    return levenshteinDistance(consonantsInput, consonantsTarget) <= 1;
  }
}
