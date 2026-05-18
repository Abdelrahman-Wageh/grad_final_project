/// Smartino Button Widget
/// 
/// World-class button with Disney-quality interactions:
/// - Rounded corners (32px radius)
/// - Gradient backgrounds
/// - Bounce animation on tap
/// - Haptic feedback
/// - Shimmer effect
/// - Sound effects (ready)
/// 
/// Requirements: 25.1, 25.2, 25.3 (Disney-quality interactions)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/smartino_colors.dart';
import '../theme/smartino_text_styles.dart';

enum SmartinoButtonSize {
  small,
  medium,
  large,
}

enum SmartinoButtonStyle {
  primary,
  secondary,
  success,
  encouragement,
}

class SmartinoButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final SmartinoButtonSize size;
  final SmartinoButtonStyle style;
  final IconData? icon;
  final bool isLoading;
  final bool enableHaptic;
  final bool enableShimmer;
  
  const SmartinoButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.size = SmartinoButtonSize.medium,
    this.style = SmartinoButtonStyle.primary,
    this.icon,
    this.isLoading = false,
    this.enableHaptic = true,
    this.enableShimmer = true,
  }) : super(key: key);

  @override
  State<SmartinoButton> createState() => _SmartinoButtonState();
}

class _SmartinoButtonState extends State<SmartinoButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    // Bounce animation controller
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _bounceController.forward();
      
      // Haptic feedback
      if (widget.enableHaptic) {
        HapticFeedback.lightImpact();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = false);
      _bounceController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = false);
      _bounceController.reverse();
    }
  }

  void _handleTap() {
    if (widget.onPressed != null && !widget.isLoading) {
      // Medium haptic feedback on actual tap
      if (widget.enableHaptic) {
        HapticFeedback.mediumImpact();
      }
      
      // TODO: Play sound effect
      // AudioPlayer().play('assets/sounds/button_tap.mp3');
      
      widget.onPressed!();
    }
  }

  LinearGradient _getGradient() {
    switch (widget.style) {
      case SmartinoButtonStyle.primary:
        return SmartinoColors.galaxyGradient;
      case SmartinoButtonStyle.secondary:
        return SmartinoColors.oceanGradient;
      case SmartinoButtonStyle.success:
        return SmartinoColors.forestGradient;
      case SmartinoButtonStyle.encouragement:
        return SmartinoColors.sunsetGradient;
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case SmartinoButtonSize.small:
        return 48;
      case SmartinoButtonSize.medium:
        return 64;
      case SmartinoButtonSize.large:
        return 80;
    }
  }

  double _getPadding() {
    switch (widget.size) {
      case SmartinoButtonSize.small:
        return 16;
      case SmartinoButtonSize.medium:
        return 24;
      case SmartinoButtonSize.large:
        return 32;
    }
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case SmartinoButtonSize.small:
        return SmartinoTextStyles.button.copyWith(fontSize: 18);
      case SmartinoButtonSize.medium:
        return SmartinoTextStyles.button;
      case SmartinoButtonSize.large:
        return SmartinoTextStyles.buttonLarge;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          height: _getHeight(),
          padding: EdgeInsets.symmetric(horizontal: _getPadding()),
          decoration: BoxDecoration(
            gradient: isDisabled
                ? const LinearGradient(
                    colors: [Color(0xFFBDC3C7), Color(0xFF95A5A6)],
                  )
                : _getGradient(),
            borderRadius: BorderRadius.circular(32),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: _getGradient().colors.first.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: widget.enableShimmer && !isDisabled
              ? _ShimmerEffect(
                  child: _buildContent(),
                )
              : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null && !widget.isLoading) ...[
          Icon(
            widget.icon,
            color: Colors.white,
            size: widget.size == SmartinoButtonSize.large ? 28 : 24,
          ),
          const SizedBox(width: 12),
        ],
        if (widget.isLoading)
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        else
          Text(
            widget.text,
            style: _getTextStyle(),
          ),
      ],
    );
  }
}

/// Shimmer effect for magical feel
class _ShimmerEffect extends StatefulWidget {
  final Widget child;
  
  const _ShimmerEffect({required this.child});

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                Colors.transparent,
                Colors.white24,
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(_shimmerController.value * 6.28),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
