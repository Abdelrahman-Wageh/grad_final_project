import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartino/models/learning_models.dart';
import 'package:smartino/providers/learning_providers.dart';

// ==================== SHOP SCREEN ====================

class ShopScreen extends ConsumerWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const userId = 'user_id';
    final shopItemsAsync = ref.watch(shopItemsProvider);
    final userProfileAsync = ref.watch(userProfileProvider(userId));

    return DefaultTabController(
      length: 4,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Shop',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Customize your avatar!',
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
                      SizedBox(height: 12),

                      // Currency display
                      userProfileAsync.when(
                        loading: () => SizedBox.shrink(),
                        error: (_, __) => SizedBox.shrink(),
                        data: (profile) => Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text('🪙', style: TextStyle(fontSize: 14)),
                                  SizedBox(width: 4),
                                  Text(
                                    '${profile.totalCoins}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.cyan.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text('💎', style: TextStyle(fontSize: 14)),
                                  SizedBox(width: 4),
                                  Text(
                                    '${profile.totalGems}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyan,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                      Tab(text: '👗 Clothes'),
                      Tab(text: '⌚ Accessories'),
                      Tab(text: '🧑 Avatars'),
                      Tab(text: '⚡ Power-Ups'),
                    ],
                  ),
                ),

                // ==================== TAB CONTENT ====================
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildCategoryTab(
                        context,
                        ref,
                        ShopItemType.avatarClothes,
                        shopItemsAsync,
                      ),
                      _buildCategoryTab(
                        context,
                        ref,
                        ShopItemType.avatarAccessories,
                        shopItemsAsync,
                      ),
                      _buildCategoryTab(
                        context,
                        ref,
                        ShopItemType.avatar,
                        shopItemsAsync,
                      ),
                      _buildCategoryTab(
                        context,
                        ref,
                        ShopItemType.powerUp,
                        shopItemsAsync,
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

  Widget _buildCategoryTab(
    BuildContext context,
    WidgetRef ref,
    ShopItemType type,
    AsyncValue<List<ShopItem>> shopItemsAsync,
  ) {
    return shopItemsAsync.when(
      loading: () => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
      error: (err, st) => Center(
        child: Text(
          'Error loading items',
          style: TextStyle(color: Colors.white),
        ),
      ),
      data: (items) {
        final filtered = items.where((item) => item.itemType == type).toList();
        return GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            return _buildShopItemCard(context, filtered[index]);
          },
        );
      },
    );
  }

  Widget _buildShopItemCard(BuildContext context, ShopItem item) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(item.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.description),
                SizedBox(height: 16),
                if (item.priceCoins != null)
                  Row(
                    children: [
                      Text('🪙 ${item.priceCoins}'),
                    ],
                  ),
                if (item.priceGems != null)
                  Row(
                    children: [
                      Text('💎 ${item.priceGems}'),
                    ],
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} purchased! 🎉'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Text('Purchase'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🎨', style: TextStyle(fontSize: 40)),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                item.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 8),
            if (item.priceCoins != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🪙', style: TextStyle(fontSize: 12)),
                  SizedBox(width: 2),
                  Text(
                    '${item.priceCoins}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            if (item.priceGems != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('💎', style: TextStyle(fontSize: 12)),
                  SizedBox(width: 2),
                  Text(
                    '${item.priceGems}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// ==================== PARENT DASHBOARD SCREEN ====================

class ParentDashboardScreen extends ConsumerWidget {
  final String childId;

  const ParentDashboardScreen({
    Key? key,
    required this.childId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentDashboardAsync =
        ref.watch(studentDashboardProvider(childId));
    final dailyStatsAsync = ref.watch(studentDailyStatsProvider(childId));

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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            'Parent Dashboard',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Track your child\'s learning',
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

                // ==================== DASHBOARD CONTENT ====================
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: studentDashboardAsync.when(
                    loading: () => Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    ),
                    error: (err, st) => Center(
                      child: Text(
                        'Error loading dashboard',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    data: (dashboard) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ==================== CHILD INFO ====================
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.purple,
                                  child: Text(
                                    '👧',
                                    style: TextStyle(fontSize: 32),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dashboard.studentName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Level ${dashboard.currentStreak}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),

                          // ==================== STATS ====================
                          Text(
                            'Learning Statistics',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 12),
                          GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              _buildStatCard(
                                '📚',
                                '${dashboard.lessonsCompleted}',
                                'Lessons',
                              ),
                              _buildStatCard(
                                '🏆',
                                '${dashboard.totalBadges}',
                                'Badges',
                              ),
                              _buildStatCard(
                                '⏱️',
                                '${dashboard.totalStudyTimeHours}h',
                                'Study Time',
                              ),
                              _buildStatCard(
                                '📊',
                                '${dashboard.averageScore.toStringAsFixed(0)}%',
                                'Avg Score',
                              ),
                            ],
                          ),
                          SizedBox(height: 24),

                          // ==================== DAILY STATS ====================
                          Text(
                            'Last 7 Days Activity',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 12),
                          dailyStatsAsync.when(
                            loading: () => Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            ),
                            error: (_, __) => SizedBox.shrink(),
                            data: (stats) => Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                children: stats
                                    .take(7)
                                    .map((stat) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              stat.date,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white70,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                _buildActivityBadge(
                                                  '⏱️',
                                                  '${stat.studyTimeMinutes}m',
                                                ),
                                                SizedBox(width: 8),
                                                _buildActivityBadge(
                                                  '📚',
                                                  '${stat.lessonsCompleted}',
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),

                          // ==================== SUBJECT PROGRESS ====================
                          Text(
                            'Progress by Subject',
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
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              children: dashboard.learningAreas.entries
                                  .map((entry) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                entry.key,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                '${entry.value.toStringAsFixed(0)}%',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 6),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: LinearProgressIndicator(
                                              value: entry.value / 100,
                                              minHeight: 6,
                                              backgroundColor: Colors
                                                  .white
                                                  .withOpacity(0.2),
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                Colors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: 40),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String emoji, String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: TextStyle(fontSize: 28)),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityBadge(String emoji, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 12)),
          SizedBox(width: 2),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}