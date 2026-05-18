import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../services/storage_service.dart';
import '../services/game_service.dart';
import '../utils/app_constants.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final storageService = Provider.of<StorageService>(context, listen: false);
    await storageService.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Cards
            _buildOverviewCards(),
            
            const SizedBox(height: 24),
            
            // Learning Progress
            _buildLearningProgress(),
            
            const SizedBox(height: 24),
            
            // Recent Interactions
            _buildRecentInteractions(),
            
            const SizedBox(height: 24),
            
            // Game Statistics
            _buildGameStatistics(),
            
            const SizedBox(height: 24),
            
            // Data Management
            _buildDataManagement(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    final storageService = Provider.of<StorageService>(context, listen: false);
    final gameService = Provider.of<GameService>(context, listen: false);
    final stats = storageService.getInteractionStatistics();
    final gameStats = gameService.getGameStatistics();
    
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total Interactions',
            value: '${stats['total_interactions'] ?? 0}',
            icon: Icons.chat,
            color: AppConstants.primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Success Rate',
            value: '${((stats['success_rate'] ?? 0) * 100).toStringAsFixed(1)}%',
            icon: Icons.check_circle,
            color: AppConstants.successColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppConstants.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(
      begin: 0.3,
      duration: 500.ms,
    );
  }

  Widget _buildLearningProgress() {
    final storageService = Provider.of<StorageService>(context, listen: false);
    final learningData = storageService.getLearningProgress();
    final progress = learningData['learning_progress'] as Map<String, int>? ?? {};
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          const Text(
            'Learning Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 16),
          ...progress.entries.map((entry) => _buildLearningItem(
            category: entry.key,
            progress: entry.value,
          )),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }

  Widget _buildLearningItem({
    required String category,
    required int progress,
  }) {
    final colors = {
      'colors': AppConstants.accentColor,
      'numbers': AppConstants.primaryColor,
      'shapes': AppConstants.secondaryColor,
      'animals': AppConstants.successColor,
    };
    
    final color = colors[category] ?? AppConstants.primaryColor;
    final percentage = (progress / 10 * 100).clamp(0, 100);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                category.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const Spacer(),
              Text(
                '$progress/10',
                style: TextStyle(
                  fontSize: 12,
                  color: AppConstants.textColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppConstants.backgroundColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentInteractions() {
    final storageService = Provider.of<StorageService>(context, listen: false);
    final logs = storageService.getAllInteractionLogs().take(5).toList();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          const Text(
            'Recent Interactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 16),
          if (logs.isEmpty)
            const Text(
              'No interactions yet',
              style: TextStyle(
                color: AppConstants.textColor,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            ...logs.map((log) => _buildInteractionItem(log)),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms);
  }

  Widget _buildInteractionItem(interactionLog) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: interactionLog.success 
                  ? AppConstants.successColor 
                  : AppConstants.errorColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMM dd, HH:mm').format(interactionLog.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppConstants.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (interactionLog.childQuery != null)
                  Text(
                    interactionLog.childQuery!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppConstants.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Text(
            '${interactionLog.responseTime.inMilliseconds}ms',
            style: TextStyle(
              fontSize: 10,
              color: AppConstants.textColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameStatistics() {
    final gameService = Provider.of<GameService>(context, listen: false);
    final stats = gameService.getGameStatistics();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          const Text(
            'Game Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow('Current Level', '${stats['current_level']}'),
          _buildStatRow('Total Score', '${stats['score']}'),
          _buildStatRow('Completion Rate', '${stats['completion_percentage']}%'),
          _buildStatRow('Total Attempts', '${stats['total_attempts']}'),
          _buildStatRow('Hints Used', '${stats['hints_used']}'),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 600.ms);
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppConstants.textColor,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagement() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          const Text(
            'Data Management',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _exportData,
                  icon: const Icon(Icons.download),
                  label: const Text('Export Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _clearData,
                  icon: const Icon(Icons.delete),
                  label: const Text('Clear Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.errorColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 800.ms);
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Text('Settings functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData() async {
    final storageService = Provider.of<StorageService>(context, listen: false);
    await storageService.exportData();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data exported successfully'),
          backgroundColor: AppConstants.successColor,
        ),
      );
    }
  }

  Future<void> _clearData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('Are you sure you want to clear all data? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.errorColor,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      final storageService = Provider.of<StorageService>(context, listen: false);
      await storageService.clearAllData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data cleared'),
            backgroundColor: AppConstants.successColor,
          ),
        );
        setState(() {});
      }
    }
  }
}
