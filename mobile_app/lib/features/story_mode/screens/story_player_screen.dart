import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart' as provider;
import '../models/story.dart';
import '../../../widgets/character/farfour_widget.dart';
import '../../../core/character/farfour_controller.dart';
import '../../../services/ai/elevenlabs_service.dart';
import '../../../services/sound_manager.dart';
import '../../../theme/smartino_colors.dart';

class StoryPlayerScreen extends ConsumerStatefulWidget {
  final Story story;
  
  const StoryPlayerScreen({
    super.key,
    required this.story,
  });
  
  @override
  ConsumerState<StoryPlayerScreen> createState() => _StoryPlayerScreenState();
}

class _StoryPlayerScreenState extends ConsumerState<StoryPlayerScreen> {
  int _currentSegmentIndex = 0;
  bool _isNarrating = false;
  bool _showChoices = false;
  bool _isGeneratingTTS = false;
  
  @override
  void initState() {
    super.initState();
    _startNarration();
  }
  
  Future<void> _startNarration() async {
    final elevenLabs = provider.Provider.of<ElevenLabsService>(context, listen: false);
    final soundManager = provider.Provider.of<SoundManager>(context, listen: false);
    final segment = widget.story.segments[_currentSegmentIndex];

    setState(() {
      _isNarrating = true;
      _isGeneratingTTS = true;
    });
    
    // Set Farfour to talking mood
    ref.read(farfourControllerProvider.notifier).startTalking();
    
    try {
      // Generate TTS using ElevenLabs
      final audioPath = await elevenLabs.textToSpeech(segment.textAr);
      
      if (mounted) {
        setState(() => _isGeneratingTTS = false);
        
        if (audioPath != null) {
          // Play narrated audio
          await soundManager.playLocalFile(audioPath);
        }
        
        // Wait for narration to finish (simulated for now, ideally use onPlayerComplete)
        final duration = segment.textAr.length * 100; // rough estimate: 100ms per character
        await Future.delayed(Duration(milliseconds: duration.clamp(2000, 10000)));
        
        if (mounted) {
          setState(() => _isNarrating = false);
          ref.read(farfourControllerProvider.notifier).stopTalking();
          
          // Show choices if available
          if (segment.choices != null && segment.choices!.isNotEmpty) {
            setState(() => _showChoices = true);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isNarrating = false;
          _isGeneratingTTS = false;
        });
        ref.read(farfourControllerProvider.notifier).stopTalking();
      }
      debugPrint('❌ Narration error: $e');
    }
  }
  
  void _nextSegment() {
    if (_currentSegmentIndex < widget.story.segments.length - 1) {
      setState(() {
        _currentSegmentIndex++;
        _showChoices = false;
      });
      _startNarration();
    } else {
      _completeStory();
    }
  }
  
  void _handleChoice(StoryChoice choice) {
    // Farfour celebrates the choice
    ref.read(farfourControllerProvider.notifier).celebrate();
    
    setState(() {
      _currentSegmentIndex = choice.nextSegmentIndex;
      _showChoices = false;
    });
    _startNarration();
  }
  
  void _completeStory() {
    // Farfour celebrates completion
    ref.read(farfourControllerProvider.notifier).celebrate();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 برافو!'),
        content: const Text('أنت أنهيت الحدوتة! أنت شاطر جداً!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('تمام'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final segment = widget.story.segments[_currentSegmentIndex];
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: SafeArea(
        child: Stack(
          children: [
            // Background
            _buildBackground(),
            
            // Content
            Column(
              children: [
                // Header
                _buildHeader(),
                
                // Story content
                Expanded(
                  child: _buildStoryContent(segment),
                ),
                
                // Navigation
                _buildNavigation(segment),
              ],
            ),
            
            // Farfour overlay
            const FarfourOverlay(alignment: Alignment.topRight),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF2196F3).withOpacity(0.1),
            const Color(0xFFF5F5DC),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.story.titleAr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: (_currentSegmentIndex + 1) / widget.story.segments.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStoryContent(StorySegment segment) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Story text
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Text(
              segment.textAr,
              style: const TextStyle(
                fontSize: 20,
                height: 1.8,
              ),
              textAlign: TextAlign.center,
            ),
          ).animate()
            .fadeIn(duration: 500.ms)
            .scale(begin: const Offset(0.9, 0.9)),
          
          if (_isGeneratingTTS)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: CircularProgressIndicator(),
            ),
          
          const SizedBox(height: 32),
          
          // Choices (if available)
          if (_showChoices && segment.choices != null)
            _buildChoices(segment.choices!),
        ],
      ),
    );
  }
  
  Widget _buildChoices(List<StoryChoice> choices) {
    return Column(
      children: [
        const Text(
          'اختار إيه اللي عايز تعمله:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2196F3),
          ),
        ),
        const SizedBox(height: 16),
        ...choices.map((choice) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ElevatedButton(
            onPressed: () => _handleChoice(choice),
            style: ElevatedButton.styleFrom(
              backgroundColor: SmartinoColors.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              choice.textAr,
              style: const TextStyle(fontSize: 16),
            ),
          ).animate()
            .fadeIn(delay: (choices.indexOf(choice) * 200).ms)
            .slideX(begin: -0.2),
        )),
      ],
    );
  }
  
  Widget _buildNavigation(StorySegment segment) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          if (_currentSegmentIndex > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  _currentSegmentIndex--;
                  _showChoices = false;
                });
              },
            )
          else
            const SizedBox(width: 48),
          
          // Play/Pause narration
          FloatingActionButton(
            onPressed: _isNarrating ? null : _startNarration,
            backgroundColor: const Color(0xFF2196F3),
            child: Icon(
              _isNarrating ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
          
          // Next button
          if (!_showChoices && _currentSegmentIndex < widget.story.segments.length - 1)
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: _nextSegment,
            )
          else if (_currentSegmentIndex == widget.story.segments.length - 1)
            ElevatedButton(
              onPressed: _completeStory,
              style: ElevatedButton.styleFrom(
                backgroundColor: SmartinoColors.success,
              ),
              child: const Text('خلصت! 🎉'),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}
