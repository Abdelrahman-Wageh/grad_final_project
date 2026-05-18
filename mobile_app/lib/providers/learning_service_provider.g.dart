// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$spacedRepetitionManagerHash() =>
    r'22abaf8f7efd97f66d576d7c0906c1f1168ef683';

/// Spaced Repetition Manager Provider
///
/// Provides access to SM-2 algorithm for optimized learning retention
/// Requirements: 26.1, 26.3
///
/// Copied from [spacedRepetitionManager].
@ProviderFor(spacedRepetitionManager)
final spacedRepetitionManagerProvider =
    AutoDisposeProvider<SpacedRepetitionManager>.internal(
  spacedRepetitionManager,
  name: r'spacedRepetitionManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$spacedRepetitionManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SpacedRepetitionManagerRef
    = AutoDisposeProviderRef<SpacedRepetitionManager>;
String _$difficultyAdapterHash() => r'230cbd57aa4ffcbbe94a2711360272a68c215da7';

/// Difficulty Adapter Provider
///
/// Provides access to adaptive difficulty system
/// Requirements: 26.1, 26.3
///
/// Copied from [difficultyAdapter].
@ProviderFor(difficultyAdapter)
final difficultyAdapterProvider =
    AutoDisposeProvider<DifficultyAdapter>.internal(
  difficultyAdapter,
  name: r'difficultyAdapterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$difficultyAdapterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DifficultyAdapterRef = AutoDisposeProviderRef<DifficultyAdapter>;
String _$cardsDueForReviewHash() => r'a18b248873041615237e2b46d690fb8522d25b1f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$CardsDueForReview
    extends BuildlessAutoDisposeAsyncNotifier<List<SpacedRepetitionCard>> {
  late final String profileId;

  FutureOr<List<SpacedRepetitionCard>> build(
    String profileId,
  );
}

/// Cards Due for Review Provider
///
/// Provides cards that are due for review for the current profile
/// Requirements: 26.1, 26.4
///
/// Copied from [CardsDueForReview].
@ProviderFor(CardsDueForReview)
const cardsDueForReviewProvider = CardsDueForReviewFamily();

/// Cards Due for Review Provider
///
/// Provides cards that are due for review for the current profile
/// Requirements: 26.1, 26.4
///
/// Copied from [CardsDueForReview].
class CardsDueForReviewFamily
    extends Family<AsyncValue<List<SpacedRepetitionCard>>> {
  /// Cards Due for Review Provider
  ///
  /// Provides cards that are due for review for the current profile
  /// Requirements: 26.1, 26.4
  ///
  /// Copied from [CardsDueForReview].
  const CardsDueForReviewFamily();

  /// Cards Due for Review Provider
  ///
  /// Provides cards that are due for review for the current profile
  /// Requirements: 26.1, 26.4
  ///
  /// Copied from [CardsDueForReview].
  CardsDueForReviewProvider call(
    String profileId,
  ) {
    return CardsDueForReviewProvider(
      profileId,
    );
  }

  @override
  CardsDueForReviewProvider getProviderOverride(
    covariant CardsDueForReviewProvider provider,
  ) {
    return call(
      provider.profileId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'cardsDueForReviewProvider';
}

/// Cards Due for Review Provider
///
/// Provides cards that are due for review for the current profile
/// Requirements: 26.1, 26.4
///
/// Copied from [CardsDueForReview].
class CardsDueForReviewProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CardsDueForReview, List<SpacedRepetitionCard>> {
  /// Cards Due for Review Provider
  ///
  /// Provides cards that are due for review for the current profile
  /// Requirements: 26.1, 26.4
  ///
  /// Copied from [CardsDueForReview].
  CardsDueForReviewProvider(
    String profileId,
  ) : this._internal(
          () => CardsDueForReview()..profileId = profileId,
          from: cardsDueForReviewProvider,
          name: r'cardsDueForReviewProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cardsDueForReviewHash,
          dependencies: CardsDueForReviewFamily._dependencies,
          allTransitiveDependencies:
              CardsDueForReviewFamily._allTransitiveDependencies,
          profileId: profileId,
        );

  CardsDueForReviewProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileId,
  }) : super.internal();

  final String profileId;

  @override
  FutureOr<List<SpacedRepetitionCard>> runNotifierBuild(
    covariant CardsDueForReview notifier,
  ) {
    return notifier.build(
      profileId,
    );
  }

  @override
  Override overrideWith(CardsDueForReview Function() create) {
    return ProviderOverride(
      origin: this,
      override: CardsDueForReviewProvider._internal(
        () => create()..profileId = profileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CardsDueForReview,
      List<SpacedRepetitionCard>> createElement() {
    return _CardsDueForReviewProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CardsDueForReviewProvider && other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CardsDueForReviewRef
    on AutoDisposeAsyncNotifierProviderRef<List<SpacedRepetitionCard>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _CardsDueForReviewProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CardsDueForReview,
        List<SpacedRepetitionCard>> with CardsDueForReviewRef {
  _CardsDueForReviewProviderElement(super.provider);

  @override
  String get profileId => (origin as CardsDueForReviewProvider).profileId;
}

String _$recommendedDifficultyHash() =>
    r'7716fea58f09f82f3fd4ad197182d9cf3858931a';

abstract class _$RecommendedDifficulty
    extends BuildlessAutoDisposeNotifier<DifficultyLevel> {
  late final ChildProfile profile;

  DifficultyLevel build(
    ChildProfile profile,
  );
}

/// Recommended Difficulty Provider
///
/// Calculates the recommended difficulty for the current profile
/// Requirements: 26.1, 26.4
///
/// Copied from [RecommendedDifficulty].
@ProviderFor(RecommendedDifficulty)
const recommendedDifficultyProvider = RecommendedDifficultyFamily();

/// Recommended Difficulty Provider
///
/// Calculates the recommended difficulty for the current profile
/// Requirements: 26.1, 26.4
///
/// Copied from [RecommendedDifficulty].
class RecommendedDifficultyFamily extends Family<DifficultyLevel> {
  /// Recommended Difficulty Provider
  ///
  /// Calculates the recommended difficulty for the current profile
  /// Requirements: 26.1, 26.4
  ///
  /// Copied from [RecommendedDifficulty].
  const RecommendedDifficultyFamily();

  /// Recommended Difficulty Provider
  ///
  /// Calculates the recommended difficulty for the current profile
  /// Requirements: 26.1, 26.4
  ///
  /// Copied from [RecommendedDifficulty].
  RecommendedDifficultyProvider call(
    ChildProfile profile,
  ) {
    return RecommendedDifficultyProvider(
      profile,
    );
  }

  @override
  RecommendedDifficultyProvider getProviderOverride(
    covariant RecommendedDifficultyProvider provider,
  ) {
    return call(
      provider.profile,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recommendedDifficultyProvider';
}

/// Recommended Difficulty Provider
///
/// Calculates the recommended difficulty for the current profile
/// Requirements: 26.1, 26.4
///
/// Copied from [RecommendedDifficulty].
class RecommendedDifficultyProvider extends AutoDisposeNotifierProviderImpl<
    RecommendedDifficulty, DifficultyLevel> {
  /// Recommended Difficulty Provider
  ///
  /// Calculates the recommended difficulty for the current profile
  /// Requirements: 26.1, 26.4
  ///
  /// Copied from [RecommendedDifficulty].
  RecommendedDifficultyProvider(
    ChildProfile profile,
  ) : this._internal(
          () => RecommendedDifficulty()..profile = profile,
          from: recommendedDifficultyProvider,
          name: r'recommendedDifficultyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recommendedDifficultyHash,
          dependencies: RecommendedDifficultyFamily._dependencies,
          allTransitiveDependencies:
              RecommendedDifficultyFamily._allTransitiveDependencies,
          profile: profile,
        );

  RecommendedDifficultyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profile,
  }) : super.internal();

  final ChildProfile profile;

  @override
  DifficultyLevel runNotifierBuild(
    covariant RecommendedDifficulty notifier,
  ) {
    return notifier.build(
      profile,
    );
  }

  @override
  Override overrideWith(RecommendedDifficulty Function() create) {
    return ProviderOverride(
      origin: this,
      override: RecommendedDifficultyProvider._internal(
        () => create()..profile = profile,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profile: profile,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<RecommendedDifficulty, DifficultyLevel>
      createElement() {
    return _RecommendedDifficultyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecommendedDifficultyProvider && other.profile == profile;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profile.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RecommendedDifficultyRef
    on AutoDisposeNotifierProviderRef<DifficultyLevel> {
  /// The parameter `profile` of this provider.
  ChildProfile get profile;
}

class _RecommendedDifficultyProviderElement
    extends AutoDisposeNotifierProviderElement<RecommendedDifficulty,
        DifficultyLevel> with RecommendedDifficultyRef {
  _RecommendedDifficultyProviderElement(super.provider);

  @override
  ChildProfile get profile => (origin as RecommendedDifficultyProvider).profile;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
