/// Animation Controller System
/// 
/// Unity-inspired animation system for Flutter.
/// Handles character animations, transitions, and state machines.

import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animation State Machine
class AnimationStateMachine {
  String _currentState = 'idle';
  final Map<String, AnimationState> _states = {};
  final Map<String, List<AnimationTransition>> _transitions = {};
  
  AnimationStateMachine() {
    _initializeStates();
  }
  
  void _initializeStates() {
    // Define animation states
    _states['idle'] = AnimationState('idle', duration: const Duration(seconds: 2));
    _states['happy'] = AnimationState('happy', duration: const Duration(milliseconds: 1500));
    _states['excited'] = AnimationState('excited', duration: const Duration(milliseconds: 1200));
    _states['thinking'] = AnimationState('thinking', duration: const Duration(seconds: 3));
    _states['sad'] = AnimationState('sad', duration: const Duration(seconds: 2));
    _states['celebrating'] = AnimationState('celebrating', duration: const Duration(seconds: 2));
    _states['speaking'] = AnimationState('speaking', duration: const Duration(milliseconds: 500));
    _states['sleeping'] = AnimationState('sleeping', duration: const Duration(seconds: 4));
    _states['walking'] = AnimationState('walking', duration: const Duration(milliseconds: 800));
    _states['jumping'] = AnimationState('jumping', duration: const Duration(milliseconds: 600));
    _states['dancing'] = AnimationState('dancing', duration: const Duration(milliseconds: 1000));
    _states['waving'] = AnimationState('waving', duration: const Duration(milliseconds: 1200));
    
    // Define transitions
    _addTransition('idle', 'happy', condition: () => true);
    _addTransition('happy', 'excited', condition: () => true);
    _addTransition('excited', 'celebrating', condition: () => true);
    _addTransition('celebrating', 'idle', condition: () => true);
    _addTransition('idle', 'thinking', condition: () => true);
    _addTransition('thinking', 'idle', condition: () => true);
    _addTransition('idle', 'sad', condition: () => true);
    _addTransition('sad', 'idle', condition: () => true);
    _addTransition('idle', 'speaking', condition: () => true);
    _addTransition('speaking', 'idle', condition: () => true);
  }
  
  void _addTransition(String from, String to, {required bool Function() condition}) {
    if (!_transitions.containsKey(from)) {
      _transitions[from] = [];
    }
    _transitions[from]!.add(AnimationTransition(to, condition));
  }
  
  bool transitionTo(String newState) {
    if (!_states.containsKey(newState)) return false;
    
    // Check if transition is valid
    final transitions = _transitions[_currentState];
    if (transitions != null) {
      final validTransition = transitions.any((t) => t.targetState == newState && t.condition());
      if (validTransition) {
        _currentState = newState;
        return true;
      }
    }
    
    // Allow direct transition if no rules defined
    _currentState = newState;
    return true;
  }
  
  String get currentState => _currentState;
  AnimationState? getState(String stateName) => _states[stateName];
}

/// Animation State
class AnimationState {
  final String name;
  final Duration duration;
  final bool loop;
  
  AnimationState(
    this.name, {
    required this.duration,
    this.loop = true,
  });
}

/// Animation Transition
class AnimationTransition {
  final String targetState;
  final bool Function() condition;
  
  AnimationTransition(this.targetState, this.condition);
}

/// Advanced Animation Controller
class AdvancedAnimationController {
  final AnimationStateMachine stateMachine = AnimationStateMachine();
  final Map<String, AnimationController> _controllers = {};
  
  /// Initialize animation controller
  void initialize(TickerProvider vsync) {
    // Create controllers for each state
    for (final state in stateMachine._states.values) {
      final controller = AnimationController(
        vsync: vsync,
        duration: state.duration,
      );
      
      if (state.loop) {
        controller.repeat();
      }
      
      _controllers[state.name] = controller;
    }
  }
  
  /// Play animation
  void play(String animationName) {
    if (stateMachine.transitionTo(animationName)) {
      // Stop all other animations
      for (final entry in _controllers.entries) {
        if (entry.key != animationName) {
          entry.value.stop();
        }
      }
      
      // Start new animation
      final controller = _controllers[animationName];
      if (controller != null) {
        controller.forward(from: 0);
      }
    }
  }
  
  /// Get current animation controller
  AnimationController? getCurrentController() {
    return _controllers[stateMachine.currentState];
  }
  
  /// Dispose all controllers
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }
}

/// Particle System for effects
class ParticleSystem {
  final List<Particle> particles = [];
  final int maxParticles;
  final Duration lifetime;
  
  ParticleSystem({
    this.maxParticles = 100,
    this.lifetime = const Duration(seconds: 2),
  });
  
  /// Emit particles
  void emit({
    required Offset position,
    required int count,
    required Color color,
    double speed = 100.0,
    double spread = math.pi * 2,
  }) {
    final random = math.Random();
    
    for (int i = 0; i < count && particles.length < maxParticles; i++) {
      final angle = random.nextDouble() * spread;
      final velocity = Offset(
        math.cos(angle) * speed,
        math.sin(angle) * speed,
      );
      
      particles.add(Particle(
        position: position,
        velocity: velocity,
        color: color,
        size: 4.0 + random.nextDouble() * 4.0,
        lifetime: lifetime,
      ));
    }
  }
  
  /// Update particles
  void update(Duration delta) {
    particles.removeWhere((p) => p.isDead);
    
    for (final particle in particles) {
      particle.update(delta);
    }
  }
  
  /// Clear all particles
  void clear() {
    particles.clear();
  }
}

/// Individual Particle
class Particle {
  Offset position;
  Offset velocity;
  final Color color;
  final double size;
  final Duration lifetime;
  Duration age = Duration.zero;
  
  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.lifetime,
  });
  
  void update(Duration delta) {
    age += delta;
    position += velocity * (delta.inMilliseconds / 1000.0);
    velocity *= 0.98; // Friction
  }
  
  bool get isDead => age >= lifetime;
  
  double get opacity {
    final progress = age.inMilliseconds / lifetime.inMilliseconds;
    return 1.0 - progress;
  }
}

/// Tween Animation Helpers
class TweenAnimations {
  /// Bounce animation
  static Animation<double> bounce(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 0.9)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
    ]).animate(controller);
  }
  
  /// Shake animation
  static Animation<double> shake(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -10.0, end: 0.0), weight: 1),
    ]).animate(controller);
  }
  
  /// Pulse animation
  static Animation<double> pulse(AnimationController controller) {
    return Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  /// Fade animation
  static Animation<double> fade(AnimationController controller) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );
  }
  
  /// Slide animation
  static Animation<Offset> slide(
    AnimationController controller, {
    Offset begin = const Offset(0.0, 1.0),
    Offset end = Offset.zero,
  }) {
    return Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ),
    );
  }
  
  /// Scale animation
  static Animation<double> scale(
    AnimationController controller, {
    double begin = 0.0,
    double end = 1.0,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ),
    );
  }
  
  /// Rotation animation
  static Animation<double> rotate(AnimationController controller) {
    return Tween<double>(begin: 0.0, end: 2 * math.pi).animate(controller);
  }
}

/// Animation Presets
class AnimationPresets {
  /// Celebration animation sequence
  static Future<void> celebration(TickerProvider vsync, VoidCallback onComplete) async {
    final controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2000),
    );
    
    await controller.forward();
    onComplete();
    controller.dispose();
  }
  
  /// Star collection animation
  static Future<void> starCollect(TickerProvider vsync, VoidCallback onComplete) async {
    final controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 800),
    );
    
    await controller.forward();
    onComplete();
    controller.dispose();
  }
}
