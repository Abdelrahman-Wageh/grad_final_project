import 'package:flutter/foundation.dart';
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

/// Initializes the Smartino app
/// - Sets up Hive database
/// - Registers type adapters
/// - Validates AI model paths
/// - Loads dev settings
class AppInitializer {
  static bool _isInitialized = false;

  /// Initialize the app
  /// Returns true if successful, false otherwise
  static Future<InitializationResult> initialize() async {
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

      // Step 4: Load and validate dev settings
      final devSettings = await DevSettings.load();
      final validation = await devSettings.validateModelPaths();

      // Step 5: Log initialization status
      if (kDebugMode) {
        print('=== Smartino Initialization ===');
        print('Hive initialized: ✓');
        print('Adapters registered: ✓');
        print('Boxes opened: ✓');
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
    // Register AIMode adapter
    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(AIModeAdapter());
    }

    // Register DevSettings adapter (will be generated)
    // if (!Hive.isAdapterRegistered(8)) {
    //   Hive.registerAdapter(DevSettingsAdapter());
    // }

    // Register existing adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChildProfileAdapter());
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GameStateAdapter());
    }

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ChallengeAdapter());
    }

    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(InteractionLogAdapter());
    }

    // Register Phase 1 adapters
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(SpacedRepetitionCardAdapter());
    }

    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(ConversationHistoryAdapter());
    }

    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(MessageRoleAdapter());
    }

    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(MessageAdapter());
    }
  }

  /// Open all Hive boxes
  static Future<void> _openBoxes() async {
    // Open dev settings box
    if (!Hive.isBoxOpen('dev_settings')) {
      await Hive.openBox<DevSettings>('dev_settings');
    }

    // Open existing boxes
    if (!Hive.isBoxOpen('profiles')) {
      await Hive.openBox<ChildProfile>('profiles');
    }

    if (!Hive.isBoxOpen('game_states')) {
      await Hive.openBox<GameState>('game_states');
    }

    if (!Hive.isBoxOpen('challenges')) {
      await Hive.openBox<Challenge>('challenges');
    }

    if (!Hive.isBoxOpen('interaction_logs')) {
      await Hive.openBox<InteractionLog>('interaction_logs');
    }

    // Open Phase 1 boxes
    if (!Hive.isBoxOpen('conversations')) {
      await Hive.openBox<ConversationHistory>('conversations');
    }

    if (!Hive.isBoxOpen('messages')) {
      await Hive.openBox<Message>('messages');
    }

    if (!Hive.isBoxOpen('sr_cards')) {
      await Hive.openBox<SpacedRepetitionCard>('sr_cards');
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
