import 'package:flutter/material.dart';

import '../utils/app_constants.dart';

class VoiceButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isRecording;
  final bool isProcessing;

  const VoiceButton({
    super.key,
    required this.onPressed,
    required this.isRecording,
    required this.isProcessing,
  });

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(VoiceButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isRecording && !oldWidget.isRecording) {
      _pulseController.repeat(reverse: true);
      _rippleController.repeat();
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _pulseController.stop();
      _rippleController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: widget.isProcessing ? null : widget.onPressed,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _rippleAnimation]),
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Ripple effect
                if (widget.isRecording)
                  Container(
                    width: 200 * _rippleAnimation.value,
                    height: 200 * _rippleAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(
                          1.0 - _rippleAnimation.value,
                        ),
                        width: 2,
                      ),
                    ),
                  ),
                
                // Main button
                Transform.scale(
                  scale: widget.isRecording ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.isRecording
                            ? [AppConstants.accentColor, AppConstants.errorColor]
                            : [AppConstants.primaryColor, AppConstants.secondaryColor],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      _getButtonIcon(),
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                // Processing indicator
                if (widget.isProcessing)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: AppConstants.warningColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.psychology,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  IconData _getButtonIcon() {
    if (widget.isProcessing) {
      return Icons.psychology;
    } else if (widget.isRecording) {
      return Icons.mic;
    } else {
      return Icons.mic_none;
    }
  }
}
