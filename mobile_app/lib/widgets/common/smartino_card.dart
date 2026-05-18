/// Smartino Super-App - Card Component
/// Reusable card with Egyptian-inspired design
/// Requirements: 2.1, 2.2

import 'package:flutter/material.dart';
import '../../theme/smartino_colors.dart';

enum SmartinoCardType {
  elevated,
  outlined,
  filled,
  gradient,
}

class SmartinoCard extends StatelessWidget {
  final Widget child;
  final SmartinoCardType type;
  final Color? color;
  final LinearGradient? gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final double elevation;
  final Border? border;
  
  const SmartinoCard({
    super.key,
    required this.child,
    this.type = SmartinoCardType.elevated,
    this.color,
    this.gradient,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
    this.elevation = 4,
    this.border,
  });
  
  /// Create an elevated card (default)
  factory SmartinoCard.elevated({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    double elevation = 4,
  }) {
    return SmartinoCard(
      type: SmartinoCardType.elevated,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      borderRadius: borderRadius,
      onTap: onTap,
      elevation: elevation,
      child: child,
    );
  }
  
  /// Create an outlined card
  factory SmartinoCard.outlined({
    required Widget child,
    Color? borderColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
  }) {
    return SmartinoCard(
      type: SmartinoCardType.outlined,
      border: Border.all(
        color: borderColor ?? SmartinoColors.primary,
        width: 2,
      ),
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      borderRadius: borderRadius,
      onTap: onTap,
      child: child,
    );
  }
  
  /// Create a filled card with solid color
  factory SmartinoCard.filled({
    required Widget child,
    required Color color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
  }) {
    return SmartinoCard(
      type: SmartinoCardType.filled,
      color: color,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      borderRadius: borderRadius,
      onTap: onTap,
      child: child,
    );
  }
  
  /// Create a gradient card
  factory SmartinoCard.gradient({
    required Widget child,
    required LinearGradient gradient,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
  }) {
    return SmartinoCard(
      type: SmartinoCardType.gradient,
      gradient: gradient,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      borderRadius: borderRadius,
      onTap: onTap,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);
    final effectivePadding = padding ?? const EdgeInsets.all(16);
    
    Widget cardContent = Container(
      width: width,
      height: height,
      padding: effectivePadding,
      decoration: _getDecoration(effectiveBorderRadius),
      child: child,
    );
    
    if (onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: cardContent,
        ),
      );
    }
    
    if (type == SmartinoCardType.elevated) {
      cardContent = Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: effectiveBorderRadius,
        ),
        margin: EdgeInsets.zero,
        child: cardContent,
      );
    }
    
    if (margin != null) {
      cardContent = Padding(
        padding: margin!,
        child: cardContent,
      );
    }
    
    return cardContent;
  }
  
  BoxDecoration _getDecoration(BorderRadius borderRadius) {
    switch (type) {
      case SmartinoCardType.elevated:
        return BoxDecoration(
          color: color ?? SmartinoColors.surface,
          borderRadius: borderRadius,
        );
        
      case SmartinoCardType.outlined:
        return BoxDecoration(
          color: color ?? Colors.transparent,
          borderRadius: borderRadius,
          border: border,
        );
        
      case SmartinoCardType.filled:
        return BoxDecoration(
          color: color ?? SmartinoColors.primary,
          borderRadius: borderRadius,
        );
        
      case SmartinoCardType.gradient:
        return BoxDecoration(
          gradient: gradient ?? SmartinoColors.primaryGradient,
          borderRadius: borderRadius,
        );
    }
  }
}

/// Chapter Card - Specialized card for journey map chapters
class ChapterCard extends StatelessWidget {
  final String chapterId;
  final String titleAr;
  final String titleEn;
  final String icon;
  final double completion;
  final VoidCallback? onTap;
  final Widget? child;
  
  const ChapterCard({
    super.key,
    required this.chapterId,
    required this.titleAr,
    required this.titleEn,
    required this.icon,
    required this.completion,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final chapterColor = SmartinoColors.getChapterColor(chapterId);
    
    return SmartinoCard.gradient(
      gradient: LinearGradient(
        colors: [chapterColor, chapterColor.withOpacity(0.7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleAr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      titleEn,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: completion,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 6,
            ),
          ),
          if (child != null) ...[
            const SizedBox(height: 12),
            child!,
          ],
        ],
      ),
    );
  }
}

/// Game Card - Specialized card for game selection
class GameCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isLocked;
  final int? stars;
  
  const GameCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.onTap,
    this.isLocked = false,
    this.stars,
  });

  @override
  Widget build(BuildContext context) {
    return SmartinoCard.gradient(
      gradient: LinearGradient(
        colors: [color, color.withOpacity(0.7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      onTap: isLocked ? null : onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: isLocked
                  ? const Icon(Icons.lock, size: 40, color: Colors.grey)
                  : Text(icon, style: const TextStyle(fontSize: 48)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (stars != null && stars! > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  index < stars! ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}
