import 'package:flutter/material.dart';
import 'confetti_celebration.dart';

/// Celebration animations for game feedback
/// Shows success and encouragement messages with animations
class CelebrationAnimations {
  /// Show success celebration
  static void showSuccess(
    BuildContext context, {
    required String message,
    VoidCallback? onComplete,
  }) {
    // Show snackbar with success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Call onComplete after delay
    if (onComplete != null) {
      Future.delayed(const Duration(seconds: 2), onComplete);
    }
  }

  /// Show encouragement message
  static void showEncouragement(
    BuildContext context, {
    required String message,
    VoidCallback? onComplete,
  }) {
    // Show snackbar with encouragement message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Call onComplete after delay
    if (onComplete != null) {
      Future.delayed(const Duration(seconds: 2), onComplete);
    }
  }
}

