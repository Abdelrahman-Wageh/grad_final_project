import 'dart:math';
import 'package:flutter/material.dart';

/// Treasure chest opening animation with sparkles
/// 
/// Shows a chest that opens to reveal the unlocked item
/// with magical sparkle effects.
/// 
/// Requirements: 5.1
class TreasureChestAnimation extends StatefulWidget {
  final String treasureName;
  final VoidCallback? onComplete;

  const TreasureChestAnimation({
    Key? key,
    required this.treasureName,
    this.onComplete,
  }) : super(key: key);

  @override
  _TreasureChestAnimationState createState() => _TreasureChestAnimationState();
}

class _TreasureChestAnimationState extends State<TreasureChestAnimation>
    with TickerProviderStateMixin {
  late AnimationController _openController;
  late AnimationController _sparkleController;
  late Animation<double> _openAnimation;
  late Animation<double> _revealAnimation;

  @override
  void initState() {
    super.initState();

    // Chest opening animation
    _openController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _openAnimation = CurvedAnimation(
      parent: _openController,
      curve: Curves.easeOutBack,
    );

    _revealAnimation = CurvedAnimation(
      parent: _openController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    // Sparkle animation (continuous)
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Start animation
    _openController.forward();

    // Complete callback
    _openController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 2), () {
          widget.onComplete?.call();
        });
      }
    });
  }

  @override
  void dispose() {
    _openController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: Listenable.merge([_openController, _sparkleController]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Sparkles
              ..._buildSparkles(),

              // Chest
              _buildChest(),

              // Revealed treasure
              _buildRevealedTreasure(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChest() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.brown[700],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Chest body
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.brown[600]!,
                    Colors.brown[800]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Chest lid (opens)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateX(-_openAnimation.value * pi / 2),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.brown[500]!,
                      Colors.brown[700]!,
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  border: Border.all(color: Colors.amber, width: 3),
                ),
                child: Center(
                  child: Icon(
                    Icons.lock,
                    color: Colors.amber,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevealedTreasure() {
    return Opacity(
      opacity: _revealAnimation.value,
      child: Transform.scale(
        scale: _revealAnimation.value,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎁',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 16),
              Text(
                'You unlocked:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.treasureName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSparkles() {
    final sparkles = <Widget>[];
    final random = Random(42); // Fixed seed for consistent positions

    for (int i = 0; i < 20; i++) {
      final angle = (i / 20) * 2 * pi;
      final distance = 150 + random.nextDouble() * 50;
      final delay = random.nextDouble();

      final sparkleProgress = (_sparkleController.value + delay) % 1.0;
      final opacity = sparkleProgress < 0.5
          ? sparkleProgress * 2
          : (1.0 - sparkleProgress) * 2;

      sparkles.add(
        Positioned(
          left: MediaQuery.of(context).size.width / 2 +
              cos(angle) * distance * _revealAnimation.value,
          top: MediaQuery.of(context).size.height / 2 +
              sin(angle) * distance * _revealAnimation.value,
          child: Opacity(
            opacity: opacity * _revealAnimation.value,
            child: Icon(
              Icons.star,
              color: Colors.amber,
              size: 16 + random.nextDouble() * 16,
            ),
          ),
        ),
      );
    }

    return sparkles;
  }
}
