/// Smartino Typography System
/// 
/// Large, readable fonts optimized for children aged 4-8.
/// Follows accessibility guidelines with high contrast and clear hierarchy.
/// 
/// Requirements: 25.6 (Large, readable typography)

import 'package:flutter/material.dart';
import 'smartino_colors.dart';

class SmartinoTextStyles {
  // Font family (using system default for now, can be customized)
  static const String fontFamily = 'Poppins'; // Rounded, friendly font
  
  // Heading 1 - Main titles
  static const TextStyle heading1 = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.textPrimary,
    height: 1.2,
    letterSpacing: 0.5,
  );
  
  // Heading 2 - Section titles
  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.textPrimary,
    height: 1.3,
    letterSpacing: 0.3,
  );
  
  // Heading 3 - Subsection titles
  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: SmartinoColors.textPrimary,
    height: 1.3,
  );
  
  // Body text - Main content
  static const TextStyle body = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: SmartinoColors.textPrimary,
    height: 1.5,
  );
  
  // Body large - Emphasized content
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: SmartinoColors.textPrimary,
    height: 1.5,
  );
  
  // Body small - Secondary content
  static const TextStyle bodySmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: SmartinoColors.textSecondary,
    height: 1.4,
  );
  
  // Button text - Call to action
  static const TextStyle button = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.textLight,
    height: 1.2,
    letterSpacing: 0.5,
  );
  
  // Button large - Primary actions
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.textLight,
    height: 1.2,
    letterSpacing: 0.5,
  );
  
  // Caption - Small labels
  static const TextStyle caption = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: SmartinoColors.textSecondary,
    height: 1.3,
  );
  
  // Success message - Positive feedback
  static const TextStyle success = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.success,
    height: 1.3,
  );
  
  // Encouragement message - Try again feedback
  static const TextStyle encouragement = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: SmartinoColors.encouragement,
    height: 1.3,
  );
  
  // Star count - Achievement display
  static const TextStyle starCount = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: SmartinoColors.starGold,
    height: 1.2,
  );
  
  // Mascot speech - Smartino dialogue
  static const TextStyle mascotSpeech = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: SmartinoColors.textPrimary,
    height: 1.5,
    fontStyle: FontStyle.italic,
  );
  
  /// Create a custom text style with gradient
  static TextStyle withGradient(TextStyle base, LinearGradient gradient) {
    return base.copyWith(
      foreground: Paint()
        ..shader = gradient.createShader(
          const Rect.fromLTWH(0, 0, 200, 70),
        ),
    );
  }
  
  /// Create a text style with shadow for emphasis
  static TextStyle withShadow(TextStyle base) {
    return base.copyWith(
      shadows: [
        Shadow(
          color: SmartinoColors.shadowColor,
          offset: const Offset(2, 2),
          blurRadius: 4,
        ),
      ],
    );
  }
}
