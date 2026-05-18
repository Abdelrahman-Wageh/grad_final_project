import 'package:flutter/material.dart';

/// 🌲 Whispering Woods - Magical Theme
/// 
/// A child-friendly theme with:
/// - High contrast colors for visibility
/// - Soft gradients for magical feel
/// - Large touch targets for small fingers
/// - Rounded corners everywhere (Disney-quality polish)
class AppTheme {
  // ============================================
  // MAGICAL COLOR PALETTE
  // ============================================
  
  /// Primary: Magical Purple (enchanted forest)
  static const Color magicalPurple = Color(0xFF7B2CBF);
  static const Color magicalPurpleLight = Color(0xFF9D4EDD);
  static const Color magicalPurpleDark = Color(0xFF5A189A);
  
  /// Secondary: Sunny Yellow (warm and welcoming)
  static const Color sunnyYellow = Color(0xFFFFBE0B);
  static const Color sunnyYellowLight = Color(0xFFFFC93C);
  static const Color sunnyYellowDark = Color(0xFFFB8500);
  
  /// Accent: Leaf Green (nature and growth)
  static const Color leafGreen = Color(0xFF06D6A0);
  static const Color leafGreenLight = Color(0xFF4ECDC4);
  static const Color leafGreenDark = Color(0xFF118AB2);
  
  /// Background: Soft cream (easy on eyes)
  static const Color softCream = Color(0xFFFFF8F0);
  static const Color softWhite = Color(0xFFFFFBF5);
  
  /// Text colors
  static const Color textDark = Color(0xFF2D3142);
  static const Color textMedium = Color(0xFF4F5D75);
  static const Color textLight = Color(0xFF8B95A8);
  
  /// Semantic colors
  static const Color success = Color(0xFF06D6A0);
  static const Color warning = Color(0xFFFFBE0B);
  static const Color error = Color(0xFFEF476F);
  static const Color info = Color(0xFF118AB2);
  
  // ============================================
  // GRADIENTS
  // ============================================
  
  /// Magical gradient (purple to pink)
  static const LinearGradient magicalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7B2CBF),
      Color(0xFF9D4EDD),
      Color(0xFFC77DFF),
    ],
  );
  
  /// Sunny gradient (yellow to orange)
  static const LinearGradient sunnyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFBE0B),
      Color(0xFFFB8500),
      Color(0xFFFF9E00),
    ],
  );
  
  /// Forest gradient (green to teal)
  static const LinearGradient forestGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF06D6A0),
      Color(0xFF4ECDC4),
      Color(0xFF118AB2),
    ],
  );
  
  /// Sky gradient (light blue to purple)
  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF89CFF0),
      Color(0xFFC77DFF),
    ],
  );
  
  // ============================================
  // THEME DATA
  // ============================================
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: magicalPurple,
        secondary: sunnyYellow,
        tertiary: leafGreen,
        surface: softCream,
        error: error,
        onPrimary: Colors.white,
        onSecondary: textDark,
        onSurface: textDark,
        onError: Colors.white,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: softCream,
      
      // App bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: magicalPurple,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(
          color: magicalPurple,
          size: 28,
        ),
      ),
      
      // Text theme
      textTheme: const TextTheme(
        // Headlines
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: magicalPurple,
          letterSpacing: 1.5,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: magicalPurple,
          letterSpacing: 1.3,
          height: 1.2,
        ),
        displaySmall: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: magicalPurple,
          letterSpacing: 1.2,
          height: 1.2,
        ),
        
        // Titles
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textDark,
          letterSpacing: 1.0,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textDark,
          letterSpacing: 0.8,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textDark,
          letterSpacing: 0.5,
        ),
        
        // Body text
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textDark,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textMedium,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textLight,
          height: 1.4,
        ),
        
        // Labels
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textDark,
          letterSpacing: 0.5,
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textMedium,
          letterSpacing: 0.3,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textLight,
          letterSpacing: 0.2,
        ),
      ),
      
      // Elevated button (primary action buttons)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: magicalPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
          shadowColor: magicalPurple.withOpacity(0.4),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
          minimumSize: const Size(120, 56), // Large touch target
        ),
      ),
      
      // Outlined button (secondary actions)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: magicalPurple,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          side: const BorderSide(
            color: magicalPurple,
            width: 2,
          ),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
          minimumSize: const Size(120, 56),
        ),
      ),
      
      // Text button (tertiary actions)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: magicalPurple,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // Floating action button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: sunnyYellow,
        foregroundColor: textDark,
        elevation: 12,
        shape: CircleBorder(),
        iconSize: 32,
      ),
      
      // Card
      cardTheme: CardThemeData(
        color: softWhite,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: const EdgeInsets.all(12),
      ),
      
      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: softWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: magicalPurpleLight,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: magicalPurpleLight.withOpacity(0.5),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: magicalPurple,
            width: 3,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: error,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textMedium,
        ),
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textLight.withOpacity(0.7),
        ),
      ),
      
      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: softWhite,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: magicalPurple,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 16,
          color: textDark,
          height: 1.5,
        ),
      ),
      
      // Bottom sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: softWhite,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(32),
          ),
        ),
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textDark,
        contentTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 8,
      ),
      
      // Progress indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: magicalPurple,
        linearTrackColor: magicalPurpleLight,
        circularTrackColor: magicalPurpleLight,
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: textLight.withOpacity(0.2),
        thickness: 1,
        space: 24,
      ),
    );
  }
  
  // ============================================
  // CUSTOM DECORATIONS
  // ============================================
  
  /// Magical card decoration with gradient
  static BoxDecoration magicalCard({
    Gradient? gradient,
    double borderRadius = 24,
  }) {
    return BoxDecoration(
      gradient: gradient ?? magicalGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: magicalPurple.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
  
  /// Floating island decoration (for bottom nav)
  static BoxDecoration floatingIsland() {
    return BoxDecoration(
      color: softWhite,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(32),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, -5),
        ),
      ],
    );
  }
  
  /// Game card decoration
  static BoxDecoration gameCard(Gradient gradient) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}
