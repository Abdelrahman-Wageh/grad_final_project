import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/game_service.dart';
import '../utils/app_constants.dart';

class GameProgressIndicator extends StatelessWidget {
  final int progress;
  final String currentObjective;

  const GameProgressIndicator({
    super.key,
    required this.progress,
    required this.currentObjective,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Header
          Row(
            children: [
              const Icon(
                Icons.star,
                color: AppConstants.warningColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'التقدم',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              const Spacer(),
              Text(
                '$progress%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppConstants.backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress / 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppConstants.primaryColor,
                      AppConstants.secondaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Current Objective
          Row(
            children: [
              const Icon(
                Icons.flag,
                color: AppConstants.successColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  currentObjective,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppConstants.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Game Statistics
          _buildGameStats(context),
        ],
      ),
    );
  }

  Widget _buildGameStats(BuildContext context) {
    final gameService = Provider.of<GameService>(context, listen: false);
    final stats = gameService.getGameStatistics();
    
    return Row(
      children: [
        _buildStatItem(
          icon: Icons.trending_up,
          label: 'النقاط',
          value: '${stats['score']}',
          color: AppConstants.warningColor,
        ),
        const SizedBox(width: 16),
        _buildStatItem(
          icon: Icons.check_circle,
          label: 'مكتمل',
          value: '${stats['completed_objectives']}/${stats['total_objectives']}',
          color: AppConstants.successColor,
        ),
        const SizedBox(width: 16),
        _buildStatItem(
          icon: Icons.layers,
          label: 'المستوى',
          value: '${stats['current_level']}',
          color: AppConstants.primaryColor,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 14,
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: AppConstants.textColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
