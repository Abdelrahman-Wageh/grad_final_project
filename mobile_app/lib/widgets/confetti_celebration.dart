import 'dart:math';
import 'package:flutter/material.dart';

/// Explosive confetti animation for treasure unlocks
/// 
/// Creates 50 colorful particles that explode from the center
/// with physics-based motion and rotation.
/// 
/// Requirements: 25.4
class ConfettiCelebration extends StatefulWidget {
  final Widget child;
  final bool isActive;
  final VoidCallback? onComplete;

  const ConfettiCelebration({
    Key? key,
    required this.child,
    this.isActive = false,
    this.onComplete,
  }) : super(key: key);

  @override
  _ConfettiCelebrationState createState() => _ConfettiCelebrationState();
}

class _ConfettiCelebrationState extends State<ConfettiCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = [];
  final Random _random = Random();

  // 5 vibrant colors
  static const List<Color> COLORS = [
    Color(0xFFFF6B6B), // Red
    Color(0xFFFECA57), // Yellow
    Color(0xFF48DBFB), // Blue
    Color(0xFF1DD1A1), // Green
    Color(0xFFEE5A6F), // Pink
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _generateParticles();
  }

  @override
  void didUpdateWidget(ConfettiCelebration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _generateParticles();
      _controller.forward(from: 0.0);
    }
  }

  void _generateParticles() {
    _particles.clear();
    
    // Generate 50 particles
    for (int i = 0; i < 50; i++) {
      _particles.add(ConfettiParticle(
        color: COLORS[_random.nextInt(COLORS.length)],
        angle: _random.nextDouble() * 2 * pi,
        velocity: 200 + _random.nextDouble() * 200, // 200-400 pixels/sec
        size: 8 + _random.nextDouble() * 8, // 8-16 pixels
        rotationSpeed: (_random.nextDouble() - 0.5) * 10, // -5 to 5 rad/sec
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isActive)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: ConfettiPainter(
                    particles: _particles,
                    progress: _controller.value,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Individual confetti particle
class ConfettiParticle {
  final Color color;
  final double angle;
  final double velocity;
  final double size;
  final double rotationSpeed;

  ConfettiParticle({
    required this.color,
    required this.angle,
    required this.velocity,
    required this.size,
    required this.rotationSpeed,
  });
}

/// Painter for confetti particles
class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (final particle in particles) {
      // Calculate position with physics
      final distance = particle.velocity * progress;
      final x = centerX + cos(particle.angle) * distance;
      final y = centerY + sin(particle.angle) * distance + 
                (0.5 * 500 * progress * progress); // Gravity

      // Calculate rotation
      final rotation = particle.rotationSpeed * progress;

      // Fade out near the end
      final opacity = progress < 0.8 ? 1.0 : (1.0 - (progress - 0.8) / 0.2);

      // Draw particle
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      final paint = Paint()
        ..color = particle.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      // Draw rectangle (confetti piece)
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size * 0.6,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
