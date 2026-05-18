import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 🎤 Listening Wave Animation
/// 
/// A beautiful wave animation that shows when the AI is listening to the child.
/// Uses CustomPainter for smooth, performant animations.
class ListeningWaveAnimation extends StatefulWidget {
  final Color color;
  final double height;
  final double width;
  final bool isListening;
  
  const ListeningWaveAnimation({
    super.key,
    this.color = const Color(0xFF7B2CBF),
    this.height = 100,
    this.width = 300,
    this.isListening = true,
  });

  @override
  State<ListeningWaveAnimation> createState() => _ListeningWaveAnimationState();
}

class _ListeningWaveAnimationState extends State<ListeningWaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    if (widget.isListening) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ListeningWaveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isListening && _controller.isAnimating) {
      _controller.stop();
    }
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
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _WavePainter(
            animationValue: _controller.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _WavePainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final waveHeight = size.height / 4;
    final waveLength = size.width / 3;
    
    // Draw 3 waves with different phases
    for (int wave = 0; wave < 3; wave++) {
      path.reset();
      
      final phaseShift = wave * math.pi / 3;
      final amplitude = waveHeight * (1 - wave * 0.2);
      final opacity = 1.0 - wave * 0.3;
      
      paint.color = color.withOpacity(opacity * 0.6);
      
      for (double x = 0; x <= size.width; x++) {
        final y = size.height / 2 +
            amplitude *
                math.sin((x / waveLength) * 2 * math.pi +
                    animationValue * 2 * math.pi +
                    phaseShift);
        
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// 🎵 Sound Bars Animation
/// 
/// Alternative animation style with vertical bars (like a music equalizer)
class SoundBarsAnimation extends StatefulWidget {
  final Color color;
  final double height;
  final int barCount;
  final bool isActive;
  
  const SoundBarsAnimation({
    super.key,
    this.color = const Color(0xFF7B2CBF),
    this.height = 80,
    this.barCount = 5,
    this.isActive = true,
  });

  @override
  State<SoundBarsAnimation> createState() => _SoundBarsAnimationState();
}

class _SoundBarsAnimationState extends State<SoundBarsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _barAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    // Create staggered animations for each bar
    _barAnimations = List.generate(
      widget.barCount,
      (index) => Tween<double>(begin: 0.2, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index / widget.barCount,
            (index + 1) / widget.barCount,
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
    
    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(SoundBarsAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isActive && _controller.isAnimating) {
      _controller.stop();
    }
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            widget.barCount,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 8,
                height: widget.height * _barAnimations[index].value,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 🎙️ Microphone Pulse Animation
/// 
/// Pulsing circle animation for microphone button
class MicrophonePulseAnimation extends StatefulWidget {
  final Widget child;
  final Color color;
  final bool isActive;
  
  const MicrophonePulseAnimation({
    super.key,
    required this.child,
    this.color = const Color(0xFF7B2CBF),
    this.isActive = true,
  });

  @override
  State<MicrophonePulseAnimation> createState() =>
      _MicrophonePulseAnimationState();
}

class _MicrophonePulseAnimationState extends State<MicrophonePulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(MicrophonePulseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isActive && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
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
      alignment: Alignment.center,
      children: [
        // Pulsing circles
        if (widget.isActive)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 100 * _scaleAnimation.value,
                height: 100 * _scaleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withOpacity(_opacityAnimation.value),
                ),
              );
            },
          ),
        // Child (microphone icon)
        widget.child,
      ],
    );
  }
}
