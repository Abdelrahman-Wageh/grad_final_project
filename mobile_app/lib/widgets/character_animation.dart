import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../services/ai_service.dart';
import '../utils/app_constants.dart';

class CharacterAnimation extends StatefulWidget {
  final AnimationController controller;
  final bool isProcessing;
  final bool isRecording;
  final bool isSpeaking;

  const CharacterAnimation({
    super.key,
    required this.controller,
    required this.isProcessing,
    required this.isRecording,
    this.isSpeaking = false,
  });

  @override
  State<CharacterAnimation> createState() => _CharacterAnimationState();
}

class _CharacterAnimationState extends State<CharacterAnimation> with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _blinkController;
  late AnimationController _mouthController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _blinkAnimation;
  late Animation<double> _mouthAnimation;
  
  bool _isBlinking = false;

  @override
  void initState() {
    super.initState();
    
    // Breathing animation (floating motion) - 3 seconds
    _breathingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _breathingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
    
    // Blinking animation - random intervals
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.1).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );
    
    // Mouth animation for speaking
    _mouthController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _mouthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mouthController, curve: Curves.easeInOut),
    );
    
    // Start random blinking
    _startRandomBlinking();
  }

  void _startRandomBlinking() {
    Future.delayed(Duration(milliseconds: 2000 + (DateTime.now().millisecond % 3000)), () {
      if (mounted) {
        setState(() => _isBlinking = true);
        _blinkController.forward().then((_) {
          _blinkController.reverse().then((_) {
            if (mounted) {
              setState(() => _isBlinking = false);
              _startRandomBlinking();
            }
          });
        });
      }
    });
  }

  @override
  void didUpdateWidget(CharacterAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Animate mouth when speaking
    if (widget.isSpeaking && !oldWidget.isSpeaking) {
      _mouthController.repeat(reverse: true);
    } else if (!widget.isSpeaking && oldWidget.isSpeaking) {
      _mouthController.stop();
      _mouthController.reset();
    }
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _blinkController.dispose();
    _mouthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.controller,
        _breathingController,
        _blinkController,
        _mouthController,
      ]),
      builder: (context, child) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Character Avatar with breathing animation
              Transform.translate(
                offset: Offset(0, _breathingAnimation.value),
                child: Transform.rotate(
                  angle: _breathingAnimation.value * 0.01, // Subtle rotation
                  child: _buildCharacterAvatar(),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Status Indicator
              _buildStatusIndicator(),
              
              const SizedBox(height: 10),
              
              // Speech Bubble
              _buildSpeechBubble(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCharacterAvatar() {
    // Determine emotional state colors
    List<Color> gradientColors;
    if (widget.isProcessing) {
      gradientColors = [
        AppConstants.warningColor,
        AppConstants.warningColor.withOpacity(0.7),
      ];
    } else if (widget.isRecording) {
      gradientColors = [
        AppConstants.successColor,
        AppConstants.successColor.withOpacity(0.7),
      ];
    } else if (widget.isSpeaking) {
      gradientColors = [
        AppConstants.primaryColor,
        AppConstants.secondaryColor,
      ];
    } else {
      gradientColors = [
        AppConstants.primaryColor,
        AppConstants.secondaryColor,
      ];
    }
    
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Character face
          Center(
            child: _buildCharacterFace(),
          ),
          
          // Thinking animation
          if (widget.isProcessing)
            Positioned(
              top: 10,
              right: 10,
              child: _buildThinkingAnimation(),
            ),
          
          // Listening animation
          if (widget.isRecording)
            Positioned(
              bottom: 10,
              left: 10,
              child: _buildListeningAnimation(),
            ),
          
          // Speaking shimmer effect
          if (widget.isSpeaking)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ).animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.5)),
            ),
        ],
      ),
    );
  }

  Widget _buildCharacterFace() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Eyes with blinking
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildEye(),
            const SizedBox(width: 20),
            _buildEye(),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Mouth with animation
        _buildMouth(),
      ],
    );
  }

  Widget _buildEye() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 14,
      height: _isBlinking ? 2 : 14,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: _isBlinking 
            ? BorderRadius.circular(10)
            : BorderRadius.circular(7),
      ),
      child: _isBlinking 
          ? null
          : Center(
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: widget.isProcessing 
                      ? AppConstants.warningColor
                      : widget.isRecording
                          ? AppConstants.successColor
                          : AppConstants.textColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
    );
  }

  Widget _buildMouth() {
    // Different mouth shapes based on state
    if (widget.isSpeaking) {
      // Animated mouth for speaking
      return AnimatedBuilder(
        animation: _mouthAnimation,
        builder: (context, child) {
          return Container(
            width: 25,
            height: 15 + (_mouthAnimation.value * 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
          );
        },
      );
    } else if (widget.isProcessing) {
      // Thinking mouth (small circle)
      return Container(
        width: 15,
        height: 15,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      );
    } else if (widget.isRecording) {
      // Listening mouth (slightly open)
      return Container(
        width: 20,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      );
    } else {
      // Happy mouth (smile)
      return Container(
        width: 30,
        height: 15,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
      );
    }
  }

  Widget _buildThinkingAnimation() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppConstants.warningColor,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.psychology,
        color: Colors.white,
        size: 16,
      ),
    ).animate(onPlay: (controller) => controller.repeat())
        .scale(
          duration: 1000.ms,
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.2, 1.2),
        )
        .then()
        .scale(
          duration: 1000.ms,
          begin: const Offset(1.2, 1.2),
          end: const Offset(1.0, 1.0),
        );
  }

  Widget _buildListeningAnimation() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppConstants.successColor,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.hearing,
        color: Colors.white,
        size: 16,
      ),
    ).animate(onPlay: (controller) => controller.repeat())
        .scale(
          duration: 500.ms,
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.3, 1.3),
        )
        .then()
        .scale(
          duration: 500.ms,
          begin: const Offset(1.3, 1.3),
          end: const Offset(1.0, 1.0),
        );
  }

  Widget _buildStatusIndicator() {
    String statusText;
    Color statusColor;
    IconData statusIcon;
    
    if (widget.isProcessing) {
      statusText = 'أفكر... 🤔';
      statusColor = AppConstants.warningColor;
      statusIcon = Icons.psychology;
    } else if (widget.isRecording) {
      statusText = 'أستمع لك... 👂';
      statusColor = AppConstants.successColor;
      statusIcon = Icons.hearing;
    } else if (widget.isSpeaking) {
      statusText = 'أتحدث... 💬';
      statusColor = AppConstants.primaryColor;
      statusIcon = Icons.record_voice_over;
    } else {
      statusText = 'مرحباً! 😊';
      statusColor = AppConstants.primaryColor;
      statusIcon = Icons.emoji_emotions;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: statusColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1.0, 1.0),
      duration: 300.ms,
      curve: Curves.elasticOut,
    );
  }

  Widget _buildSpeechBubble(BuildContext context) {
    final aiService = Provider.of<AIService>(context, listen: false);
    final lastResponse = aiService.lastResponse;
    
    if (lastResponse == null) {
      return const SizedBox.shrink();
    }
    
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            lastResponse,
            style: const TextStyle(
              color: AppConstants.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          
          const SizedBox(height: 12),
          
          // Response time indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppConstants.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              '⚡ ${aiService.responseTime.inMilliseconds}ms',
              style: TextStyle(
                color: AppConstants.successColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(
      begin: 0.5,
      duration: 500.ms,
      curve: Curves.elasticOut,
    ).fadeIn(duration: 500.ms);
  }
}
