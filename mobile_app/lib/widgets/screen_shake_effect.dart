import 'dart:math';
import 'package:flutter/material.dart';

/// Screen shake effect for big achievements
/// 
/// Provides a subtle shake animation that adds juice to celebrations
/// without being disorienting.
/// 
/// Requirements: 25.4
class ScreenShakeEffect extends StatefulWidget {
  final Widget child;
  final bool isActive;
  final double intensity;
  final VoidCallback? onComplete;

  const ScreenShakeEffect({
    Key? key,
    required this.child,
    this.isActive = false,
    this.intensity = 10.0,
    this.onComplete,
  }) : super(key: key);

  @override
  _ScreenShakeEffectState createState() => _ScreenShakeEffectState();
}

class _ScreenShakeEffectState extends State<ScreenShakeEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(ScreenShakeEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.forward(from: 0.0);
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
        if (!widget.isActive || _controller.value == 0.0) {
          return widget.child;
        }

        // Calculate shake offset
        final progress = _controller.value;
        final decay = 1.0 - progress; // Decay over time
        
        // Random shake in both directions
        final offsetX = (_random.nextDouble() - 0.5) * 
                       widget.intensity * 
                       decay * 
                       sin(progress * pi * 10); // Oscillate
        
        final offsetY = (_random.nextDouble() - 0.5) * 
                       widget.intensity * 
                       decay * 
                       sin(progress * pi * 10 + pi / 2); // Phase shift

        return Transform.translate(
          offset: Offset(offsetX, offsetY),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}

/// Shake controller for triggering shake effects
class ShakeController {
  final List<VoidCallback> _listeners = [];

  void shake() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void dispose() {
    _listeners.clear();
  }
}
