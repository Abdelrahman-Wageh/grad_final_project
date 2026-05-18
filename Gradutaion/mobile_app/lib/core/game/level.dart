import 'difficulty_level.dart';

/// Base class for all game levels
/// Requirements: 18.1, 18.2, 18.3, 18.4
abstract class Level {
  final String id;
  final DifficultyLevel difficulty;
  final DateTime createdAt;

  Level({
    required this.id,
    required this.difficulty,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Validate that the level is solvable
  bool validate();

  /// Get level metadata as JSON
  Map<String, dynamic> toJson();

  /// Create level from JSON
  static Level fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('Subclasses must implement fromJson');
  }
}

/// Position in a 2D grid
class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => 'Position($x, $y)';

  /// Get Manhattan distance to another position
  int distanceTo(Position other) {
    return (x - other.x).abs() + (y - other.y).abs();
  }

  /// Get adjacent positions (up, down, left, right)
  List<Position> getAdjacent() {
    return [
      Position(x, y - 1), // Up
      Position(x, y + 1), // Down
      Position(x - 1, y), // Left
      Position(x + 1, y), // Right
    ];
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(json['x'] as int, json['y'] as int);
  }
}

/// Direction for movement commands
enum Direction {
  up,
  down,
  left,
  right;

  /// Get display icon
  String get icon {
    switch (this) {
      case Direction.up:
        return '⬆️';
      case Direction.down:
        return '⬇️';
      case Direction.left:
        return '⬅️';
      case Direction.right:
        return '➡️';
    }
  }

  /// Get position delta
  Position get delta {
    switch (this) {
      case Direction.up:
        return const Position(0, -1);
      case Direction.down:
        return const Position(0, 1);
      case Direction.left:
        return const Position(-1, 0);
      case Direction.right:
        return const Position(1, 0);
    }
  }

  /// Apply direction to position
  Position apply(Position pos) {
    final d = delta;
    return Position(pos.x + d.x, pos.y + d.y);
  }
}
