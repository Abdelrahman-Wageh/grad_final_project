import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartino/models/learning_models.dart';
import 'package:smartino/providers/learning_providers.dart';

// ==================== DAILY CHALLENGE SCREEN ====================

class DailyChallengeScreen extends ConsumerStatefulWidget {
  const DailyChallengeScreen({Key? key}) : super(key: key);

  @override
  _DailyChallengeScreenState createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends ConsumerState<DailyChallengeScreen> {
  bool _challengeCompleted = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const userId = 'user_id';
    final todaysChallengeAsync = ref.watch(todaysChallengeProvider(userId));

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
                          'Daily Challenge',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Complete today\'s challenge to earn rewards!',
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

              // ==================== CHALLENGE CONTENT ====================
              Expanded(
                child: todaysChallengeAsync.when(
                  loading: () => Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                  error: (err, st) => Center(
                    child: Text(
                      'Error loading challenge',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  data: (challenge) => _buildChallengeContent(challenge),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeContent(DailyChallenge challenge) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================== CHALLENGE BADGE ====================
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber.withOpacity(0.4)),
              ),
              child: Text(
                '⚡',
                style: TextStyle(fontSize: 80),
              ),
            ),
          ),
          SizedBox(height: 24),

          // ==================== CHALLENGE TITLE & DESCRIPTION ====================
          Text(
            challenge.title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            challenge.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
          ),
          SizedBox(height: 20),

          // ==================== DIFFICULTY & REWARDS ====================
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('⚔️', style: TextStyle(fontSize: 24)),
                    SizedBox(height: 8),
                    Text(
                      challenge.difficulty.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('🪙', style: TextStyle(fontSize: 24)),
                    SizedBox(height: 8),
                    Text(
                      '+${challenge.rewardCoins}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('💎', style: TextStyle(fontSize: 24)),
                    SizedBox(height: 8),
                    Text(
                      '+${challenge.rewardGems}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // ==================== CHALLENGE CONTENT ====================
          Text(
            'Challenge Tasks:',
            style: TextStyle(
              fontSize: 14,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (challenge.content['tasks'] != null)
                  ...(challenge.content['tasks'] as List).map((task) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: false,
                            onChanged: (_) {},
                            fillColor: MaterialStateProperty.all(Colors.green),
                          ),
                          Expanded(
                            child: Text(
                              task,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()
                else
                  Text(
                    'Solve 10 math problems',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
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
                  child: Text('Later'),
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
                    setState(() => _challengeCompleted = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Challenge started! Good luck! 🍀'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text('Start Challenge'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ==================== AVATAR CUSTOMIZATION SCREEN ====================

class AvatarCustomizationScreen extends ConsumerStatefulWidget {
  const AvatarCustomizationScreen({Key? key}) : super(key: key);

  @override
  _AvatarCustomizationScreenState createState() =>
      _AvatarCustomizationScreenState();
}

class _AvatarCustomizationScreenState
    extends ConsumerState<AvatarCustomizationScreen> {
  late AvatarCustomization _currentCustomization;

  @override
  void initState() {
    super.initState();
    _currentCustomization = AvatarCustomization(
      avatarId: 'default',
      outfit: 'default',
    );
  }

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
                          'Customize Avatar',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Make your character unique!',
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

              // ==================== AVATAR PREVIEW ====================
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar preview
                      Center(
                        child: Container(
                          width: 200,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '🧑',
                              style: TextStyle(fontSize: 100),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // ==================== CUSTOMIZATION OPTIONS ====================

                      // Outfit selector
                      Text(
                        'Outfit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildCustomizationOptions([
                        {'id': 'suit', 'emoji': '🤵', 'name': 'Suit'},
                        {'id': 'casual', 'emoji': '👕', 'name': 'Casual'},
                        {'id': 'sports', 'emoji': '⚽', 'name': 'Sports'},
                        {'id': 'princess', 'emoji': '👸', 'name': 'Princess'},
                      ]),
                      SizedBox(height: 24),

                      // Hair style selector
                      Text(
                        'Hair Style',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildCustomizationOptions([
                        {'id': 'short', 'emoji': '💇', 'name': 'Short'},
                        {'id': 'long', 'emoji': '💇‍♀️', 'name': 'Long'},
                        {'id': 'curly', 'emoji': '🌀', 'name': 'Curly'},
                        {'id': 'afro', 'emoji': '🎗️', 'name': 'Afro'},
                      ]),
                      SizedBox(height: 24),

                      // Accessories selector
                      Text(
                        'Accessories',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildCustomizationOptions([
                        {'id': 'glasses', 'emoji': '👓', 'name': 'Glasses'},
                        {'id': 'hat', 'emoji': '🎩', 'name': 'Hat'},
                        {'id': 'tie', 'emoji': '🎀', 'name': 'Bowtie'},
                        {'id': 'none', 'emoji': '✨', 'name': 'None'},
                      ]),
                      SizedBox(height: 40),

                      // Save button
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Avatar customization saved! 🎉'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check),
                            SizedBox(width: 8),
                            Text('Save Customization'),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizationOptions(List<Map<String, String>> options) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((option) {
        return GestureDetector(
          onTap: () {
            setState(() {
              // Update customization
            });
          },
          child: Container(
            width: 80,
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Text(option['emoji']!, style: TextStyle(fontSize: 28)),
                SizedBox(height: 4),
                Text(
                  option['name']!,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
