import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../core/game/code_commander_level.dart';
import '../../core/game/code_commander_generator.dart';
import '../../core/game/level.dart';
import '../../core/game/difficulty_level.dart';
import '../../data/models/child_profile.dart';
import '../../widgets/smartino_mascot_placeholder.dart';

/// Code Commander Game - Logic & Pathfinding
/// Requirements: 19.1, 19.2, 19.3, 19.4
class CodeCommanderGame extends StatefulWidget {
  final CodeCommanderLevel level;
  final ChildProfile profile;

  const CodeCommanderGame({
    super.key,
    required this.level,
    required this.profile,
  });

  @override
  State<CodeCommanderGame> createState() => _CodeCommanderGameState();
}

class _CodeCommanderGameState extends State<CodeCommanderGame>
    with SingleTickerProviderStateMixin {
  // Game state
  List<Direction> commandSequence = [];
  Position? currentPosition;
  bool isExecuting = false;
  bool isSuccess = false;
  MascotMood mascotMood = MascotMood.idle;

  // Animation
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // Celebration
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    currentPosition = widget.level.start;

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Setup confetti
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            // Main game content
            Column(
              children: [
                // Header
                _buildHeader(),

                // Game grid
                Expanded(
                  child: Center(
                    child: _buildGameGrid(),
                  ),
                ),

                // Command palette
                _buildCommandPalette(),

                // Command sequence display
                _buildCommandSequence(),

                // Action buttons
                _buildActionButtons(),

                const SizedBox(height: 20),
              ],
            ),

            // Mascot overlay
            Positioned(
              top: 80,
              right: 20,
              child: SizedBox(
                width: 100,
                height: 100,
                child: SmartinoMascotPlaceholder(mood: mascotMood),
              ),
            ),

            // Confetti overlay
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 50,
                gravity: 0.1,
                colors: const [
                  Colors.red,
                  Colors.yellow,
                  Colors.blue,
                  Colors.green,
                  Colors.purple,
                ],
              ),
            ),

            // Success overlay
            if (isSuccess) _buildSuccessOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 28),
            onPressed: () => Navigator.pop(context),
          ),

          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Code Commander',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  'Difficulty: ${widget.level.difficulty.displayName}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Hint button
          if (widget.level.difficulty.hintsEnabled)
            IconButton(
              icon: const Icon(Icons.lightbulb_outline, size: 28),
              color: Colors.amber,
              onPressed: _showHint,
            ),
        ],
      ),
    );
  }

  Widget _buildGameGrid() {
    final gridSize = widget.level.gridSize;
    final cellSize = (MediaQuery.of(context).size.width - 80) / gridSize;

    return Container(
      padding: const EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: gridSize * gridSize,
          itemBuilder: (context, index) {
            final x = index % gridSize;
            final y = index ~/ gridSize;
            final position = Position(x, y);

            return _buildGridCell(position, cellSize);
          },
        ),
      ),
    );
  }

  Widget _buildGridCell(Position position, double size) {
    final isStart = position == widget.level.start;
    final isGoal = position == widget.level.goal;
    final isObstacle = widget.level.obstacles.contains(position);
    final isCurrent = position == currentPosition;

    Color cellColor = Colors.white;
    Widget? cellContent;

    if (isObstacle) {
      cellColor = const Color(0xFF34495E);
      cellContent = const Icon(Icons.block, color: Colors.white, size: 24);
    } else if (isGoal) {
      cellColor = const Color(0xFFF39C12);
      cellContent = const Text(
        '🔋',
        style: TextStyle(fontSize: 32),
      );
    } else if (isCurrent) {
      cellColor = const Color(0xFF3498DB);
      cellContent = AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: const Text(
              '🤖',
              style: TextStyle(fontSize: 32),
            ),
          );
        },
      );
    } else if (isStart && !isCurrent) {
      cellColor = const Color(0xFFECF0F1);
    }

    return Container(
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Center(child: cellContent),
    );
  }

  Widget _buildCommandPalette() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: Direction.values.map((direction) {
          return _buildCommandButton(direction);
        }).toList(),
      ),
    );
  }

  Widget _buildCommandButton(Direction direction) {
    return GestureDetector(
      onTap: isExecuting ? null : () => _addCommand(direction),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: isExecuting ? Colors.grey[300] : const Color(0xFF9B59B6),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            direction.icon,
            style: const TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }

  Widget _buildCommandSequence() {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: commandSequence.isEmpty
          ? Center(
              child: Text(
                'Drag commands here',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: commandSequence.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _removeCommand(index),
                  child: Container(
                    width: 56,
                    height: 56,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3498DB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        commandSequence[index].icon,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Clear button
          Expanded(
            child: ElevatedButton(
              onPressed: isExecuting ? null : _clearCommands,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE74C3C),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Clear',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Execute button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isExecuting || commandSequence.isEmpty
                  ? null
                  : _executeCommands,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27AE60),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                isExecuting ? 'Executing...' : 'Execute',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎉',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 16),
              const Text(
                'Amazing!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF27AE60),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You helped Smartino reach the battery!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF7F8C8D),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF95A5A6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Exit',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _playAgain,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3498DB),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Play Again',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Game logic methods
  void _addCommand(Direction direction) {
    if (commandSequence.length < 20) {
      // Max 20 commands
      setState(() {
        commandSequence.add(direction);
      });
      HapticFeedback.lightImpact();
    }
  }

  void _removeCommand(int index) {
    setState(() {
      commandSequence.removeAt(index);
    });
    HapticFeedback.lightImpact();
  }

  void _clearCommands() {
    setState(() {
      commandSequence.clear();
      currentPosition = widget.level.start;
    });
    HapticFeedback.mediumImpact();
  }

  Future<void> _executeCommands() async {
    setState(() {
      isExecuting = true;
      currentPosition = widget.level.start;
      mascotMood = MascotMood.thinking;
    });

    // Animate each command
    for (final command in commandSequence) {
      await Future.delayed(const Duration(milliseconds: 500));

      final newPosition = command.apply(currentPosition!);

      // Check bounds
      if (newPosition.x < 0 ||
          newPosition.x >= widget.level.gridSize ||
          newPosition.y < 0 ||
          newPosition.y >= widget.level.gridSize) {
        _handleFailure('Out of bounds!');
        return;
      }

      // Check obstacle
      if (widget.level.obstacles.contains(newPosition)) {
        _handleFailure('Hit an obstacle!');
        return;
      }

      setState(() {
        currentPosition = newPosition;
      });

      _animationController.forward().then((_) {
        _animationController.reverse();
      });

      // Check if reached goal
      if (currentPosition == widget.level.goal) {
        _handleSuccess();
        return;
      }
    }

    // Didn't reach goal
    _handleFailure('So close! Try adding more commands!');
  }

  void _handleSuccess() {
    setState(() {
      isSuccess = true;
      mascotMood = MascotMood.excited;
    });

    // Trigger confetti
    _confettiController.play();

    // Play success sound (if available)
    // _audioPlayer.play(AssetSource('sounds/success.mp3'));

    HapticFeedback.heavyImpact();
  }

  void _handleFailure(String message) {
    setState(() {
      isExecuting = false;
      mascotMood = MascotMood.sad;
    });

    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: const Color(0xFFE74C3C),
        duration: const Duration(seconds: 2),
      ),
    );

    // Reset after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          currentPosition = widget.level.start;
          mascotMood = MascotMood.idle;
        });
      }
    });
  }

  void _showHint() {
    final hint = widget.level.getHint(currentPosition!);

    if (hint != null) {
      setState(() {
        mascotMood = MascotMood.happy;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Try going ${hint.name}! ${hint.icon}',
            style: const TextStyle(fontSize: 16),
          ),
          backgroundColor: const Color(0xFFF39C12),
          duration: const Duration(seconds: 3),
        ),
      );

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            mascotMood = MascotMood.idle;
          });
        }
      });
    }
  }

  void _playAgain() {
    // Generate new level
    final generator = CodeCommanderGenerator();
    final newLevel = generator.generateLevel(
      widget.level.difficulty,
      widget.profile,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CodeCommanderGame(
          level: newLevel,
          profile: widget.profile,
        ),
      ),
    );
  }
}
