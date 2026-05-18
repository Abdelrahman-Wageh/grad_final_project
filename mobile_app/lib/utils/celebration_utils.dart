/// Smartino Super-App - Celebration Utilities
/// Confetti, animations, and celebration effects
/// Requirements: 2.5

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'dart:math';

class CelebrationUtils {
  static final Random _random = Random();
  
  /// Show confetti celebration
  static void showConfetti(
    BuildContext context,
    ConfettiController controller, {
    Duration duration = const Duration(seconds: 3),
  }) {
    controller.play();
    Future.delayed(duration, () {
      if (controller.state == ConfettiControllerState.playing) {
        controller.stop();
      }
    });
  }
  
  /// Create confetti widget overlay
  static Widget createConfettiOverlay({
    required ConfettiController controller,
    Alignment alignment = Alignment.topCenter,
    BlastDirectionality blastDirectionality = BlastDirectionality.explosive, // Use enum instead of double
    int numberOfParticles = 20,
    double gravity = 0.1,
  }) {
    return Align(
      alignment: alignment,
      child: ConfettiWidget(
        confettiController: controller,
        blastDirectionality: blastDirectionality,
        numberOfParticles: numberOfParticles,
        gravity: gravity,
        emissionFrequency: 0.05,
        colors: const [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
          Colors.orange,
          Colors.pink,
        ],
        createParticlePath: _createStarPath,
      ),
    );
  }
  
  /// Create star-shaped confetti path
  static Path _createStarPath(Size size) {
    final path = Path();
    final double width = size.width;
    final double height = size.height;
    
    path.moveTo(width * 0.5, 0);
    path.lineTo(width * 0.61, height * 0.35);
    path.lineTo(width, height * 0.35);
    path.lineTo(width * 0.68, height * 0.57);
    path.lineTo(width * 0.79, height * 0.91);
    path.lineTo(width * 0.5, height * 0.7);
    path.lineTo(width * 0.21, height * 0.91);
    path.lineTo(width * 0.32, height * 0.57);
    path.lineTo(0, height * 0.35);
    path.lineTo(width * 0.39, height * 0.35);
    path.close();
    
    return path;
  }
  
  /// Show success animation with haptic feedback
  static Future<void> celebrateSuccess(
    BuildContext context, {
    String message = 'رائع! 🌟',
    bool showConfetti = true,
    bool enableHaptic = true,
  }) async {
    // Haptic feedback
    if (enableHaptic) {
      await _successHaptic();
    }
    
    // Show snackbar with animation
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.celebration, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
  
  /// Show star animation for earning stars
  static Future<void> celebrateStars(
    BuildContext context,
    int stars, {
    bool enableHaptic = true,
  }) async {
    if (enableHaptic) {
      await _starHaptic(stars);
    }
    
    final starEmoji = '⭐' * stars;
    await celebrateSuccess(
      context,
      message: 'حصلت على $starEmoji!',
      showConfetti: stars >= 3,
      enableHaptic: false, // Already done above
    );
  }
  
  /// Show encouragement for trying again
  static Future<void> showEncouragement(
    BuildContext context, {
    String message = 'حاول تاني! أنت قريب جداً! 💪',
    bool enableHaptic = true,
  }) async {
    if (enableHaptic) {
      await _encouragementHaptic();
    }
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.emoji_emotions, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
  
  /// Haptic feedback for success
  static Future<void> _successHaptic() async {
    try {
      HapticFeedback.heavyImpact();
      await Vibration.vibrate(
        pattern: [0, 100, 50, 100, 50, 200],
        intensities: [0, 128, 0, 128, 0, 255],
      );
    } catch (e) {
      // Vibration not supported
    }
  }
  
  /// Haptic feedback for stars
  static Future<void> _starHaptic(int stars) async {
    try {
      for (int i = 0; i < stars; i++) {
        HapticFeedback.mediumImpact();
        await Vibration.vibrate(duration: 100);
        await Future.delayed(const Duration(milliseconds: 150));
      }
    } catch (e) {
      // Vibration not supported
    }
  }
  
  /// Haptic feedback for encouragement
  static Future<void> _encouragementHaptic() async {
    try {
      HapticFeedback.lightImpact();
      await Vibration.vibrate(duration: 50);
    } catch (e) {
      // Vibration not supported
    }
  }
  
  /// Create floating star animation
  static Widget createFloatingStars({
    required int count,
    required Duration duration,
  }) {
    return Stack(
      children: List.generate(count, (index) {
        return _FloatingStar(
          delay: Duration(milliseconds: index * 200),
          duration: duration,
        );
      }),
    );
  }
  
  /// Show floating stars animation
  static Future<void> showFloatingStars(
    BuildContext context, {
    int count = 5,
    Duration duration = const Duration(seconds: 2),
  }) async {
    // This would typically be shown as an overlay
    // For now, just show a celebration
    await celebrateSuccess(context, message: '⭐ رائع! ⭐');
  }
  
  /// Show celebration with confetti
  static Future<void> showCelebration(
    BuildContext context, {
    String message = 'مبروك! 🎉',
    bool showConfetti = true,
  }) async {
    await celebrateSuccess(
      context,
      message: message,
      showConfetti: showConfetti,
    );
  }
}

/// Floating star widget for animations
class _FloatingStar extends StatefulWidget {
  final Duration delay;
  final Duration duration;
  
  const _FloatingStar({
    required this.delay,
    required this.duration,
  });

  @override
  State<_FloatingStar> createState() => _FloatingStarState();
}

class _FloatingStarState extends State<_FloatingStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late double _startX;
  
  @override
  void initState() {
    super.initState();
    
    _startX = Random().nextDouble();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _positionAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
    ));
    
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: MediaQuery.of(context).size.width * _startX,
          bottom: MediaQuery.of(context).size.height * _positionAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: const Icon(
                Icons.star,
                color: Colors.amber,
                size: 40,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Celebration dialog for major achievements
class CelebrationDialog extends StatelessWidget {
  final String title;
  final String message;
  final int stars;
  final VoidCallback? onContinue;
  
  const CelebrationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.stars,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.celebration,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < stars ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onContinue?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'استمر',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
