import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartino/models/learning_models.dart';
import 'package:smartino/providers/learning_providers.dart';
import 'package:smartino/screens/course_categories_screen.dart';
import 'package:smartino/screens/progress_tracker_screen.dart';
import 'package:smartino/screens/rewards_badges_screen.dart';
import 'package:smartino/screens/daily_challenge_screen.dart';

class LearningHomeScreen extends ConsumerWidget {
  const LearningHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider('user_id'));
    final todayChallengeAsync = ref.watch(todaysChallengeProvider('user_id'));
    final userProgressAsync = ref.watch(userProgressProvider('user_id'));

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
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================== HEADER ====================
                  userProfileAsync.when(
                    loading: () => Shimmer(
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    error: (err, st) => SizedBox.shrink(),
                    data: (profile) => _buildHeader(context, profile),
                  ),
                  SizedBox(height: 30),

                  // ==================== GREETING & PROGRESS ====================
                  userProgressAsync.when(
                    loading: () => SizedBox.shrink(),
                    error: (err, st) => SizedBox.shrink(),
                    data: (progress) => _buildProgressSummary(context, progress),
                  ),
                  SizedBox(height: 30),

                  // ==================== COURSE CATEGORIES BUTTON (MAIN ACTION) ====================
                  _buildCoursesCategoryButton(context),
                  SizedBox(height: 20),

                  // ==================== QUICK ACTION BUTTONS ====================
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionButton(
                          context,
                          '📊',
                          'Progress',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProgressTrackerScreen(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionButton(
                          context,
                          '🏆',
                          'Badges',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RewardsBadgesScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionButton(
                          context,
                          '⚡',
                          'Daily Challenge',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DailyChallengeScreen(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionButton(
                          context,
                          '🗺️',
                          'Learning Map',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LearningMapScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // ==================== TODAY'S CHALLENGE PREVIEW ====================
                  Text(
                    'Today\'s Challenge',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  todayChallengeAsync.when(
                    loading: () => _buildChallengeSkeletonLoader(),
                    error: (err, st) => SizedBox.shrink(),
                    data: (challenge) => _buildChallengePreview(context, challenge),
                  ),
                  SizedBox(height: 30),

                  // ==================== CONTINUE LEARNING ====================
                  Text(
                    'Continue Learning',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildContinueLearning(context),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==================== HELPER WIDGETS ====================

  Widget _buildHeader(BuildContext context, UserProfile profile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${profile.name}! 👋',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Let's Learn Something New Today!",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        // Avatar
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.amber,
          child: Text(
            '${profile.age}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSummary(BuildContext context, UserProgress progress) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('📚', '${progress.totalLessonsCompleted}', 'Lessons'),
          _buildStatItem('🏅', '${progress.badgesEarned}', 'Badges'),
          _buildStatItem('⭐', '${progress.totalPoints}', 'Points'),
          _buildStatItem('🔥', '${progress.currentStreakDays}d', 'Streak'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: TextStyle(fontSize: 24)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildCoursesCategoryButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CourseCategoriesScreen()),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF7C3AED).withOpacity(0.4),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, color: Colors.white, size: 28),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore Courses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Math, Science, Language & More',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String emoji,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(emoji, style: TextStyle(fontSize: 28)),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengePreview(BuildContext context, DailyChallenge challenge) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amber.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Text('⚡', style: TextStyle(fontSize: 40)),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  challenge.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '+${challenge.rewardCoins} Coins',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildChallengeSkeletonLoader() {
    return Shimmer(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildContinueLearning(BuildContext context) {
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
                'Mathematics - Level 1',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '60%',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.6,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(Colors.green),
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.play_arrow),
            label: Text('Continue Lesson'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 40),
            ),
          ),
        ],
      ),
    );
  }
}

// Shimmer effect widget
class Shimmer extends StatefulWidget {
  final Widget child;

  const Shimmer({Key? key, required this.child}) : super(key: key);

  @override
  _ShimmerState createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment(-1.0, -1.0),
          end: Alignment(2.0, 2.0),
          colors: [
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.0),
          ],
          stops: [
            _controller.value - 0.5,
            _controller.value,
            _controller.value + 0.5,
          ],
        ).createShader(bounds);
      },
      child: widget.child,
    );
  }
}
