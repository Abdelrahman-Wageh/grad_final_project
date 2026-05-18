/// Smartino Mascot Widget
/// Animated mascot with breathing, blinking, and emotions
/// Displays unlocked items (hats, wands, capes, etc.)
library;

import 'package:flutter/material.dart';
import 'dart:math' as math;

enum MascotState {
  idle,
  listening,
  thinking,
  happy,
  excited,
  celebrating,
}

enum MascotEmotion {
  neutral,
  happy,
  excited,
  proud,
  encouraging,
}

class SmartinoMascot extends StatefulWidget {
  final MascotState state;
  final MascotEmotion emotion;
  final List<UnlockedItem> items;
  final double size;
  final bool enableBreathing;
  final bool enableBlinking;

  const SmartinoMascot({
    Key? key,
    this.state = MascotState.idle,
    this.emotion = MascotEmotion.neutral,
    this.items = const [],
    this.size = 200,
    this.enableBreathing = true,
    this.enableBlinking = true,
  }) : super(key: key);

  @override
  State<SmartinoMascot> createState() => _SmartinoMascotState();
}

class _SmartinoMascotState extends State<SmartinoMascot>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _blinkController;
  late AnimationController _emotionController;
  late AnimationController _bounceController;

  late Animation<double> _breathingAnimation;
  late Animation<double> _blinkAnimation;
  late Animation<double> _emotionAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // Breathing animation (subtle scale)
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ),
    );
    if (widget.enableBreathing) {
      _breathingController.repeat(reverse: true);
    }

    // Blinking animation (eye opacity)
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _blinkController,
        curve: Curves.easeInOut,
      ),
    );
    if (widget.enableBlinking) {
      _scheduleBlink();
    }

    // Emotion animation (for state changes)
    _emotionController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _emotionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _emotionController,
        curve: Curves.elasticOut,
      ),
    );

    // Bounce animation (for happy/excited states)
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.bounceOut,
      ),
    );

    _updateAnimationsForState();
  }

  void _scheduleBlink() {
    Future.delayed(Duration(milliseconds: 2000 + math.Random().nextInt(3000)),
        () {
      if (mounted && widget.enableBlinking) {
        _blinkController.forward().then((_) {
          _blinkController.reverse();
          _scheduleBlink();
        });
      }
    });
  }

  void _updateAnimationsForState() {
    switch (widget.state) {
      case MascotState.happy:
      case MascotState.excited:
        _bounceController.forward(from: 0);
        break;
      case MascotState.celebrating:
        _bounceController.repeat(reverse: true);
        break;
      default:
        _bounceController.stop();
    }
  }

  @override
  void didUpdateWidget(SmartinoMascot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _emotionController.forward(from: 0);
      _updateAnimationsForState();
    }
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _blinkController.dispose();
    _emotionController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  String _getMascotEmoji() {
    switch (widget.emotion) {
      case MascotEmotion.happy:
        return '😊';
      case MascotEmotion.excited:
        return '🤩';
      case MascotEmotion.proud:
        return '😎';
      case MascotEmotion.encouraging:
        return '🥰';
      default:
        return '🦊';
    }
  }

  Color _getMascotGlowColor() {
    switch (widget.state) {
      case MascotState.listening:
        return Colors.blue;
      case MascotState.thinking:
        return Colors.purple;
      case MascotState.happy:
        return Colors.green;
      case MascotState.excited:
      case MascotState.celebrating:
        return Colors.yellow;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _breathingAnimation,
        _blinkAnimation,
        _emotionAnimation,
        _bounceAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _breathingAnimation.value,
          child: Transform.translate(
            offset: Offset(
              0,
              -20 * math.sin(_bounceAnimation.value * math.pi),
            ),
            child: Container(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow effect
                  Container(
                    width: widget.size * 1.2,
                    height: widget.size * 1.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _getMascotGlowColor().withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),

                  // Base mascot
                  Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFF6B9D),
                          Color(0xFFFFC93C),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _getMascotEmoji(),
                        style: TextStyle(fontSize: widget.size * 0.6),
                      ),
                    ),
                  ),

                  // Eyes (for blinking)
                  Positioned(
                    top: widget.size * 0.35,
                    child: Opacity(
                      opacity: _blinkAnimation.value,
                      child: Row(
                        children: [
                          Container(
                            width: widget.size * 0.1,
                            height: widget.size * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: widget.size * 0.15),
                          Container(
                            width: widget.size * 0.1,
                            height: widget.size * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Unlocked items layered on top
                  ...widget.items.map((item) => _buildItem(item)),

                  // Listening indicator
                  if (widget.state == MascotState.listening)
                    Positioned(
                      bottom: 0,
                      child: _buildListeningIndicator(),
                    ),

                  // Thinking indicator
                  if (widget.state == MascotState.thinking)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: _buildThinkingIndicator(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildItem(UnlockedItem item) {
    return Positioned(
      left: item.position.dx * widget.size,
      top: item.position.dy * widget.size,
      child: Transform.scale(
        scale: widget.size / 200, // Scale relative to default size
        child: Text(
          item.emoji,
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }

  Widget _buildListeningIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.mic, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text(
            'أستمع...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThinkingIndicator() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.purple,
        shape: BoxShape.circle,
      ),
      child: Text('💭', style: TextStyle(fontSize: 20)),
    );
  }
}

class UnlockedItem {
  final String id;
  final String nameEn;
  final String nameAr;
  final ItemType type;
  final String emoji;
  final Offset position; // Relative position (0-1 range)
  final int starsRequired;
  final DateTime unlockedAt;

  UnlockedItem({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.type,
    required this.emoji,
    required this.position,
    required this.starsRequired,
    required this.unlockedAt,
  });
}

enum ItemType {
  hat,
  wand,
  cape,
  glasses,
  background,
  accessory,
}
