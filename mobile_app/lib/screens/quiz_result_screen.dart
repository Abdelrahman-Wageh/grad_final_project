import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartino/models/learning_models.dart';
import 'package:smartino/providers/learning_providers.dart';

// ==================== QUIZ RESULT SCREEN ====================

class QuizResultScreen extends ConsumerWidget {
  final String quizId;
  final double scorePercentage;
  final bool passed;
  final int totalQuestions;
  final int correctAnswers;
  final dynamic rewards;
  final List<Badge> badges;

  const QuizResultScreen({
    Key? key,
    required this.quizId,
    required this.scorePercentage,
    required this.passed,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.rewards,
    required this.badges,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),

                  // ==================== RESULT ANIMATION ====================
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: passed ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        passed ? '✓' : '✗',
                        style: TextStyle(
                          fontSize: 80,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // ==================== RESULT MESSAGE ====================
                  Text(
                    passed ? 'Excellent Work! 🎉' : 'Try Again! 💪',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    passed
                        ? 'You passed the quiz! Great job!'
                        : 'You need ${100 - scorePercentage.toInt()}% more to pass.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),

                  // ==================== SCORE DETAILS ====================
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Score',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              '${scorePercentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: scorePercentage / 100,
                            minHeight: 10,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation(
                              passed ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '$correctAnswers',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  'Correct',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '${totalQuestions - correctAnswers}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  'Incorrect',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // ==================== REWARDS ====================
                  if (rewards != null)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(color: Colors.amber.withOpacity(0.4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🎁 Rewards Earned',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildRewardItem(
                                '🪙',
                                '+${rewards['coins_earned']}',
                                'Coins',
                              ),
                              _buildRewardItem(
                                '💎',
                                '+${rewards['gems_earned']}',
                                'Gems',
                              ),
                              _buildRewardItem(
                                '⭐',
                                '+${rewards['points_earned']}',
                                'Points',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 20),

                  // ==================== BADGES ====================
                  if (badges.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(color: Colors.purple.withOpacity(0.4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🏆 New Badges Earned',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 12),
                          ...badges.map((badge) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Text('🏅', style: TextStyle(fontSize: 24)),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          badge.name,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          badge.description,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  SizedBox(height: 40),

                  // ==================== BUTTONS ====================
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Back'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to next lesson or course
                          },
                          icon: Icon(Icons.arrow_forward),
                          label: Text('Continue'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRewardItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 28)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

// ==================== REWARDS & BADGES SCREEN ====================

class RewardsBadgesScreen extends ConsumerWidget {
  const RewardsBadgesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const userId = 'user_id'; // Should come from auth
    final userBadgesAsync = ref.watch(userBadgesProvider(userId));
    final userRewardsAsync = ref.watch(userRewardsProvider(userId));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                            'Your Badges',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Collect badges as you progress',
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

                // ==================== TABS ====================
                Container(
                  color: Colors.white.withOpacity(0.1),
                  child: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    indicatorColor: Colors.amber,
                    tabs: [
                      Tab(text: '🏆 Badges (${userBadgesAsync.valueOrNull?.length ?? 0})'),
                      Tab(text: '🎁 Rewards (${userRewardsAsync.valueOrNull?.length ?? 0})'),
                    ],
                  ),
                ),

                // ==================== TAB CONTENT ====================
                Expanded(
                  child: TabBarView(
                    children: [
                      // Badges tab
                      userBadgesAsync.when(
                        loading: () => Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                        error: (err, st) => Center(
                          child: Text(
                            'Error loading badges',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        data: (badges) => GridView.builder(
                          padding: EdgeInsets.all(16),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: badges.length,
                          itemBuilder: (context, index) {
                            final badge = badges[index].badge;
                            return _buildBadgeCard(badge);
                          },
                        ),
                      ),

                      // Rewards tab
                      userRewardsAsync.when(
                        loading: () => Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                        error: (err, st) => Center(
                          child: Text(
                            'Error loading rewards',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        data: (rewards) => ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: rewards.length,
                          itemBuilder: (context, index) {
                            final reward = rewards[index];
                            return _buildRewardCard(reward);
                          },
                        ),
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

  Widget _buildBadgeCard(Badge badge) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🏅', style: TextStyle(fontSize: 50)),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              badge.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              badge.rarity,
              style: TextStyle(
                fontSize: 9,
                color: Colors.amber,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(Reward reward) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reward.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            reward.reason,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (reward.coinsEarned > 0)
                Row(
                  children: [
                    Text('🪙', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 4),
                    Text(
                      '+${reward.coinsEarned}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              if (reward.gemsEarned > 0)
                Row(
                  children: [
                    Text('💎', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 4),
                    Text(
                      '+${reward.gemsEarned}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                      ),
                    ),
                  ],
                ),
              if (reward.pointsEarned > 0)
                Row(
                  children: [
                    Text('⭐', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 4),
                    Text(
                      '+${reward.pointsEarned}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent,
                      ),
                    ),
                  ],
                ),
              Text(
                reward.earnedAt.toString().split('.')[0],
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
