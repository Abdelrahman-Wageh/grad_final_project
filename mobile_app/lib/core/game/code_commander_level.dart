import 'level.dart';
import 'difficulty_level.dart';
import 'pathfinding.dart';

/// Code Commander game level
/// Requirements: 18.1, 18.5, 19.1-19.6
class CodeCommanderLevel extends Level {
  final int gridSize;
  final Position start;
  final Position goal;
  final Set<Position> obstacles;
  final List<Direction>? solution; // Optional hint

  CodeCommanderLevel({
    required super.id,
    required super.difficulty,
    required this.gridSize,
    required this.start,
    required this.goal,
    required this.obstacles,
    this.solution,
    super.createdAt,
  });

  @override
  bool validate() {
    // Requirement 18.5: Validate path exists with A* pathfinding
    final path = AStarPathfinder.findPath(
      start: start,
      goal: goal,
      obstacles: obstacles,
      gridSize: gridSize,
    );

    return path != null && path.length >= 2;
  }

  /// Get optimal solution path
  List<Direction> getSolution() {
    if (solution != null) return solution!;

    final path = AStarPathfinder.findPath(
      start: start,
      goal: goal,
      obstacles: obstacles,
      gridSize: gridSize,
    );

    if (path == null) return [];

    return AStarPathfinder.pathToDirections(path);
  }

  /// Check if a sequence of commands solves the level
  bool checkSolution(List<Direction> commands) {
    Position current = start;

    for (final command in commands) {
      // Apply command
      current = command.apply(current);

      // Check if out of bounds
      if (current.x < 0 ||
          current.x >= gridSize ||
          current.y < 0 ||
          current.y >= gridSize) {
        return false;
      }

      // Check if hit obstacle
      if (obstacles.contains(current)) {
        return false;
      }
    }

    // Check if reached goal
    return current == goal;
  }

  /// Simulate command execution and return path
  List<Position> simulateCommands(List<Direction> commands) {
    final path = <Position>[start];
    Position current = start;

    for (final command in commands) {
      current = command.apply(current);

      // Stop if out of bounds or hit obstacle
      if (current.x < 0 ||
          current.x >= gridSize ||
          current.y < 0 ||
          current.y >= gridSize ||
          obstacles.contains(current)) {
        break;
      }

      path.add(current);
    }

    return path;
  }

  /// Get hint for next move
  Direction? getHint(Position currentPosition) {
    if (!difficulty.hintsEnabled) return null;

    final path = AStarPathfinder.findPath(
      start: currentPosition,
      goal: goal,
      obstacles: obstacles,
      gridSize: gridSize,
    );

    if (path == null || path.length < 2) return null;

    final directions = AStarPathfinder.pathToDirections(path);
    return directions.isNotEmpty ? directions.first : null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'difficulty': difficulty.name,
      'gridSize': gridSize,
      'start': start.toJson(),
      'goal': goal.toJson(),
      'obstacles': obstacles.map((p) => p.toJson()).toList(),
      'solution': solution?.map((d) => d.name).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CodeCommanderLevel.fromJson(Map<String, dynamic> json) {
    return CodeCommanderLevel(
      id: json['id'] as String,
      difficulty: DifficultyLevel.values.firstWhere(
        (d) => d.name == json['difficulty'],
      ),
      gridSize: json['gridSize'] as int,
      start: Position.fromJson(json['start'] as Map<String, dynamic>),
      goal: Position.fromJson(json['goal'] as Map<String, dynamic>),
      obstacles: (json['obstacles'] as List)
          .map((p) => Position.fromJson(p as Map<String, dynamic>))
          .toSet(),
      solution: json['solution'] != null
          ? (json['solution'] as List)
              .map((d) => Direction.values.firstWhere((dir) => dir.name == d))
              .toList()
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Get level statistics
  Map<String, dynamic> getStats() {
    final optimalSolution = getSolution();

    return {
      'gridSize': gridSize,
      'obstacleCount': obstacles.length,
      'obstacleDensity': obstacles.length / (gridSize * gridSize),
      'optimalMoves': optimalSolution.length,
      'difficulty': difficulty.displayName,
    };
  }
}
