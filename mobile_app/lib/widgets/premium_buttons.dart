import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// 🎨 Premium Animated Button Components
/// A collection of impressive, kid-friendly buttons with various animations
class PremiumButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isEnabled;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final LinearGradient? gradient;
  final Color? backgroundColor;
  final Duration animationDuration;

  const PremiumButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
    this.fontSize = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    this.gradient,
    this.backgroundColor,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isEnabled && !widget.isLoading ? _onTapDown : null,
      onTapUp: widget.isEnabled && !widget.isLoading ? _onTapUp : null,
      onTapCancel: widget.isEnabled && !widget.isLoading ? _onTapCancel : null,
      onTap: widget.isEnabled && !widget.isLoading ? widget.onPressed : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.gradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.backgroundColor ?? const Color(0xFFFF006E),
                    (widget.backgroundColor ?? const Color(0xFFFF006E))
                        .withOpacity(0.8),
                  ],
                ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color:
                    (widget.backgroundColor ?? const Color(0xFFFF006E))
                        .withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color:
                    (widget.backgroundColor ?? const Color(0xFFFF006E))
                        .withOpacity(0.2),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap:
                  widget.isEnabled && !widget.isLoading ? widget.onPressed : null,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: widget.padding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isLoading)
                      SizedBox(
                        width: widget.fontSize + 4,
                        height: widget.fontSize + 4,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withOpacity(0.9),
                          ),
                        ),
                      )
                    else if (widget.icon != null)
                      Icon(
                        widget.icon,
                        color: Colors.white,
                        size: widget.fontSize + 4,
                      ),
                    if (widget.icon != null && !widget.isLoading)
                      SizedBox(width: 8),
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 🎪 Fun Bounce Button (Special animation for CTAs)
class BounceButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final LinearGradient gradient;
  final double size;

  const BounceButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    required this.gradient,
    this.size = 60,
  }) : super(key: key);

  @override
  State<BounceButton> createState() =>_BounceButtonState();
}

class _BounceButtonState extends State<BounceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
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
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0.0);
        widget.onPressed();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final value = _controller.value;
              final curve = Curves.elasticOut;
              final animValue = curve.transform(value);

              return Transform.translate(
                offset: Offset(0, -20 * animValue),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    gradient: widget.gradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12 + (12 * (1 - animValue)),
                        offset: Offset(0, 4 + (4 * (1 - animValue))),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onPressed,
                      borderRadius: BorderRadius.circular(widget.size / 2),
                      child: Center(
                        child: widget.icon != null
                            ? Icon(
                                widget.icon,
                                color: Colors.white,
                                size: widget.size * 0.4,
                              )
                            : Text(
                                '🎮',
                                style: TextStyle(fontSize: widget.size * 0.4),
                              ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 12),
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1F2E),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🌊 Ripple Button (Wave effect animation)
class RippleButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final IconData? icon;

  const RippleButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.color,
    this.icon,
  }) : super(key: key);

  @override
  State<RippleButton> createState() => _RippleButtonState();
}

class _RippleButtonState extends State<RippleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _rippleController.forward(from: 0.0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _rippleController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                for (int i = 0; i < 3; i++)
                  BoxShadow(
                    color: widget.color.withOpacity(
                      0.5 * (1 - (_rippleController.value + i * 0.3) % 1),
                    ),
                    blurRadius: 8 + (12 * (_rippleController.value + i * 0.3) % 1),
                    spreadRadius:
                        2 + (8 * (_rippleController.value + i * 0.3) % 1),
                  ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null)
                    Icon(widget.icon, color: Colors.white, size: 20),
                  if (widget.icon != null) SizedBox(width: 8),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
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
}

/// 🎨 Gradient Border Button
class GradientBorderButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final LinearGradient gradient;
  final IconData? icon;

  const GradientBorderButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.gradient,
    this.icon,
  }) : super(key: key);

  @override
  State<GradientBorderButton> createState() => _GradientBorderButtonState();
}

class _GradientBorderButtonState extends State<GradientBorderButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1.0 - (0.05 * _controller.value);
          return Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: widget.gradient,
              ),
              padding: const EdgeInsets.all(2.5),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFAF0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null)
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            widget.gradient.createShader(bounds),
                        child: Icon(widget.icon, color: Colors.white, size: 20),
                      ),
                    if (widget.icon != null) SizedBox(width: 8),
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          widget.gradient.createShader(bounds),
                      child: Text(
                        widget.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 🎯 Icon Button with Label (For game screens)
class IconLabelButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double size;

  const IconLabelButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFFF006E),
    this.foregroundColor = Colors.white,
    this.size = 70,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(size * 0.25),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(size * 0.25),
                child: Icon(
                  icon,
                  color: foregroundColor,
                  size: size * 0.5,
                ),
              ),
            ),
          )
              .animate()
              .scale(
                duration: const Duration(milliseconds: 500),
                begin: const Offset(1, 1),
                end: const Offset(1.05, 1.05),
              )
              .then()
              .scale(
                duration: const Duration(milliseconds: 500),
                begin: const Offset(1.05, 1.05),
                end: const Offset(1, 1),
              ),
          SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1F2E),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// 🌟 Achievement Button (For unlocking special items)
class AchievementButton extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isUnlocked;
  final LinearGradient gradient;

  const AchievementButton({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
    this.isUnlocked = true,
    required this.gradient,
  }) : super(key: key);

  @override
  State<AchievementButton> createState() => _AchievementButtonState();
}

class _AchievementButtonState extends State<AchievementButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    if (widget.isUnlocked) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isUnlocked ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final rotation = widget.isUnlocked ? _controller.value * 0.1 : 0.0;
          return Transform.rotate(
            angle: rotation,
            child: Container(
              decoration: BoxDecoration(
                gradient: widget.gradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (widget.isUnlocked)
                    BoxShadow(
                      color: Colors.yellow.withOpacity(0.4 + (0.3 * _controller.value)),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!widget.isUnlocked)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'Locked',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
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
}
