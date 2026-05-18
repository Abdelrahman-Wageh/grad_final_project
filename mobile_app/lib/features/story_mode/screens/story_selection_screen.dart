/// Smartino Super-App - Story Selection Screen
/// Browse and select Egyptian stories to play
/// Requirements: 2.3, 2.4

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as legacy_provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/story.dart';
import '../story_generator.dart';
import 'story_player_screen.dart';
import '../../../widgets/character/farfour_widget.dart';
import '../../../core/character/farfour_controller.dart';

class StorySelectionScreen extends ConsumerStatefulWidget {
  final String profileId;
  
  const StorySelectionScreen({
    super.key,
    required this.profileId,
  });

  @override
  ConsumerState<StorySelectionScreen> createState() => _StorySelectionScreenState();
}

class _StorySelectionScreenState extends ConsumerState<StorySelectionScreen> {
  bool _isGenerating = false;
  
  // Egyptian story templates
  static final List<Story> egyptianStoryTemplates = [
    Story(
      id: 'story_1',
      titleAr: 'مغامرة في الأهرامات',
      titleEn: 'Pyramids Adventure',
      theme: 'ألوان',
      segments: [
        StorySegment(
          textAr: 'كان يا مكان، في قديم الزمان، طفل اسمه أحمد راح يزور الأهرامات...',
          textEn: 'Once upon a time, a child named Ahmed visited the pyramids...',
        ),
      ],
    ),
    Story(
      id: 'story_2',
      titleAr: 'رحلة النيل',
      titleEn: 'Nile Journey',
      theme: 'أرقام',
      segments: [
        StorySegment(
          textAr: 'في يوم جميل، ركب فرفور مركب في النيل...',
          textEn: 'On a beautiful day, Farfour rode a boat on the Nile...',
        ),
      ],
    ),
    Story(
      id: 'story_3',
      titleAr: 'سوق الخان',
      titleEn: 'Khan Market',
      theme: 'حروف',
      segments: [
        StorySegment(
          textAr: 'في سوق الخان الكبير، كان فيه محلات كتير...',
          textEn: 'In the big Khan market, there were many shops...',
        ),
      ],
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    // Farfour greets when entering story mode
    Future.delayed(const Duration(milliseconds: 500), () {
      ref.read(farfourControllerProvider.notifier).speak(
        'اهلاً! اختار قصة عشان نبدأ المغامرة! 📚',
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // Beige background
      appBar: AppBar(
        title: const Text(
          'قصص فرفور',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF9C27B0), // Purple
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF9C27B0),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: const Column(
                  children: [
                    Text(
                      'اختار قصة مصرية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'كل قصة فيها مغامرة جديدة!',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Story cards
              Expanded(
                child: _isGenerating
                    ? _buildLoadingView()
                    : _buildStoryGrid(),
              ),
            ],
          ),
          
          // Farfour overlay
          const FarfourOverlay(alignment: Alignment.bottomRight),
        ],
      ),
    );
  }
  
  Widget _buildStoryGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: egyptianStoryTemplates.length,
      itemBuilder: (context, index) {
        final template = egyptianStoryTemplates[index];
        return _buildStoryCard(template);
      },
    );
  }
  
  Widget _buildStoryCard(Story template) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () => _onStorySelected(template),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                _getStoryColor(template.theme),
                _getStoryColor(template.theme).withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    _getStoryIcon(template.theme),
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  template.titleAr, // Use titleAr instead of title
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              
              // Theme badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  template.theme,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9C27B0)),
          ),
          const SizedBox(height: 20),
          const Text(
            'فرفور بيجهز القصة...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9C27B0),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'استنى شوية! 🎨',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
  
  void _onStorySelected(Story template) async {
    // Farfour excitement
    ref.read(farfourControllerProvider.notifier).celebrate();
    
    setState(() {
      _isGenerating = true;
    });
    
    try {
      // Get story generator
      final storyGenerator = legacy_provider.Provider.of<StoryGenerator>(context, listen: false);
      
      // Generate story based on template
      final story = await storyGenerator.generateGameRelatedStory(
        gameName: template.theme,
        difficulty: 'easy',
      );
      
      setState(() {
        _isGenerating = false;
      });
      
      // Navigate to story player
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StoryPlayerScreen(story: story),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });
      
      // Show error and use template as fallback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('هنستخدم القصة الجاهزة! 📖'),
            backgroundColor: Colors.orange,
          ),
        );
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StoryPlayerScreen(story: template),
          ),
        );
      }
    }
  }
  
  Color _getStoryColor(String theme) {
    switch (theme.toLowerCase()) {
      case 'colors':
      case 'ألوان':
        return const Color(0xFFFF5722); // Deep Orange
      case 'numbers':
      case 'أرقام':
        return const Color(0xFF2196F3); // Blue
      case 'letters':
      case 'حروف':
        return const Color(0xFF4CAF50); // Green
      case 'shapes':
      case 'أشكال':
        return const Color(0xFF9C27B0); // Purple
      case 'maze':
      case 'متاهة':
        return const Color(0xFFFF9800); // Orange
      default:
        return const Color(0xFF607D8B); // Blue Grey
    }
  }
  
  String _getStoryIcon(String theme) {
    switch (theme.toLowerCase()) {
      case 'colors':
      case 'ألوان':
        return '🎨';
      case 'numbers':
      case 'أرقام':
        return '🔢';
      case 'letters':
      case 'حروف':
        return '📝';
      case 'shapes':
      case 'أشكال':
        return '🔷';
      case 'maze':
      case 'متاهة':
        return '🗺️';
      default:
        return '📚';
    }
  }
}
