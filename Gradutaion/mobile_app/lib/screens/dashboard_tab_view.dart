import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/models/child_profile.dart';
import '../theme/smartino_colors.dart';
import '../theme/smartino_text_styles.dart';

/// Dashboard tab - displays child's progress and achievements
/// Implements Requirements: 7.4, 7.5 (Progress Display)
class DashboardTabView extends StatelessWidget {
  final ChildProfile profile;

  const DashboardTabView({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: SmartinoColors.sunsetGlow,
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
                    '⭐ لوحتي',
                    style: SmartinoTextStyles.heading1.copyWith(
                      color: Colors.white,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'مرحباً ${profile.name}! 👋',
                    style: SmartinoTextStyles.heading2.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Stats
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildStatCard(
                    title: 'النجوم المكتسبة',
                    value: '${profile.totalStars}',
                    emoji: '⭐',
                    gradient: SmartinoColors.sunsetGlow,
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    title: 'الكنوز المفتوحة',
                    value: '${profile.unlockedItems.length}',
                    emoji: '🎁',
                    gradient: SmartinoColors.lavenderDream,
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    title: 'المفاهيم المتقنة',
                    value: '${profile.masteredConcepts.length}',
                    emoji: '🧠',
                    gradient: SmartinoColors.oceanBreeze,
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    title: 'وقت اللعب',
                    value: '${(profile.totalPlayTimeMinutes / 60).toStringAsFixed(1)} ساعة',
                    emoji: '⏱️',
                    gradient: SmartinoColors.forestMist,
                  ),
                  const SizedBox(height: 32),
                  // Achievements section
                  _buildAchievementsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String emoji,
    required Gradient gradient,
  }) {
    return Container(
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
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Emoji
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: SmartinoTextStyles.body.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: SmartinoTextStyles.heading1.copyWith(
                    color: Colors.white,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            '🏆 الإنجازات',
            style: SmartinoTextStyles.heading2.copyWith(
              color: SmartinoColors.purple,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 16),
          if (profile.unlockedItems.isEmpty)
            Text(
              'ابدأ اللعب لفتح الإنجازات!',
              style: SmartinoTextStyles.body.copyWith(
                color: Colors.grey,
              ),
              textDirection: TextDirection.rtl,
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: profile.unlockedItems.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: SmartinoColors.magicalSky,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item,
                    style: SmartinoTextStyles.body.copyWith(
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
