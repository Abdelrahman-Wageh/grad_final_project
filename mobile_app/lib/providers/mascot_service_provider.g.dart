// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mascot_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mascotStateHash() => r'e9e9b91e667b86e6d5be0764e597cd7018f6ae5f';

/// Mascot State Provider
///
/// Manages the mascot's mood and animation state
/// Requirements: 17.6, 26.1, 26.4
///
/// Copied from [MascotState].
@ProviderFor(MascotState)
final mascotStateProvider =
    AutoDisposeNotifierProvider<MascotState, MascotMood>.internal(
  MascotState.new,
  name: r'mascotStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mascotStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MascotState = AutoDisposeNotifier<MascotMood>;
String _$mascotVisibilityHash() => r'77aeb294cd6451cebc086fd681b5d67bc3143e97';

/// Mascot Visibility Provider
///
/// Controls whether the mascot overlay is visible
/// Requirements: 17.7, 26.1, 26.4
///
/// Copied from [MascotVisibility].
@ProviderFor(MascotVisibility)
final mascotVisibilityProvider =
    AutoDisposeNotifierProvider<MascotVisibility, bool>.internal(
  MascotVisibility.new,
  name: r'mascotVisibilityProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mascotVisibilityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MascotVisibility = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
