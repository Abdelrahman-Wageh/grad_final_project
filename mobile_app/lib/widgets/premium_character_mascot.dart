import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/premium_kid_theme.dart';

/// 🎭 Premium Character Mascot Interactions
/// Engaging character animations and behaviors that kids will love
class PremiumCharacterMascot extends StatefulWidget {
  final String characterEmoji;
  final String characterName;
  final double size;
  final bool isInteractive;
  final VoidCallback? onTap;
  final String? currentMood;
  final List<String> expressions;

  const PremiumCharacterMascot({
    Key? key,
    this.characterEmoji = '🎮',
    this.characterName = 'Smartino',
    this.size = 200,
    this.isInteractive = true,
    this.onTap,
    this.currentMood,
    this.expressions = const ['happy', 'excited', 'thinking', 'celebrating'],
  }) : super(key: key);

  @override
  State<PremiumCharacterMascot> createState() =>
      _PremiumCharacterMascotState();
}

class _PremiumCharacterMascotState extends State<PremiumCharacterMascot>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _bounceController;
  late AnimationController _expressionController;
  late Animation<double> _floatAnimation;
  late Animation<double> _bounceAnimation;
  String _currentExpression = 'happy';
  String _speechBubble = 'Hi there! Ready to play?';

  final Map<String, String> _moodEmojis = {
    'happy': '😊',
    'excited': '🤩',
    'thinking': '🤔',
    'celebrating': '🎉',
    'sad': '😢',
    'confused': '🤨',
  };

  final Map<String, List<String>> _speeches = {
    'hello': [
      'Hi there! Ready to learn?',
      'Let\'s go on an adventure!',
      'Welcome back, friend!',
      'Are you ready to play?'
    ],
    'correct': [
      'Amazing! 🌟',
      'That\'s right!',
      'Well done! 👏',
      'Fantastic! 🎉'
    ],
    'incorrect': [
      'Try again!',
      'Not quite...',
      'Keep trying! 💪',
      'You\'re getting there!'
    ],
    'celebrating': [
      'We did it! 🎉',
      'So proud of you!',
      'You\'re awesome!',
      'High five! ✋'
    ],
  };

  @override
  void initState() {
    super.initState();
    _currentExpression = widget.expressions.first;

    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _expressionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _floatAnimation = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _bounceAnimation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bounceController.dispose();
    _expressionController.dispose();
    super.dispose();
  }

  void _bounce() {
    _bounceController.forward(from: 0.0);
  }

  void _changeExpression(String mood) {
    _expressionController.forward(from: 0.0).then((_) {
      setState(() {
        _currentExpression = mood;
      });
    });
  }

  void _showSpeech(String category) {
    final speeches = _speeches[category] ?? _speeches['hello']!;
    final randomSpeech =
        speeches[DateTime.now().millisecond % speeches.length];
    setState(() {
      _speechBubble = randomSpeech;
    });
    _bounce();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isInteractive) {
          _bounce();
          _showSpeech('hello');
          widget.onTap?.call();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSpeechBubble(),
          SizedBox(height: 16),
          _buildCharacterWithAnimations(),
          SizedBox(height: 12),
          _buildCharacterName(),
        ],
      ),
    );
  }

  /// Speech bubble
  Widget _buildSpeechBubble() {
    return Transform.scale(
      scale: _expressionController.value > 0.5 ? 0.9 : 1.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: PremiumKidTheme.vibrantMagenta.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                _speechBubble,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1F2E),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 8),
            Text('💬', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: -0.2, end: 0);
  }

  /// Main character with animations
  Widget _buildCharacterWithAnimations() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow background
        Container(
          width: widget.size * 1.3,
          height: widget.size * 1.3,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                PremiumKidTheme.vibrantMagenta.withOpacity(0.15),
                PremiumKidTheme.vibrantMagenta.withOpacity(0),
              ],
            ),
          ),
        )
            .animate()
            .scaleXY(begin: 0.8, end: 1.2, duration: 2000.ms)
            .then()
            .scaleXY(begin: 1.2, end: 0.8, duration: 2000.ms),

        // Character container
        AnimatedBuilder(
          animation: Listenable.merge([_floatAnimation, _bounceAnimation]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value + _bounceAnimation.value),
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: PremiumKidTheme.vibrantMagenta.withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.isInteractive
                        ? () {
                            _bounce();
                            _showSpeech('hello');
                            widget.onTap?.call();
                          }
                        : null,
                    borderRadius: BorderRadius.circular(widget.size / 2),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Main emoji
                        Text(
                          widget.characterEmoji,
                          style: TextStyle(fontSize: widget.size * 0.55),
                        ),

                        // Mood indicator
                        Positioned(
                          bottom: widget.size * 0.08,
                          right: widget.size * 0.08,
                          child: Container(
                            width: widget.size * 0.25,
                            height: widget.size * 0.25,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: PremiumKidTheme.vibrantMagenta,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _moodEmojis[_currentExpression] ?? '😊',
                                style: TextStyle(
                                  fontSize: widget.size * 0.12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Floating stars/hearts
        if (widget.isInteractive)
          ..._buildFloatingReactions(),
      ],
    );
  }

  /// Character name
  Widget _buildCharacterName() {
    return Text(
      widget.characterName,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1F2E),
      ),
    );
  }

  /// Floating reactions
  List<Widget> _buildFloatingReactions() {
    return [
      Positioned(
        top: -10,
        right: -10,
        child: Text('✨', style: TextStyle(fontSize: 24))
            .animate()
            .fadeIn(duration: 400.ms)
            .scale(begin: 0, end: 1, duration: 400.ms)
            .then()
            .fadeOut(duration: 200.ms, delay: 1000.ms),
      ),
      Positioned(
        bottom: -15,
        left: -15,
        child: Text('⭐', style: TextStyle(fontSize: 20))
            .animate()
            .fadeIn(duration: 400.ms, delay: 200.ms)
            .scale(begin: 0, end: 1, duration: 400.ms)
            .then()
            .fadeOut(duration: 200.ms, delay: 800.ms),
      ),
    ];
  }
}

/// Character response panel
class CharacterResponsePanel extends StatefulWidget {
  final String responseText;
  final String? moodEmoji;
  final List<String>? actionButtons;
  final VoidCallback? onDismiss;
  final Duration duration;

  const CharacterResponsePanel({
    Key? key,
    required this.responseText,
    this.moodEmoji,
    this.actionButtons,
    this.onDismiss,
    this.duration = const Duration(milliseconds: 3000),
  }) : super(key: key);

  @override
  State<CharacterResponsePanel> createState() =>
      _CharacterResponsePanelState();
}

class _CharacterResponsePanelState extends State<CharacterResponsePanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward().then((_) {
      widget.onDismiss?.call();
    });
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
            begin: const Offset(0, -1),
            end: const Offset(0, 0),
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
          ),
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: PremiumKidTheme.magentaPinkGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: PremiumKidTheme.vibrantMagenta.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                if (widget.moodEmoji != null) ...[
                  Text(
                    widget.moodEmoji!,
                    style: const TextStyle(fontSize: 32),
                  ),
                  SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    widget.responseText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

/// Character action panel
class CharacterActionPanel extends StatelessWidget {
  final List<CharacterAction> actions;
  final String? characterMood;

  const CharacterActionPanel({
    Key? key,
    required this.actions,
    this.characterMood,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: actions
          .asMap()
          .entries
          .map(
            (entry) => _buildActionButton(entry.key, entry.value),
          )
          .toList(),
    );
  }

  Widget _buildActionButton(int index, CharacterAction action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: action.gradient ?? PremiumKidTheme.magentaPinkGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (action.icon != null) ...[
                Icon(
                  action.icon,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 8),
              ],
              Text(
                action.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: Duration(milliseconds: index * 100))
        .slideY(begin: 0.2, end: 0);
  }
}

/// Character action model
class CharacterAction {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final LinearGradient? gradient;

  CharacterAction({
    required this.label,
    required this.onTap,
    this.icon,
    this.gradient,
  });
}

/// Character celebration animation
class CharacterCelebration extends StatefulWidget {
  final String message;
  final String celebrationEmoji;
  final Duration duration;

  const CharacterCelebration({
    Key? key,
    required this.message,
    this.celebrationEmoji = '🎉',
    this.duration = const Duration(milliseconds: 2000),
  }) : super(key: key);

  @override
  State<CharacterCelebration> createState() => _CharacterCelebrationState();
}

class _CharacterCelebrationState extends State<CharacterCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Celebration emojis
          Text(
            widget.celebrationEmoji,
            style: const TextStyle(fontSize: 80),
          )
              .animate()
              .scaleXY(begin: 0, end: 1, duration: 400.ms, curve: Curves.elasticOut)
              .then()
              .rotate(
                begin: 0,
                end: 0.2,
                duration: 100.ms,
              )
              .then()
              .rotate(
                begin: 0.2,
                end: -0.2,
                duration: 100.ms,
              )
              .then()
              .rotate(
                begin: -0.2,
                end: 0,
                duration: 100.ms,
              ),

          SizedBox(height: 20),

          // Message
          Text(
            widget.message,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: PremiumKidTheme.vibrantMagenta,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 200.ms)
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    )
        .animate()
        .fadeOut(duration: 300.ms, delay: widget.duration - const Duration(milliseconds: 300));
  }
}
