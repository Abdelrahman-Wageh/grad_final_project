/// Farfour Widget - Visual representation of the character
/// Displays Farfour with animations and responds to state changes

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/character/farfour_controller.dart';

class FarfourWidget extends ConsumerWidget {
  final double size;
  final bool showSpeechBubble;
  final String? speechText;
  
  const FarfourWidget({
    super.key,
    this.size = 120,
    this.showSpeechBubble = false,
    this.speechText,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farfourState = ref.watch(farfourControllerProvider);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      transform: Matrix4.identity()
        ..translate(farfourState.position.dx, farfourState.position.dy)
        ..scale(farfourState.scale),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Speech bubble (if talking)
          if (showSpeechBubble && speechText != null)
            _buildSpeechBubble(speechText!),
          
          const SizedBox(height: 8),
          
          // Farfour character
          _buildCharacter(farfourState),
        ],
      ),
    );
  }
  
  Widget _buildCharacter(FarfourState state) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6B4CE6), // Purple
            const Color(0xFF9B7EF7), // Light purple
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B4CE6).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Character face/body
          _buildCharacterFace(state),
          
          // Animation overlay
          if (state.isAnimating)
            _buildAnimationOverlay(state),
        ],
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(),
    ).shimmer(
      duration: 2000.ms,
      color: Colors.white.withOpacity(0.3),
    );
  }
  
  Widget _buildCharacterFace(FarfourState state) {
    // Placeholder: In production, use Rive or sprite sheets
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Eyes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEye(state),
              const SizedBox(width: 16),
              _buildEye(state),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Mouth
          _buildMouth(state),
        ],
      ),
    );
  }
  
  Widget _buildEye(FarfourState state) {
    final isBlinking = state.mood == FarfourMood.sleeping;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 12,
      height: isBlinking ? 2 : 12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
  
  Widget _buildMouth(FarfourState state) {
    IconData mouthIcon;
    
    switch (state.mood) {
      case FarfourMood.happy:
      case FarfourMood.excited:
        mouthIcon = Icons.sentiment_very_satisfied;
        break;
      case FarfourMood.thinking:
        mouthIcon = Icons.sentiment_neutral;
        break;
      case FarfourMood.talking:
        mouthIcon = Icons.record_voice_over;
        break;
      case FarfourMood.listening:
        mouthIcon = Icons.hearing;
        break;
      case FarfourMood.encouraging:
        mouthIcon = Icons.sentiment_satisfied;
        break;
      default:
        mouthIcon = Icons.sentiment_satisfied;
    }
    
    return Icon(
      mouthIcon,
      color: Colors.white,
      size: 24,
    ).animate(
      onPlay: (controller) {
        if (state.mood == FarfourMood.talking) {
          controller.repeat();
        }
      },
    ).scale(
      duration: 300.ms,
      begin: const Offset(1.0, 1.0),
      end: const Offset(1.2, 1.2),
    );
  }
  
  Widget _buildAnimationOverlay(FarfourState state) {
    if (state.mood == FarfourMood.excited) {
      // Celebration particles
      return Positioned.fill(
        child: CustomPaint(
          painter: _CelebrationPainter(),
        ),
      );
    }
    
    return const SizedBox.shrink();
  }
  
  Widget _buildSpeechBubble(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2C3E50),
        ),
        textAlign: TextAlign.center,
      ),
    ).animate()
      .fadeIn(duration: 300.ms)
      .scale(begin: const Offset(0.8, 0.8));
  }
}

/// Custom painter for celebration effects
class _CelebrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFB800)
      ..style = PaintingStyle.fill;
    
    // Draw simple star particles
    for (var i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final x = size.width / 2 + (size.width / 2) * 0.8 * (i % 2 == 0 ? 1 : 0.6) * (i / 8);
      final y = size.height / 2 + (size.height / 2) * 0.8 * (i % 2 == 0 ? 1 : 0.6) * (i / 8);
      
      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Farfour overlay widget for floating character
class FarfourOverlay extends ConsumerWidget {
  final Alignment alignment;
  
  const FarfourOverlay({
    super.key,
    this.alignment = Alignment.topRight,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: const FarfourWidget(size: 80),
        ),
      ),
    );
  }
}
