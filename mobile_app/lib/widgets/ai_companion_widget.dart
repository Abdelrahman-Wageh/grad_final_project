/// AI Companion Widget for Whispering Woods.
/// Shows listening, thinking, idle, and playing animation states.
/// Includes dry-run preview mode.

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart' show Lottie;
import 'dart:async';

enum CompanionState {
  idle,
  listening,
  thinking,
  playing,
  celebrating,
  encouraging
}

class AICompanionWidget extends StatefulWidget {
  final CompanionState state;
  final String? message;
  final bool isDryRun;
  final Function()? onTap;
  final double size;

  const AICompanionWidget({
    super.key,
    required this.state,
    this.message,
    this.isDryRun = false,
    this.onTap,
    this.size = 150.0,
  });

  @override
  State<AICompanionWidget> createState() => _AICompanionWidgetState();
}

class _AICompanionWidgetState extends State<AICompanionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _rotationAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
      onTap: widget.onTap,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _getStateColor().withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animated background circle
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            _getStateColor().withOpacity(0.3),
                            _getStateColor().withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            
            // Companion icon/avatar
            _buildCompanionIcon(),
            
            // State indicator
            Positioned(
              bottom: 10,
              child: _buildStateIndicator(),
            ),
            
            // Dry-run badge
            if (widget.isDryRun)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.code,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanionIcon() {
    // Character icon based on state
    IconData icon;
    double iconSize = widget.size * 0.6;
    
    switch (widget.state) {
      case CompanionState.listening:
        icon = Icons.hearing;
        break;
      case CompanionState.thinking:
        icon = Icons.psychology;
        break;
      case CompanionState.playing:
        icon = Icons.play_circle_filled;
        break;
      case CompanionState.celebrating:
        icon = Icons.celebration;
        break;
      case CompanionState.encouraging:
        icon = Icons.favorite;
        break;
      default:
        icon = Icons.flutter_dash; // Default character icon
    }
    
    return Icon(
      icon,
      size: iconSize,
      color: _getStateColor(),
    );
  }

  Widget _buildStateIndicator() {
    String text;
    Color color = _getStateColor();
    
    switch (widget.state) {
      case CompanionState.listening:
        text = "👂 أستمع";
        break;
      case CompanionState.thinking:
        text = "💭 أفكر";
        break;
      case CompanionState.playing:
        text = "🎵 أتكلم";
        break;
      case CompanionState.celebrating:
        text = "🎉 أفرح";
        break;
      case CompanionState.encouraging:
        text = "💪 أشجع";
        break;
      default:
        text = "😊 جاهز";
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Color _getStateColor() {
    switch (widget.state) {
      case CompanionState.listening:
        return Colors.blue;
      case CompanionState.thinking:
        return Colors.purple;
      case CompanionState.playing:
        return Colors.green;
      case CompanionState.celebrating:
        return Colors.orange;
      case CompanionState.encouraging:
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}

/// Companion State Manager
class CompanionStateManager extends ChangeNotifier {
  CompanionState _currentState = CompanionState.idle;
  bool _isDryRun = false;
  
  CompanionState get currentState => _currentState;
  bool get isDryRun => _isDryRun;
  
  void setState(CompanionState state) {
    _currentState = state;
    notifyListeners();
  }
  
  void setDryRun(bool enabled) {
    _isDryRun = enabled;
    notifyListeners();
  }
  
  void startListening() {
    setState(CompanionState.listening);
  }
  
  void startThinking() {
    setState(CompanionState.thinking);
  }
  
  void startPlaying() {
    setState(CompanionState.playing);
  }
  
  void celebrate() {
    setState(CompanionState.celebrating);
    Timer(const Duration(seconds: 2), () {
      setState(CompanionState.idle);
    });
  }
  
  void encourage() {
    setState(CompanionState.encouraging);
    Timer(const Duration(seconds: 1), () {
      setState(CompanionState.idle);
    });
  }
  
  void reset() {
    setState(CompanionState.idle);
  }
}

