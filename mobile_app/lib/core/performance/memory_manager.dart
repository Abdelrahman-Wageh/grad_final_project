/// Memory Manager Service
/// 
/// Manages memory usage and prevents memory leaks.
/// Implements Requirements: Task 22.4 (Reduce memory usage)

import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  // Memory thresholds
  static const int maxImageCacheSize = 100; // Max number of cached images
  static const int maxImageCacheBytes = 50 * 1024 * 1024; // 50 MB

  /// Initialize memory manager
  void initialize() {
    _configureImageCache();
    developer.log('MemoryManager: Initialized');
  }

  /// Configure image cache limits
  void _configureImageCache() {
    imageCache.maximumSize = maxImageCacheSize;
    imageCache.maximumSizeBytes = maxImageCacheBytes;
    
    developer.log('MemoryManager: Image cache configured');
    developer.log('  - Max size: $maxImageCacheSize images');
    developer.log('  - Max bytes: ${maxImageCacheBytes ~/ (1024 * 1024)} MB');
  }

  /// Clear image cache to free memory
  void clearImageCache() {
    final currentSize = imageCache.currentSize;
    final currentBytes = imageCache.currentSizeBytes;
    
    imageCache.clear();
    imageCache.clearLiveImages();
    
    developer.log('MemoryManager: Cleared image cache');
    developer.log('  - Freed $currentSize images');
    developer.log('  - Freed ${currentBytes ~/ 1024} KB');
  }

  /// Get current memory usage
  Map<String, dynamic> getMemoryUsage() {
    return {
      'image_cache_size': imageCache.currentSize,
      'image_cache_bytes': imageCache.currentSizeBytes,
      'image_cache_max_size': imageCache.maximumSize,
      'image_cache_max_bytes': imageCache.maximumSizeBytes,
      'cache_usage_percent': (imageCache.currentSize / imageCache.maximumSize * 100).toStringAsFixed(1),
    };
  }

  /// Check if memory usage is high
  bool isMemoryUsageHigh() {
    final usage = imageCache.currentSize / imageCache.maximumSize;
    return usage > 0.8; // 80% threshold
  }

  /// Optimize memory if usage is high
  void optimizeIfNeeded() {
    if (isMemoryUsageHigh()) {
      developer.log('MemoryManager: High memory usage detected, optimizing...');
      clearImageCache();
    }
  }

  /// Log memory statistics
  void logMemoryStats() {
    final stats = getMemoryUsage();
    developer.log('''
MemoryManager Statistics:
- Image Cache: ${stats['image_cache_size']} / ${stats['image_cache_max_size']} images
- Cache Bytes: ${stats['image_cache_bytes'] ~/ 1024} KB / ${stats['image_cache_max_bytes'] ~/ 1024} KB
- Usage: ${stats['cache_usage_percent']}%
    ''');
  }
}

/// Mixin for widgets that need memory management
mixin MemoryOptimizedState<T extends StatefulWidget> on State<T> {
  @override
  void dispose() {
    // Check and optimize memory on widget disposal
    MemoryManager().optimizeIfNeeded();
    super.dispose();
  }
}

/// Disposable resource tracker
class DisposableTracker {
  static final DisposableTracker _instance = DisposableTracker._internal();
  factory DisposableTracker() => _instance;
  DisposableTracker._internal();

  final Set<String> _activeResources = {};

  /// Register a resource
  void register(String resourceId) {
    _activeResources.add(resourceId);
    developer.log('DisposableTracker: Registered $resourceId');
  }

  /// Unregister a resource
  void unregister(String resourceId) {
    _activeResources.remove(resourceId);
    developer.log('DisposableTracker: Unregistered $resourceId');
  }

  /// Get active resources count
  int get activeResourcesCount => _activeResources.length;

  /// Check for potential memory leaks
  void checkForLeaks() {
    if (_activeResources.length > 50) {
      developer.log('DisposableTracker: WARNING - High number of active resources: ${_activeResources.length}');
      developer.log('Active resources: $_activeResources');
    }
  }

  /// Clear all tracked resources
  void clear() {
    _activeResources.clear();
    developer.log('DisposableTracker: Cleared all tracked resources');
  }
}
