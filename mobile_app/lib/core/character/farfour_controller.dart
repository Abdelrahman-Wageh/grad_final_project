/// Farfour Character Controller
/// Manages the Farfour character's animations, moods, and behaviors
/// Adapted from Antura system with Egyptian Arabic personality

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Farfour's mood states
enum FarfourMood {
  idle,       // Default state, breathing animation
  happy,      // Success, celebration
  thinking,   // Processing, considering
  excited,    // Very happy, jumping
  encouraging,// Supportive, never sad
  talking,    // Speaking with lip-sync
  listening,  // Attentive, ears perked
  sleeping,   // Resting between sessions
}

/// Farfour animation state
class FarfourState {
  final FarfourMood mood;
  final String currentAnimation;
  final bool isAnimating;
  final double scale;
  final Offset position;
  
  const FarfourState({
    this.mood = FarfourMood.idle,
    this.currentAnimation = 'idle',
    this.isAnimating = false,
    this.scale = 1.0,
    this.position = Offset.zero,
  });
  
  FarfourState copyWith({
    FarfourMood? mood,
    String? currentAnimation,
    bool? isAnimating,
    double? scale,
    Offset? position,
  }) {
    return FarfourState(
      mood: mood ?? this.mood,
      currentAnimation: currentAnimation ?? this.currentAnimation,
      isAnimating: isAnimating ?? this.isAnimating,
      scale: scale ?? this.scale,
      position: position ?? this.position,
    );
  }
}

/// Farfour Controller - manages character state and animations
class FarfourController extends StateNotifier<FarfourState> {
  FarfourController() : super(const FarfourState());
  
  /// Set Farfour's mood
  void setMood(FarfourMood mood) {
    final animation = _getAnimationForMood(mood);
    state = state.copyWith(
      mood: mood,
      currentAnimation: animation,
      isAnimating: true,
    );
  }
  
  /// Play celebration animation
  void celebrate() {
    setMood(FarfourMood.excited);
    // Return to happy after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setMood(FarfourMood.happy);
      }
    });
  }
  
  /// Play encouraging animation (never show sad)
  void encourage() {
    setMood(FarfourMood.encouraging);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setMood(FarfourMood.idle);
      }
    });
  }
  
  /// Start talking animation
  void startTalking() {
    setMood(FarfourMood.talking);
  }
  
  /// Stop talking animation
  void stopTalking() {
    setMood(FarfourMood.idle);
  }
  
  /// Start listening animation
  void startListening() {
    setMood(FarfourMood.listening);
  }
  
  /// Stop listening animation
  void stopListening() {
    setMood(FarfourMood.idle);
  }
  
  /// Shorthand methods for common actions
  void speak(String text) {
    startTalking();
  }
  
  void listen() {
    startListening();
  }
  
  void idle() {
    setMood(FarfourMood.idle);
  }
  
  void happy() {
    setMood(FarfourMood.happy);
  }
  
  /// Show thinking animation
  void think() {
    setMood(FarfourMood.thinking);
  }
  
  /// Scale animation (bounce effect)
  void bounce() {
    state = state.copyWith(scale: 1.2);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        state = state.copyWith(scale: 1.0);
      }
    });
  }
  
  /// Move Farfour to position
  void moveTo(Offset position, {Duration duration = const Duration(milliseconds: 500)}) {
    state = state.copyWith(position: position);
  }
  
  /// Reset to idle state
  void reset() {
    state = const FarfourState();
  }
  
  /// Get animation name for mood
  String _getAnimationForMood(FarfourMood mood) {
    switch (mood) {
      case FarfourMood.idle:
        return 'idle';
      case FarfourMood.happy:
        return 'happy';
      case FarfourMood.thinking:
        return 'thinking';
      case FarfourMood.excited:
        return 'celebrate';
      case FarfourMood.encouraging:
        return 'encourage';
      case FarfourMood.talking:
        return 'talking';
      case FarfourMood.listening:
        return 'listening';
      case FarfourMood.sleeping:
        return 'sleeping';
    }
  }
  
  bool get mounted => true; // Override in actual implementation
}

/// Provider for Farfour controller
final farfourControllerProvider = StateNotifierProvider<FarfourController, FarfourState>(
  (ref) => FarfourController(),
);
