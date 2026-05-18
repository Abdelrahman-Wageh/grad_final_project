import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../services/ai_service.dart';
import '../services/game_service.dart';
import '../services/storage_service.dart';
import '../utils/app_constants.dart';
import '../utils/game_messages.dart';
import '../widgets/voice_button.dart';
import '../widgets/game_world.dart';
import '../widgets/character_animation.dart';
import '../widgets/progress_indicator.dart';
import 'parent_dashboard.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late AnimationController _characterController;
  late AnimationController _worldController;
  late AnimationController _backgroundController;
  
  @override
  void initState() {
    super.initState();
    _characterController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );
    _worldController = AnimationController(
      duration: AppConstants.longAnimation,
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    final gameService = Provider.of<GameService>(context, listen: false);
    gameService.initializeGame();
    
    // Start character animation
    _characterController.repeat();
    _worldController.forward();
  }

  @override
  void dispose() {
    _characterController.dispose();
    _worldController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  Future<void> _handleVoiceInteraction() async {
    final aiService = Provider.of<AIService>(context, listen: false);
    final gameService = Provider.of<GameService>(context, listen: false);
    final storageService = Provider.of<StorageService>(context, listen: false);
    
    try {
      // Start recording
      await aiService.startRecording();
      
      // Show listening animation
      _characterController.stop();
      _characterController.forward();
      
      // Wait for user to speak
      await Future.delayed(const Duration(seconds: 3));
      
      // Stop recording
      final audioPath = await aiService.stopRecording();
      if (audioPath == null) return;
      
      // Process the voice input
      final log = await aiService.processVoiceInput(
        audioPath: audioPath,
        gameProgress: gameService.currentProgress,
      );
      
      // Save interaction log
      await storageService.saveInteractionLog(log);
      
      // Play AI response if available
      if (log.aiResponse != null && log.metadata['responseAudioPath'] != null) {
        await aiService.playResponse(log.metadata['responseAudioPath']);
      }
      
      // Update game state based on interaction
      _updateGameStateFromInteraction(log);
      
    } catch (e) {
      _showErrorDialog('Error processing voice input: $e');
    }
  }

  void _updateGameStateFromInteraction(interactionLog) {
    final gameService = Provider.of<GameService>(context, listen: false);
    
    // Simple state machine logic based on interaction
    if (interactionLog.success && interactionLog.aiResponse != null) {
      // Check if objective was completed
      final response = interactionLog.aiResponse!.toLowerCase();
      final currentObjective = gameService.getCurrentObjective().toLowerCase();
      
      if (response.contains('ممتاز') || response.contains('excellent')) {
        gameService.completeObjective(gameService.getCurrentObjective());
        _showSuccessAnimation();
      } else if (response.contains('مساعدة') || response.contains('help')) {
        gameService.incrementHints();
      }
    }
    
    gameService.incrementAttempts();
  }

  void _showSuccessAnimation() {
    // Show celebration animation
    _characterController.stop();
    _characterController.forward();
    
    // Show success message with emoji
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🎉 ', style: TextStyle(fontSize: 24)),
            Text('ممتاز! أنت ذكي جداً!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(' 🎉', style: TextStyle(fontSize: 24)),
          ],
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: AppConstants.successColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Row(
          children: [
            Text('⚠️ '),
            Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    AppConstants.forestGreen,
                    AppConstants.oceanBlue,
                    _backgroundController.value,
                  )!,
                  Color.lerp(
                    AppConstants.oceanBlue,
                    AppConstants.castlePurple,
                    _backgroundController.value,
                  )!,
                  Color.lerp(
                    AppConstants.castlePurple,
                    AppConstants.candyPink,
                    _backgroundController.value,
                  )!,
                ],
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar with Progress and Parent Access
              _buildTopBar(),
              
              // Game World
              Expanded(
                child: Stack(
                  children: [
                    // Background Game World
                    GameWorld(
                      controller: _worldController,
                      gameState: context.watch<GameService>().currentProgress.currentState,
                    ),
                    
                    // Character Animation
                    Positioned(
                      bottom: 120,
                      left: 0,
                      right: 0,
                      child: CharacterAnimation(
                        controller: _characterController,
                        isProcessing: context.watch<AIService>().isProcessing,
                        isRecording: context.watch<AIService>().isRecording,
                      ),
                    ),
                    
                    // Voice Interaction Button with Fun Animation
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: VoiceButton(
                        onPressed: _handleVoiceInteraction,
                        isRecording: context.watch<AIService>().isRecording,
                        isProcessing: context.watch<AIService>().isProcessing,
                      )
                          .animate(onPlay: (controller) => controller.repeat())
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.05, 1.05),
                            duration: 1500.ms,
                            curve: Curves.easeInOut,
                          )
                          .then()
                          .scale(
                            begin: const Offset(1.05, 1.05),
                            end: const Offset(1, 1),
                            duration: 1500.ms,
                            curve: Curves.easeInOut,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Progress Indicator
          Expanded(
            child: GameProgressIndicator(
              progress: context.watch<GameService>().getCompletionPercentage(),
              currentObjective: context.watch<GameService>().getCurrentObjective(),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Parent Dashboard Access Button
          GestureDetector(
            onTap: () => _showParentAccessDialog(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 28,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  duration: 2000.ms,
                  color: Colors.white.withOpacity(0.5),
                ),
          ),
        ],
      ),
    );
  }

  void _showParentAccessDialog() {
    showDialog(
      context: context,
      builder: (context) => ParentAccessDialog(
        onSuccess: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ParentDashboard()),
          );
        },
      ),
    );
  }
}

class ParentAccessDialog extends StatefulWidget {
  final VoidCallback onSuccess;

  const ParentAccessDialog({
    super.key,
    required this.onSuccess,
  });

  @override
  State<ParentAccessDialog> createState() => _ParentAccessDialogState();
}

class _ParentAccessDialogState extends State<ParentAccessDialog> {
  final TextEditingController _pinController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🔒 '),
          Text('Parent Access', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter PIN to access parent dashboard:', textAlign: TextAlign.center),
          const SizedBox(height: 20),
          TextField(
            controller: _pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, letterSpacing: 8),
            decoration: InputDecoration(
              labelText: 'PIN',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _verifyPin,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: _isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Access'),
        ),
      ],
    );
  }

  Future<void> _verifyPin() async {
    setState(() => _isLoading = true);
    
    try {
      final storageService = Provider.of<StorageService>(context, listen: false);
      final isValid = await storageService.verifyParentPin(_pinController.text);
      
      if (isValid) {
        widget.onSuccess();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('❌ '),
                Text('Invalid PIN'),
              ],
            ),
            backgroundColor: AppConstants.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppConstants.errorColor,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
}
