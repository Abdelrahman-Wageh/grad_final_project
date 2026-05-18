/// Games Screen
/// 
/// Displays all available games for the user to select and play.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/smartino_colors.dart';
import '../theme/smartino_typography.dart';
import '../widgets/common/smartino_card.dart';
import '../features/games/game_registry.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              SmartinoColors.primary,
              SmartinoColors.accent,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildGameGrid(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الألعاب',
                style: SmartinoTypography.displaySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'اختار لعبة وابدأ التعلم',
                style: SmartinoTypography.bodyLarge.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildGameGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: GameRegistry.allGames.length,
      itemBuilder: (context, index) {
        return _buildGameCard(context, GameRegistry.allGames[index], index);
      },
    );
  }

  Widget _buildGameCard(BuildContext context, GameInfo game, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GameRegistry.createGameByType(
              game.type,
              'demo_stage',
              game.targetLetters,
              game.targetScore,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _getGameColor(index).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                game.icon,
                size: 40,
                color: _getGameColor(index),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                game.nameAr,
                style: SmartinoTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                game.description,
                style: SmartinoTypography.bodySmall.copyWith(
                  color: SmartinoColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ).animate().scale(
        delay: (index * 100).ms,
        duration: 300.ms,
      ),
    );
  }

  Color _getGameColor(int index) {
    final colors = [
      SmartinoColors.primary,
      SmartinoColors.accent,
      SmartinoColors.success,
      SmartinoColors.warning,
      SmartinoColors.error,
    ];
    return colors[index % colors.length];
  }
}
