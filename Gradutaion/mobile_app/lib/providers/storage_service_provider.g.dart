// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localStorageServiceHash() =>
    r'aa1f8655f3d8251101c2b54dfd02ba241896010b';

/// Local Storage Service Provider
///
/// Provides access to Hive database for offline data persistence
/// Requirements: 26.1, 26.3
///
/// Copied from [localStorageService].
@ProviderFor(localStorageService)
final localStorageServiceProvider =
    AutoDisposeProvider<LocalStorageService>.internal(
  localStorageService,
  name: r'localStorageServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localStorageServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocalStorageServiceRef = AutoDisposeProviderRef<LocalStorageService>;
String _$currentProfileHash() => r'46af7632b3c7f28a6839acd33f1140f4c7305a25';

/// Child Profile Provider
///
/// Manages the current active child profile
/// Requirements: 26.1, 26.4
///
/// Copied from [CurrentProfile].
@ProviderFor(CurrentProfile)
final currentProfileProvider =
    AutoDisposeNotifierProvider<CurrentProfile, ChildProfile?>.internal(
  CurrentProfile.new,
  name: r'currentProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentProfile = AutoDisposeNotifier<ChildProfile?>;
String _$allProfilesHash() => r'0abab5a9e761e0ccb155f7dbab0f6f50f93dfc3a';

/// All Profiles Provider
///
/// Provides access to all child profiles
/// Requirements: 26.1, 26.4
///
/// Copied from [AllProfiles].
@ProviderFor(AllProfiles)
final allProfilesProvider =
    AutoDisposeAsyncNotifierProvider<AllProfiles, List<ChildProfile>>.internal(
  AllProfiles.new,
  name: r'allProfilesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allProfilesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AllProfiles = AutoDisposeAsyncNotifier<List<ChildProfile>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
