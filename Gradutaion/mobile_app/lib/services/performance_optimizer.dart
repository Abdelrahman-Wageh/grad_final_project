/// Performance Optimization Service
/// 
/// Ensures 60 FPS animations and smooth user experience.
/// Implements best practices for Flutter performance.
/// 
/// Requirements: 15.2, 25.7 (60 FPS performance)

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:developer' as developer;

class PerformanceOptimizer {
  static final PerformanceOptimizer _instance = PerformanceOptimizer._internal();
  factory PerformanceOptimizer() => _instance;
  PerformanceOptimizer._internal();

  // Frame timing tracking
  final List<Duration> _frameTimes = [];
  int _droppedFrames = 0;
  double _averageFps = 60.0;
  
  // Performance thresholds
  static const Duration targetFrameTime = Duration(milliseconds: 16); // 60 FPS
  static const int maxFrameHistory = 120; // 2 seconds at 60 FPS
  
  /// Initialize performance monitoring
  void initialize() {
    SchedulerBinding.instance.addTimingsCallback(_onFrameTiming);
    developer.log('Performance monitoring initialized');
  }

  /// Handle frame timing data
  void _onFrameTiming(List<FrameTiming> timings) {
    for (final timing in timings) {
      final frameDuration = timing.totalSpan;
      _frameTimes.add(frameDuration);
      
      // Track dropped frames (>16ms = dropped frame at 60 FPS)
      if (frameDuration > targetFrameTime) {
        _droppedFrames++;
      }
      
      // Keep only recent history
      if (_frameTimes.length > maxFrameHistory) {
        _frameTimes.removeAt(0);
      }
    }
    
    // Calculate average FPS
    if (_frameTimes.isNotEmpty) {
      final avgDuration = _frameTimes.reduce((a, b) => a + b) ~/ _frameTimes.length;
      _averageFps = 1000000 / avgDuration.inMicroseconds;
    }
  }

  /// Get current FPS
  double get currentFps => _averageFps;

  /// Get dropped frame count
  int get droppedFrames => _droppedFrames;

  /// Check if performance is good (>55 FPS)
  bool get isPerformanceGood => _averageFps >= 55.0;

  /// Reset performance metrics
  void reset() {
    _frameTimes.clear();
    _droppedFrames = 0;
    _averageFps = 60.0;
  }

  /// Log performance report
  void logPerformanceReport() {
    developer.log('''
Performance Report:
- Average FPS: ${_averageFps.toStringAsFixed(1)}
- Dropped Frames: $_droppedFrames
- Frame History: ${_frameTimes.length}
- Status: ${isPerformanceGood ? 'GOOD' : 'NEEDS OPTIMIZATION'}
    ''');
  }
}

/// Widget wrapper for performance optimization
/// 
/// Wraps widgets with RepaintBoundary to isolate repaints
class OptimizedWidget extends StatelessWidget {
  final Widget child;
  final bool enableRepaintBoundary;
  
  const OptimizedWidget({
    Key? key,
    required this.child,
    this.enableRepaintBoundary = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (enableRepaintBoundary) {
      return RepaintBoundary(child: child);
    }
    return child;
  }
}

/// Mixin for widgets that need performance optimization
mixin PerformanceOptimizedState<T extends StatefulWidget> on State<T> {
  /// Override to enable automatic RepaintBoundary
  bool get shouldUseRepaintBoundary => true;

  @override
  Widget build(BuildContext context) {
    final widget = buildOptimized(context);
    
    if (shouldUseRepaintBoundary) {
      return RepaintBoundary(child: widget);
    }
    return widget;
  }

  /// Implement this instead of build()
  Widget buildOptimized(BuildContext context);
}

/// Image preloader for faster loading
class ImagePreloader {
  static final ImagePreloader _instance = ImagePreloader._internal();
  factory ImagePreloader() => _instance;
  ImagePreloader._internal();

  final Set<String> _preloadedImages = {};

  /// Preload critical images
  Future<void> preloadImages(BuildContext context, List<String> imagePaths) async {
    for (final path in imagePaths) {
      if (!_preloadedImages.contains(path)) {
        try {
          await precacheImage(AssetImage(path), context);
          _preloadedImages.add(path);
          developer.log('Preloaded image: $path');
        } catch (e) {
          developer.log('Failed to preload image: $path - $e');
        }
      }
    }
  }

  /// Check if image is preloaded
  bool isPreloaded(String path) => _preloadedImages.contains(path);

  /// Clear preloaded images
  void clear() {
    _preloadedImages.clear();
  }
}

/// Animation performance helper
class AnimationPerformanceHelper {
  /// Create optimized animation controller
  static AnimationController createOptimizedController({
    required TickerProvider vsync,
    required Duration duration,
    double? value,
  }) {
    return AnimationController(
      vsync: vsync,
      duration: duration,
      value: value,
    );
  }

  /// Create curve animation with performance optimization
  static Animation<double> createCurvedAnimation({
    required Animation<double> parent,
    required Curve curve,
  }) {
    return CurvedAnimation(
      parent: parent,
      curve: curve,
    );
  }

  /// Dispose multiple controllers efficiently
  static void disposeControllers(List<AnimationController> controllers) {
    for (final controller in controllers) {
      controller.dispose();
    }
  }
}

/// Memory optimization utilities
class MemoryOptimizer {
  /// Clear image cache to free memory
  static void clearImageCache() {
    imageCache.clear();
    imageCache.clearLiveImages();
    developer.log('Image cache cleared');
  }

  /// Get image cache size
  static int getImageCacheSize() {
    return imageCache.currentSize;
  }

  /// Set image cache size limit
  static void setImageCacheLimit(int maxSize) {
    imageCache.maximumSize = maxSize;
    developer.log('Image cache limit set to: $maxSize');
  }
}
