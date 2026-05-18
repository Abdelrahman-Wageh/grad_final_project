import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/models/child_profile.dart';
import '../core/game/difficulty_level.dart';
import '../core/game/code_commander_generator.dart';
import '../core/game/story_weaver_generator.dart';
import '../core/game/potion_shop_generator.dart';
import '../theme/smartino_colors.dart';
import '../theme/smartino_text_styles.dart';
import '../widgets/smartino_button.dart';
import 'games/code_commander_game.dart';
import 'games/story_weaver_game.dart';
import 'games/potion_shop_game.dart';

/// Games tab - displays all 3 procedural games
/// Implements Requirements: 19.1, 20.1, 21.1 (Game UIs)
class GamesTabView extends StatelessWidget {
  final ChildProfile profile;

  const GamesTabView({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: SmartinoColors.magicalSky,
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
                    '🎮 ألعاب سمارتينو',
                    style: SmartinoTextStyles.heading1.copyWith(
                      color: Colors.white,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اختر لعبة وابدأ المغامرة!',
                    style: SmartinoTextStyles.body.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Games grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.count(
                  crossAxisCount: 1,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2.5,
                  children: [
                    _buildGameCard(
                      context: context,
                      title: 'قائد الأكواد',
                      subtitle: 'ساعد سمارتينو يوصل للبطارية',
                      emoji: '🤖',
                      gradient: SmartinoColors.sunsetGlow,
                      onTap: () => _startCodeCommander(context),
                    ),
                    _buildGameCard(
                      context: context,
                      title: 'نساج القصص',
                      subtitle: 'أكمل القصة بصوتك',
                      emoji: '📖',
                      gradient: SmartinoColors.oceanBreeze,
                      onTap: () => _startStoryWeaver(context),
                    ),
                    _buildGameCard(
                      context: context,
                      title: 'محل الجرعات',
                      subtitle: 'اخلط الجرعات واحسب الأرقام',
                      emoji: '🧪',
                      gradient: SmartinoColors.forestMist,
                      onTap: () => _startPotionShop(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String emoji,
    required Gradient gradient,
    required VoidCallback onTap,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // Emoji
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Text
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        style: SmartinoTextStyles.heading2.copyWith(
                          color: Colors.white,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: SmartinoTextStyles.body.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startCodeCommander(BuildContext context) async {
    // Generate level based on profile difficulty
    final generator = CodeCommanderGenerator();
    final level = generator.generateLevel(profile.currentDifficulty, profile);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CodeCommanderGame(
          level: level,
          profile: profile,
        ),
      ),
    );
  }

  void _startStoryWeaver(BuildContext context) async {
    // Generate level based on profile difficulty
    final generator = StoryWeaverGenerator();
    final level = await generator.generateLevel(profile.currentDifficulty, profile);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StoryWeaverGame(
          level: level,
          profile: profile,
        ),
      ),
    );
  }

  void _startPotionShop(BuildContext context) async {
    // Generate level based on profile difficulty
    final generator = PotionShopGenerator();
    final level = generator.generateLevel(profile.currentDifficulty, profile);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PotionShopGame(
          level: level,
          profile: profile,
        ),
      ),
    );
  }
}
