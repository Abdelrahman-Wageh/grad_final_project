// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameSessionHash() => r'afd9e20f9c30a1beaa1e6e9110d8c070236d2493';

/// Game Session Manager Provider
///
/// Manages game sessions with spaced repetition and dynamic difficulty
/// Requirements: 26.1, 26.2, 26.3
///
/// Copied from [GameSession].
@ProviderFor(GameSession)
final gameSessionProvider =
    AutoDisposeNotifierProvider<GameSession, GameSessionManager>.internal(
  GameSession.new,
  name: r'gameSessionProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gameSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GameSession = AutoDisposeNotifier<GameSessionManager>;
String _$currentGameSessionHash() =>
    r'ac6281a0aafff5eb22ab518c0ee284aceafd06db';

/// Current game session state
///
/// Tracks the active game session for the current profile
///
/// Copied from [CurrentGameSession].
@ProviderFor(CurrentGameSession)
final currentGameSessionProvider =
    AutoDisposeNotifierProvider<CurrentGameSession, GameSession?>.internal(
  CurrentGameSession.new,
  name: r'currentGameSessionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentGameSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentGameSession = AutoDisposeNotifier<GameSession?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
