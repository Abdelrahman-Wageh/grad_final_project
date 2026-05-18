/// Smartino Super-App - Journey Map Screen
/// Visual learning path with stages and progression
/// Requirements: 1.3, 1.4, 1.5, 2.1

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as legacy_provider;
import '../core/game/progression_manager.dart';
import '../data/curriculum/curriculum_data.dart';
import '../widgets/character/farfour_widget.dart';
import '../core/character/farfour_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JourneyMapScreen extends ConsumerStatefulWidget {
  final String profileId;
  
  const JourneyMapScreen({
    super.key,
    required this.profileId,
  });

  @override
  ConsumerState<JourneyMapScreen> createState() => _JourneyMapScreenState();
}

class _JourneyMapScreenState extends ConsumerState<JourneyMapScreen> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final progressionManager = legacy_provider.Provider.of<ProgressionManager>(context);
    final overallCompletion = progressionManager.getOverallCompletionPercentage();
    final totalStars = progressionManager.getTotalStarsEarned();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // Beige background
      appBar: AppBar(
        title: const Text(
          'رحلة التعلم',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '$totalStars',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Progress header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF2196F3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'التقدم الكلي: ${overallCompletion.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: overallCompletion / 100,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Journey map
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: CurriculumData.chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = CurriculumData.chapters[index];
                    final chapterCompletion = progressionManager.getChapterCompletion(chapter.id);
                    
                    return _buildChapterCard(
                      context,
                      chapter,
                      chapterCompletion,
                      progressionManager,
                    );
                  },
                ),
              ),
            ],
          ),
          
          // Farfour overlay
          const FarfourOverlay(alignment: Alignment.bottomRight),
        ],
      ),
    );
  }
  
  Widget _buildChapterCard(
    BuildContext context,
    Chapter chapter,
    double completion,
    ProgressionManager progressionManager,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              _getChapterColor(chapter.id),
              _getChapterColor(chapter.id).withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Chapter header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        chapter.icon,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter.titleAr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chapter.titleEn,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: LinearProgressIndicator(
                            value: completion,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Stages
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: chapter.stages.map((stage) {
                  return _buildStageItem(
                    context,
                    chapter,
                    stage,
                    progressionManager,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStageItem(
    BuildContext context,
    Chapter chapter,
    Stage stage,
    ProgressionManager progressionManager,
  ) {
    final progress = progressionManager.getStageProgress(stage.id);
    final isUnlocked = progressionManager.isStageUnlocked(chapter.id, stage.stageNumber);
    final isCompleted = progress != null && progress.isCompleted;
    final stars = progress?.bestStars ?? 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: isUnlocked ? () => _onStageSelected(context, stage) : null,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Stage icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isUnlocked 
                        ? (isCompleted ? Colors.green : Colors.blue)
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: isUnlocked
                        ? (isCompleted
                            ? const Icon(Icons.check, color: Colors.white, size: 28)
                            : const Icon(Icons.play_arrow, color: Colors.white, size: 28))
                        : const Icon(Icons.lock, color: Colors.white, size: 28),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Stage info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stage.titleAr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? Colors.black87 : Colors.grey,
                        ),
                      ),
                      if (isCompleted) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: List.generate(3, (index) {
                            return Icon(
                              index < stars ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            );
                          }),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Arrow
                if (isUnlocked)
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _onStageSelected(BuildContext context, Stage stage) {
    // Farfour encouragement
    ref.read(farfourControllerProvider.notifier).encourage();
    
    // Navigate to game
    Navigator.pushNamed(
      context,
      '/game',
      arguments: {
        'stageId': stage.id,
        'gameType': stage.gameType,
        'profileId': widget.profileId,
      },
    );
  }
  
  Color _getChapterColor(String chapterId) {
    switch (chapterId) {
      case 'chapter_1':
        return const Color(0xFF4CAF50); // Green
      case 'chapter_2':
        return const Color(0xFF2196F3); // Blue
      case 'chapter_3':
        return const Color(0xFFFF9800); // Orange
      case 'chapter_4':
        return const Color(0xFF9C27B0); // Purple
      case 'chapter_5':
        return const Color(0xFFF44336); // Red
      case 'chapter_6':
        return const Color(0xFF00BCD4); // Cyan
      case 'chapter_7':
        return const Color(0xFFFFEB3B); // Yellow
      case 'chapter_8':
        return const Color(0xFF795548); // Brown
      default:
        return const Color(0xFF607D8B); // Blue Grey
    }
  }
}
