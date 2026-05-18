import 'dart:math';
import 'level_generator.dart';
import 'code_commander_level.dart';
import 'difficulty_level.dart';
import 'level.dart';
import 'pathfinding.dart';
import '../../data/models/child_profile.dart';

/// Procedural generator for Code Commander levels
/// Requirements: 18.1, 18.5, 19.5
class CodeCommanderGenerator extends LevelGenerator<CodeCommanderLevel> {
  static const int maxGenerationAttempts = 10;

  CodeCommanderGenerator({super.random});

  @override
  CodeCommanderLevel generateLevel(
      DifficultyLevel difficulty, ChildProfile profile) {
    // Try multiple times to generate a valid level
    for (int attempt = 0; attempt < maxGenerationAttempts; attempt++) {
      final level = _attemptGeneration(difficulty);

      if (validateLevel(level)) {
        return level;
      }
    }

    // Fallback: generate simple level
    return _generateSimpleLevel(difficulty);
  }

  CodeCommanderLevel _attemptGeneration(DifficultyLevel difficulty) {
    // Requirement 18.1: Generate grid size based on difficulty
    final gridSize = difficulty.gridSize;

    // Generate start position (usually bottom-left area)
    final start = Position(
      random.nextInt(gridSize ~/ 2),
      gridSize - 1 - random.nextInt(gridSize ~/ 3),
    );

    // Generate goal position (usually top-right area)
    final goal = Position(
      gridSize - 1 - random.nextInt(gridSize ~/ 2),
      random.nextInt(gridSize ~/ 3),
    );

    // Requirement 18.1: Place random obstacles based on difficulty
    final obstacles = _generateObstacles(gridSize, start, goal, difficulty);

    return CodeCommanderLevel(
      id: generateLevelId(),
      difficulty: difficulty,
      gridSize: gridSize,
      start: start,
      goal: goal,
      obstacles: obstacles,
    );
  }

  Set<Position> _generateObstacles(
    int gridSize,
    Position start,
    Position goal,
    DifficultyLevel difficulty,
  ) {
    final obstacles = <Position>{};
    final totalCells = gridSize * gridSize;
    final targetObstacles =
        (totalCells * difficulty.obstacleDensity).round();

    // Reserve positions
    final reserved = {start, goal};

    // Add obstacles
    int attempts = 0;
    while (obstacles.length < targetObstacles && attempts < targetObstacles * 3) {
      final pos = randomPosition(gridSize);

      // Don't place on reserved positions
      if (reserved.contains(pos)) {
        attempts++;
        continue;
      }

      // Don't place adjacent to start or goal
      if (pos.distanceTo(start) <= 1 || pos.distanceTo(goal) <= 1) {
        attempts++;
        continue;
      }

      obstacles.add(pos);
      attempts++;
    }

    return obstacles;
  }

  @override
  bool validateLevel(CodeCommanderLevel level) {
    // Requirement 18.5: Validate path exists with A* pathfinding
    return level.validate();
  }

  /// Generate a guaranteed solvable simple level
  CodeCommanderLevel _generateSimpleLevel(DifficultyLevel difficulty) {
    final gridSize = difficulty.gridSize;

    // Simple path: start at bottom-left, goal at top-right
    final start = Position(0, gridSize - 1);
    final goal = Position(gridSize - 1, 0);

    // Add a few obstacles that don't block the path
    final obstacles = <Position>{};

    // Add some obstacles in the middle
    for (int i = 0; i < gridSize ~/ 2; i++) {
      final pos = Position(
        random.nextInt(gridSize - 2) + 1,
        random.nextInt(gridSize - 2) + 1,
      );

      if (pos != start && pos != goal) {
        obstacles.add(pos);
      }
    }

    return CodeCommanderLevel(
      id: generateLevelId(),
      difficulty: difficulty,
      gridSize: gridSize,
      start: start,
      goal: goal,
      obstacles: obstacles,
    );
  }

  /// Generate level with specific constraints
  CodeCommanderLevel generateCustomLevel({
    required DifficultyLevel difficulty,
    int? minMoves,
    int? maxMoves,
    bool requireTurns = false,
  }) {
    for (int attempt = 0; attempt < maxGenerationAttempts * 2; attempt++) {
      final level = _attemptGeneration(difficulty);

      if (!validateLevel(level)) continue;

      final solution = level.getSolution();

      // Check move count constraints
      if (minMoves != null && solution.length < minMoves) continue;
      if (maxMoves != null && solution.length > maxMoves) continue;

      // Check if turns are required
      if (requireTurns) {
        bool hasTurns = false;
        for (int i = 1; i < solution.length; i++) {
          if (solution[i] != solution[i - 1]) {
            hasTurns = true;
            break;
          }
        }
        if (!hasTurns) continue;
      }

      return level;
    }

    // Fallback
    return _generateSimpleLevel(difficulty);
  }
}
