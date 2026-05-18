/// Smartino Super-App - Color System
/// Egyptian-inspired color palette for the app
/// Requirements: 2.1, 2.2

import 'package:flutter/material.dart';

class SmartinoColors {
  // Primary Colors - Egyptian Blue & Gold
  static const Color primary = Color(0xFF2196F3); // Egyptian Blue
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF64B5F6);
  
  static const Color secondary = Color(0xFFFFB300); // Egyptian Gold
  static const Color secondaryDark = Color(0xFFF57C00);
  static const Color secondaryLight = Color(0xFFFFD54F);
  
  // Accent Colors - Vibrant & Playful
  static const Color accent = Color(0xFF9C27B0); // Purple
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentRed = Color(0xFFF44336);
  static const Color accentCyan = Color(0xFF00BCD4);
  static const Color accentPink = Color(0xFFE91E63);
  
  // Background Colors
  static const Color background = Color(0xFFF5F5DC); // Beige (Egyptian sand)
  static const Color backgroundLight = Color(0xFFFFFFF0); // Ivory
  static const Color backgroundDark = Color(0xFFE8E8D0);
  
  // Surface Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFFEEEEEE);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFF212121);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Game-Specific Colors
  static const Color gameCorrect = Color(0xFF4CAF50);
  static const Color gameIncorrect = Color(0xFFFF9800); // Orange instead of red
  static const Color gameNeutral = Color(0xFF9E9E9E);
  static const Color gameHighlight = Color(0xFFFFEB3B);
  
  // Star Colors
  static const Color starGold = Color(0xFFFFD700);
  static const Color starSilver = Color(0xFFC0C0C0);
  static const Color starBronze = Color(0xFFCD7F32);
  static const Color starEmpty = Color(0xFFE0E0E0);
  
  // Chapter Colors (for Journey Map)
  static const Color chapter1 = Color(0xFF4CAF50); // Green - Arabic Letters
  static const Color chapter2 = Color(0xFF2196F3); // Blue - English Letters
  static const Color chapter3 = Color(0xFFFF9800); // Orange - Arabic Words
  static const Color chapter4 = Color(0xFF9C27B0); // Purple - English Words
  static const Color chapter5 = Color(0xFFF44336); // Red - Numbers
  static const Color chapter6 = Color(0xFF00BCD4); // Cyan - Colors & Shapes
  static const Color chapter7 = Color(0xFFFFEB3B); // Yellow - Reading
  static const Color chapter8 = Color(0xFF795548); // Brown - Advanced
  
  // Farfour Character Colors
  static const Color farfourPrimary = Color(0xFF8B4513); // Brown
  static const Color farfourSecondary = Color(0xFFD2691E);
  static const Color farfourAccent = Color(0xFFFFD700);
  
  // Additional Colors (Missing)
  static const Color textLight = Color(0xFFFFFFFF); // White text
  static const Color encouragement = Color(0xFFFF9800); // Orange for encouragement
  static const Color gold = Color(0xFFFFD700); // Gold
  static const Color purple = Color(0xFF9C27B0); // Purple
  static const Color skyBlue = Color(0xFF87CEEB); // Sky Blue
  static const Color shadowColor = Color(0x33000000); // Shadow color
  
  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Additional Gradients (Missing)
  static const LinearGradient magicalSky = LinearGradient(
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient sunsetGlow = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient oceanBreeze = LinearGradient(
    colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient forestMist = LinearGradient(
    colors: [Color(0xFF134E5E), Color(0xFF71B280)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient lavenderDream = LinearGradient(
    colors: [Color(0xFFDA22FF), Color(0xFF9733EE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient galaxyGradient = LinearGradient(
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient oceanGradient = LinearGradient(
    colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient forestGradient = LinearGradient(
    colors: [Color(0xFF134E5E), Color(0xFF71B280)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
  
  // Overlay Colors
  static const Color overlayLight = Color(0x0A000000);
  static const Color overlayMedium = Color(0x1F000000);
  static const Color overlayDark = Color(0x33000000);
  
  // Helper Methods
  
  /// Get chapter color by ID
  static Color getChapterColor(String chapterId) {
    switch (chapterId) {
      case 'chapter_1':
        return chapter1;
      case 'chapter_2':
        return chapter2;
      case 'chapter_3':
        return chapter3;
      case 'chapter_4':
        return chapter4;
      case 'chapter_5':
        return chapter5;
      case 'chapter_6':
        return chapter6;
      case 'chapter_7':
        return chapter7;
      case 'chapter_8':
        return chapter8;
      default:
        return primary;
    }
  }
  
  /// Get gradient for chapter
  static LinearGradient getChapterGradient(String chapterId) {
    final color = getChapterColor(chapterId);
    return LinearGradient(
      colors: [color, color.withOpacity(0.7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  /// Get star color based on count
  static Color getStarColor(int stars) {
    switch (stars) {
      case 3:
        return starGold;
      case 2:
        return starSilver;
      case 1:
        return starBronze;
      default:
        return starEmpty;
    }
  }
  
  /// Get game result color
  static Color getGameResultColor(bool isCorrect) {
    return isCorrect ? gameCorrect : gameIncorrect;
  }
  
  /// Create a lighter shade of a color
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
  
  /// Create a darker shade of a color
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
  
  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
}
