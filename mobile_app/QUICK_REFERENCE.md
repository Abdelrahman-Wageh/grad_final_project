# 🎯 QUICK REFERENCE - SMARTINO PREMIUM COMPONENTS

## Color Quick Access
```dart
// Primary Colors
PremiumKidTheme.vibrantMagenta        // 🔴 #FF006E
PremiumKidTheme.brilliantBlue         // 🔵 #0099FF
PremiumKidTheme.sunnyYellow           // 🟡 #FFD60A
PremiumKidTheme.limeGreen             // 🟢 #39FF14

// Gradients
PremiumKidTheme.magentaPinkGradient   // Pink wave
PremiumKidTheme.blueTurquoiseGradient // Cool blue
PremiumKidTheme.rainbowGradient       // All colors
PremiumKidTheme.sunsetGradient        // Warm colors
PremiumKidTheme.goldenGradient        // Premium feel
```

## Button Cheat Sheet

### For CTAs (Main Actions)
```dart
PremiumButton(
  label: '🚀 PLAY',
  onPressed: () {},
  gradient: PremiumKidTheme.rainbowGradient,
)
```

### For Special Moments
```dart
BounceButton(
  label: 'Start',
  onPressed: () {},
  gradient: PremiumKidTheme.magentaPinkGradient,
)
```

### For Secondary Actions
```dart
GradientBorderButton(
  label: 'Learn More',
  onPressed: () {},
  gradient: PremiumKidTheme.blueTurquoiseGradient,
)
```

### For Game Navigation
```dart
IconLabelButton(
  icon: Icons.games,
  label: 'Games',
  onPressed: () {},
)
```

## Loading States Cheat Sheet

```dart
// Simple spinner
PremiumLoadingStates.loadingIndicator()

// Bouncing balls (fast)
PremiumLoadingStates.bouncingBallsLoader()

// Full screen (blocking)
PremiumLoadingStates.fullScreenLoader(message: 'Loading...')

// Success celebration
PremiumLoadingStates.successAnimation(onComplete: () {})

// Error handling
PremiumLoadingStates.errorAnimation(onRetry: () {})
```

## Game UI Components

### Display Score
```dart
PremiumGameWidgets.scoreDisplay(
  score: 1500,
  showAnimation: true,
)
```

### Show Lives
```dart
PremiumGameWidgets.livesIndicator(
  lives: 3,
  maxLives: 5,
)
```

### Show Combo
```dart
PremiumGameWidgets.comboCounter(comboCount: 5)
```

### Countdown Timer
```dart
PremiumGameWidgets.timerDisplay(
  timeRemaining: Duration(seconds: 30),
  totalTime: Duration(minutes: 2),
)
```

### Level Progress
```dart
PremiumGameWidgets.levelProgress(
  currentLevel: 3,
  totalLevels: 10,
  progress: 0.65,
)
```

## Character Mascot

### Interactive Character
```dart
PremiumCharacterMascot(
  characterEmoji: '🎮',
  characterName: 'Smartino',
  isInteractive: true,
  onTap: () {},
)
```

### Show Speech Bubble
```dart
CharacterResponsePanel(
  responseText: 'Great job!',
  moodEmoji: '🤩',
)
```

### Celebrate
```dart
CharacterCelebration(
  message: 'Fantastic!',
  celebrationEmoji: '🎉',
)
```

## Particle Effects

### Celebrate
```dart
ParticleEffects.confettiBurst(particleCount: 50)
```

### Stars
```dart
ParticleEffects.starBurst(
  position: Offset(100, 100),
  starCount: 12,
)
```

### Background
```dart
ParticleEffects.floatingParticles(count: 20)
```

### Glow
```dart
ParticleEffects.glowEffect(
  child: YourWidget(),
)
```

## API Service

### Get User Profile
```dart
final profile = await api.getUserProfile(userId);
```

### Submit Game Result
```dart
await api.submitGameResult(
  sessionId: id,
  score: 1500,
  playTime: Duration(minutes: 5),
  metrics: {'accuracy': 95},
);
```

### Get AI Response
```dart
final response = await api.getCompanionResponse(
  userMessage: 'Play a game',
  userId: userId,
  context: 'game_selection',
);
```

### Get Achievements
```dart
final achievements = await api.getAchievements(userId);
```

### Unlock Achievement
```dart
await api.unlockAchievement(
  userId: userId,
  achievementId: 'first_game',
);
```

## Common Patterns

### Loading + Error Handling
```dart
FutureBuilder(
  future: api.getGames(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return PremiumLoadingStates.bouncingBallsLoader();
    }
    if (snapshot.hasError) {
      return PremiumLoadingStates.errorAnimation(
        message: 'Failed to load',
        onRetry: () { /* retry */ },
      );
    }
    if (!snapshot.hasData) {
      return PremiumLoadingStates.emptyState();
    }
    return GamesList(games: snapshot.data!);
  },
)
```

### Animate Score Change
```dart
PremiumGameWidgets.scoreDisplay(
  score: newScore,
  previousScore: oldScore,
  showAnimation: true,
)
```

### Show Achievement
```dart
showDialog(
  context: context,
  builder: (_) => Dialog(
    child: PremiumGameWidgets.achievementUnlock(
      achievementName: 'Master',
      description: 'Completed all levels',
      achievementIcon: '🏆',
      pointsAwarded: 500,
    ),
  ),
);
```

### Game Over Flow
```dart
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) => PremiumGameWidgets.gameOverScreen(
    finalScore: finalScore,
    didWin: hasWon,
    onRestart: restartGame,
    onQuit: quitGame,
    bestScore: bestScore,
  ),
);
```

## Styling Tips

### Make any widget stand out
```dart
ParticleEffects.glowEffect(
  child: YourWidget(),
  glowColor: PremiumKidTheme.vibrantMagenta,
)
```

### Add shimmer
```dart
ParticleEffects.shimmerOverlay(
  child: YourWidget(),
)
```

### Add pulse ring
```dart
ParticleEffects.pulseRing(
  child: YourWidget(),
  ringCount: 3,
)
```

## Theme Integration

### In MaterialApp
```dart
MaterialApp(
  theme: PremiumKidTheme.lightTheme,
  darkTheme: PremiumKidTheme.darkTheme,
  themeMode: ThemeMode.light,
)
```

### Access theme colors
```dart
Theme.of(context).primaryColor
Theme.of(context).colorScheme.secondary
Theme.of(context).scaffoldBackgroundColor
```

## Common Mistakes to Avoid

❌ **Don't:** Use default Flutter colors
```dart
Container(color: Colors.blue)
```

✅ **Do:** Use premium colors
```dart
Container(color: PremiumKidTheme.brilliantBlue)
```

---

❌ **Don't:** Skip animations
```dart
Text('Score: $score')
```

✅ **Do:** Add animations
```dart
PremiumGameWidgets.scoreDisplay(score: score, showAnimation: true)
```

---

❌ **Don't:** Show plain loading
```dart
CircularProgressIndicator()
```

✅ **Do:** Use premium loader
```dart
PremiumLoadingStates.loadingIndicator()
```

---

❌ **Don't:** Basic buttons
```dart
ElevatedButton(onPressed: () {}, child: Text('Play'))
```

✅ **Do:** Use premium buttons
```dart
PremiumButton(label: '🎮 PLAY', onPressed: () {})
```

## Imports Cheat Sheet

```dart
// Theme
import 'package:smartino/theme/premium_kid_theme.dart';

// Widgets
import 'package:smartino/widgets/premium_buttons.dart';
import 'package:smartino/widgets/premium_loading_states.dart';
import 'package:smartino/widgets/particle_effects.dart';
import 'package:smartino/widgets/premium_character_mascot.dart';
import 'package:smartino/widgets/premium_game_widgets.dart';

// Screens
import 'package:smartino/screens/enhanced_home_screen.dart';

// API
import 'package:smartino/services/modern_api_service.dart';
```

---

**Pro Tip:** Use DevTools to inspect performance. The premium animations are optimized but test on real devices! 🚀
