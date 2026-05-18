import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/models/child_profile.dart';
import '../theme/smartino_colors.dart';
import '../theme/smartino_text_styles.dart';

/// Chapters tab - displays story-driven curriculum
/// Implements Requirements: 2.1, 2.2, 2.3 (Story-Driven Curriculum)
/// Note: Full chapter system to be implemented in future phases
class ChaptersTabView extends StatelessWidget {
  final ChildProfile profile;

  const ChaptersTabView({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: SmartinoColors.lavenderDream,
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    '📚 فصول المغامرة',
                    style: SmartinoTextStyles.heading1.copyWith(
                      color: Colors.white,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ساعد سمارتينو في مغامراته',
                    style: SmartinoTextStyles.body.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Chapters list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildChapterCard(
                    context: context,
                    chapterNumber: 1,
                    title: 'مدينة الألوان المفقودة',
                    description: 'ساعد سمارتينو يرجع الألوان للمدينة',
                    emoji: '🎨',
                    gradient: SmartinoColors.sunsetGlow,
                    isLocked: false,
                  ),
                  const SizedBox(height: 16),
                  _buildChapterCard(
                    context: context,
                    chapterNumber: 2,
                    title: 'حديقة الحيوانات الناطقة',
                    description: 'تعلم أسماء الحيوانات وأصواتها',
                    emoji: '🦁',
                    gradient: SmartinoColors.forestMist,
                    isLocked: true,
                  ),
                  const SizedBox(height: 16),
                  _buildChapterCard(
                    context: context,
                    chapterNumber: 3,
                    title: 'قلعة الأرقام السحرية',
                    description: 'اكتشف أسرار الأرقام والحساب',
                    emoji: '🔢',
                    gradient: SmartinoColors.oceanBreeze,
                    isLocked: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterCard({
    required BuildContext context,
    required int chapterNumber,
    required String title,
    required String description,
    required String emoji,
    required Gradient gradient,
    required bool isLocked,
  }) {
    return Opacity(
      opacity: isLocked ? 0.6 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
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
                ? null
                : () {
                    HapticFeedback.mediumImpact();
                    _showComingSoonDialog(context);
                  },
            borderRadius: BorderRadius.circular(32),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
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
                    emoji,
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
                                title,
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
                          description,
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
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        title: const Text(
          '🚀 قريباً',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28),
        ),
        content: const Text(
          'نظام الفصول الكامل سيكون متاح قريباً!\nحالياً يمكنك اللعب من تبويب الألعاب 🎮',
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
