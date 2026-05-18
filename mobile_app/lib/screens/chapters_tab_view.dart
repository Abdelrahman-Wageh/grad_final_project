import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../data/models/child_profile.dart';
import '../core/game/progression_manager.dart';
import '../data/curriculum/curriculum_data.dart';
import '../theme/smartino_colors.dart';
import '../theme/smartino_text_styles.dart';
import 'journey_map_screen.dart';

/// Chapters tab - displays story-driven curriculum with actual progression
/// Implements Requirements: 2.1, 2.2, 2.3 (Story-Driven Curriculum)
class ChaptersTabView extends StatelessWidget {
  final ChildProfile profile;

  const ChaptersTabView({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final progressionManager = Provider.of<ProgressionManager>(context);
    final stats = progressionManager.getStatistics();
    
    return Container(
      decoration: BoxDecoration(
        gradient: SmartinoColors.lavenderDream,
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Header with progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    '📖 حواديت فرفور',
                    style: SmartinoTextStyles.heading1.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اكتشف سحر الحروف مع فرفور الذكي',
                    style: SmartinoTextStyles.body.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 16),
                  // Progress summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('🌟', '${stats['totalStars'] ?? 0}', 'نجوم'),
                        _buildStatItem('📖', '${stats['completedStages'] ?? 0}', 'حدوتة'),
                        _buildStatItem('🦸', '${((stats['overallCompletion'] ?? 0.0) * 100).toStringAsFixed(0)}%', 'بطل'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Chapters list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: CurriculumData.chapters.length,
                itemBuilder: (context, index) {
                  final chapter = CurriculumData.chapters[index];
                  final chapterProgress = progressionManager.getChapterProgress(chapter.id);
                  final isUnlocked = progressionManager.isChapterUnlocked(chapter.id);
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildChapterCard(
                      context: context,
                      chapter: chapter,
                      chapterNumber: index + 1,
                      progress: chapterProgress,
                      isLocked: !isUnlocked,
                      progressionManager: progressionManager,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: SmartinoTextStyles.heading2.copyWith(
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: SmartinoTextStyles.caption.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildChapterCard({
    required BuildContext context,
    required Chapter chapter,
    required int chapterNumber,
    required double progress,
    required bool isLocked,
    required ProgressionManager progressionManager,
  }) {
    final completedStages = (progress * chapter.stages.length).round();
    final totalStages = chapter.stages.length;
    
    return Opacity(
      opacity: isLocked ? 0.6 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          gradient: _getChapterGradient(chapterNumber),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLocked
                ? () => _showLockedDialog(context)
                : () => _openChapter(context, chapter, progressionManager),
            borderRadius: BorderRadius.circular(32),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      // Chapter number badge
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$chapterNumber',
                            style: SmartinoTextStyles.heading1.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Emoji
                      Text(
                        chapter.emoji,
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(width: 16),
                      // Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (isLocked)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                Flexible(
                                  child: Text(
                                    chapter.titleAr,
                                    style: SmartinoTextStyles.heading2.copyWith(
                                      color: Colors.white,
                                    ),
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              chapter.descriptionAr,
                              style: SmartinoTextStyles.body.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!isLocked) ...[
                    const SizedBox(height: 16),
                    // Progress bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$completedStages / $totalStages أجزاء الحدوتة',
                          style: SmartinoTextStyles.caption.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            minHeight: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Gradient _getChapterGradient(int chapterNumber) {
    switch (chapterNumber % 5) {
      case 1:
        return SmartinoColors.sunsetGlow;
      case 2:
        return SmartinoColors.forestMist;
      case 3:
        return SmartinoColors.oceanBreeze;
      case 4:
        return SmartinoColors.lavenderDream;
      default:
        return SmartinoColors.sunsetGradient;
    }
  }

  void _openChapter(BuildContext context, Chapter chapter, ProgressionManager progressionManager) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JourneyMapScreen(
          profileId: profile.id,
        ),
      ),
    );
  }

  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        title: const Text(
          '🔒 مقفول',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28),
        ),
        content: const Text(
          'أكمل الفصول السابقة لفتح هذا الفصل!',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'حسناً',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
