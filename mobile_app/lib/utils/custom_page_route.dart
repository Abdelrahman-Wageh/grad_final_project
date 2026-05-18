import 'package:flutter/material.dart';

/// Custom page route with elastic curve animations
/// Provides smooth, playful transitions between screens
class ElasticPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;
  
  ElasticPageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 400),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Elastic curve for playful feel
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.elasticOut,
              reverseCurve: Curves.easeIn,
            );
            
            // Slide and fade transition
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );
}

/// Bounce page route for extra playful transitions
class BouncePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;
  
  BouncePageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 500),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Bounce curve for extra playfulness
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.bounceOut,
              reverseCurve: Curves.easeIn,
            );
            
            // Scale and fade transition
            return ScaleTransition(
              scale: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(curvedAnimation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );
}

/// Hero page route for mascot transitions
class HeroPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;
  
  HeroPageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 400),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Elastic curve with slide
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.elasticOut,
              reverseCurve: Curves.easeIn,
            );
            
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );
}

/// Utility class for navigation with custom transitions
class AppNavigator {
  /// Navigate with elastic transition
  static Future<T?> pushElastic<T>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.of(context).push<T>(
      ElasticPageRoute(page: page),
    );
  }
  
  /// Navigate with bounce transition
  static Future<T?> pushBounce<T>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.of(context).push<T>(
      BouncePageRoute(page: page),
    );
  }
  
  /// Navigate with hero transition
  static Future<T?> pushHero<T>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.of(context).push<T>(
      HeroPageRoute(page: page),
    );
  }
  
  /// Replace with elastic transition
  static Future<T?> replaceElastic<T, TO>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.of(context).pushReplacement<T, TO>(
      ElasticPageRoute(page: page),
    );
  }
}
