import 'dart:collection';
import 'level.dart';

/// A* pathfinding algorithm implementation
/// Requirement 19.5: Validate path exists with A* pathfinding
class AStarPathfinder {
  /// Find path from start to goal avoiding obstacles
  /// Returns null if no path exists
  static List<Position>? findPath({
    required Position start,
    required Position goal,
    required Set<Position> obstacles,
    required int gridSize,
  }) {
    // Priority queue for open set (positions to explore)
    final openSet = PriorityQueue<_Node>((a, b) => a.fScore.compareTo(b.fScore));
    final openSetPositions = <Position>{};

    // Closed set (already explored)
    final closedSet = <Position>{};

    // Track came-from for path reconstruction
    final cameFrom = <Position, Position>{};

    // G score: cost from start to position
    final gScore = <Position, double>{start: 0};

    // F score: g + heuristic (estimated cost to goal)
    final fScore = <Position, double>{start: _heuristic(start, goal)};

    // Add start node
    openSet.add(_Node(start, fScore[start]!));
    openSetPositions.add(start);

    while (openSet.isNotEmpty) {
      // Get node with lowest f score
      final current = openSet.removeFirst();
      openSetPositions.remove(current.position);

      // Goal reached!
      if (current.position == goal) {
        return _reconstructPath(cameFrom, current.position);
      }

      closedSet.add(current.position);

      // Check all neighbors
      for (final neighbor in current.position.getAdjacent()) {
        // Skip if out of bounds
        if (!_isInBounds(neighbor, gridSize)) continue;

        // Skip if obstacle
        if (obstacles.contains(neighbor)) continue;

        // Skip if already explored
        if (closedSet.contains(neighbor)) continue;

        // Calculate tentative g score
        final tentativeGScore = gScore[current.position]! + 1;

        // Check if this path is better
        if (!gScore.containsKey(neighbor) ||
            tentativeGScore < gScore[neighbor]!) {
          // This path is better, record it
          cameFrom[neighbor] = current.position;
          gScore[neighbor] = tentativeGScore;
          fScore[neighbor] = tentativeGScore + _heuristic(neighbor, goal);

          // Add to open set if not already there
          if (!openSetPositions.contains(neighbor)) {
            openSet.add(_Node(neighbor, fScore[neighbor]!));
            openSetPositions.add(neighbor);
          }
        }
      }
    }

    // No path found
    return null;
  }

  /// Manhattan distance heuristic
  static double _heuristic(Position a, Position b) {
    return (a.x - b.x).abs() + (a.y - b.y).abs().toDouble();
  }

  /// Check if position is within grid bounds
  static bool _isInBounds(Position pos, int gridSize) {
    return pos.x >= 0 && pos.x < gridSize && pos.y >= 0 && pos.y < gridSize;
  }

  /// Reconstruct path from came-from map
  static List<Position> _reconstructPath(
    Map<Position, Position> cameFrom,
    Position current,
  ) {
    final path = <Position>[current];

    while (cameFrom.containsKey(current)) {
      current = cameFrom[current]!;
      path.insert(0, current);
    }

    return path;
  }

  /// Convert path to direction commands
  static List<Direction> pathToDirections(List<Position> path) {
    if (path.length < 2) return [];

    final directions = <Direction>[];

    for (int i = 0; i < path.length - 1; i++) {
      final current = path[i];
      final next = path[i + 1];

      final dx = next.x - current.x;
      final dy = next.y - current.y;

      if (dx == 1) {
        directions.add(Direction.right);
      } else if (dx == -1) {
        directions.add(Direction.left);
      } else if (dy == 1) {
        directions.add(Direction.down);
      } else if (dy == -1) {
        directions.add(Direction.up);
      }
    }

    return directions;
  }
}

/// Node for A* priority queue
class _Node {
  final Position position;
  final double fScore;

  _Node(this.position, this.fScore);
}

/// Simple priority queue implementation
class PriorityQueue<T> {
  final List<T> _items = [];
  final Comparator<T> _comparator;

  PriorityQueue(this._comparator);

  void add(T item) {
    _items.add(item);
    _items.sort(_comparator);
  }

  T removeFirst() {
    return _items.removeAt(0);
  }

  bool get isNotEmpty => _items.isNotEmpty;
  bool get isEmpty => _items.isEmpty;
  int get length => _items.length;
}
