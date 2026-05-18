import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/interaction_log.dart';
import '../models/child_profile.dart';
import '../utils/app_constants.dart';

class StorageService extends ChangeNotifier {
  Box<InteractionLog>? _interactionLogsBox;
  Box<ChildProfile>? _childProfileBox;
  Box? _settingsBox;
  
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Get references to already-open boxes (opened by AppInitializer)
      // Use try-catch for each box to handle any issues gracefully
      try {
        if (Hive.isBoxOpen('interaction_logs')) {
          _interactionLogsBox = Hive.box<InteractionLog>('interaction_logs');
          if (kDebugMode) print('Got interaction_logs box reference');
        }
      } catch (e) {
        debugPrint('Could not get interaction_logs box: $e');
      }
      
      try {
        if (Hive.isBoxOpen('child_profile')) {
          _childProfileBox = Hive.box<ChildProfile>('child_profile');
          if (kDebugMode) print('Got child_profile box reference');
        }
      } catch (e) {
        debugPrint('Could not get child_profile box: $e');
      }
      
      try {
        if (Hive.isBoxOpen('game_settings')) {
          _settingsBox = Hive.box('game_settings');
          if (kDebugMode) print('Got game_settings box reference');
        }
      } catch (e) {
        debugPrint('Could not get game_settings box: $e');
      }
      
      _isInitialized = true;
      notifyListeners();
      
      if (kDebugMode) {
        print('StorageService initialized successfully');
      }
    } catch (e) {
      debugPrint('Error initializing storage: $e');
      // Don't throw, just log - allow app to continue
    }
  }

  Future<void> saveInteractionLog(InteractionLog log) async {
    if (!_isInitialized) await initialize();
    
    try {
      if (_interactionLogsBox != null) {
        await _interactionLogsBox!.add(log);
        debugPrint('Interaction log saved: ${log.id}');
      } else {
        debugPrint('Cannot save interaction log: box not initialized');
      }
    } catch (e) {
      debugPrint('Error saving interaction log: $e');
    }
  }

  List<InteractionLog> getAllInteractionLogs() {
    if (!_isInitialized || _interactionLogsBox == null) return [];
    
    try {
      return _interactionLogsBox!.values.toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      debugPrint('Error getting interaction logs: $e');
      return [];
    }
  }

  List<InteractionLog> getInteractionLogsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    if (!_isInitialized || _interactionLogsBox == null) return [];
    
    try {
      return _interactionLogsBox!.values
          .where((log) => 
              log.timestamp.isAfter(startDate) && 
              log.timestamp.isBefore(endDate))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      debugPrint('Error getting interaction logs by date range: $e');
      return [];
    }
  }

  List<InteractionLog> getInteractionLogsByGameState(String gameState) {
    if (!_isInitialized || _interactionLogsBox == null) return [];
    
    try {
      return _interactionLogsBox!.values
          .where((log) => log.gameState == gameState)
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      debugPrint('Error getting interaction logs by game state: $e');
      return [];
    }
  }

  Map<String, dynamic> getInteractionStatistics() {
    if (!_isInitialized || _interactionLogsBox == null) return {};
    
    try {
      final logs = _interactionLogsBox!.values.toList();
      
      if (logs.isEmpty) {
        return {
          'total_interactions': 0,
          'successful_interactions': 0,
          'success_rate': 0.0,
          'average_response_time': 0.0,
          'total_play_time': Duration.zero,
          'most_active_game_state': 'none',
          'most_active_context': 'none',
        };
      }

      final successfulLogs = logs.where((log) => log.success).toList();
      final successRate = logs.isNotEmpty ? successfulLogs.length / logs.length : 0.0;
      
      final totalResponseTime = logs.fold<Duration>(
        Duration.zero,
        (sum, log) => sum + log.responseTime,
      );
      final averageResponseTime = logs.isNotEmpty 
          ? totalResponseTime.inMilliseconds / logs.length 
          : 0.0;

      // Calculate total play time (sum of all response times)
      final totalPlayTime = logs.fold<Duration>(
        Duration.zero,
        (sum, log) => sum + log.responseTime,
      );

      // Find most active game state and context
      final gameStateCounts = <String, int>{};
      final contextCounts = <String, int>{};
      
      for (final log in logs) {
        gameStateCounts[log.gameState] = (gameStateCounts[log.gameState] ?? 0) + 1;
        contextCounts[log.gameContext] = (contextCounts[log.gameContext] ?? 0) + 1;
      }

      final mostActiveGameState = gameStateCounts.isNotEmpty
          ? gameStateCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key
          : 'none';
      
      final mostActiveContext = contextCounts.isNotEmpty
          ? contextCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key
          : 'none';

      return {
        'total_interactions': logs.length,
        'successful_interactions': successfulLogs.length,
        'success_rate': successRate,
        'average_response_time': averageResponseTime,
        'total_play_time': totalPlayTime,
        'most_active_game_state': mostActiveGameState,
        'most_active_context': mostActiveContext,
        'game_state_distribution': gameStateCounts,
        'context_distribution': contextCounts,
      };
    } catch (e) {
      debugPrint('Error getting interaction statistics: $e');
      return {};
    }
  }

  Map<String, dynamic> getLearningProgress() {
    if (!_isInitialized || _interactionLogsBox == null) return {};
    
    try {
      final logs = _interactionLogsBox!.values.toList();
      final successfulLogs = logs.where((log) => log.success).toList();
      
      // Analyze learning patterns
      final learningKeywords = {
        'colors': ['أحمر', 'أزرق', 'أخضر', 'أصفر', 'red', 'blue', 'green', 'yellow'],
        'numbers': ['واحد', 'اثنين', 'ثلاثة', 'one', 'two', 'three'],
        'shapes': ['دائرة', 'مربع', 'مثلث', 'circle', 'square', 'triangle'],
        'animals': ['قطة', 'كلب', 'طائر', 'cat', 'dog', 'bird'],
      };

      final learningProgress = <String, int>{};
      
      for (final category in learningKeywords.keys) {
        final keywords = learningKeywords[category]!;
        int count = 0;
        
        for (final log in successfulLogs) {
          final query = log.childQuery?.toLowerCase() ?? '';
          final response = log.aiResponse?.toLowerCase() ?? '';
          
          for (final keyword in keywords) {
            if (query.contains(keyword.toLowerCase()) || 
                response.contains(keyword.toLowerCase())) {
              count++;
              break;
            }
          }
        }
        
        learningProgress[category] = count;
      }

      return {
        'learning_progress': learningProgress,
        'total_learning_interactions': learningProgress.values.fold(0, (sum, count) => sum + count),
        'mastered_categories': learningProgress.entries
            .where((entry) => entry.value >= 5)
            .map((entry) => entry.key)
            .toList(),
        'needs_practice': learningProgress.entries
            .where((entry) => entry.value < 3)
            .map((entry) => entry.key)
            .toList(),
      };
    } catch (e) {
      debugPrint('Error getting learning progress: $e');
      return {};
    }
  }

  Future<void> clearAllData() async {
    if (!_isInitialized) await initialize();
    
    try {
      if (_interactionLogsBox != null) {
        await _interactionLogsBox!.clear();
      }
      if (_settingsBox != null) {
        await _settingsBox!.clear();
      }
      debugPrint('All data cleared');
    } catch (e) {
      debugPrint('Error clearing data: $e');
    }
  }

  Future<Map<String, Object>> exportData() async {
    if (!_isInitialized) await initialize();
    
    try {
      if (_interactionLogsBox == null) {
        return {};
      }
      
      final logs = _interactionLogsBox!.values.toList();
      final exportData = {
        'export_timestamp': DateTime.now().toIso8601String(),
        'total_logs': logs.length,
        'logs': logs.map((log) => log.toJson()).toList(),
        'statistics': getInteractionStatistics(),
        'learning_progress': getLearningProgress(),
      };
      
      // In a real app, you would save this to a file or send it to a server
      debugPrint('Data export prepared: ${exportData['total_logs']} logs');
      return exportData;
    } catch (e) {
      debugPrint('Error exporting data: $e');
      return {};
    }
  }

  Future<void> setParentPin(String pin) async {
    if (!_isInitialized) await initialize();
    
    try {
      if (_settingsBox != null) {
        await _settingsBox!.put(AppConstants.parentPinKey, pin);
      }
    } catch (e) {
      debugPrint('Error setting parent PIN: $e');
    }
  }

  Future<String?> getParentPin() async {
    if (!_isInitialized) await initialize();
    
    try {
      return _settingsBox?.get(AppConstants.parentPinKey);
    } catch (e) {
      debugPrint('Error getting parent PIN: $e');
      return null;
    }
  }

  Future<bool> verifyParentPin(String pin) async {
    final savedPin = await getParentPin();
    return savedPin == pin;
  }

  Future<bool> hasSelectedCharacter() async {
    if (!_isInitialized) await initialize();
    
    try {
      if (_settingsBox == null) return false;
      final character = _settingsBox!.get('selected_character');
      return character != null;
    } catch (e) {
      debugPrint('Error checking selected character: $e');
      return false;
    }
  }

  Future<void> saveSelectedCharacter(String characterType, String characterName) async {
    if (!_isInitialized) await initialize();
    
    try {
      if (_settingsBox != null) {
        await _settingsBox!.put('selected_character', characterType);
        await _settingsBox!.put('character_name', characterName);
      }
    } catch (e) {
      debugPrint('Error saving selected character: $e');
    }
  }

  Future<Map<String, String>?> getSelectedCharacter() async {
    if (!_isInitialized) await initialize();
    
    try {
      if (_settingsBox == null) return null;
      
      final type = _settingsBox!.get('selected_character');
      final name = _settingsBox!.get('character_name');
      
      if (type != null) {
        return {
          'type': type,
          'name': name ?? 'صديقي',
        };
      }
      return null;
    } catch (e) {
      debugPrint('Error getting selected character: $e');
      return null;
    }
  }

  Future<void> loadGameProgress() async {
    // Placeholder for loading game progress
    // This would load saved game states, levels, etc.
    if (!_isInitialized) await initialize();
    debugPrint('Game progress loaded');
  }

  // ============ Child Profile Methods ============

  Future<void> saveChildProfile(ChildProfile profile) async {
    if (!_isInitialized) await initialize();
    
    try {
      if (_childProfileBox != null) {
        await _childProfileBox!.put('current_profile', profile);
        notifyListeners();
        debugPrint('Child profile saved: ${profile.name}');
      }
    } catch (e) {
      debugPrint('Error saving child profile: $e');
    }
  }

  Future<ChildProfile?> getChildProfile() async {
    if (!_isInitialized) await initialize();
    
    try {
      return _childProfileBox?.get('current_profile');
    } catch (e) {
      debugPrint('Error loading profile: $e');
      return null;
    }
  }

  Future<void> updateChildProfile(ChildProfile Function(ChildProfile) updater) async {
    if (!_isInitialized) await initialize();
    
    try {
      final currentProfile = await getChildProfile();
      if (currentProfile != null) {
        final updatedProfile = updater(currentProfile);
        await saveChildProfile(updatedProfile);
      }
    } catch (e) {
      debugPrint('Error updating child profile: $e');
    }
  }

  Future<void> addStarsToProfile(int stars) async {
    await updateChildProfile((profile) => profile.addStars(stars));
  }

  Future<void> trackConceptAttempt(String concept, bool success) async {
    await updateChildProfile((profile) => profile.trackConceptAttempt(concept, success));
  }

  Future<void> addSuccessRateToProfile(double rate) async {
    await updateChildProfile((profile) => profile.addSuccessRate(rate));
  }

  Future<void> unlockItemForProfile(String itemId) async {
    await updateChildProfile((profile) => profile.unlockItem(itemId));
  }

  Future<List<String>> getMasteredConcepts() async {
    final profile = await getChildProfile();
    return profile?.masteredConcepts ?? [];
  }

  Future<List<String>> getUnlockedItems() async {
    final profile = await getChildProfile();
    return profile?.unlockedItems ?? [];
  }

  Future<int> getTotalStars() async {
    final profile = await getChildProfile();
    return profile?.totalStars ?? 0;
  }

  Future<double> getAverageSuccessRate() async {
    final profile = await getChildProfile();
    return profile?.getAverageSuccessRate() ?? 0.5;
  }

  Future<bool> hasChildProfile() async {
    final profile = await getChildProfile();
    return profile != null;
  }

  Future<void> createDefaultProfile(String name, int age, String level) async {
    final profile = ChildProfile(
      name: name,
      age: age,
      level: level,
      assessment: 'Average',
    );
    await saveChildProfile(profile);
  }
}
