/// Smartino Super-App - Typography System
/// Arabic and English text styles
/// Requirements: 2.1, 2.2

import 'package:flutter/material.dart';
import 'smartino_colors.dart';

class SmartinoTypography {
  // Display Styles - Large headings
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.textPrimary,
    height: 1.2,
  );
  
  // Headline Styles - Section headings
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.textPrimary,
    height: 1.3,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.textPrimary,
    height: 1.3,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.textPrimary,
    height: 1.3,
  );
  
  // Title Styles - Card titles, dialog titles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: SmartinoColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: SmartinoColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: SmartinoColors.textPrimary,
    height: 1.4,
  );
  
  // Body Styles - Regular text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: SmartinoColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: SmartinoColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: SmartinoColors.textPrimary,
    height: 1.5,
  );
  
  // Label Styles - Buttons, chips, small labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: SmartinoColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.5,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: SmartinoColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.5,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: SmartinoColors.textPrimary,
    height: 1.4,
    letterSpacing: 0.5,
  );
  
  // Arabic-Specific Styles (larger for readability)
  static const TextStyle arabicDisplayLarge = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle arabicDisplayMedium = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle arabicHeadline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle arabicTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: SmartinoColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle arabicBody = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: SmartinoColors.textPrimary,
    height: 1.6,
  );
  
  // Game-Specific Styles
  static const TextStyle gameTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.2,
    shadows: [
      Shadow(
        color: SmartinoColors.shadowDark,
        offset: Offset(2, 2),
        blurRadius: 4,
      ),
    ],
  );
  
  static const TextStyle gameScore = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.secondary,
    height: 1.2,
  );
  
  static const TextStyle gameInstruction = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: SmartinoColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle gameFeedback = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.success,
    height: 1.3,
  );
  
  // Button Styles
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 0.5,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 0.5,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 0.5,
  );
  
  // Farfour Speech Bubble
  static const TextStyle farfourSpeech = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: SmartinoColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle farfourSpeechArabic = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: SmartinoColors.textPrimary,
    height: 1.5,
  );
  
  // Helper Methods
  
  /// Get text style with custom color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
  
  /// Get text style with custom size
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
  
  /// Get text style with custom weight
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
  
  /// Get text style with shadow
  static TextStyle withShadow(TextStyle style, {
    Color color = SmartinoColors.shadowMedium,
    Offset offset = const Offset(2, 2),
    double blurRadius = 4,
  }) {
    return style.copyWith(
      shadows: [
        Shadow(
          color: color,
          offset: offset,
          blurRadius: blurRadius,
        ),
      ],
    );
  }
  
  /// Get text style for white text (on colored backgrounds)
  static TextStyle onPrimary(TextStyle style) {
    return style.copyWith(color: SmartinoColors.textOnPrimary);
  }
  
  /// Get text style for dark text (on light backgrounds)
  static TextStyle onSecondary(TextStyle style) {
    return style.copyWith(color: SmartinoColors.textOnSecondary);
  }
  
  /// Get responsive text size based on screen width
  static double getResponsiveSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) {
      return baseSize * 0.9; // Small phones
    } else if (width > 600) {
      return baseSize * 1.1; // Tablets
    }
    return baseSize; // Normal phones
  }
  
  /// Get text style for specific language
  static TextStyle forLanguage(String language, TextStyle baseStyle) {
    if (language == 'ar' || language == 'arabic') {
      // Arabic needs larger size and more line height
      return baseStyle.copyWith(
        fontSize: (baseStyle.fontSize ?? 14) * 1.15,
        height: (baseStyle.height ?? 1.5) * 1.1,
      );
    }
    return baseStyle;
  }
}
