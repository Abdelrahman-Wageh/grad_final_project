import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/ai/ai_orchestrator.dart';
import '../services/ai/groq_service.dart';
import '../services/ai/elevenlabs_service.dart';
import '../services/local_ai_service.dart';
import 'storage_service_provider.dart';

part 'ai_service_provider.g.dart';

/// Groq Service Provider
@riverpod
GroqService groqService(GroqServiceRef ref) {
  return GroqService();
}

/// ElevenLabs Service Provider
@riverpod
ElevenLabsService elevenLabsService(ElevenLabsServiceRef ref) {
  return ElevenLabsService();
}

/// Local AI Service Provider
@riverpod
LocalAIService localAIService(LocalAIServiceRef ref) {
  return LocalAIService();
}

/// AI Orchestrator Provider
/// Coordinates all AI services for Speech-to-Speech
@riverpod
AIOrchestrator aiOrchestrator(AiOrchestratorRef ref) {
  final groqService = ref.watch(groqServiceProvider);
  final elevenLabsService = ref.watch(elevenLabsServiceProvider);
  final localAIService = ref.watch(localAIServiceProvider);
  final storage = ref.watch(localStorageServiceProvider);
  
  return AIOrchestrator(
    groqService: groqService,
    elevenLabsService: elevenLabsService,
    localAIService: localAIService,
    storage: storage,
  );
}
