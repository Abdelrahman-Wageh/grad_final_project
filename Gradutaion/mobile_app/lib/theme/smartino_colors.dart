/// Smartino Color Palette
/// 
/// High-contrast, vibrant colors optimized for children aged 4-8.
/// Follows Disney/Pixar color theory for magical, engaging experiences.
/// 
/// Requirements: 25.2 (High-contrast colors)

import 'package:flutter/material.dart';

class SmartinoColors {
  // Primary vibrant colors
  static const Color red = Color(0xFFFF4757);
  static const Color yellow = Color(0xFFFFC312);
  static const Color blue = Color(0xFF1E90FF);
  static const Color green = Color(0xFF2ECC71);
  static const Color purple = Color(0xFF9B59B6);
  static const Color pink = Color(0xFFFF6B9D);
  static const Color orange = Color(0xFFFF8C42);
  
  // Magical gradients
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient sunsetGlow = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient oceanGradient = LinearGradient(
    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient oceanBreeze = LinearGradient(
    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient forestGradient = LinearGradient(
    colors: [Color(0xFF56AB2F), Color(0xFFA8E063)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient forestMist = LinearGradient(
    colors: [Color(0xFF56AB2F), Color(0xFFA8E063)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient galaxyGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient magicalSky = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient candyGradient = LinearGradient(
    colors: [Color(0xFFFF6B9D), Color(0xFFC44569)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient lavenderDream = LinearGradient(
    colors: [Color(0xFF9B59B6), Color(0xFFE056FD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Background colors
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF2C3E50);
  
  // UI element colors
  static const Color cardBackground = Colors.white;
  static const Color shadowColor = Color(0x1A000000);
  
  // Success/Error colors (always positive)
  static const Color success = Color(0xFF2ECC71);
  static const Color encouragement = Color(0xFFFF8C42); // Never "error" - always "try again"
  
  // Text colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Colors.white;
  
  // Star/reward colors
  static const Color starGold = Color(0xFFFFD700);
  static const Color treasureGold = Color(0xFFFFA500);
  
  /// Get a random vibrant color for variety
  static Color getRandomVibrant() {
    final colors = [red, yellow, blue, green, purple, pink, orange];
    return colors[DateTime.now().millisecond % colors.length];
  }
  
  /// Get a random magical gradient
  static LinearGradient getRandomGradient() {
    final gradients = [
      sunsetGradient,
      oceanGradient,
      forestGradient,
      galaxyGradient,
      candyGradient,
    ];
    return gradients[DateTime.now().millisecond % gradients.length];
  }
}
