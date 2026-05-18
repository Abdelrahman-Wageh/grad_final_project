/// Smartino Super-App - Button Component
/// Reusable button with animations and haptic feedback
/// Requirements: 2.1, 2.2, 2.5

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import '../../theme/smartino_colors.dart';
import '../../theme/smartino_typography.dart';

enum SmartinoButtonSize {
  small,
  medium,
  large,
}

enum SmartinoButtonType {
  primary,
  secondary,
  success,
  warning,
  error,
  outline,
  text,
}

class SmartinoButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final SmartinoButtonSize size;
  final SmartinoButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final bool enableHaptic;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  
  const SmartinoButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = SmartinoButtonSize.medium,
    this.type = SmartinoButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.enableHaptic = true,
    this.width,
    this.padding,
    this.borderRadius,
  });

  @override
  State<SmartinoButton> createState() => _SmartinoButtonState();
}

class _SmartinoButtonState extends State<SmartinoButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
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
  
  void _handleTapDown(TapDownDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }
  
  void _handleTapUp(TapUpDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }
  
  void _handleTapCancel() {
    if (!widget.isDisabled && !widget.isLoading) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }
  
  Future<void> _handleTap() async {
    if (widget.isDisabled || widget.isLoading || widget.onPressed == null) {
      return;
    }
    
    // Haptic feedback
    if (widget.enableHaptic) {
      HapticFeedback.mediumImpact();
      try {
        await Vibration.vibrate(duration: 50);
      } catch (e) {
        // Vibration not supported
      }
    }
    
    widget.onPressed!();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isDisabled || widget.isLoading;
    
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
          width: widget.width,
          padding: widget.padding ?? _getPadding(),
          decoration: _getDecoration(isDisabled),
          child: widget.isLoading
              ? _buildLoadingIndicator()
              : _buildContent(),
        ),
      ),
    );
  }
  
  EdgeInsetsGeometry _getPadding() {
    switch (widget.size) {
      case SmartinoButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case SmartinoButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case SmartinoButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }
  
  BoxDecoration _getDecoration(bool isDisabled) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(12);
    
    if (widget.type == SmartinoButtonType.outline) {
      return BoxDecoration(
        color: Colors.transparent,
        borderRadius: borderRadius,
        border: Border.all(
          color: isDisabled
              ? SmartinoColors.textHint
              : _getColor(),
          width: 2,
        ),
      );
    }
    
    if (widget.type == SmartinoButtonType.text) {
      return BoxDecoration(
        color: Colors.transparent,
        borderRadius: borderRadius,
      );
    }
    
    return BoxDecoration(
      gradient: isDisabled
          ? LinearGradient(
              colors: [
                SmartinoColors.textHint,
                SmartinoColors.textHint.withOpacity(0.8),
              ],
            )
          : _getGradient(),
      borderRadius: borderRadius,
      boxShadow: isDisabled
          ? []
          : [
              BoxShadow(
                color: _getColor().withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
    );
  }
  
  Widget _buildContent() {
    final textStyle = _getTextStyle();
    
    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            color: _getTextColor(),
            size: _getIconSize(),
          ),
          const SizedBox(width: 8),
          Text(
            widget.text,
            style: textStyle,
          ),
        ],
      );
    }
    
    return Text(
      widget.text,
      style: textStyle,
      textAlign: TextAlign.center,
    );
  }
  
  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: _getIconSize(),
      width: _getIconSize(),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
      ),
    );
  }
  
  Color _getColor() {
    switch (widget.type) {
      case SmartinoButtonType.primary:
        return SmartinoColors.primary;
      case SmartinoButtonType.secondary:
        return SmartinoColors.secondary;
      case SmartinoButtonType.success:
        return SmartinoColors.success;
      case SmartinoButtonType.warning:
        return SmartinoColors.warning;
      case SmartinoButtonType.error:
        return SmartinoColors.error;
      case SmartinoButtonType.outline:
        return SmartinoColors.primary;
      case SmartinoButtonType.text:
        return SmartinoColors.primary;
    }
  }
  
  LinearGradient _getGradient() {
    final color = _getColor();
    return LinearGradient(
      colors: [color, SmartinoColors.lighten(color, 0.1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
  
  Color _getTextColor() {
    if (widget.isDisabled) {
      return SmartinoColors.textHint;
    }
    
    if (widget.type == SmartinoButtonType.outline ||
        widget.type == SmartinoButtonType.text) {
      return _getColor();
    }
    
    return Colors.white;
  }
  
  TextStyle _getTextStyle() {
    TextStyle baseStyle;
    
    switch (widget.size) {
      case SmartinoButtonSize.small:
        baseStyle = SmartinoTypography.buttonSmall;
        break;
      case SmartinoButtonSize.medium:
        baseStyle = SmartinoTypography.buttonMedium;
        break;
      case SmartinoButtonSize.large:
        baseStyle = SmartinoTypography.buttonLarge;
        break;
    }
    
    return baseStyle.copyWith(color: _getTextColor());
  }
  
  double _getIconSize() {
    switch (widget.size) {
      case SmartinoButtonSize.small:
        return 16;
      case SmartinoButtonSize.medium:
        return 20;
      case SmartinoButtonSize.large:
        return 24;
    }
  }
}
