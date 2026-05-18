import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../core/game/story_weaver_level.dart';
import '../../core/game/story_weaver_generator.dart';
import '../../core/game/difficulty_level.dart';
import '../../data/models/child_profile.dart';
import '../../widgets/smartino_mascot_placeholder.dart';
import '../../utils/fuzzy_matcher.dart';

/// Story Weaver Game - NLU & Creativity
/// Requirements: 20.1, 20.2, 20.3, 20.4
class StoryWeaverGame extends StatefulWidget {
  final StoryWeaverLevel level;
  final ChildProfile profile;

  const StoryWeaverGame({
    super.key,
    required this.level,
    required this.profile,
  });

  @override
  State<StoryWeaverGame> createState() => _StoryWeaverGameState();
}

class _StoryWeaverGameState extends State<StoryWeaverGame>
    with SingleTickerProviderStateMixin {
  // Game state
  String userAnswer = '';
  bool isListening = false;
  bool isSuccess = false;
  bool showCompletedStory = false;
  MascotMood mascotMood = MascotMood.idle;
  final TextEditingController _textController = TextEditingController();

  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Celebration
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Setup confetti
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // Start fade animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    _textController.dispose();
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

                // Story display
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Story text
                        _buildStoryDisplay(),

                        const SizedBox(height: 40),

                        // Input section
                        if (!showCompletedStory) _buildInputSection(),

                        // Completed story
                        if (showCompletedStory) _buildCompletedStory(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Action buttons
                if (!showCompletedStory) _buildActionButtons(),

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
            if (isSuccess && !showCompletedStory) _buildSuccessOverlay(),
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
                  'Story Weaver',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  'Category: ${widget.level.category}',
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

  Widget _buildStoryDisplay() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
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
            // Story icon
            const Text(
              '📖',
              style: TextStyle(fontSize: 48),
            ),

            const SizedBox(height: 16),

            // Story text
            _buildStoryText(),

            // Arabic story (if bilingual)
            if (widget.level.isBilingual && widget.level.storyArabic != null)
              ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _buildStoryTextArabic(),
              ],
          ],
        ),
      ),
    );
  }

  Widget _buildStoryText() {
    final parts = widget.level.story.split('[BLANK]');

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 24,
          height: 1.5,
          color: Color(0xFF2C3E50),
        ),
        children: [
          TextSpan(text: parts[0]),
          WidgetSpan(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF39C12).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFF39C12),
                  width: 2,
                ),
              ),
              child: Text(
                userAnswer.isEmpty ? '____' : userAnswer,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF39C12),
                ),
              ),
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }

  Widget _buildStoryTextArabic() {
    final parts = widget.level.storyArabic!.split('[BLANK]');

    return RichText(
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 22,
          height: 1.5,
          color: Color(0xFF7F8C8D),
        ),
        children: [
          TextSpan(text: parts[0]),
          WidgetSpan(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF9B59B6).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF9B59B6),
                  width: 2,
                ),
              ),
              child: Text(
                userAnswer.isEmpty ? '____' : userAnswer,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9B59B6),
                ),
              ),
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: Column(
        children: [
          // Text input
          TextField(
            controller: _textController,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: 'Type your answer...',
              hintStyle: TextStyle(
                fontSize: 18,
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
                userAnswer = value;
              });
            },
            onSubmitted: (_) => _checkAnswer(),
          ),

          const SizedBox(height: 16),

          // Voice input button
          ElevatedButton.icon(
            onPressed: _startVoiceInput,
            icon: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              size: 28,
            ),
            label: Text(
              isListening ? 'Listening...' : 'Speak Your Answer',
              style: const TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isListening ? const Color(0xFFE74C3C) : const Color(0xFF9B59B6),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedStory() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              '✨',
              style: TextStyle(fontSize: 48),
            ),

            const SizedBox(height: 16),

            Text(
              widget.level.getCompletedStory(userAnswer),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                height: 1.5,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (widget.level.isBilingual &&
                widget.level.storyArabic != null) ...[
              const SizedBox(height: 16),
              const Divider(color: Colors.white54),
              const SizedBox(height: 16),
              Text(
                widget.level.getCompletedStoryArabic(userAnswer) ?? '',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 22,
                  height: 1.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _playAgain,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF27AE60),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Tell Another Story',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
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
              onPressed: userAnswer.isEmpty ? null : _clearAnswer,
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

          // Check button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: userAnswer.isEmpty ? null : _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27AE60),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Check Answer',
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
                '🎉',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 16),
              const Text(
                'Perfect!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF27AE60),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Great creativity!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF7F8C8D),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _continueStory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3498DB),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue Story',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Game logic methods
  void _startVoiceInput() {
    setState(() {
      isListening = !isListening;
      mascotMood = isListening ? MascotMood.listening : MascotMood.idle;
    });

    HapticFeedback.mediumImpact();

    // TODO: Integrate with LocalAIService for STT
    // For now, show message
    if (isListening) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voice input coming soon! Use text input for now.'),
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            isListening = false;
            mascotMood = MascotMood.idle;
          });
        }
      });
    }
  }

  void _checkAnswer() {
    if (userAnswer.isEmpty) return;

    setState(() {
      mascotMood = MascotMood.thinking;
    });

    // Requirement 20.2: Fuzzy matching validation
    final isCorrect = FuzzyMatcher.matches(
      userAnswer,
      widget.level.correctAnswer,
      tolerance: 2,
    );

    // Also check acceptable answers
    final isAcceptable = widget.level.acceptableAnswers.any(
      (answer) => FuzzyMatcher.matches(userAnswer, answer, tolerance: 2),
    );

    if (isCorrect || isAcceptable) {
      _handleSuccess();
    } else {
      _handleFailure();
    }
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

  void _handleFailure() {
    setState(() {
      mascotMood = MascotMood.sad;
    });

    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'So close! Try "${widget.level.correctAnswer}" or something similar!',
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

  void _continueStory() {
    setState(() {
      isSuccess = false;
      showCompletedStory = true;
      mascotMood = MascotMood.happy;
    });

    _animationController.reset();
    _animationController.forward();
  }

  void _clearAnswer() {
    setState(() {
      userAnswer = '';
      _textController.clear();
    });
    HapticFeedback.lightImpact();
  }

  void _playAgain() async {
    // Generate new level
    final generator = StoryWeaverGenerator();
    final newLevel = await generator.generateLevel(
      widget.level.difficulty,
      widget.profile,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => StoryWeaverGame(
          level: newLevel,
          profile: widget.profile,
        ),
      ),
    );
  }
}
