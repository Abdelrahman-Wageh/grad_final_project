# Smartino UI/UX Design System

## Overview
This document defines the unified design language for Smartino, blending the best visual elements from Antura, Singles, and current Smartino into a cohesive, world-class educational experience.

---

## 1. Design Philosophy

### 1.1 Core Principles
1. **Playful Yet Educational**: Fun without sacrificing learning value
2. **Juicy Interactions**: Every tap, swipe, and action feels satisfying
3. **Child-First**: Designed for 4-8 year olds (minimal text, maximum visuals)
4. **Culturally Relevant**: Egyptian Arabic context and aesthetics
5. **Accessible**: Works for all children, including those with disabilities

### 1.2 Design Inspiration Sources

```
┌─────────────────────────────────────────────────────────────┐
│                    SMARTINO DESIGN DNA                       │
├─────────────────────────────────────────────────────────────┤
│  Antura          Singles         Current         Disney      │
│  ┌────────┐     ┌────────┐     ┌────────┐     ┌────────┐  │
│  │Playful │     │Polished│     │Modern  │     │Magical │  │
│  │Colors  │  +  │Minimal │  +  │Clean   │  +  │Juicy   │  │
│  │Rewards │     │UI      │     │Smooth  │     │Delight │  │
│  └────────┘     └────────┘     └────────┘     └────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Color System

### 2.1 Primary Palette

```dart
// lib/theme/colors.dart

class SmartinoColors {
  // Primary Colors (from Antura + modernized)
  static const Color primary = Color(0xFF6B4CE6);      // Purple (Farfour's collar)
  static const Color primaryLight = Color(0xFF9B7EF7);
  static const Color primaryDark = Color(0xFF4A2FB8);
  
  // Secondary Colors
  static const Color secondary = Color(0xFFFFB800);    // Golden yellow (rewards)
  static const Color secondaryLight = Color(0xFFFFD54F);
  static const Color secondaryDark = Color(0xFFF57C00);
  
  // Accent Colors (from Singles - clean and modern)
  static const Color accent = Color(0xFF00BFA5);       // Teal (success)
  static const Color accentPink = Color(0xFFFF4081);   // Pink (playful)
  static const Color accentOrange = Color(0xFFFF6E40); // Orange (energy)
  
  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Neutral Colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F5);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textDisabled = Color(0xFFBDC3C7);
  
  // Game-Specific Colors
  static const Color gameRed = Color(0xFFE74C3C);
  static const Color gameBlue = Color(0xFF3498DB);
  static const Color gameGreen = Color(0xFF2ECC71);
  static const Color gameYellow = Color(0xFFF1C40F);
  static const Color gamePurple = Color(0xFF9B59B6);
}
```

### 2.2 Color Usage Guidelines

| Context | Primary | Secondary | Accent |
|---------|---------|-----------|--------|
| Buttons | Purple | Yellow | Teal |
| Success | Green | Yellow | - |
| Rewards | Yellow | Purple | - |
| Games | Varies | Yellow | - |
| Farfour | Purple | Yellow | - |

---

## 3. Typography

### 3.1 Font System

```dart
// lib/theme/typography.dart

class SmartinoTypography {
  // Font Families
  static const String primaryFont = 'Cairo';      // Arabic-friendly
  static const String secondaryFont = 'Poppins';  // English
  static const String displayFont = 'Baloo';      // Playful headers
  
  // Font Sizes (scaled for children)
  static const double displayLarge = 48.0;   // Titles
  static const double displayMedium = 36.0;  // Section headers
  static const double displaySmall = 28.0;   // Card titles
  
  static const double headlineLarge = 24.0;  // Game titles
  static const double headlineMedium = 20.0; // Subtitles
  static const double headlineSmall = 18.0;  // Labels
  
  static const double bodyLarge = 16.0;      // Body text
  static const double bodyMedium = 14.0;     // Secondary text
  static const double bodySmall = 12.0;      // Captions
  
  // Font Weights
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight regular = FontWeight.w400;
  
  // Text Styles
  static TextStyle get displayLargeStyle => TextStyle(
    fontFamily: displayFont,
    fontSize: displayLarge,
    fontWeight: bold,
    color: SmartinoColors.textPrimary,
    height: 1.2,
  );
  
  static TextStyle get headlineLargeStyle => TextStyle(
    fontFamily: primaryFont,
    fontSize: headlineLarge,
    fontWeight: semiBold,
    color: SmartinoColors.textPrimary,
    height: 1.3,
  );
  
  static TextStyle get bodyLargeStyle => TextStyle(
    fontFamily: primaryFont,
    fontSize: bodyLarge,
    fontWeight: regular,
    color: SmartinoColors.textPrimary,
    height: 1.5,
  );
}
```

### 3.2 Typography Guidelines
- **Minimal Text**: Use icons and images whenever possible
- **Large Sizes**: Children need bigger text (16px minimum)
- **High Contrast**: Ensure readability (WCAG AA minimum)
- **RTL Support**: All text supports right-to-left for Arabic

---

## 4. Component Library

### 4.1 Buttons

```dart
// lib/widgets/common/smartino_button.dart

class SmartinoButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final SmartinoButtonStyle style;
  final IconData? icon;
  final bool isLoading;
  
  const SmartinoButton({
    required this.text,
    required this.onPressed,
    this.style = SmartinoButtonStyle.primary,
    this.icon,
    this.isLoading = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getButtonStyle(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 24),
              const SizedBox(width: 8),
            ],
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Text(text, style: SmartinoTypography.headlineMediumStyle),
          ],
        ),
      ),
    ).animate()
      .scale(duration: 200.ms, curve: Curves.easeOut)
      .then()
      .shimmer(duration: 300.ms);
  }
  
  ButtonStyle _getButtonStyle() {
    switch (style) {
      case SmartinoButtonStyle.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: SmartinoColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        );
      case SmartinoButtonStyle.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: SmartinoColors.secondary,
          foregroundColor: SmartinoColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        );
      case SmartinoButtonStyle.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: SmartinoColors.primary,
          side: const BorderSide(color: SmartinoColors.primary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
    }
  }
}

enum SmartinoButtonStyle { primary, secondary, outline }
```

### 4.2 Cards

```dart
// lib/widgets/common/smartino_card.dart

class SmartinoCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double elevation;
  final EdgeInsets padding;
  
  const SmartinoCard({
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.elevation = 4,
    this.padding = const EdgeInsets.all(16),
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? SmartinoColors.surface,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    ).animate()
      .fadeIn(duration: 300.ms)
      .scale(begin: const Offset(0.95, 0.95), duration: 300.ms);
  }
}
```

