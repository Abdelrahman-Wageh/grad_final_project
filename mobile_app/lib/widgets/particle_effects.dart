import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/premium_kid_theme.dart';

/// ✨ Premium Particle Effects & Visual Polish
/// Creates impressive visual effects that delight kids
class ParticleEffects {
  /// Confetti particle burst
  static Widget confettiBurst({
    int particleCount = 50,
    Duration duration = const Duration(milliseconds: 2000),
    Color? color,
  }) {
    return _ConfettiBurst(
      particleCount: particleCount,
      duration: duration,
      color: color ?? PremiumKidTheme.vibrantMagenta,
    );
  }

  /// Floating particles background
  static Widget floatingParticles({
    int count = 20,
    Color color = const Color(0xFFFF006E),
    double opacity = 0.3,
  }) {
    return _FloatingParticlesBackground(
      count: count,
      color: color,
      opacity: opacity,
    );
  }

  /// Star burst effect
  static Widget starBurst({
    required Offset position,
    int starCount = 12,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return _StarBurst(
      position: position,
      starCount: starCount,
      duration: duration,
    );
  }

  /// Particle shower effect
  static Widget particleShower({
    int particleCount = 30,
    Duration duration = const Duration(milliseconds: 2500),
    Color color = const Color(0xFFFFD60A),
  }) {
    return _ParticleShower(
      particleCount: particleCount,
      duration: duration,
      color: color,
    );
  }

  /// Rainbow trail effect
  static Widget rainbowTrail({
    required Offset startOffset,
    required Offset endOffset,
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    return _RainbowTrail(
      startOffset: startOffset,
      endOffset: endOffset,
      duration: duration,
    );
  }

  /// Shimmer effect overlay
  static Widget shimmerOverlay({
    required Widget child,
    Color shimmerColor = Colors.white,
    Duration duration = const Duration(milliseconds: 2000),
  }) {
    return _ShimmerEffect(
      child: child,
      shimmerColor: shimmerColor,
      duration: duration,
    );
  }

  /// Glow effect
  static Widget glowEffect({
    required Widget child,
    Color glowColor = const Color(0xFFFF006E),
    double glowRadius = 20,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return _GlowEffect(
      child: child,
      glowColor: glowColor,
      glowRadius: glowRadius,
      duration: duration,
    );
  }

  /// Particle trail on drag
  static Widget particleTrail({
    required Widget child,
    Color trailColor = const Color(0xFFFF006E),
  }) {
    return _ParticleTrailWidget(
      child: child,
      trailColor: trailColor,
    );
  }

  /// Pulse ring effect
  static Widget pulseRing({
    required Widget child,
    Color ringColor = const Color(0xFFFF006E),
    Duration duration = const Duration(milliseconds: 1500),
    int ringCount = 3,
  }) {
    return _PulseRingEffect(
      child: child,
      ringColor: ringColor,
      duration: duration,
      ringCount: ringCount,
    );
  }
}

/// Confetti burst animation
class _ConfettiBurst extends StatefulWidget {
  final int particleCount;
  final Duration duration;
  final Color color;

  const _ConfettiBurst({
    required this.particleCount,
    required this.duration,
    required this.color,
  });

  @override
  State<_ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<_ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward();

    _particles = List.generate(
      widget.particleCount,
      (index) => _Particle(
        random: math.Random(),
        color: widget.color,
      ),
    );
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
        return Stack(
          children: _particles.map((particle) {
            final position = particle.getPosition(_controller.value);
            return Positioned(
              left: position.dx,
              top: position.dy,
              child: Transform.rotate(
                angle: particle.rotation * _controller.value,
                child: Container(
                  width: particle.size,
                  height: particle.size,
                  decoration: BoxDecoration(
                    color: particle.color
                        .withOpacity(1 - _controller.value),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

/// Particle model
class _Particle {
  final math.Random random;
  final Color color;
  late double vx;
  late double vy;
  late double size;
  late double rotation;
  late double rotationSpeed;

  _Particle({
    required this.random,
    required this.color,
  }) {
    vx = (random.nextDouble() - 0.5) * 500;
    vy = (random.nextDouble() - 0.5) * 500;
    size = random.nextDouble() * 10 + 2;
    rotation = random.nextDouble() * 2 * math.pi;
    rotationSpeed = (random.nextDouble() - 0.5) * 10;
  }

  Offset getPosition(double progress) {
    final x = vx * progress * 300;
    final y = vy * progress * 300;
    return Offset(x, y);
  }
}

/// Floating particles background
class _FloatingParticlesBackground extends StatefulWidget {
  final int count;
  final Color color;
  final double opacity;

  const _FloatingParticlesBackground({
    required this.count,
    required this.color,
    required this.opacity,
  });

  @override
  State<_FloatingParticlesBackground> createState() =>
      _FloatingParticlesBackgroundState();
}

class _FloatingParticlesBackgroundState extends State<_FloatingParticlesBackground>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.count,
      (index) => AnimationController(
        duration: Duration(milliseconds: 3000 + (index * 200)),
        vsync: this,
      )..repeat(),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(widget.count, (index) {
        return Positioned(
          left: (index * 50) % 400.0,
          top: (index * 100) % 800.0,
          child: AnimatedBuilder(
            animation: _controllers[index],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  20 * math.sin(_controllers[index].value * 2 * math.pi),
                  -50 * _controllers[index].value,
                ),
                child: Opacity(
                  opacity: widget.opacity * (1 - (_controllers[index].value % 0.5).abs()),
                  child: Container(
                    width: 4 + (index % 3) * 2.0,
                    height: 4 + (index % 3) * 2.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

/// Star burst effect
class _StarBurst extends StatefulWidget {
  final Offset position;
  final int starCount;
  final Duration duration;

  const _StarBurst({
    required this.position,
    required this.starCount,
    required this.duration,
  });

  @override
  State<_StarBurst> createState() => _StarBurstState();
}

class _StarBurstState extends State<_StarBurst>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward();
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
        return Stack(
          children: List.generate(widget.starCount, (index) {
            final angle = (index / widget.starCount) * 2 * math.pi;
            final distance = 100 * _controller.value;
            final dx = distance * math.cos(angle);
            final dy = distance * math.sin(angle);

            return Positioned(
              left: widget.position.dx + dx - 10,
              top: widget.position.dy + dy - 10,
              child: Opacity(
                opacity: 1 - _controller.value,
                child: Text(
                  '⭐',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Particle shower effect
class _ParticleShower extends StatefulWidget {
  final int particleCount;
  final Duration duration;
  final Color color;

  const _ParticleShower({
    required this.particleCount,
    required this.duration,
    required this.color,
  });

  @override
  State<_ParticleShower> createState() => _ParticleShowerState();
}

class _ParticleShowerState extends State<_ParticleShower>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(widget.particleCount, (index) {
        final random = math.Random(index);
        final startX = random.nextDouble() * 300 - 150;
        final endX = startX + (random.nextDouble() - 0.5) * 200;
        final startY = -50;
        final endY = 400;

        final x = startX + (endX - startX) * _controller.value;
        final y = startY + (endY - startY) * _controller.value;

        return Positioned(
          left: x,
          top: y,
          child: Opacity(
            opacity: 1 - (_controller.value > 0.7 ? (_controller.value - 0.7) / 0.3 : 0),
            child: Container(
              width: 3 + random.nextDouble() * 3,
              height: 3 + random.nextDouble() * 3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Rainbow trail effect
class _RainbowTrail extends StatefulWidget {
  final Offset startOffset;
  final Offset endOffset;
  final Duration duration;

  const _RainbowTrail({
    required this.startOffset,
    required this.endOffset,
    required this.duration,
  });

  @override
  State<_RainbowTrail> createState() => _RainbowTrailState();
}

class _RainbowTrailState extends State<_RainbowTrail>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RainbowTrailPainter(
        progress: _controller.value,
        startOffset: widget.startOffset,
        endOffset: widget.endOffset,
      ),
    );
  }
}

class _RainbowTrailPainter extends CustomPainter {
  final double progress;
  final Offset startOffset;
  final Offset endOffset;

  _RainbowTrailPainter({
    required this.progress,
    required this.startOffset,
    required this.endOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      Color(0xFFFF006E),
      Color(0xFFFFD60A),
      Color(0xFF39FF14),
      Color(0xFF0099FF),
      Color(0xFFBB00FF),
    ];

    final distance = (endOffset - startOffset) * progress;
    final steps = (distance.distance / 10).toInt();

    for (int i = 0; i < steps; i++) {
      final t = i / (steps > 0 ? steps : 1);
      final color = colors[i % colors.length];
      final point = startOffset + distance * t;
      final opacity = 1 - (i / (steps > 0 ? steps : 1));

      canvas.drawCircle(
        point,
        2,
        Paint()
          ..color = color.withOpacity(opacity * 0.7)
          ..isAntiAlias = true,
      );
    }
  }

  @override
  bool shouldRepaint(_RainbowTrailPainter oldDelegate) => true;
}

/// Shimmer effect
class _ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color shimmerColor;
  final Duration duration;

  const _ShimmerEffect({
    required this.child,
    required this.shimmerColor,
    required this.duration,
  });

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
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
        return Stack(
          children: [
            widget.child,
            Positioned.fill(
              child: Transform.translate(
                offset: Offset(
                  (_controller.value - 0.5) * 200,
                  0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.shimmerColor.withOpacity(0),
                        widget.shimmerColor.withOpacity(0.5),
                        widget.shimmerColor.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Glow effect
class _GlowEffect extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double glowRadius;
  final Duration duration;

  const _GlowEffect({
    required this.child,
    required this.glowColor,
    required this.glowRadius,
    required this.duration,
  });

  @override
  State<_GlowEffect> createState() => _GlowEffectState();
}

class _GlowEffectState extends State<_GlowEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);
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
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(0.3 + (0.3 * _controller.value)),
                blurRadius: widget.glowRadius * (0.5 + (0.5 * _controller.value)),
                spreadRadius: 2 + (2 * _controller.value),
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Particle trail widget
class _ParticleTrailWidget extends StatefulWidget {
  final Widget child;
  final Color trailColor;

  const _ParticleTrailWidget({
    required this.child,
    required this.trailColor,
  });

  @override
  State<_ParticleTrailWidget> createState() => _ParticleTrailWidgetState();
}

class _ParticleTrailWidgetState extends State<_ParticleTrailWidget> {
  final List<_TrailParticle> _particles = [];

  void _addParticle(Offset position) {
    setState(() {
      _particles.add(
        _TrailParticle(
          position: position,
          color: widget.trailColor,
          createdAt: DateTime.now(),
        ),
      );
      _particles.removeWhere(
        (p) => DateTime.now().difference(p.createdAt).inMilliseconds > 500,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => _addParticle(event.localPosition),
      child: Stack(
        children: [
          ..._particles.map((p) => _ParticleWidget(particle: p)),
          widget.child,
        ],
      ),
    );
  }
}

class _TrailParticle {
  final Offset position;
  final Color color;
  final DateTime createdAt;

  _TrailParticle({
    required this.position,
    required this.color,
    required this.createdAt,
  });

  double get opacity {
    final age = DateTime.now().difference(createdAt).inMilliseconds;
    return 1 - (age / 500);
  }
}

class _ParticleWidget extends StatelessWidget {
  final _TrailParticle particle;

  const _ParticleWidget({required this.particle});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: particle.position.dx - 2,
      top: particle.position.dy - 2,
      child: Opacity(
        opacity: particle.opacity,
        child: Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: particle.color,
          ),
        ),
      ),
    );
  }
}

/// Pulse ring effect
class _PulseRingEffect extends StatefulWidget {
  final Widget child;
  final Color ringColor;
  final Duration duration;
  final int ringCount;

  const _PulseRingEffect({
    required this.child,
    required this.ringColor,
    required this.duration,
    required this.ringCount,
  });

  @override
  State<_PulseRingEffect> createState() => _PulseRingEffectState();
}

class _PulseRingEffectState extends State<_PulseRingEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
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
        return Stack(
          alignment: Alignment.center,
          children: [
            ...(List.generate(widget.ringCount, (index) {
              final delay = index / widget.ringCount;
              final value = (_controller.value + delay) % 1.0;

              return Container(
                width: 200 + (200 * value),
                height: 200 + (200 * value),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.ringColor.withOpacity(1 - value),
                    width: 2,
                  ),
                ),
              );
            })),
            widget.child,
          ],
        );
      },
    );
  }
}
