import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/premium_kid_theme.dart';

/// 🎮 Premium Game Widgets
/// High-end, impressive game UI components for kids
class PremiumGameWidgets {
  /// Score display with animation
  static Widget scoreDisplay({
    required int score,
    int previousScore = 0,
    bool showAnimation = false,
  }) {
    return _ScoreDisplay(
      score: score,
      previousScore: previousScore,
      showAnimation: showAnimation,
    );
  }

  /// Lives indicator with hearts
  static Widget livesIndicator({
    required int lives,
    required int maxLives,
  }) {
    return _LivesIndicator(
      lives: lives,
      maxLives: maxLives,
    );
  }

  /// Combo counter
  static Widget comboCounter({
    required int comboCount,
    double size = 60,
  }) {
    return _ComboCounter(
      comboCount: comboCount,
      size: size,
    );
  }

  /// Time remaining display
  static Widget timerDisplay({
    required Duration timeRemaining,
    required Duration totalTime,
    Color timerColor = PremiumKidTheme.vibrantMagenta,
  }) {
    return _TimerDisplay(
      timeRemaining: timeRemaining,
      totalTime: totalTime,
      timerColor: timerColor,
    );
  }

  /// Level progress
  static Widget levelProgress({
    required int currentLevel,
    required int totalLevels,
    required double progress,
  }) {
    return _LevelProgress(
      currentLevel: currentLevel,
      totalLevels: totalLevels,
      progress: progress,
    );
  }

  /// Power-up card
  static Widget powerUpCard({
    required String powerUpName,
    required String powerUpEmoji,
    required String description,
    VoidCallback? onActivate,
    bool isActive = false,
  }) {
    return _PowerUpCard(
      powerUpName: powerUpName,
      powerUpEmoji: powerUpEmoji,
      description: description,
      onActivate: onActivate,
      isActive: isActive,
    );
  }

  /// Achievement unlock popup
  static Widget achievementUnlock({
    required String achievementName,
    required String description,
    required String achievementIcon,
    int pointsAwarded = 100,
  }) {
    return _AchievementUnlock(
      achievementName: achievementName,
      description: description,
      achievementIcon: achievementIcon,
      pointsAwarded: pointsAwarded,
    );
  }

  /// Game over screen
  static Widget gameOverScreen({
    required int finalScore,
    required bool didWin,
    required VoidCallback onRestart,
    required VoidCallback onQuit,
    int? bestScore,
  }) {
    return _GameOverScreen(
      finalScore: finalScore,
      didWin: didWin,
      onRestart: onRestart,
      onQuit: onQuit,
      bestScore: bestScore,
    );
  }

  /// Difficulty selector
  static Widget difficultySelector({
    required Function(String) onDifficultySelected,
    String initialDifficulty = 'medium',
  }) {
    return _DifficultySelector(
      onDifficultySelected: onDifficultySelected,
      initialDifficulty: initialDifficulty,
    );
  }

  /// Challenge card
  static Widget challengeCard({
    required String challengeTitle,
    required String description,
    required int targetScore,
    required String reward,
    bool isCompleted = false,
  }) {
    return _ChallengeCard(
      challengeTitle: challengeTitle,
      description: description,
      targetScore: targetScore,
      reward: reward,
      isCompleted: isCompleted,
    );
  }

  /// Leaderboard entry
  static Widget leaderboardEntry({
    required int rank,
    required String playerName,
    required int score,
    bool isCurrentPlayer = false,
    String? avatar,
  }) {
    return _LeaderboardEntry(
      rank: rank,
      playerName: playerName,
      score: score,
      isCurrentPlayer: isCurrentPlayer,
      avatar: avatar,
    );
  }

  /// Star rating display
  static Widget starRating({
    required int earnedStars,
    required int totalStars,
    double size = 40,
  }) {
    return _StarRating(
      earnedStars: earnedStars,
      totalStars: totalStars,
      size: size,
    );
  }
}

/// Score display
class _ScoreDisplay extends StatefulWidget {
  final int score;
  final int previousScore;
  final bool showAnimation;

  const _ScoreDisplay({
    required this.score,
    required this.previousScore,
    required this.showAnimation,
  });

  @override
  State<_ScoreDisplay> createState() => _ScoreDisplayState();
}

class _ScoreDisplayState extends State<_ScoreDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _displayScore = 0;

  @override
  void initState() {
    super.initState();
    _displayScore = widget.previousScore;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    if (widget.showAnimation) {
      _animateScore();
    } else {
      _displayScore = widget.score;
    }
  }

  void _animateScore() {
    _controller.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(_ScoreDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score && widget.showAnimation) {
      _animateScore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (widget.showAnimation && _controller.isAnimating) {
          _displayScore =
              (widget.previousScore +
                  (widget.score - widget.previousScore) * _controller.value)
                  .toInt();
        } else if (!widget.showAnimation) {
          _displayScore = widget.score;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: PremiumKidTheme.magentaPinkGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: PremiumKidTheme.vibrantMagenta.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'SCORE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _displayScore.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        );
      },
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .scaleXY(begin: 0.8, end: 1, duration: 400.ms);
  }
}

/// Lives indicator
class _LivesIndicator extends StatelessWidget {
  final int lives;
  final int maxLives;

  const _LivesIndicator({
    required this.lives,
    required this.maxLives,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxLives, (index) {
        final hasLife = index < lives;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hasLife ? PremiumKidTheme.errorBright : Colors.grey[300],
              boxShadow: hasLife
                  ? [
                      BoxShadow(
                        color: PremiumKidTheme.errorBright.withOpacity(0.4),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                '❤️',
                style: TextStyle(fontSize: 18),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: Duration(milliseconds: index * 100))
              .scaleXY(begin: 0.5, end: 1, duration: 400.ms),
        );
      }),
    );
  }
}

/// Combo counter
class _ComboCounter extends StatefulWidget {
  final int comboCount;
  final double size;

  const _ComboCounter({
    required this.comboCount,
    required this.size,
  });

  @override
  State<_ComboCounter> createState() => _ComboCounterState();
}

class _ComboCounterState extends State<_ComboCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _triggerAnimation();
  }

  void _triggerAnimation() {
    _scaleController.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(_ComboCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.comboCount != widget.comboCount) {
      _triggerAnimation();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.comboCount <= 1) {
      return SizedBox.shrink();
    }

    return ScaleTransition(
      scale: Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
      ),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          gradient: PremiumKidTheme.sunsetGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: PremiumKidTheme.coralOrange.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🔥',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 2),
              Text(
                '${widget.comboCount}x',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Timer display
class _TimerDisplay extends StatefulWidget {
  final Duration timeRemaining;
  final Duration totalTime;
  final Color timerColor;

  const _TimerDisplay({
    required this.timeRemaining,
    required this.totalTime,
    required this.timerColor,
  });

  @override
  State<_TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<_TimerDisplay> {
  late Color _displayColor;

  @override
  void initState() {
    super.initState();
    _updateColor();
  }

  void _updateColor() {
    final percent = widget.timeRemaining.inMilliseconds / 
                    widget.totalTime.inMilliseconds;
    if (percent > 0.5) {
      _displayColor = widget.timerColor;
    } else if (percent > 0.25) {
      _displayColor = PremiumKidTheme.warningBright;
    } else {
      _displayColor = PremiumKidTheme.errorBright;
    }
  }

  @override
  void didUpdateWidget(_TimerDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateColor();
  }

  @override
  Widget build(BuildContext context) {
    final percent = widget.timeRemaining.inMilliseconds / 
                   widget.totalTime.inMilliseconds;
    final seconds = (widget.timeRemaining.inMilliseconds / 1000).ceil();

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [_displayColor, _displayColor.withOpacity(0.7)],
        ),
        boxShadow: [
          BoxShadow(
            color: _displayColor.withOpacity(0.4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular progress
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: percent,
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          // Time text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'TIME',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2),
              Text(
                seconds.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .scaleXY(begin: 0.8, end: 1, duration: 400.ms);
  }
}

/// Level progress
class _LevelProgress extends StatelessWidget {
  final int currentLevel;
  final int totalLevels;
  final double progress;

  const _LevelProgress({
    required this.currentLevel,
    required this.totalLevels,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level $currentLevel',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1F2E),
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: PremiumKidTheme.vibrantMagenta,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 16,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              PremiumKidTheme.vibrantMagenta,
            ),
          )
              .animate()
              .scaleX(begin: 0, end: 1, duration: 600.ms)
              .then()
              .shimmer(duration: 3000.ms, delay: 100.ms),
        ),
      ],
    );
  }
}

/// Power-up card
class _PowerUpCard extends StatelessWidget {
  final String powerUpName;
  final String powerUpEmoji;
  final String description;
  final VoidCallback? onActivate;
  final bool isActive;

  const _PowerUpCard({
    required this.powerUpName,
    required this.powerUpEmoji,
    required this.description,
    this.onActivate,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onActivate : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isActive
              ? PremiumKidTheme.magentaPinkGradient
              : LinearGradient(
                  colors: [
                    Colors.grey[300]!,
                    Colors.grey[200]!,
                  ],
                ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: PremiumKidTheme.vibrantMagenta.withOpacity(0.4),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              powerUpEmoji,
              style: const TextStyle(fontSize: 40),
            ),
            SizedBox(height: 8),
            Text(
              powerUpName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white.withOpacity(0.8) : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms)
          .scaleXY(begin: 0.5, end: 1, duration: 400.ms),
    );
  }
}

/// Achievement unlock
class _AchievementUnlock extends StatefulWidget {
  final String achievementName;
  final String description;
  final String achievementIcon;
  final int pointsAwarded;

  const _AchievementUnlock({
    required this.achievementName,
    required this.description,
    required this.achievementIcon,
    required this.pointsAwarded,
  });

  @override
  State<_AchievementUnlock> createState() => _AchievementUnlockState();
}

class _AchievementUnlockState extends State<_AchievementUnlock>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1.5),
            end: const Offset(0, 0.1),
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
          ),
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: PremiumKidTheme.goldenGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: PremiumKidTheme.sunnyYellow.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.achievementIcon,
                  style: const TextStyle(fontSize: 60),
                ),
                SizedBox(height: 12),
                const Text(
                  '🏆 Achievement Unlocked! 🏆',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.achievementName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 6),
                Text(
                  widget.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '+${widget.pointsAwarded} points',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Game over screen
class _GameOverScreen extends StatelessWidget {
  final int finalScore;
  final bool didWin;
  final VoidCallback onRestart;
  final VoidCallback onQuit;
  final int? bestScore;

  const _GameOverScreen({
    required this.finalScore,
    required this.didWin,
    required this.onRestart,
    required this.onQuit,
    this.bestScore,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: didWin
                  ? PremiumKidTheme.rainbowGradient
                  : LinearGradient(
                      colors: [
                        Colors.blue[800]!,
                        Colors.blue[600]!,
                      ],
                    ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  didWin ? '🎉' : '😢',
                  style: const TextStyle(fontSize: 80),
                )
                    .animate()
                    .scaleXY(begin: 0, end: 1, duration: 600.ms, curve: Curves.elasticOut),
                SizedBox(height: 16),
                Text(
                  didWin ? 'YOU WON!' : 'GAME OVER',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),
                SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'FINAL SCORE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        finalScore.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (bestScore != null && bestScore! > finalScore) ...[
                        SizedBox(height: 12),
                        Text(
                          'Best: $bestScore',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms)
                    .scaleXY(begin: 0.8, end: 1, duration: 600.ms),
                SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onRestart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Try Again',
                          style: TextStyle(
                            color: PremiumKidTheme.vibrantMagenta,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onQuit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Quit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 600.ms)
                    .slideY(begin: 0.3, end: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Difficulty selector
class _DifficultySelector extends StatefulWidget {
  final Function(String) onDifficultySelected;
  final String initialDifficulty;

  const _DifficultySelector({
    required this.onDifficultySelected,
    required this.initialDifficulty,
  });

  @override
  State<_DifficultySelector> createState() => _DifficultySelectorState();
}

class _DifficultySelectorState extends State<_DifficultySelector> {
  late String _selectedDifficulty;

  final Map<String, Map<String, dynamic>> _difficulties = {
    'easy': {
      'emoji': '😊',
      'label': 'Easy',
      'description': 'Perfect for beginners',
      'color': PremiumKidTheme.successBright,
    },
    'medium': {
      'emoji': '🤔',
      'label': 'Medium',
      'description': 'A fun challenge',
      'color': PremiumKidTheme.warningBright,
    },
    'hard': {
      'emoji': '💪',
      'label': 'Hard',
      'description': 'For experts only',
      'color': PremiumKidTheme.errorBright,
    },
  };

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = widget.initialDifficulty;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _difficulties.entries.map((entry) {
        final key = entry.key;
        final value = entry.value;
        final isSelected = key == _selectedDifficulty;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDifficulty = key;
            });
            widget.onDifficultySelected(key);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(colors: [value['color'], value['color']])
                  : null,
              color: isSelected ? null : Colors.white,
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.grey[300]!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: (value['color'] as Color).withOpacity(0.4),
                        blurRadius: 12,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Text(
                  value['emoji'],
                  style: const TextStyle(fontSize: 32),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value['label'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : Color(0xFF1A1F2E),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        value['description'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white.withOpacity(0.8) : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 28,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Challenge card
class _ChallengeCard extends StatelessWidget {
  final String challengeTitle;
  final String description;
  final int targetScore;
  final String reward;
  final bool isCompleted;

  const _ChallengeCard({
    required this.challengeTitle,
    required this.description,
    required this.targetScore,
    required this.reward,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isCompleted
            ? PremiumKidTheme.goldenGradient
            : PremiumKidTheme.magentaPinkGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isCompleted
                ? PremiumKidTheme.sunnyYellow
                : PremiumKidTheme.vibrantMagenta)
                .withOpacity(0.4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  challengeTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '✓ Completed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Target: $targetScore points',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Reward: $reward',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, end: 0);
  }
}

/// Leaderboard entry
class _LeaderboardEntry extends StatelessWidget {
  final int rank;
  final String playerName;
  final int score;
  final bool isCurrentPlayer;
  final String? avatar;

  const _LeaderboardEntry({
    required this.rank,
    required this.playerName,
    required this.score,
    required this.isCurrentPlayer,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    final medal = _getMedalForRank(rank);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentPlayer ? PremiumKidTheme.vibrantMagenta.withOpacity(0.1) : Colors.white,
        border: Border(
          left: BorderSide(
            color: isCurrentPlayer
                ? PremiumKidTheme.vibrantMagenta
                : Colors.transparent,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            medal,
            style: const TextStyle(fontSize: 24),
          ),
          SizedBox(width: 12),
          Text(
            '$rank',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1F2E),
            ),
          ),
          SizedBox(width: 12),
          if (avatar != null) ...[
            Text(avatar!, style: const TextStyle(fontSize: 20)),
            SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              playerName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isCurrentPlayer
                    ? PremiumKidTheme.vibrantMagenta
                    : Color(0xFF1A1F2E),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: PremiumKidTheme.magentaPinkGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              score.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideX(begin: -0.2, end: 0);
  }

  String _getMedalForRank(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '•';
    }
  }
}

/// Star rating
class _StarRating extends StatelessWidget {
  final int earnedStars;
  final int totalStars;
  final double size;

  const _StarRating({
    required this.earnedStars,
    required this.totalStars,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalStars, (index) {
        final isEarned = index < earnedStars;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: size * 0.1),
          child: Icon(
            Icons.star,
            size: size,
            color: isEarned ? Colors.amber : Colors.grey[300],
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: Duration(milliseconds: index * 100))
              .scaleXY(begin: 0.5, end: 1, duration: 400.ms),
        );
      }),
    );
  }
}
