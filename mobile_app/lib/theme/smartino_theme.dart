/// Smartino Super-App - Theme Configuration
/// Complete theme with Egyptian-inspired design
/// Requirements: 2.1, 2.2, 25.1, 25.2, 25.6

import 'package:flutter/material.dart';
import 'smartino_colors.dart';
import 'smartino_typography.dart';

class SmartinoTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: SmartinoColors.primary,
        primaryContainer: SmartinoColors.primaryLight,
        secondary: SmartinoColors.secondary,
        secondaryContainer: SmartinoColors.secondaryLight,
        surface: SmartinoColors.surface,
        background: SmartinoColors.background,
        error: SmartinoColors.error,
        onPrimary: SmartinoColors.textOnPrimary,
        onSecondary: SmartinoColors.textOnSecondary,
        onSurface: SmartinoColors.textPrimary,
        onBackground: SmartinoColors.textPrimary,
        onError: Colors.white,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: SmartinoColors.background,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: SmartinoColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: SmartinoTypography.headlineMedium.copyWith(
          color: Colors.white,
        ),
      ),
      
      // Card
      cardTheme: const CardThemeData(
        elevation: 4,
        color: SmartinoColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        shadowColor: SmartinoColors.shadowMedium,
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SmartinoColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          textStyle: SmartinoTypography.buttonMedium,
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: SmartinoColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: SmartinoTypography.buttonMedium,
        ),
      ),
      
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SmartinoColors.primary,
          side: const BorderSide(color: SmartinoColors.primary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: SmartinoTypography.buttonMedium,
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SmartinoColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SmartinoColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: SmartinoColors.textHint),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SmartinoColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SmartinoColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: SmartinoTypography.bodyMedium.copyWith(
          color: SmartinoColors.textHint,
        ),
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: SmartinoColors.secondary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: SmartinoColors.primaryLight,
        labelStyle: SmartinoTypography.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Dialog
      dialogTheme: const DialogThemeData(
        backgroundColor: SmartinoColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        elevation: 8,
        titleTextStyle: SmartinoTypography.headlineMedium,
        contentTextStyle: SmartinoTypography.bodyMedium,
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: SmartinoColors.textPrimary,
        contentTextStyle: SmartinoTypography.bodyMedium.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: SmartinoColors.primary,
        linearTrackColor: SmartinoColors.primaryLight,
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: SmartinoColors.textHint.withOpacity(0.3),
        thickness: 1,
        space: 16,
      ),
      
      // Icon
      iconTheme: const IconThemeData(
        color: SmartinoColors.textPrimary,
        size: 24,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: SmartinoTypography.displayLarge,
        displayMedium: SmartinoTypography.displayMedium,
        displaySmall: SmartinoTypography.displaySmall,
        headlineLarge: SmartinoTypography.headlineLarge,
        headlineMedium: SmartinoTypography.headlineMedium,
        headlineSmall: SmartinoTypography.headlineSmall,
        titleLarge: SmartinoTypography.titleLarge,
        titleMedium: SmartinoTypography.titleMedium,
        titleSmall: SmartinoTypography.titleSmall,
        bodyLarge: SmartinoTypography.bodyLarge,
        bodyMedium: SmartinoTypography.bodyMedium,
        bodySmall: SmartinoTypography.bodySmall,
        labelLarge: SmartinoTypography.labelLarge,
        labelMedium: SmartinoTypography.labelMedium,
        labelSmall: SmartinoTypography.labelSmall,
      ),
    );
  }
}
