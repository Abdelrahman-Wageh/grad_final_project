import 'package:flutter/material.dart';

/// 🌈 Premium Kid-Friendly Theme for Smartino
/// An elevated, vibrant, and impressive visual experience
/// Designed for maximum engagement and delight
class PremiumKidTheme {
  // ============================================
  // VIBRANT COLOR PALETTE (High Saturation)
  // ============================================

  /// Vibrant Magenta (Eye-catching primary)
  static const Color vibrantMagenta = Color(0xFFFF006E);
  static const Color vibrantMagentaLight = Color(0xFFFF4D94);
  static const Color vibrantMagentaDark = Color(0xFFD60056);

  /// Brilliant Blue (Sky and calm)
  static const Color brilliantBlue = Color(0xFF0099FF);
  static const Color brilliantBlueLighter = Color(0xFF66D9FF);
  static const Color brilliantBlueDark = Color(0xFF0077CC);

  /// Sunny Yellow (Warm and inviting)
  static const Color sunnyYellow = Color(0xFFFFD60A);
  static const Color sunnyYellowLight = Color(0xFFFFE94D);
  static const Color sunnyYellowDark = Color(0xFFFFC300);

  /// Lime Green (Energy and growth)
  static const Color limeGreen = Color(0xFF39FF14);
  static const Color limeGreenDark = Color(0xFF2DD700);

  /// Hot Pink (Accent and highlights)
  static const Color hotPink = Color(0xFFFF10F0);
  static const Color hotPinkLight = Color(0xFFFF66FF);

  /// Electric Purple (Mystery and magic)
  static const Color electricPurple = Color(0xFFBB00FF);
  static const Color electricPurpleDark = Color(0xFF9900CC);

  /// Coral Orange (Fun and playful)
  static const Color coralOrange = Color(0xFFFF5E00);
  static const Color coralOrangeLight = Color(0xFFFF8C42);

  /// Turquoise (Cool and refreshing)
  static const Color turquoise = Color(0xFF00D9FF);
  static const Color turquoiseDark = Color(0xFF00B8D4);

  /// Background: Vibrant Cream
  static const Color premiumCream = Color(0xFFFFFAF0);
  static const Color premiumWhite = Color(0xFFFFFFFF);
  static const Color darkBg = Color(0xFF0F1419);

  /// Text colors
  static const Color textPrimary = Color(0xFF1A1F2E);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textOnVibrant = Color(0xFFFFFFFF);

  /// Semantic colors
  static const Color successBright = Color(0xFF39FF14);
  static const Color warningBright = Color(0xFFFFD60A);
  static const Color errorBright = Color(0xFFFF006E);
  static const Color infoBright = Color(0xFF0099FF);

  // ============================================
  // PREMIUM GRADIENTS
  // ============================================

  /// Vibrant Magenta to Pink gradient
  static const LinearGradient magentaPinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF006E),
      Color(0xFFFF4D94),
      Color(0xFFFF1493),
    ],
  );

  /// Blue to Turquoise gradient
  static const LinearGradient blueTurquoiseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0099FF),
      Color(0xFF00D9FF),
      Color(0xFF00FFD1),
    ],
  );

  /// Purple to Magenta gradient (Mystic)
  static const LinearGradient mysticPurpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFBB00FF),
      Color(0xFFFF006E),
      Color(0xFFFF1493),
    ],
  );

  /// Rainbow gradient (Ultra vibrant)
  static const LinearGradient rainbowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF006E),
      Color(0xFFFFD60A),
      Color(0xFF39FF14),
      Color(0xFF0099FF),
      Color(0xFFBB00FF),
    ],
  );

  /// Sunset gradient (Warm and playful)
  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF5E00),
      Color(0xFFFFD60A),
      Color(0xFFFF006E),
    ],
  );

  /// Golden gradient (Premium feel)
  static const LinearGradient goldenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFD60A),
      Color(0xFFFFC300),
      Color(0xFFFF8C42),
    ],
  );

  /// Cool blue gradient
  static const LinearGradient coolBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0099FF),
      Color(0xFF0077CC),
      Color(0xFF66D9FF),
    ],
  );

  // ============================================
  // PREMIUM THEME DATA
  // ============================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: vibrantMagenta,
        onPrimary: textOnVibrant,
        secondary: brilliantBlue,
        onSecondary: textOnVibrant,
        tertiary: sunnyYellow,
        error: errorBright,
        surface: premiumWhite,
        onSurface: textPrimary,
        background: premiumCream,
        onBackground: textPrimary,
      ),
      scaffoldBackgroundColor: premiumCream,
      
      // ========== TEXT THEME ==========
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w900,
          color: textPrimary,
          letterSpacing: -1.5,
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textSecondary,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textLight,
          letterSpacing: 0.4,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: 0.1,
        ),
      ),
      
      // ========== ELEVATED BUTTON THEME ==========
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: vibrantMagenta,
          foregroundColor: textOnVibrant,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: const Color(0xFFFF006E).withOpacity(0.4),
        ),
      ),
      
      // ========== TEXT BUTTON THEME ==========
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: vibrantMagenta,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      // ========== OUTLINED BUTTON THEME ==========
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: vibrantMagenta,
          side: const BorderSide(color: vibrantMagenta, width: 2.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      
      // ========== CARD THEME ==========
      cardTheme: CardThemeData(
        color: premiumWhite,
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(0),
      ),
      
      // ========== INPUT DECORATION THEME ==========
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F5F7),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: vibrantMagenta,
            width: 2.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: errorBright,
            width: 1.5,
          ),
        ),
        hintStyle: const TextStyle(
          color: textLight,
          fontSize: 16,
        ),
      ),
      
      // ========== CHIP THEME ==========
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF0F0F0),
        selectedColor: vibrantMagenta,
        disabledColor: const Color(0xFFE0E0E0),
        labelStyle: const TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: const TextStyle(
          color: textOnVibrant,
          fontWeight: FontWeight.w600,
        ),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // ========== APP BAR THEME ==========
      appBarTheme: AppBarTheme(
        backgroundColor: premiumWhite,
        foregroundColor: textPrimary,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        scrolledUnderElevation: 8,
      ),
      
      // ========== BOTTOM SHEET THEME ==========
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: premiumWhite,
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
      
      // ========== NAVIGATION THEME ==========
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: premiumWhite,
        elevation: 8,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: vibrantMagenta,
              );
            }
            return const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: textLight,
            );
          },
        ),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: vibrantMagenta, size: 28);
            }
            return const IconThemeData(color: textLight, size: 26);
          },
        ),
      ),
      
      // ========== FAB THEME ==========
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: vibrantMagenta,
        foregroundColor: textOnVibrant,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        sizeConstraints: const BoxConstraints(
          minHeight: 60,
          minWidth: 60,
          maxHeight: 60,
          maxWidth: 60,
        ),
      ),
      
      // ========== DIALOG THEME ==========
      dialogTheme: DialogThemeData(
        backgroundColor: premiumWhite,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // ========== PROGRESS INDICATOR THEME ==========
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: vibrantMagenta,
        linearTrackColor: Color(0xFFE0E0E0),
        circularTrackColor: Color(0xFFE0E0E0),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: vibrantMagenta,
        onPrimary: textOnVibrant,
        secondary: brilliantBlue,
        onSecondary: textOnVibrant,
        tertiary: sunnyYellow,
        error: errorBright,
        surface: darkBg,
        onSurface: premiumWhite,
        background: darkBg,
        onBackground: premiumWhite,
      ),
      scaffoldBackgroundColor: darkBg,
    );
  }

  // ============================================
  // UTILITY METHODS
  // ============================================

  /// Get a random vibrant color for variety
  static Color getRandomVibrantColor() {
    final colors = [
      vibrantMagenta,
      brilliantBlue,
      sunnyYellow,
      limeGreen,
      hotPink,
      electricPurple,
      coralOrange,
      turquoise,
    ];
    colors.shuffle();
    return colors.first;
  }

  /// Get gradient by name
  static LinearGradient? getGradientByName(String name) {
    switch (name.toLowerCase()) {
      case 'magenta':
        return magentaPinkGradient;
      case 'blue':
        return blueTurquoiseGradient;
      case 'purple':
        return mysticPurpleGradient;
      case 'rainbow':
        return rainbowGradient;
      case 'sunset':
        return sunsetGradient;
      case 'golden':
        return goldenGradient;
      case 'cool_blue':
        return coolBlueGradient;
      default:
        return magentaPinkGradient;
    }
  }
}
