# 🚀 Phase 6 Quick Start: Spaced Repetition & Dynamic Difficulty

**Quick integration guide for developers**

---

## 📦 Setup

### 1. Initialize Services

```dart
import 'package:smartino/services/local_storage_service.dart';
import 'package:smartino/services/spaced_repetition_manager.dart';
import 'package:smartino/services/difficulty_adapter.dart';
import 'package:smartino/services/game_session_manager.dart';

// In your app initialization
final storage = LocalStorageService();
await storage.init();

final srManager = SpacedRepetitionManager(storage);
final difficultyAdapter = DifficultyAdapter();
final sessionManager = GameSessionManager(
  srManager,
  difficultyAdapter,
  storage,
);
```

---

## 🎮 Basic Usage

### Start a Game Session

```dart
// Get current profile
final profile = await storage.loadProfile(profileId);

// Start session
final session = await sessionManager.startSession(profile);

// Show difficulty change notification if any
if (session.difficultyChangedMessage != null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(session.difficultyChangedMessage!)),
  );
}

// Use session settings
final difficulty = session.difficulty;
final hints = session.visualHints;
final complexity = session.complexityParams;
```

### End a Game Session

```dart
// After game completes
final result = await sessionManager.endSession(
  profile: profile,
  concept: "colors_red_blue",
  isCorrect: userAnsweredCorrectly,
  performanceQuality: 5, // 0-5 scale
);

// Show next review date
if (result.nextReviewDate != null) {
  print("Review this again on: ${result.nextReviewDate}");
}
```

---

## 🎯 Game Integration Examples

### Code Commander

```dart
class CodeCommanderGame extends StatefulWidget {
  @override
  _CodeCommanderGameState createState() => _CodeCommanderGameState();
}

class _CodeCommanderGameState extends State<CodeCommanderGame> {
  late GameSession session;
  
  @override
  void initState() {
    super.initState();
    _initSession();
  }
  
  Future<void> _initSession() async {
    session = await sessionManager.startSession(widget.profile);
    
    // Use complexity params
    final gridSize = session.complexityParams.gridSize;
    final obstacleCount = session.complexityParams.obstacleCount;
    
    // Generate level
    final level = generator.generateLevel(
      session.difficulty,
      widget.profile,
    );
    
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Show hints if enabled
          if (session.visualHints.showPathHighlight)
            PathHighlightWidget(),
          
          // Game grid
          GameGrid(
            size: session.complexityParams.gridSize,
          ),
        ],
      ),
    );
  }
  
  Future<void> _onGameComplete(bool isCorrect) async {
    await sessionManager.endSession(
      profile: widget.profile,
      concept: "pathfinding_${session.difficulty}",
      isCorrect: isCorrect,
      performanceQuality: isCorrect ? 5 : 2,
    );
  }
}
```

### Story Weaver

```dart
class StoryWeaverGame extends StatefulWidget {
  @override
  _StoryWeaverGameState createState() => _StoryWeaverGameState();
}

class _StoryWeaverGameState extends State<StoryWeaverGame> {
  late GameSession session;
  
  @override
  void initState() {
    super.initState();
    _initSession();
  }
  
  Future<void> _initSession() async {
    session = await sessionManager.startSession(widget.profile);
    
    // Get concepts due for review
    final dueConcepts = session.dueCards
        .map((card) => card.concept)
        .toList();
    
    // Generate level prioritizing due concepts
    final level = await generator.generateLevel(
      session.difficulty,
      widget.profile,
      priorityConcepts: dueConcepts,
    );
    
    setState(() {});
  }
  
  Future<void> _onAnswerSubmitted(String answer, bool isCorrect) async {
    // Calculate performance quality
    final quality = isCorrect ? 5 : 2;
    
    await sessionManager.endSession(
      profile: widget.profile,
      concept: "vocabulary_${level.category}",
      isCorrect: isCorrect,
      performanceQuality: quality,
    );
  }
}
```

### Potion Shop

```dart
class PotionShopGame extends StatefulWidget {
  @override
  _PotionShopGameState createState() => _PotionShopGameState();
}

class _PotionShopGameState extends State<PotionShopGame> {
  late GameSession session;
  Timer? gameTimer;
  
  @override
  void initState() {
    super.initState();
    _initSession();
  }
  
  Future<void> _initSession() async {
    session = await sessionManager.startSession(widget.profile);
    
    // Use complexity params
    final maxNumber = session.complexityParams.maxNumber;
    final timeLimit = session.complexityParams.timeLimit;
    
    // Generate level
    final level = generator.generateLevel(
      session.difficulty,
      widget.profile,
    );
    
    // Start timer if time limit exists
    if (timeLimit != null) {
      gameTimer = Timer(Duration(seconds: timeLimit), _onTimeUp);
    }
    
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Show number hints if enabled
          if (session.visualHints.showNumberHints)
            NumberLineWidget(max: session.complexityParams.maxNumber),
          
          // Potion mixing area
          PotionMixingArea(),
        ],
      ),
    );
  }
  
  Future<void> _onAnswerSubmitted(int answer, bool isCorrect) async {
    gameTimer?.cancel();
    
    await sessionManager.endSession(
      profile: widget.profile,
      concept: "math_addition_${session.difficulty}",
      isCorrect: isCorrect,
      performanceQuality: isCorrect ? 5 : 2,
    );
  }
  
  void _onTimeUp() {
    _onAnswerSubmitted(0, false);
  }
}
```

---

## 📊 Progress Tracking

### Show Progress to Parents

```dart
class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LearningProgress>(
      future: sessionManager.getProgress(profile),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        
        final progress = snapshot.data!;
        
        return Column(
          children: [
            Text('Difficulty: ${progress.currentDifficulty}'),
            Text('Success Rate: ${(progress.successRate * 100).toInt()}%'),
            Text('Mastered: ${progress.masteredConcepts}/${progress.totalConcepts}'),
            Text('Due Today: ${progress.dueToday}'),
            Text('Streak: ${progress.currentStreak} days'),
            
            // Encouraging message
            Text(progress.getProgressMessage()),
          ],
        );
      },
    );
  }
}
```

### Show Spaced Repetition Stats

```dart
class SpacedRepetitionStatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SpacedRepetitionStats>(
      future: srManager.getStats(profile.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        
        final stats = snapshot.data!;
        
        return Column(
          children: [
            StatCard(
              title: 'Total Concepts',
              value: stats.totalCards,
              icon: Icons.school,
            ),
            StatCard(
              title: 'Mastered',
              value: stats.mastered,
              icon: Icons.star,
              color: Colors.gold,
            ),
            StatCard(
              title: 'Learning',
              value: stats.learning,
              icon: Icons.trending_up,
              color: Colors.blue,
            ),
            StatCard(
              title: 'Due Today',
              value: stats.dueToday,
              icon: Icons.today,
              color: Colors.orange,
            ),
          ],
        );
      },
    );
  }
}
```

---

## 🎨 Visual Hints Implementation

### Path Highlight (Easy Mode)

```dart
class PathHighlightWidget extends StatelessWidget {
  final List<Position> correctPath;
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PathHighlightPainter(correctPath),
      child: Container(),
    );
  }
}

class PathHighlightPainter extends CustomPainter {
  final List<Position> path;
  
  PathHighlightPainter(this.path);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.3)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    
    // Draw path
    for (int i = 0; i < path.length - 1; i++) {
      canvas.drawLine(
        Offset(path[i].x * cellSize, path[i].y * cellSize),
        Offset(path[i + 1].x * cellSize, path[i + 1].y * cellSize),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
```

### Number Line (Easy/Medium Mode)

```dart
class NumberLineWidget extends StatelessWidget {
  final int max;
  final int? highlight;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: max + 1,
        itemBuilder: (context, index) {
          return Container(
            width: 40,
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: index == highlight 
                  ? Colors.yellow 
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
```

---

## 🔧 Advanced Usage

### Manual Difficulty Adjustment

```dart
// Force difficulty change (e.g., parent override)
profile.currentDifficulty = DifficultyLevel.easy;
await storage.saveProfile(profile);
```

### Custom Quality Rating

```dart
// Calculate quality based on multiple factors
int calculateQuality({
  required bool isCorrect,
  required int attempts,
  required Duration timeSpent,
}) {
  if (!isCorrect) return 2;
  
  if (attempts == 1 && timeSpent.inSeconds < 10) {
    return 5; // Perfect
  } else if (attempts == 1) {
    return 4; // Correct with hesitation
  } else if (attempts == 2) {
    return 3; // Correct but difficult
  } else {
    return 2; // Multiple attempts
  }
}
```

### Batch Review Scheduling

```dart
// Schedule multiple concepts at once
final concepts = ['red', 'blue', 'green', 'yellow'];

for (final concept in concepts) {
  await srManager.scheduleReview(profile.id, 'color_$concept');
}
```

---

## 📝 Best Practices

### 1. Always Start Sessions

```dart
// ✅ Good
final session = await sessionManager.startSession(profile);
final level = generator.generateLevel(session.difficulty, profile);

// ❌ Bad
final level = generator.generateLevel(profile.currentDifficulty, profile);
```

### 2. Use Performance Quality Correctly

```dart
// ✅ Good - Nuanced quality rating
final quality = isCorrect 
    ? (attempts == 1 ? 5 : 4)
    : (wasClose ? 2 : 1);

// ❌ Bad - Binary rating
final quality = isCorrect ? 5 : 0;
```

### 3. Show Encouraging Messages

```dart
// ✅ Good
if (session.difficultyChangedMessage != null) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Great Progress!'),
      content: Text(session.difficultyChangedMessage!),
    ),
  );
}

// ❌ Bad - Ignore difficulty changes
```

### 4. Track Concepts Properly

```dart
// ✅ Good - Specific concept names
await sessionManager.endSession(
  concept: "math_addition_up_to_10",
  ...
);

// ❌ Bad - Generic concept names
await sessionManager.endSession(
  concept: "game",
  ...
);
```

---

## 🐛 Troubleshooting

### Issue: Difficulty not changing

**Solution**: Ensure profile has enough recent attempts
```dart
// Need at least 5 attempts for adjustment
if (profile.recentAttempts.length < 5) {
  print("Not enough data for difficulty adjustment");
}
```

### Issue: Cards not appearing for review

**Solution**: Check nextReview dates
```dart
final cards = await srManager.getCardsForReview(profile.id);
for (final card in cards) {
  print("${card.concept}: ${card.nextReview}");
}
```

### Issue: Visual hints not showing

**Solution**: Check difficulty level
```dart
final hints = difficultyAdapter.getVisualHints(session.difficulty);
print("Show path: ${hints.showPathHighlight}");
print("Show colors: ${hints.showColorCoding}");
```

---

## 📚 API Reference

### SpacedRepetitionManager

- `updateCard(card, quality)` - Update card with performance
- `getCardsForReview(profileId)` - Get cards due today
- `scheduleReview(profileId, concept)` - Schedule new concept
- `getStats(profileId)` - Get SR statistics

### DifficultyAdapter

- `calculateDifficulty(profile, attempts)` - Get recommended difficulty
- `getNotificationMessage(old, new)` - Get encouraging message
- `getVisualHints(difficulty)` - Get hints configuration
- `getComplexityParams(difficulty)` - Get complexity settings
- `shouldAdjustDifficulty(attempts)` - Check if adjustment needed

### GameSessionManager

- `startSession(profile)` - Start new game session
- `endSession(...)` - End session and record result
- `getProgress(profile)` - Get learning progress summary

---

**Ready to integrate intelligent learning into your games!** 🧠✨

