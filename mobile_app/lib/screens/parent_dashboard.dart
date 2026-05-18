import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart' as legacy_provider;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../services/storage_service.dart';
import '../services/game_service.dart';
import '../services/local_storage_service.dart';
import '../core/game/progression_manager.dart';
import '../core/ai/ai_orchestrator.dart';
import '../data/curriculum/curriculum_data.dart';
import '../utils/app_constants.dart';
import '../theme/smartino_colors.dart';
import '../theme/smartino_typography.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AIMode _selectedAIMode = AIMode.cloud;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
    _loadAIMode();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final storageService = legacy_provider.Provider.of<StorageService>(context, listen: false);
    await storageService.initialize();
    setState(() {});
  }
  
  Future<void> _loadAIMode() async {
    final storage = legacy_provider.Provider.of<LocalStorageService>(context, listen: false);
    final mode = await storage.getAIMode();
    setState(() {
      _selectedAIMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'لوحة تحكم الأهل',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: SmartinoColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'نظرة عامة'),
            Tab(icon: Icon(Icons.map), text: 'رحلة التعلم'),
            Tab(icon: Icon(Icons.chat), text: 'المحادثات'),
            Tab(icon: Icon(Icons.settings), text: 'الإعدادات'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildJourneyMapTab(),
          _buildConversationsTab(),
          _buildSettingsTab(),
        ],
      ),
    );
  }
  
  // Tab 1: Overview
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
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
          
          // Time Spent Chart
          _buildTimeSpentChart(),
        ],
      ),
    );
  }
  
  // Tab 2: Journey Map Progress
  Widget _buildJourneyMapTab() {
    final progressionManager = legacy_provider.Provider.of<ProgressionManager>(context);
    final chapters = CurriculumData.chapters;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تقدم رحلة التعلم',
            style: SmartinoTypography.displaySmall.copyWith(
              color: SmartinoColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تتبع تقدم طفلك عبر الفصول والمراحل',
            style: SmartinoTypography.bodyMedium.copyWith(
              color: SmartinoColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          
          // Overall Progress
          _buildOverallProgress(progressionManager),
          
          const SizedBox(height: 24),
          
          // Chapter Progress Cards
          ...chapters.map((chapter) => _buildChapterProgressCard(
            chapter,
            progressionManager,
          )),
        ],
      ),
    );
  }
  
  // Tab 3: AI Conversations
  Widget _buildConversationsTab() {
    final storage = legacy_provider.Provider.of<LocalStorageService>(context, listen: false);
    
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: storage.getConversationHistory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final conversations = snapshot.data!;
        
        if (conversations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: SmartinoColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'لا توجد محادثات بعد',
                  style: SmartinoTypography.titleLarge.copyWith(
                    color: SmartinoColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            final conversation = conversations[index];
            return _buildConversationCard(conversation);
          },
        );
      },
    );
  }
  
  // Tab 4: Settings
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إعدادات التطبيق',
            style: SmartinoTypography.displaySmall.copyWith(
              color: SmartinoColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          
          // AI Mode Settings
          _buildAIModeSettings(),
          
          const SizedBox(height: 24),
          
          // Data Management
          _buildDataManagement(),
          
          const SizedBox(height: 24),
          
          // About Section
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    final storageService = legacy_provider.Provider.of<StorageService>(context, listen: false);
    final progressionManager = legacy_provider.Provider.of<ProgressionManager>(context);
    final stats = storageService.getInteractionStatistics();
    
    // Get progression stats
    final totalStars = progressionManager.getTotalStarsEarned();
    final completionPercentage = progressionManager.getOverallCompletionPercentage();
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'إجمالي النجوم',
                value: '$totalStars',
                icon: Icons.star,
                color: SmartinoColors.gold,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'نسبة الإنجاز',
                value: '${completionPercentage.toStringAsFixed(0)}%',
                icon: Icons.check_circle,
                color: SmartinoColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'المحادثات',
                value: '${stats['total_interactions'] ?? 0}',
                icon: Icons.chat,
                color: SmartinoColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'معدل النجاح',
                value: '${((stats['success_rate'] ?? 0) * 100).toStringAsFixed(0)}%',
                icon: Icons.trending_up,
                color: SmartinoColors.accent,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildOverallProgress(ProgressionManager progressionManager) {
    final completionPercentage = progressionManager.getOverallCompletionPercentage();
    final totalStars = progressionManager.getTotalStarsEarned();
    final maxStars = progressionManager.getMaxPossibleStars();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: SmartinoColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: SmartinoColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التقدم الإجمالي',
                style: SmartinoTypography.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${completionPercentage.toStringAsFixed(0)}%',
                  style: SmartinoTypography.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completionPercentage / 100,
              minHeight: 12,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                '$totalStars / $maxStars نجمة',
                style: SmartinoTypography.bodyLarge.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(delay: 100.ms);
  }
  
  Widget _buildChapterProgressCard(
    Chapter chapter,
    ProgressionManager progressionManager,
  ) {
    final chapterId = chapter.id;
    final chapterName = chapter.nameAr;
    final chapterColor = _getChapterColor(chapterId);
    final stages = chapter.stages;
    
    final completedStages = stages.where((stage) {
      final stageId = stage.id;
      return progressionManager.isStageCompleted(stageId);
    }).length;
    
    final totalStars = stages.fold<int>(0, (sum, stage) {
      final stageId = stage.id;
      return sum + progressionManager.getStageStars(stageId);
    });
    
    final maxStars = stages.length * 3;
    final progress = completedStages / stages.length;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chapterColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: chapterColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: chapterColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.book,
                  color: chapterColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapterName,
                      style: SmartinoTypography.titleMedium.copyWith(
                        color: SmartinoColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$completedStages / ${stages.length} مراحل',
                      style: SmartinoTypography.bodySmall.copyWith(
                        color: SmartinoColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: SmartinoColors.gold, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '$totalStars/$maxStars',
                    style: SmartinoTypography.titleSmall.copyWith(
                      color: SmartinoColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: chapterColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(chapterColor),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.2);
  }
  
  Widget _buildConversationCard(Map<String, dynamic> conversation) {
    final timestamp = DateTime.parse(conversation['timestamp'] as String);
    final userMessage = conversation['userMessage'] as String;
    final aiResponse = conversation['aiResponse'] as String;
    final context = conversation['context'] as Map<String, dynamic>?;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: SmartinoColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(timestamp),
                style: SmartinoTypography.bodySmall.copyWith(
                  color: SmartinoColors.textSecondary,
                ),
              ),
              const Spacer(),
              if (context != null)
                IconButton(
                  icon: const Icon(Icons.info_outline, size: 20),
                  onPressed: () => _showConversationContext(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: SmartinoColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.person,
                  size: 20,
                  color: SmartinoColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    userMessage,
                    style: SmartinoTypography.bodyMedium.copyWith(
                      color: SmartinoColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: SmartinoColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.smart_toy,
                  size: 20,
                  color: SmartinoColors.accent,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    aiResponse,
                    style: SmartinoTypography.bodyMedium.copyWith(
                      color: SmartinoColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }
  
  Widget _buildAIModeSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: SmartinoColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'وضع الذكاء الاصطناعي',
                style: SmartinoTypography.titleLarge.copyWith(
                  color: SmartinoColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'اختر كيفية عمل الذكاء الاصطناعي في التطبيق',
            style: SmartinoTypography.bodyMedium.copyWith(
              color: SmartinoColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          _buildAIModeOption(
            mode: AIMode.cloud,
            title: 'السحابة (Cloud)',
            description: 'أفضل جودة - يتطلب اتصال بالإنترنت',
            icon: Icons.cloud,
          ),
          const SizedBox(height: 12),
          _buildAIModeOption(
            mode: AIMode.local,
            title: 'محلي (Local)',
            description: 'يعمل بدون إنترنت - جودة جيدة',
            icon: Icons.phone_android,
          ),
          const SizedBox(height: 12),
          _buildAIModeOption(
            mode: AIMode.hybrid,
            title: 'هجين (Hybrid)',
            description: 'تلقائي - يستخدم السحابة عند التوفر',
            icon: Icons.sync,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }
  
  Widget _buildAIModeOption({
    required AIMode mode,
    required String title,
    required String description,
    required IconData icon,
  }) {
    final isSelected = _selectedAIMode == mode;
    
    return InkWell(
      onTap: () => _changeAIMode(mode),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? SmartinoColors.primary.withOpacity(0.1)
              : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? SmartinoColors.primary
                : Colors.grey.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? SmartinoColors.primary
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: SmartinoTypography.titleMedium.copyWith(
                      color: SmartinoColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: SmartinoTypography.bodySmall.copyWith(
                      color: SmartinoColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: SmartinoColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTimeSpentChart() {
    final chapters = CurriculumData.chapters;
    
    // Calculate time spent per chapter (mock data for now)
    final timeData = chapters.asMap().entries.map((entry) {
      final index = entry.key;
      final chapter = entry.value;
      final chapterColor = _getChapterColor(chapter.id);
      
      // Mock time data - in real app, track actual time
      final timeMinutes = (index + 1) * 15.0;
      
      return {
        'name': chapter.nameAr,
        'time': timeMinutes,
        'color': chapterColor,
      };
    }).toList();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الوقت المستغرق في كل فصل',
            style: SmartinoTypography.titleLarge.copyWith(
              color: SmartinoColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 120,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < timeData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'ف${value.toInt() + 1}',
                              style: SmartinoTypography.bodySmall,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}د',
                          style: SmartinoTypography.bodySmall,
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 30,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: timeData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: data['time'] as double,
                        color: data['color'] as Color,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 1000.ms);
  }
  
  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: SmartinoColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'عن التطبيق',
                style: SmartinoTypography.titleLarge.copyWith(
                  color: SmartinoColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'سمارتينو - صديقي الذكي',
            style: SmartinoTypography.titleMedium.copyWith(
              color: SmartinoColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تطبيق تعليمي تفاعلي للأطفال المصريين يستخدم الذكاء الاصطناعي لتوفير تجربة تعليمية مخصصة وممتعة.',
            style: SmartinoTypography.bodyMedium.copyWith(
              color: SmartinoColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.withOpacity(0.2)),
          const SizedBox(height: 16),
          _buildInfoRow('الإصدار', '2.0.0'),
          _buildInfoRow('تاريخ الإصدار', 'يناير 2026'),
          _buildInfoRow('المطور', 'فريق سمارتينو'),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: SmartinoTypography.bodyMedium.copyWith(
              color: SmartinoColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: SmartinoTypography.bodyMedium.copyWith(
              color: SmartinoColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showConversationContext(Map<String, dynamic> conversationContext) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'سياق المحادثة',
          style: SmartinoTypography.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (conversationContext['currentStage'] != null)
                _buildContextItem('المرحلة الحالية', conversationContext['currentStage']),
              if (conversationContext['totalStars'] != null)
                _buildContextItem('إجمالي النجوم', '${conversationContext['totalStars']}'),
              if (conversationContext['completionPercentage'] != null)
                _buildContextItem('نسبة الإنجاز', '${conversationContext['completionPercentage']}%'),
              if (conversationContext['lastCompletedStage'] != null)
                _buildContextItem('آخر مرحلة مكتملة', conversationContext['lastCompletedStage']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContextItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: SmartinoTypography.bodyMedium.copyWith(
              color: SmartinoColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: SmartinoTypography.bodyMedium.copyWith(
              color: SmartinoColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _changeAIMode(AIMode mode) async {
    final storage = legacy_provider.Provider.of<LocalStorageService>(context, listen: false);
    await storage.saveAIMode(mode);
    
    setState(() {
      _selectedAIMode = mode;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم تغيير وضع الذكاء الاصطناعي',
            style: SmartinoTypography.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: SmartinoColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
              Text(
                value,
                style: SmartinoTypography.displaySmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: SmartinoTypography.bodyMedium.copyWith(
              color: SmartinoColors.textSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(delay: 100.ms);
  }

  Widget _buildLearningProgress() {
    final progressionManager = legacy_provider.Provider.of<ProgressionManager>(context);
    final chapters = CurriculumData.chapters.take(4).toList(); // Show first 4 chapters
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تقدم التعلم',
            style: SmartinoTypography.titleLarge.copyWith(
              color: SmartinoColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...chapters.map((chapter) {
            final chapterId = chapter.id;
            final chapterName = chapter.nameAr;
            final chapterColor = _getChapterColor(chapterId);
            final stages = chapter.stages;
            
            final completedStages = stages.where((stage) {
              final stageId = stage.id;
              return progressionManager.isStageCompleted(stageId);
            }).length;
            
            final progress = completedStages / stages.length;
            
            return _buildLearningItem(
              category: chapterName,
              progress: (progress * 10).round(),
              color: chapterColor,
            );
          }),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }

  Widget _buildLearningItem({
    required String category,
    required int progress,
    Color? color,
  }) {
    final itemColor = color ?? SmartinoColors.primary;
    final percentage = (progress / 10 * 100).clamp(0, 100);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                category,
                style: SmartinoTypography.titleSmall.copyWith(
                  color: itemColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '$progress/10',
                style: SmartinoTypography.bodyMedium.copyWith(
                  color: SmartinoColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: itemColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(itemColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentInteractions() {
    final storage = legacy_provider.Provider.of<LocalStorageService>(context, listen: false);
    
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: storage.getConversationHistory(),
      builder: (context, snapshot) {
        final conversations = snapshot.data?.take(5).toList() ?? [];
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'آخر المحادثات',
                style: SmartinoTypography.titleLarge.copyWith(
                  color: SmartinoColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (conversations.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'لا توجد محادثات بعد',
                      style: SmartinoTypography.bodyMedium.copyWith(
                        color: SmartinoColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                )
              else
                ...conversations.map((conversation) {
                  final timestamp = DateTime.parse(conversation['timestamp'] as String);
                  final userMessage = conversation['userMessage'] as String;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: SmartinoColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('dd/MM - HH:mm').format(timestamp),
                                style: SmartinoTypography.bodySmall.copyWith(
                                  color: SmartinoColors.textSecondary,
                                ),
                              ),
                              Text(
                                userMessage,
                                style: SmartinoTypography.bodyMedium.copyWith(
                                  color: SmartinoColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 400.ms);
      },
    );
  }

  Widget _buildGameStatistics() {
    final progressionManager = legacy_provider.Provider.of<ProgressionManager>(context);
    final stats = progressionManager.getStatistics();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إحصائيات الألعاب',
            style: SmartinoTypography.titleLarge.copyWith(
              color: SmartinoColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow('المراحل المكتملة', '${stats['completedStages']}'),
          _buildStatRow('إجمالي النجوم', '${stats['totalStars']}'),
          _buildStatRow('نسبة الإنجاز', '${stats['completionPercentage'].toStringAsFixed(0)}%'),
          _buildStatRow('الفصول المفتوحة', '${stats['unlockedChapters']}'),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 600.ms);
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: SmartinoTypography.bodyMedium.copyWith(
                color: SmartinoColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: SmartinoTypography.titleSmall.copyWith(
              color: SmartinoColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagement() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.storage,
                color: SmartinoColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'إدارة البيانات',
                style: SmartinoTypography.titleLarge.copyWith(
                  color: SmartinoColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _exportData,
                  icon: const Icon(Icons.download),
                  label: const Text('تصدير البيانات'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SmartinoColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _clearData,
                  icon: const Icon(Icons.delete),
                  label: const Text('مسح البيانات'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SmartinoColors.error,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 800.ms);
  }

  Future<void> _exportData() async {
    final storageService = legacy_provider.Provider.of<StorageService>(context, listen: false);
    await storageService.exportData();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم تصدير البيانات بنجاح',
            style: SmartinoTypography.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: SmartinoColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _clearData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'مسح جميع البيانات',
          style: SmartinoTypography.titleLarge,
        ),
        content: Text(
          'هل أنت متأكد من مسح جميع البيانات؟ لا يمكن التراجع عن هذا الإجراء.',
          style: SmartinoTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: SmartinoColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('مسح'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      final storageService = legacy_provider.Provider.of<StorageService>(context, listen: false);
      await storageService.clearAllData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم مسح جميع البيانات',
              style: SmartinoTypography.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: SmartinoColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        setState(() {});
      }
    }
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
