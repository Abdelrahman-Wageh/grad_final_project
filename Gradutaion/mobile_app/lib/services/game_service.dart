import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/game_state.dart';
import '../utils/app_constants.dart';

class GameService extends ChangeNotifier {
  GameProgress _currentProgress = GameProgress(
    currentState: GameState.splash,
    currentContext: GameContext.introduction,
    stateData: {},
    lastUpdated: DateTime.now(),
  );

  List<String> _availableObjectives = [];
  Map<String, dynamic> _gameData = {};

  GameProgress get currentProgress => _currentProgress;
  List<String> get availableObjectives => _availableObjectives;
  Map<String, dynamic> get gameData => _gameData;

  void initializeGame() {
    _currentProgress = GameProgress(
      currentState: GameState.forestAdventure,
      currentContext: GameContext.introduction,
      stateData: {
        'level': 1,
        'completed_tasks': [],
        'current_objective': 'Find 3 red apples',
        'hints_given': 0,
        'attempts': 0,
      },
      lastUpdated: DateTime.now(),
    );
    
    _availableObjectives = [
      'Find 3 red apples',
      'Count the trees',
      'Find the hidden path',
      'Identify animal sounds',
      'Collect colorful flowers',
    ];
    
    notifyListeners();
  }

  void updateGameState(GameState newState, GameContext newContext) {
    _currentProgress = _currentProgress.copyWith(
      currentState: newState,
      currentContext: newContext,
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
  }

  void updateStateData(Map<String, dynamic> newData) {
    _currentProgress = _currentProgress.copyWith(
      stateData: {..._currentProgress.stateData, ...newData},
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
  }

  void completeObjective(String objective) {
    if (!_currentProgress.completedObjectives.contains(objective)) {
      final newObjectives = [..._currentProgress.completedObjectives, objective];
      final newScore = _currentProgress.score + 100;
      
      _currentProgress = _currentProgress.copyWith(
        completedObjectives: newObjectives,
        score: newScore,
        lastUpdated: DateTime.now(),
      );
      
      notifyListeners();
    }
  }

  void incrementAttempts() {
    final currentAttempts = _currentProgress.stateData['attempts'] ?? 0;
    updateStateData({'attempts': currentAttempts + 1});
  }

  void incrementHints() {
    final currentHints = _currentProgress.stateData['hints_given'] ?? 0;
    updateStateData({'hints_given': currentHints + 1});
  }

  bool isObjectiveCompleted(String objective) {
    return _currentProgress.completedObjectives.contains(objective);
  }

  int getCompletionPercentage() {
    if (_availableObjectives.isEmpty) return 0;
    return (_currentProgress.completedObjectives.length / _availableObjectives.length * 100).round();
  }

  String getCurrentObjective() {
    return _currentProgress.stateData['current_objective'] ?? 'Explore and learn!';
  }

  void setCurrentObjective(String objective) {
    updateStateData({'current_objective': objective});
  }

  void advanceToNextLevel() {
    final currentLevel = _currentProgress.stateData['level'] ?? 1;
    final nextLevel = currentLevel + 1;
    
    updateStateData({
      'level': nextLevel,
      'completed_tasks': [],
      'hints_given': 0,
      'attempts': 0,
    });
    
    // Generate new objectives for the next level
    _generateNewObjectives(nextLevel);
  }

  void _generateNewObjectives(int level) {
    switch (level) {
      case 1:
        _availableObjectives = [
          'Find 3 red apples',
          'Count the trees',
          'Find the hidden path',
          'Identify animal sounds',
          'Collect colorful flowers',
        ];
        break;
      case 2:
        _availableObjectives = [
          'Find the magical door',
          'Solve the color puzzle',
          'Count the stars',
          'Find the golden key',
          'Identify shapes',
        ];
        break;
      case 3:
        _availableObjectives = [
          'Complete the number sequence',
          'Find the missing piece',
          'Identify the pattern',
          'Solve the riddle',
          'Create your own story',
        ];
        break;
      default:
        _availableObjectives = [
          'Explore freely',
          'Create something new',
          'Help others',
          'Learn something new',
          'Have fun!',
        ];
    }
    
    notifyListeners();
  }

  void resetGame() {
    _currentProgress = GameProgress(
      currentState: GameState.splash,
      currentContext: GameContext.introduction,
      stateData: {},
      lastUpdated: DateTime.now(),
    );
    
    _availableObjectives = [];
    _gameData = {};
    
    notifyListeners();
  }

  Map<String, dynamic> getGameStatistics() {
    return {
      'current_level': _currentProgress.stateData['level'] ?? 1,
      'score': _currentProgress.score,
      'completed_objectives': _currentProgress.completedObjectives.length,
      'total_objectives': _availableObjectives.length,
      'completion_percentage': getCompletionPercentage(),
      'total_attempts': _currentProgress.stateData['attempts'] ?? 0,
      'hints_used': _currentProgress.stateData['hints_given'] ?? 0,
      'last_played': _currentProgress.lastUpdated.toIso8601String(),
    };
  }

  Future<void> saveGameProgress() async {
    try {
      final box = Hive.box('game_settings');
      await box.put(AppConstants.gameProgressKey, _currentProgress);
    } catch (e) {
      debugPrint('Error saving game progress: $e');
    }
  }

  Future<void> loadGameProgress() async {
    try {
      final box = Hive.box('game_settings');
      final savedProgress = box.get(AppConstants.gameProgressKey);
      
      if (savedProgress != null) {
        _currentProgress = savedProgress as GameProgress;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading game progress: $e');
    }
  }

  Future<void> selectCharacter(String characterType, String characterName) async {
    try {
      final box = Hive.box('game_settings');
      await box.put('selected_character', characterType);
      await box.put('character_name', characterName);
      notifyListeners();
    } catch (e) {
      debugPrint('Error selecting character: $e');
    }
  }

  Future<void> startGame(String gameId) async {
    try {
      _gameData = {
        'game_id': gameId,
        'started_at': DateTime.now().toIso8601String(),
      };
      notifyListeners();
    } catch (e) {
      debugPrint('Error starting game: $e');
    }
  }
}
