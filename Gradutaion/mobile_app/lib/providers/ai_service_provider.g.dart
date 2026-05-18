// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localAIServiceHash() => r'cbd62586a2a5693f114e672e508178c508c1f55e';

/// Local AI Service Provider
///
/// Provides access to Whisper STT, Qwen LLM, and Coqui TTS
/// Requirements: 26.1, 26.2
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
String _$dualBrainAIHash() => r'7e791661233702ccf7433fa0bc819db83dc456ce';

/// Dual Brain AI Service Provider
///
/// Provides access to NLU (rule-based) and LLM (generative) modes
/// Requirements: 26.1, 26.2
///
/// Copied from [DualBrainAI].
@ProviderFor(DualBrainAI)
final dualBrainAIProvider =
    AutoDisposeNotifierProvider<DualBrainAI, DualBrainAIService>.internal(
  DualBrainAI.new,
  name: r'dualBrainAIProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dualBrainAIHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DualBrainAI = AutoDisposeNotifier<DualBrainAIService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
