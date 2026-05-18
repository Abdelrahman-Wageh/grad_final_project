import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/local_storage_service.dart';
import '../data/models/child_profile.dart';
import '../models/conversation_history.dart';
import '../models/spaced_repetition_card.dart';

part 'storage_service_provider.g.dart';

/// Local Storage Service Provider
/// 
/// Provides access to Hive database for offline data persistence
/// Requirements: 26.1, 26.3
@riverpod
LocalStorageService localStorageService(LocalStorageServiceRef ref) {
  return LocalStorageService();
}

/// Child Profile Provider
/// 
/// Manages the current active child profile
/// Requirements: 26.1, 26.4
@riverpod
class CurrentProfile extends _$CurrentProfile {
  @override
  ChildProfile? build() {
    return null;
  }

  /// Load a profile by ID
  Future<void> loadProfile(String profileId) async {
    final storage = ref.read(localStorageServiceProvider);
    final profile = await storage.loadProfile(profileId);
    state = profile;
  }

  /// Save the current profile
  Future<void> saveProfile() async {
    if (state == null) return;
    final storage = ref.read(localStorageServiceProvider);
    await storage.saveProfile(state!);
  }

  /// Update profile data
  void updateProfile(ChildProfile profile) {
    state = profile;
  }

  /// Clear the current profile
  void clearProfile() {
    state = null;
  }
}

/// All Profiles Provider
/// 
/// Provides access to all child profiles
/// Requirements: 26.1, 26.4
@riverpod
class AllProfiles extends _$AllProfiles {
  @override
  Future<List<ChildProfile>> build() async {
    final storage = ref.watch(localStorageServiceProvider);
    return await storage.getAllProfiles();
  }

  /// Refresh the profiles list
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final storage = ref.read(localStorageServiceProvider);
      return await storage.getAllProfiles();
    });
  }
}
