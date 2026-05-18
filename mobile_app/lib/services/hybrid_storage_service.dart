/// Hybrid Storage Service
/// Local-first storage with cloud sync capability
/// Handles conflict resolution and offline queueing
library;

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/models/child_profile.dart';
import 'hybrid_connectivity_service.dart';

class HybridStorageService extends ChangeNotifier {
  final HybridConnectivityService _connectivity;
  late Box<ChildProfile> _profileBox;
  late Box _syncQueueBox;
  
  bool _isInitialized = false;
  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  
  // Backend API endpoint (from config)
  static const String API_BASE_URL = 'http://localhost:8000/api';
  
  HybridStorageService(this._connectivity) {
    _initialize();
    _connectivity.addListener(_onConnectivityChanged);
  }
  
  Future<void> _initialize() async {
    try {
      _profileBox = await Hive.openBox<ChildProfile>('child_profiles');
      _syncQueueBox = await Hive.openBox('sync_queue');
      _isInitialized = true;
      
      if (kDebugMode) print('✅ HybridStorageService initialized');
      
      // Sync if online
      if (_connectivity.isOnline) {
        _syncToCloud();
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ HybridStorageService initialization failed: $e');
    }
  }
  
  void _onConnectivityChanged() {
    if (_connectivity.isOnline && !_isSyncing) {
      _syncToCloud();
    }
  }
  
  // ============================================================================
  // LOCAL OPERATIONS (Always work, even offline)
  // ============================================================================
  
  /// Save profile locally (always succeeds)
  Future<void> saveProfile(ChildProfile profile) async {
    if (!_isInitialized) await _initialize();
    
    profile.lastPlayed = DateTime.now();
    profile.needsSync = true;
    
    await _profileBox.put(profile.id, profile);
    
    // Queue for cloud sync
    await _queueForSync('save_profile', profile.toJson());
    
    notifyListeners();
    
    if (kDebugMode) print('✅ Profile saved locally: ${profile.name}');
  }
  
  /// Load profile locally
  Future<ChildProfile?> loadProfile(String id) async {
    if (!_isInitialized) await _initialize();
    
    return _profileBox.get(id);
  }
  
  /// Get all profiles
  Future<List<ChildProfile>> getAllProfiles() async {
    if (!_isInitialized) await _initialize();
    
    return _profileBox.values.toList();
  }
  
  /// Delete profile locally
  Future<void> deleteProfile(String id) async {
    if (!_isInitialized) await _initialize();
    
    await _profileBox.delete(id);
    await _queueForSync('delete_profile', {'id': id});
    
    notifyListeners();
    
    if (kDebugMode) print('✅ Profile deleted locally: $id');
  }
  
  // ============================================================================
  // CLOUD SYNC (Only when online)
  // ============================================================================
  
  /// Sync all local data to cloud
  Future<void> _syncToCloud() async {
    if (_isSyncing || !_connectivity.isOnline) return;
    
    _isSyncing = true;
    notifyListeners();
    
    try {
      // Process sync queue
      List<String> queueKeys = _syncQueueBox.keys.cast<String>().toList();
      
      for (String key in queueKeys) {
        Map<String, dynamic> operation = Map<String, dynamic>.from(
          _syncQueueBox.get(key),
        );
        
        bool success = await _executeSyncOperation(operation);
        
        if (success) {
          await _syncQueueBox.delete(key);
        }
      }
      
      // Sync all profiles
      for (ChildProfile profile in _profileBox.values) {
        if (profile.needsSync) {
          bool success = await _syncProfileToCloud(profile);
          if (success) {
            profile.needsSync = false;
            profile.lastSyncedAt = DateTime.now();
            await _profileBox.put(profile.id, profile);
          }
        }
      }
      
      _lastSyncTime = DateTime.now();
      
      if (kDebugMode) print('✅ Cloud sync completed');
    } catch (e) {
      if (kDebugMode) print('⚠️ Cloud sync failed: $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }
  
  /// Sync from cloud (pull latest data)
  Future<void> syncFromCloud() async {
    if (!_connectivity.isOnline) {
      throw Exception('Cannot sync from cloud while offline');
    }
    
    try {
      // Get all profiles from cloud
      final response = await http.get(
        Uri.parse('$API_BASE_URL/profiles'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        List<dynamic> cloudProfiles = json.decode(response.body);
        
        for (var profileData in cloudProfiles) {
          ChildProfile cloudProfile = ChildProfile.fromJson(profileData);
          ChildProfile? localProfile = await loadProfile(cloudProfile.id);
          
          if (localProfile == null) {
            // New profile from cloud
            await _profileBox.put(cloudProfile.id, cloudProfile);
          } else {
            // Resolve conflict
            ChildProfile resolved = _resolveConflict(localProfile, cloudProfile);
            await _profileBox.put(resolved.id, resolved);
          }
        }
        
        if (kDebugMode) print('✅ Synced from cloud');
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Sync from cloud failed: $e');
      rethrow;
    }
  }
  
  /// Sync specific profile to cloud
  Future<bool> _syncProfileToCloud(ChildProfile profile) async {
    try {
      final response = await http.post(
        Uri.parse('$API_BASE_URL/profiles'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(profile.toJson()),
      ).timeout(Duration(seconds: 10));
      
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) print('⚠️ Failed to sync profile to cloud: $e');
      return false;
    }
  }
  
  /// Execute queued sync operation
  Future<bool> _executeSyncOperation(Map<String, dynamic> operation) async {
    try {
      String type = operation['type'];
      Map<String, dynamic> data = operation['data'];
      
      switch (type) {
        case 'save_profile':
          return await _syncProfileToCloud(ChildProfile.fromJson(data));
          
        case 'delete_profile':
          final response = await http.delete(
            Uri.parse('$API_BASE_URL/profiles/${data['id']}'),
          ).timeout(Duration(seconds: 10));
          return response.statusCode == 200 || response.statusCode == 204;
          
        default:
          return false;
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Failed to execute sync operation: $e');
      return false;
    }
  }
  
  /// Queue operation for later sync
  Future<void> _queueForSync(String type, Map<String, dynamic> data) async {
    String key = '${type}_${DateTime.now().millisecondsSinceEpoch}';
    await _syncQueueBox.put(key, {
      'type': type,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  // ============================================================================
  // CONFLICT RESOLUTION
  // ============================================================================
  
  /// Resolve conflict between local and cloud profiles
  /// Strategy: Use latest timestamp (Last Write Wins)
  ChildProfile _resolveConflict(
    ChildProfile local,
    ChildProfile cloud,
  ) {
    // Compare last played times
    if (local.lastPlayed.isAfter(cloud.lastPlayed)) {
      if (kDebugMode) print('🔄 Conflict resolved: Using local version');
      return local;
    } else if (cloud.lastPlayed.isAfter(local.lastPlayed)) {
      if (kDebugMode) print('🔄 Conflict resolved: Using cloud version');
      return cloud;
    } else {
      // Same timestamp - merge data (take maximum values)
      if (kDebugMode) print('🔄 Conflict resolved: Merging data');
      return _mergeProfiles(local, cloud);
    }
  }
  
  /// Merge two profiles (take maximum values)
  ChildProfile _mergeProfiles(ChildProfile local, ChildProfile cloud) {
    return ChildProfile(
      id: local.id,
      name: local.name,
      age: local.age,
      level: local.level,
      assessment: local.assessment,
      difficultyLevel: local.difficultyLevel,
      masteredConcepts: _mergeLists(local.masteredConcepts, cloud.masteredConcepts),
      conceptProgress: _mergeMaps(local.conceptProgress, cloud.conceptProgress),
      stars: local.stars > cloud.stars ? local.stars : cloud.stars,
      unlockedItems: _mergeLists(local.unlockedItems, cloud.unlockedItems),
      currentChapter: local.currentChapter,
      currentStage: local.currentStage,
      lastPlayed: local.lastPlayed.isAfter(cloud.lastPlayed)
          ? local.lastPlayed
          : cloud.lastPlayed,
      totalPlayTimeMinutes: local.totalPlayTimeMinutes > cloud.totalPlayTimeMinutes
          ? local.totalPlayTimeMinutes
          : cloud.totalPlayTimeMinutes,
      recentAttempts: local.recentAttempts,
      wordsLearned: _mergeMaps(local.wordsLearned, cloud.wordsLearned),
      timePlayedPerDay: _mergeMaps(local.timePlayedPerDay, cloud.timePlayedPerDay),
    );
  }
  
  List<String> _mergeLists(List<String> list1, List<String> list2) {
    return {...list1, ...list2}.toList();
  }
  
  Map<String, int> _mergeMaps(Map<String, int> map1, Map<String, int> map2) {
    Map<String, int> merged = Map.from(map1);
    map2.forEach((key, value) {
      merged[key] = (merged[key] ?? 0) > value ? merged[key]! : value;
    });
    return merged;
  }
  
  // ============================================================================
  // GETTERS
  // ============================================================================
  
  bool get isInitialized => _isInitialized;
  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncTime => _lastSyncTime;
  int get pendingSyncOperations => _syncQueueBox.length;
  
  @override
  void dispose() {
    _connectivity.removeListener(_onConnectivityChanged);
    super.dispose();
  }
}

// Extension for ChildProfile JSON serialization
extension ChildProfileJson on ChildProfile {
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'level': level,
        'assessment': assessment,
        'difficultyLevel': difficultyLevel,
        'masteredConcepts': masteredConcepts,
        'conceptProgress': conceptProgress,
        'stars': stars,
        'unlockedItems': unlockedItems,
        'currentChapter': currentChapter,
        'currentStage': currentStage,
        'lastPlayed': lastPlayed.toIso8601String(),
        'totalPlayTimeMinutes': totalPlayTimeMinutes,
        'recentAttempts': recentAttempts,
        'wordsLearned': wordsLearned,
        'timePlayedPerDay': timePlayedPerDay,
      };

  static ChildProfile fromJson(Map<String, dynamic> json) {
    return ChildProfile(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      level: json['level'],
      assessment: json['assessment'],
      difficultyLevel: json['difficultyLevel'] ?? 'medium',
      masteredConcepts: List<String>.from(json['masteredConcepts'] ?? []),
      conceptProgress: Map<String, int>.from(json['conceptProgress'] ?? {}),
      stars: json['stars'] ?? 0,
      unlockedItems: List<String>.from(json['unlockedItems'] ?? []),
      currentChapter: json['currentChapter'] ?? 'chapter_1',
      currentStage: json['currentStage'] ?? 'chapter_1_stage_1',
      lastPlayed: DateTime.parse(json['lastPlayed']),
      totalPlayTimeMinutes: json['totalPlayTimeMinutes'] ?? 0,
      recentAttempts: List<bool>.from(json['recentAttempts'] ?? []),
      wordsLearned: Map<String, int>.from(json['wordsLearned'] ?? {}),
      timePlayedPerDay: Map<String, int>.from(json['timePlayedPerDay'] ?? {}),
    );
  }
}
