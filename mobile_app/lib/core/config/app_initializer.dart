import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'dev_settings.dart';
import 'ai_mode_adapter.dart';
import '../../data/models/child_profile.dart';
import '../../models/game_state.dart';
import '../../models/challenge.dart';
import '../../models/interaction_log.dart';
import '../../models/spaced_repetition_card.dart';
import '../../models/conversation_history.dart';
import '../../models/message.dart';
import '../../models/stage_progress.dart';
import '../performance/asset_preloader.dart';
import '../performance/memory_manager.dart';
import '../../services/performance_optimizer.dart';

/// Initializes the Smartino app
/// - Sets up Hive database
/// - Registers type adapters
/// - Validates AI model paths
/// - Loads dev settings
class AppInitializer {
  static bool _isInitialized = false;

  /// Initialize the app
  /// Returns true if successful, false otherwise
  static Future<InitializationResult> initialize({BuildContext? context}) async {
    if (_isInitialized) {
      return InitializationResult(
        success: true,
        message: 'App already initialized',
      );
    }

    try {
      // Step 1: Initialize Hive
      await _initializeHive();

      // Step 2: Register Hive adapters
      await _registerAdapters();

      // Step 3: Open Hive boxes
      await _openBoxes();

      // Step 4: Initialize performance optimizations
      await _initializePerformance(context);

      // Step 5: Load and validate dev settings
      final devSettings = await DevSettings.load();
      final validation = await devSettings.validateModelPaths();

      // Step 6: Log initialization status
      if (kDebugMode) {
        print('=== Smartino Initialization ===');
        print('Hive initialized: ✓');
        print('Adapters registered: ✓');
        print('Boxes opened: ✓');
        print('Performance optimized: ✓');
        print('Dev Settings: $devSettings');
        print('Model Validation: $validation');
        print('==============================');
      }

      _isInitialized = true;

      return InitializationResult(
        success: true,
        message: 'App initialized successfully',
        devSettings: devSettings,
        modelValidation: validation,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('=== Initialization Error ===');
        print('Error: $e');
        print('Stack trace: $stackTrace');
        print('===========================');
      }

      return InitializationResult(
        success: false,
        message: 'Initialization failed: $e',
        error: e,
      );
    }
  }

  /// Initialize performance optimizations
  static Future<void> _initializePerformance(BuildContext? context) async {
    // Initialize memory manager
    MemoryManager().initialize();
    
    // Initialize performance optimizer
    PerformanceOptimizer().initialize();
    
    // Preload critical assets if context is available
    if (context != null) {
      await AssetPreloader().initialize(context);
    }
    
    if (kDebugMode) {
      print('Performance optimizations initialized');
    }
  }

  /// Initialize Hive database
  static Future<void> _initializeHive() async {
    if (kIsWeb) {
      // Web: Use browser storage
      await Hive.initFlutter();
    } else {
      // Mobile: Use app documents directory
      final appDocDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocDir.path);
    }
  }

  /// Register all Hive type adapters
  static Future<void> _registerAdapters() async {
    // Register each adapter individually with proper checks
    // This prevents duplicate registration errors on hot reload
    
    // Helper function to safely register an adapter with explicit type
    void safeRegisterAdapter<T>(int typeId, TypeAdapter<T> adapter, String name) {
      try {
        if (!Hive.isAdapterRegistered(typeId)) {
          Hive.registerAdapter<T>(adapter);
          if (kDebugMode) print('Registered $name (typeId: $typeId)');
        } else {
          if (kDebugMode) print('$name (typeId: $typeId) already registered');
        }
      } catch (e) {
        if (kDebugMode) print('Skipping $name (typeId: $typeId) - already registered');
      }
    }
    
    try {
      // Register existing adapters with explicit types
      safeRegisterAdapter<ChildProfile>(0, ChildProfileAdapter(), 'ChildProfileAdapter');
      safeRegisterAdapter<GameState>(1, GameStateAdapter(), 'GameStateAdapter');
      safeRegisterAdapter<Challenge>(2, ChallengeAdapter(), 'ChallengeAdapter');
      safeRegisterAdapter<InteractionLog>(3, InteractionLogAdapter(), 'InteractionLogAdapter');
      
      // Register Phase 1 adapters with explicit types
      safeRegisterAdapter<SpacedRepetitionCard>(5, SpacedRepetitionCardAdapter(), 'SpacedRepetitionCardAdapter');
      safeRegisterAdapter<ConversationHistory>(6, ConversationHistoryAdapter(), 'ConversationHistoryAdapter');
      safeRegisterAdapter<MessageRole>(7, MessageRoleAdapter(), 'MessageRoleAdapter');
      safeRegisterAdapter<Message>(8, MessageAdapter(), 'MessageAdapter');
      
      // Register AIMode adapter with explicit type
      safeRegisterAdapter<AIMode>(9, AIModeAdapter(), 'AIModeAdapter');
      
      // Register Smartino adapters with explicit types
      safeRegisterAdapter<StageProgress>(10, StageProgressAdapter(), 'StageProgressAdapter');
      
      // Register DevSettings adapter with explicit type
      safeRegisterAdapter<DevSettings>(11, DevSettingsAdapter(), 'DevSettingsAdapter');
      
      if (kDebugMode) {
        print('All Hive adapters registered successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in adapter registration process: $e');
      }
      // Don't rethrow - allow app to continue even if some adapters fail
    }
  }

  /// Open all Hive boxes
  static Future<void> _openBoxes() async {
    try {
      // Open dev settings box
      if (!Hive.isBoxOpen('dev_settings')) {
        await Hive.openBox<DevSettings>('dev_settings');
        if (kDebugMode) print('Opened dev_settings box');
      }

      // Open existing boxes
      if (!Hive.isBoxOpen('profiles')) {
        await Hive.openBox<ChildProfile>('profiles');
        if (kDebugMode) print('Opened profiles box');
      }

      // Open child_profile box (used by StorageService)
      if (!Hive.isBoxOpen('child_profile')) {
        await Hive.openBox<ChildProfile>('child_profile');
        if (kDebugMode) print('Opened child_profile box');
      }

      if (!Hive.isBoxOpen('game_states')) {
        await Hive.openBox<GameState>('game_states');
        if (kDebugMode) print('Opened game_states box');
      }

      if (!Hive.isBoxOpen('challenges')) {
        await Hive.openBox<Challenge>('challenges');
        if (kDebugMode) print('Opened challenges box');
      }

      if (!Hive.isBoxOpen('interaction_logs')) {
        await Hive.openBox<InteractionLog>('interaction_logs');
        if (kDebugMode) print('Opened interaction_logs box');
      }

      // Open Phase 1 boxes
      if (!Hive.isBoxOpen('conversations')) {
        await Hive.openBox<ConversationHistory>('conversations');
        if (kDebugMode) print('Opened conversations box');
      }

      if (!Hive.isBoxOpen('messages')) {
        await Hive.openBox<Message>('messages');
        if (kDebugMode) print('Opened messages box');
      }

      if (!Hive.isBoxOpen('sr_cards')) {
        await Hive.openBox<SpacedRepetitionCard>('sr_cards');
        if (kDebugMode) print('Opened sr_cards box');
      }
      
      // Open Smartino boxes
      if (!Hive.isBoxOpen('stage_progress')) {
        await Hive.openBox<StageProgress>('stage_progress');
        if (kDebugMode) print('Opened stage_progress box');
      }
      
      // Open game settings box (for character selection and game progress)
      if (!Hive.isBoxOpen('game_settings')) {
        await Hive.openBox('game_settings');
        if (kDebugMode) print('Opened game_settings box');
      }
      
      if (kDebugMode) {
        print('All Hive boxes opened successfully');
        print('Total boxes open: ${Hive.box('game_settings') != null ? 'verified' : 'error'}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error opening Hive boxes: $e');
      }
      rethrow;
    }
  }

  /// Close all Hive boxes (for cleanup)
  static Future<void> cleanup() async {
    await Hive.close();
    _isInitialized = false;
  }

  /// Check if app is initialized
  static bool get isInitialized => _isInitialized;
}

/// Result of app initialization
class InitializationResult {
  final bool success;
  final String message;
  final DevSettings? devSettings;
  final ModelPathValidation? modelValidation;
  final Object? error;

  InitializationResult({
    required this.success,
    required this.message,
    this.devSettings,
    this.modelValidation,
    this.error,
  });

  bool get hasModelErrors => modelValidation?.hasErrors ?? false;

  String get fullMessage {
    if (!success) return message;
    
    final buffer = StringBuffer(message);
    
    if (modelValidation != null) {
      buffer.write('\n\n');
      buffer.write(modelValidation.toString());
    }
    
    return buffer.toString();
  }

  @override
  String toString() {
    return 'InitializationResult(success: $success, message: $message, '
           'hasModelErrors: $hasModelErrors)';
  }
}
