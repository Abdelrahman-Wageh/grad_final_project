import 'package:hive/hive.dart';
import 'dart:io';

part 'dev_settings.g.dart';

/// AI Mode for the Dual Brain system
enum AIMode {
  nlu,  // Rule-based, fast, safe (for games)
  llm,  // Generative, conversational (for Friend Tab)
}

/// Developer settings for Smartino app
/// Configures local AI model paths and AI mode toggle
@HiveType(typeId: 11)
class DevSettings extends HiveObject {
  /// Current AI mode (NLU or LLM)
  @HiveField(0)
  AIMode aiMode;

  /// Path to Whisper STT model
  @HiveField(1)
  String whisperPath;

  /// Path to Qwen LLM model
  @HiveField(2)
  String qwenPath;

  /// Path to Coqui/VITS TTS model
  @HiveField(3)
  String ttsPath;

  /// Enable debug logs
  @HiveField(4)
  bool enableDebugLogs;

  /// Show performance overlay
  @HiveField(5)
  bool showPerformanceOverlay;

  DevSettings({
    this.aiMode = AIMode.nlu,
    this.whisperPath = r'E:\Projects\Models\Whisper\whisper-small-egyptian-arabic',
    this.qwenPath = r'E:\Projects\Models\LLMs\Qwen\Qwen3-4B-ggfu',
    this.ttsPath = r'E:\Projects\Models\TTS',
    this.enableDebugLogs = false,
    this.showPerformanceOverlay = false,
  });

  /// Validate that all model paths exist
  Future<ModelPathValidation> validateModelPaths() async {
    final validation = ModelPathValidation();

    // Check Whisper path
    validation.whisperExists = await Directory(whisperPath).exists();
    if (!validation.whisperExists) {
      validation.errors.add('Whisper model not found at: $whisperPath');
    }

    // Check Qwen path
    validation.qwenExists = await Directory(qwenPath).exists();
    if (!validation.qwenExists) {
      validation.errors.add('Qwen model not found at: $qwenPath');
    }

    // Check TTS path
    validation.ttsExists = await Directory(ttsPath).exists();
    if (!validation.ttsExists) {
      validation.errors.add('TTS model not found at: $ttsPath');
    }

    validation.isValid = validation.whisperExists && 
                        validation.qwenExists && 
                        validation.ttsExists;

    return validation;
  }

  /// Toggle between NLU and LLM modes
  void toggleAIMode() {
    aiMode = aiMode == AIMode.nlu ? AIMode.llm : AIMode.nlu;
    save(); // Save to Hive
  }

  /// Set AI mode explicitly
  void setAIMode(AIMode mode) {
    aiMode = mode;
    save();
  }

  /// Update model paths
  void updatePaths({
    String? whisper,
    String? qwen,
    String? tts,
  }) {
    if (whisper != null) whisperPath = whisper;
    if (qwen != null) qwenPath = qwen;
    if (tts != null) ttsPath = tts;
    save();
  }

  /// Enable/disable debug features
  void setDebugMode(bool enabled) {
    enableDebugLogs = enabled;
    showPerformanceOverlay = enabled;
    save();
  }

  /// Create default settings
  static DevSettings createDefault() {
    return DevSettings();
  }

  /// Load settings from Hive or create default
  static Future<DevSettings> load() async {
    final box = await Hive.openBox<DevSettings>('dev_settings');
    
    if (box.isEmpty) {
      final settings = createDefault();
      await box.add(settings);
      return settings;
    }
    
    return box.getAt(0)!;
  }

  @override
  String toString() {
    return 'DevSettings(aiMode: $aiMode, whisperPath: $whisperPath, '
           'qwenPath: $qwenPath, ttsPath: $ttsPath, '
           'debugLogs: $enableDebugLogs, perfOverlay: $showPerformanceOverlay)';
  }
}

/// Result of model path validation
class ModelPathValidation {
  bool isValid = false;
  bool whisperExists = false;
  bool qwenExists = false;
  bool ttsExists = false;
  List<String> errors = [];

  bool get hasErrors => errors.isNotEmpty;

  String get errorMessage => errors.join('\n');

  @override
  String toString() {
    if (isValid) {
      return 'All model paths are valid ✓';
    }
    return 'Model path validation failed:\n$errorMessage';
  }
}

/// Extension for AIMode enum
extension AIModeExtension on AIMode {
  String get displayName {
    switch (this) {
      case AIMode.nlu:
        return 'NLU Mode (Rule-Based)';
      case AIMode.llm:
        return 'LLM Mode (Conversational)';
    }
  }

  String get description {
    switch (this) {
      case AIMode.nlu:
        return 'Fast, predictable responses for games (<50ms)';
      case AIMode.llm:
        return 'Natural conversation with Qwen (~500ms)';
    }
  }

  bool get isNLU => this == AIMode.nlu;
  bool get isLLM => this == AIMode.llm;
}
