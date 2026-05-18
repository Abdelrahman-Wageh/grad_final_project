/// Asset Preloader Service
/// 
/// Preloads critical assets for faster app startup and smoother experience.
/// Implements Requirements: Task 22.2 (Optimize asset loading)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;

class AssetPreloader {
  static final AssetPreloader _instance = AssetPreloader._internal();
  factory AssetPreloader() => _instance;
  AssetPreloader._internal();

  final Set<String> _preloadedImages = {};
  final Set<String> _preloadedSounds = {};
  bool _isInitialized = false;

  /// Critical images to preload on app startup
  static const List<String> criticalImages = [
    'assets/images/farfour_idle.png',
    'assets/images/farfour_happy.png',
    'assets/images/farfour_thinking.png',
    'assets/images/splash_logo.png',
    'assets/images/chapter_icons/arabic_letters.png',
    'assets/images/chapter_icons/english_letters.png',
    'assets/images/chapter_icons/numbers.png',
    'assets/images/chapter_icons/colors.png',
  ];

  /// Critical sounds to preload
  static const List<String> criticalSounds = [
    'assets/sounds/celebration.mp3',
    'assets/sounds/correct.mp3',
    'assets/sounds/tap.mp3',
    'assets/sounds/unlock.mp3',
  ];

  /// Initialize and preload critical assets
  Future<void> initialize(BuildContext context) async {
    if (_isInitialized) return;

    developer.log('AssetPreloader: Starting initialization...');
    final startTime = DateTime.now();

    try {
      // Preload images in parallel
      await Future.wait([
        _preloadImages(context, criticalImages),
        _preloadSounds(criticalSounds),
      ]);

      _isInitialized = true;
      final duration = DateTime.now().difference(startTime);
      developer.log('AssetPreloader: Initialized in ${duration.inMilliseconds}ms');
    } catch (e) {
      developer.log('AssetPreloader: Error during initialization: $e');
    }
  }

  /// Preload images
  Future<void> _preloadImages(BuildContext context, List<String> imagePaths) async {
    for (final path in imagePaths) {
      if (!_preloadedImages.contains(path)) {
        try {
          await precacheImage(AssetImage(path), context);
          _preloadedImages.add(path);
          developer.log('Preloaded image: $path');
        } catch (e) {
          // Image might not exist yet, skip silently
          developer.log('Failed to preload image: $path');
        }
      }
    }
  }

  /// Preload sounds (verify they exist)
  Future<void> _preloadSounds(List<String> soundPaths) async {
    for (final path in soundPaths) {
      if (!_preloadedSounds.contains(path)) {
        try {
          await rootBundle.load(path);
          _preloadedSounds.add(path);
          developer.log('Verified sound: $path');
        } catch (e) {
          // Sound might not exist yet, skip silently
          developer.log('Failed to verify sound: $path');
        }
      }
    }
  }

  /// Preload additional images on demand
  Future<void> preloadImages(BuildContext context, List<String> imagePaths) async {
    await _preloadImages(context, imagePaths);
  }

  /// Check if image is preloaded
  bool isImagePreloaded(String path) => _preloadedImages.contains(path);

  /// Check if sound is preloaded
  bool isSoundPreloaded(String path) => _preloadedSounds.contains(path);

  /// Clear all preloaded assets
  void clear() {
    _preloadedImages.clear();
    _preloadedSounds.clear();
    _isInitialized = false;
    developer.log('AssetPreloader: Cleared all preloaded assets');
  }

  /// Get preload statistics
  Map<String, dynamic> getStatistics() {
    return {
      'initialized': _isInitialized,
      'preloaded_images': _preloadedImages.length,
      'preloaded_sounds': _preloadedSounds.length,
      'total_assets': _preloadedImages.length + _preloadedSounds.length,
    };
  }
}

/// Widget wrapper for lazy loading
class LazyLoadWidget extends StatefulWidget {
  final Widget child;
  final Widget placeholder;
  final Duration delay;

  const LazyLoadWidget({
    Key? key,
    required this.child,
    required this.placeholder,
    this.delay = const Duration(milliseconds: 100),
  }) : super(key: key);

  @override
  State<LazyLoadWidget> createState() => _LazyLoadWidgetState();
}

class _LazyLoadWidgetState extends State<LazyLoadWidget> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded ? widget.child : widget.placeholder;
  }
}

/// Optimized image widget with caching
class OptimizedImage extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const OptimizedImage({
    Key? key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Icon(Icons.image_not_supported),
        );
      },
    );
  }
}
