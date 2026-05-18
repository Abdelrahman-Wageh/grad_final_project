import 'package:hive/hive.dart';

part 'game_state.g.dart';

@HiveType(typeId: 0)
enum GameState {
  @HiveField(0)
  splash,
  
  @HiveField(1)
  forestAdventure,
  
  @HiveField(2)
  castleExploration,
  
  @HiveField(3)
  drawingGame,
  
  @HiveField(4)
  colorLearning,
  
  @HiveField(5)
  numberLearning,
  
  @HiveField(6)
  shapeLearning,
  
  @HiveField(7)
  completed,
}

@HiveType(typeId: 1)
enum GameContext {
  @HiveField(0)
  introduction,
  
  @HiveField(1)
  puzzleSolving,
  
  @HiveField(2)
  objectFinding,
  
  @HiveField(3)
  learningActivity,
  
  @HiveField(4)
  encouragement,
  
  @HiveField(5)
  celebration,
  
  @HiveField(6)
  helpRequest,
}

@HiveType(typeId: 2)
class GameProgress {
  @HiveField(0)
  final GameState currentState;
  
  @HiveField(1)
  final GameContext currentContext;
  
  @HiveField(2)
  final Map<String, dynamic> stateData;
  
  @HiveField(3)
  final DateTime lastUpdated;
  
  @HiveField(4)
  final int score;
  
  @HiveField(5)
  final List<String> completedObjectives;

  GameProgress({
    required this.currentState,
    required this.currentContext,
    required this.stateData,
    required this.lastUpdated,
    this.score = 0,
    this.completedObjectives = const [],
  });

  GameProgress copyWith({
    GameState? currentState,
    GameContext? currentContext,
    Map<String, dynamic>? stateData,
    DateTime? lastUpdated,
    int? score,
    List<String>? completedObjectives,
  }) {
    return GameProgress(
      currentState: currentState ?? this.currentState,
      currentContext: currentContext ?? this.currentContext,
      stateData: stateData ?? this.stateData,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      score: score ?? this.score,
      completedObjectives: completedObjectives ?? this.completedObjectives,
    );
  }
}
