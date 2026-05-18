// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$groqServiceHash() => r'c185d4ab48b0d3543dec35261b35942528221932';

/// Groq Service Provider
///
/// Copied from [groqService].
@ProviderFor(groqService)
final groqServiceProvider = AutoDisposeProvider<GroqService>.internal(
  groqService,
  name: r'groqServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$groqServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GroqServiceRef = AutoDisposeProviderRef<GroqService>;
String _$elevenLabsServiceHash() => r'0e52239d6af140b494c1fddbc7ee759fc24cb9cd';

/// ElevenLabs Service Provider
///
/// Copied from [elevenLabsService].
@ProviderFor(elevenLabsService)
final elevenLabsServiceProvider =
    AutoDisposeProvider<ElevenLabsService>.internal(
  elevenLabsService,
  name: r'elevenLabsServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$elevenLabsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ElevenLabsServiceRef = AutoDisposeProviderRef<ElevenLabsService>;
String _$localAIServiceHash() => r'cbd62586a2a5693f114e672e508178c508c1f55e';

/// Local AI Service Provider
///
/// Copied from [localAIService].
@ProviderFor(localAIService)
final localAIServiceProvider = AutoDisposeProvider<LocalAIService>.internal(
  localAIService,
  name: r'localAIServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localAIServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocalAIServiceRef = AutoDisposeProviderRef<LocalAIService>;
String _$aiOrchestratorHash() => r'30bb018eeab37ee0468ed689e300f5d065e2eedc';

/// AI Orchestrator Provider
/// Coordinates all AI services for Speech-to-Speech
///
/// Copied from [aiOrchestrator].
@ProviderFor(aiOrchestrator)
final aiOrchestratorProvider = AutoDisposeProvider<AIOrchestrator>.internal(
  aiOrchestrator,
  name: r'aiOrchestratorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aiOrchestratorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AiOrchestratorRef = AutoDisposeProviderRef<AIOrchestrator>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
