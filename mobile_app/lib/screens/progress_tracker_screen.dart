import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartino/models/learning_models.dart';
import 'package:smartino/providers/learning_providers.dart';

// ==================== PROGRESS TRACKER SCREEN ====================

class ProgressTrackerScreen extends ConsumerWidget {
  const ProgressTrackerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const userId = 'user_id';
    final userProgressAsync = ref.watch(userProgressProvider(userId));
    final userStatsAsync = ref.watch(userStatsProvider(userId));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a237e).withOpacity(0.8),
              Color(0xFF0d47a1).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ==================== HEADER ====================
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Progress',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Keep up the great work!',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                // ==================== PROGRESS DATA ====================
                userProgressAsync.when(
                  loading: () => Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  ),
                  error: (err, st) => Center(
                    child: Text(
                      'Error loading progress',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  data: (progress) => _buildProgressContent(context, progress),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressContent(BuildContext context, UserProgress progress) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================== STATS OVERVIEW ====================
          _buildStatsGrid(progress),
          SizedBox(height: 24),

          // ==================== LEARNING LEVEL ====================
          Text(
            'Learning Level',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          _buildLevelCard(progress.currentLevel),
          SizedBox(height: 24),

          // ==================== COURSE PROGRESS ====================
          Text(
            'Course Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          ...progress.courseProgress.map((cp) {
            return _buildCourseProgressItem(cp);
          }).toList(),
          SizedBox(height: 24),

          // ==================== STREAKS ====================
          Text(
            'Streaks',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStreakCard(
                  '🔥',
                  'Current Streak',
                  '${progress.currentStreakDays} days',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStreakCard(
                  '⭐',
                  'Longest Streak',
                  '${progress.longestStreakDays} days',
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // ==================== TIME SPENT ====================
          Text(
            'Study Time',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Study Time',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${progress.totalStudyTimeMinutes ~/ 60}h ${progress.totalStudyTimeMinutes % 60}m',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text('📚', style: TextStyle(fontSize: 40)),
              ],
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(UserProgress progress) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildStatBox('📚', '${progress.totalLessonsCompleted}', 'Lessons'),
          _buildStatBox('🏅', '${progress.badgesEarned}', 'Badges'),
          _buildStatBox('⭐', '${progress.totalPoints}', 'Points'),
          _buildStatBox('📈', 'Lvl ${progress.currentLevel}', 'Level'),
        ],
      ),
    );
  }

  Widget _buildStatBox(String emoji, String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(emoji, style: TextStyle(fontSize: 28)),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelCard(int level) {
    const maxLevel = 20;
    final nextLevelXp = (level * 100).toInt();
    final progressPercent = (level / maxLevel).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level $level',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Level ${level + 1} in progress',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.purple,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressPercent,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(Colors.purple),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseProgressItem(CourseProgress cp) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Course ${cp.courseId}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${cp.completionPercentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: cp.completionPercentage / 100,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${cp.lessonsCompleted}/${cp.totalLessons} lessons • Avg: ${cp.averageScore.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(String emoji, String title, String value) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== LEARNING MAP SCREEN ====================

class LearningMapScreen extends ConsumerWidget {
  const LearningMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const userId = 'user_id';
    final learningMapAsync = ref.watch(learningMapProvider(userId));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e).withOpacity(0.8),
              Color(0xFF16213e).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ==================== HEADER ====================
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Learning Journey',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Explore islands and unlock new worlds',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              // ==================== MAP CONTENT ====================
              Expanded(
                child: learningMapAsync.when(
                  loading: () => Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                  error: (err, st) => Center(
                    child: Text(
                      'Error loading learning map',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  data: (map) => _buildLearningMap(context, map),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLearningMap(BuildContext context, LearningMap map) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: map.islands.length,
      itemBuilder: (context, index) {
        final island = map.islands[index];
        final isUnlocked = island.isUnlocked;
        final isCurrent = map.currentIsland == index;
        final isCompleted = index < map.completedIslands;

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUnlocked
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isCurrent
                  ? Colors.amber
                  : isUnlocked
                      ? Colors.white.withOpacity(0.2)
                      : Colors.white.withOpacity(0.1),
              width: isCurrent ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _getIslandEmoji(island.islandType),
                    style: TextStyle(fontSize: 40),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          island.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        if (isCompleted)
                          Text(
                            '✓ Completed',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        else if (isCurrent)
                          Text(
                            'In Progress',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.amber,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        else if (!isUnlocked)
                          Text(
                            'Locked: ${island.unlockRequirement}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!isUnlocked)
                    Icon(Icons.lock, color: Colors.white70)
                  else if (isCompleted)
                    Icon(Icons.check_circle, color: Colors.green)
                  else if (isCurrent)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.play_arrow, color: Colors.amber),
                    ),
                ],
              ),
              if (isUnlocked && island.courses.isNotEmpty) ...[
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: island.courses.map((courseId) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        courseId,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _getIslandEmoji(IslandType type) {
    switch (type) {
      case IslandType.numbersWorld:
        return '🔢';
      case IslandType.multiplicationForest:
        return '🌲';
      case IslandType.divisionCastle:
        return '🏰';
      case IslandType.alphabetIsland:
        return '🏝️';
      case IslandType.scienceLab:
        return '🔬';
      case IslandType.codingGalaxy:
        return '🌌';
    }
  }
}
