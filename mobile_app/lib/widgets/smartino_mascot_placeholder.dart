import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Placeholder mascot widget until Rive animation is created
/// This provides basic animations (breathing, blinking, reactions)
/// Can be replaced with SmartinoRiveMascot when Rive file is ready
class SmartinoMascotPlaceholder extends StatefulWidget {
  final MascotMood mood;
  final VoidCallback? onTap;
  final double size;

  const SmartinoMascotPlaceholder({
    Key? key,
    this.mood = MascotMood.idle,
    this.onTap,
    this.size = 200,
  }) : super(key: key);

  @override
  State<SmartinoMascotPlaceholder> createState() =>
      _SmartinoMascotPlaceholderState();
}

class _SmartinoMascotPlaceholderState
    extends State<SmartinoMascotPlaceholder>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _blinkController;
  late AnimationController _bounceController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _blinkAnimation;
  late Animation<double> _bounceAnimation;

  bool _isBlinking = false;

  @override
  void initState() {
    super.initState();

    // Breathing animation (continuous)
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ),
    );

    // Blink animation (random)
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _blinkController,
        curve: Curves.easeInOut,
      ),
    );

    // Bounce animation (on tap)
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.elasticOut,
      ),
    );

    // Random blinking
    _startRandomBlinking();
  }

  void _startRandomBlinking() {
    Future.delayed(Duration(milliseconds: 2000 + math.Random().nextInt(3000)),
        () {
      if (mounted) {
        _blink();
        _startRandomBlinking();
      }
    });
  }

  void _blink() async {
    if (_isBlinking) return;
    _isBlinking = true;
    await _blinkController.forward();
    await _blinkController.reverse();
    _isBlinking = false;
  }

  void _handleTap() {
    _bounceController.forward().then((_) => _bounceController.reverse());
    widget.onTap?.call();
  }

  Color _getMoodColor() {
    switch (widget.mood) {
      case MascotMood.idle:
        return Colors.purple.shade400;
      case MascotMood.listening:
        return Colors.blue.shade400;
      case MascotMood.thinking:
        return Colors.orange.shade400;
      case MascotMood.happy:
        return Colors.green.shade400;
      case MascotMood.excited:
        return Colors.pink.shade400;
      case MascotMood.sad:
        return Colors.grey.shade400;
    }
  }

  IconData _getMoodIcon() {
    switch (widget.mood) {
      case MascotMood.idle:
        return Icons.face;
      case MascotMood.listening:
        return Icons.hearing;
      case MascotMood.thinking:
        return Icons.psychology;
      case MascotMood.happy:
        return Icons.sentiment_very_satisfied;
      case MascotMood.excited:
        return Icons.celebration;
      case MascotMood.sad:
        return Icons.sentiment_dissatisfied;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _breathingController,
          _blinkController,
          _bounceController,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _breathingAnimation.value * _bounceAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _getMoodColor().withOpacity(0.8),
                    _getMoodColor(),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getMoodColor().withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Main face icon
                  Icon(
                    _getMoodIcon(),
                    size: widget.size * 0.5,
                    color: Colors.white,
                  ),
                  // Eyes (blinking)
                  Positioned(
                    top: widget.size * 0.35,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Left eye
                        Transform.scale(
                          scaleY: _blinkAnimation.value,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Right eye
                        Transform.scale(
                          scaleY: _blinkAnimation.value,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Mood indicator text
                  Positioned(
                    bottom: widget.size * 0.1,
                    child: Text(
                      widget.mood.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _blinkController.dispose();
    _bounceController.dispose();
    super.dispose();
  }
}

/// Mascot mood states
enum MascotMood {
  idle,
  listening,
  thinking,
  happy,
  excited,
  sad,
}
