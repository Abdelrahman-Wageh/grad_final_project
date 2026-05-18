import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/local_ai_service.dart';
import '../services/dual_brain_ai_service.dart';
import '../models/message.dart';
import '../core/config/dev_settings.dart';

part 'ai_service_provider.g.dart';

/// Local AI Service Provider
/// 
/// Provides access to Whisper STT, Qwen LLM, and Coqui TTS
/// Requirements: 26.1, 26.2
@riverpod
LocalAIService localAIService(LocalAIServiceRef ref) {
  return LocalAIService();
}

/// Dual Brain AI Service Provider
/// 
/// Provides access to NLU (rule-based) and LLM (generative) modes
/// Requirements: 26.1, 26.2
@riverpod
class DualBrainAI extends _$DualBrainAI {
  @override
  DualBrainAIService build() {
    return DualBrainAIService();
  }

  /// Get current AI mode
  AIMode get currentMode => state.currentMode;

  /// Set AI mode
  void setMode(AIMode mode) {
    state.setMode(mode);
  }

  /// Toggle between NLU and LLM modes
  void toggleMode() {
    state.toggleMode();
  }

  /// Process input using current AI mode
  /// 
  /// Routes to NLU or LLM based on current mode
  /// Requirements: 24.5, 26.2
  Future<String> processInput({
    required String input,
    String? context,
    List<Message>? conversationHistory,
  }) async {
    return await state.processInput(
      input: input,
      context: context,
      conversationHistory: conversationHistory,
    );
  }

  /// Process input using NLU (rule-based) mode
  Future<NLUResult> processNLU(String input, {String? context}) async {
    return await state.processNLU(input, context: context);
  }

  /// Process input using LLM (generative) mode
  Future<LLMResponse> processLLM(
    String input, {
    List<Message>? conversationHistory,
  }) async {
    return await state.processLLM(
      input,
      conversationHistory: conversationHistory,
    );
  }
}
