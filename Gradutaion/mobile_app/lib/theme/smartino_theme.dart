import 'package:flutter/material.dart';
import 'smartino_colors.dart';
import 'smartino_text_styles.dart';

/// Smartino theme configuration
/// Implements Requirements: 25.1, 25.2, 25.6 (Disney-Quality UI)
class SmartinoTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: SmartinoColors.purple,
        primary: SmartinoColors.purple,
        secondary: SmartinoColors.yellow,
        surface: Colors.white,
        background: const Color(0xFFFFF8F0),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFF8F0),
      fontFamily: 'Cairo', // Arabic-friendly font
      textTheme: TextTheme(
        displayLarge: SmartinoTextStyles.heading1,
        displayMedium: SmartinoTextStyles.heading2,
        displaySmall: SmartinoTextStyles.heading3,
        bodyLarge: SmartinoTextStyles.body,
        bodyMedium: SmartinoTextStyles.bodySmall,
        labelLarge: SmartinoTextStyles.button,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          elevation: 8,
          textStyle: SmartinoTextStyles.button,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        titleTextStyle: SmartinoTextStyles.heading2.copyWith(
          color: SmartinoColors.purple,
        ),
      ),
    );
  }
}
