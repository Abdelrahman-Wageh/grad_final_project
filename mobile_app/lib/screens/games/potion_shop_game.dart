import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../core/game/potion_shop_level.dart';
import '../../core/game/potion_shop_generator.dart';
import '../../core/game/difficulty_level.dart';
import '../../data/models/child_profile.dart';
import '../../widgets/smartino_mascot_placeholder.dart';

/// Potion Shop Game - Math & Visual Feedback
/// Requirements: 21.1, 21.2, 21.3
class PotionShopGame extends StatefulWidget {
  final PotionShopLevel level;
  final ChildProfile profile;

  const PotionShopGame({
    super.key,
    required this.level,
    required this.profile,
  });

  @override
  State<PotionShopGame> createState() => _PotionShopGameState();
}

class _PotionShopGameState extends State<PotionShopGame>
    with TickerProviderStateMixin {
  // Game state
  int? userAnswer;
  bool isMixing = false;
  bool isSuccess = false;
  MascotMood mascotMood = MascotMood.idle;
  final TextEditingController _answerController = TextEditingController();

  // Animation
  late AnimationController _mixAnimationController;
  late AnimationController _resultAnimationController;
  late Animation<double> _mixAnimation;
  late Animation<double> _resultScaleAnimation;

  // Celebration
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // Setup mix animation
    _mixAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _mixAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mixAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Setup result animation
    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _resultScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _resultAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Setup confetti
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _mixAnimationController.dispose();
    _resultAnimationController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    _answerController.dispose();
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

                // Game area
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Equation display
                        _buildEquationDisplay(),

                        const SizedBox(height: 40),

                        // Potions display
                        _buildPotionsDisplay(),

                        const SizedBox(height: 40),

                        // Answer input
                        _buildAnswerInput(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

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
                  'Potion Shop',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  'Mix the right amount!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquationDisplay() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '🧪',
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 16),
          Text(
            widget.level.getEquation(),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPotionsDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Potion A
        _buildPotion(
          number: widget.level.potionA,
          color: widget.level.colorA,
          label: 'Potion A',
        ),

        // Operation symbol
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF34495E),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              widget.level.operation,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Potion B
        _buildPotion(
          number: widget.level.potionB,
          color: widget.level.colorB,
          label: 'Potion B',
        ),
      ],
    );
  }

  Widget _buildPotion({
    required int number,
    required Color color,
    required String label,
  }) {
    return Column(
      children: [
        // Potion bottle
        Container(
          width: 100,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Liquid
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _mixAnimation,
                  builder: (context, child) {
                    return Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            color.withOpacity(0.7),
                            color,
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(13),
                          bottomRight: Radius.circular(13),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Number
              Center(
                child: Text(
                  number.toString(),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: Column(
        children: [
          const Text(
            'What\'s the answer?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7F8C8D),
            ),
          ),

          const SizedBox(height: 16),

          // Number input
          TextField(
            controller: _answerController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: '?',
              hintStyle: TextStyle(
                fontSize: 32,
                color: Colors.grey[400],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF3498DB),
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                userAnswer = int.tryParse(value);
              });
            },
            onSubmitted: (_) => _checkAnswer(),
          ),
        ],
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
              onPressed: userAnswer == null ? null : _clearAnswer,
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

          // Mix button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: userAnswer == null ? null : _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9B59B6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Mix Potions!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                '✨',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 16),
              const Text(
                'Perfect Mix!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9B59B6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.level.getSolution(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF7F8C8D),
                  fontWeight: FontWeight.w600,
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
                      backgroundColor: const Color(0xFF9B59B6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Mix Again',
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
  void _checkAnswer() {
    if (userAnswer == null) return;

    setState(() {
      isMixing = true;
      mascotMood = MascotMood.thinking;
    });

    // Animate mixing
    _mixAnimationController.forward().then((_) {
      // Check answer
      if (widget.level.checkAnswer(userAnswer!)) {
        _handleSuccess();
      } else {
        _handleFailure();
      }

      _mixAnimationController.reverse();
    });
  }

  void _handleSuccess() {
    setState(() {
      isSuccess = true;
      isMixing = false;
      mascotMood = MascotMood.excited;
    });

    // Trigger confetti
    _confettiController.play();

    // Animate result
    _resultAnimationController.forward();

    // Play success sound (if available)
    // _audioPlayer.play(AssetSource('sounds/success.mp3'));

    HapticFeedback.heavyImpact();
  }

  void _handleFailure() {
    setState(() {
      isMixing = false;
      mascotMood = MascotMood.sad;
    });

    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Not quite! Try again! The answer is ${widget.level.target}',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: const Color(0xFFF39C12),
        duration: const Duration(seconds: 3),
      ),
    );

    // Reset mood after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          mascotMood = MascotMood.idle;
        });
      }
    });
  }

  void _clearAnswer() {
    setState(() {
      userAnswer = null;
      _answerController.clear();
    });
    HapticFeedback.lightImpact();
  }

  void _playAgain() {
    // Generate new level
    final generator = PotionShopGenerator();
    final newLevel = generator.generateLevel(
      widget.level.difficulty,
      widget.profile,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PotionShopGame(
          level: newLevel,
          profile: widget.profile,
        ),
      ),
    );
  }
}
