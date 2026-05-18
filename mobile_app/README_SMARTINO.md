# Smartino (صديقي الذكي) - Educational Super-App

**Version**: 2.0.0  
**Status**: Production-Ready MVP  
**Platform**: Flutter (iOS, Android, Web)  
**Language**: Dart 3.0+

---

## 🌟 Overview

Smartino is an **AI-powered educational super-app** designed for Egyptian children to learn Arabic and English through interactive games, stories, and conversations with an AI companion named **Farfour (فرفور)**.

### Key Features
- 🤖 **Speech-to-Speech AI** - Talk to Farfour using voice
- 📚 **8-Chapter Curriculum** - Complete learning path
- 📖 **AI-Generated Stories** - Egyptian-themed interactive stories
- 🎮 **Educational Games** - Fun learning activities
- ⭐ **Progress Tracking** - Stars and achievements
- 🎨 **Beautiful Design** - Egyptian-inspired UI
- 🌐 **Offline-First** - Works without internet

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.35.0+
- Dart SDK 3.0+
- Android Studio / VS Code
- iOS: Xcode 14+ (for iOS development)

### Installation

```bash
# Clone the repository
cd mobile_app

# Install dependencies
flutter pub get

# Generate Hive adapters
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### API Keys Required

Create a `.env` file in the `mobile_app` directory:

```env
GROQ_API_KEY=your_groq_api_key_here
ELEVENLABS_API_KEY=your_elevenlabs_api_key_here
```

---

## 📱 Features

### 1. AI Companion (Farfour)
- **8 Moods**: idle, happy, thinking, excited, encouraging, talking, listening, sleeping
- **Context-Aware**: Knows your progress and adapts conversations
- **Egyptian Arabic**: Speaks in Egyptian dialect
- **Animations**: Smooth transitions and celebrations

### 2. Learning Path
- **8 Chapters**:
  1. Arabic Letters (3 stages)
  2. English Letters (2 stages)
  3. Arabic Words (2 stages)
  4. English Words (1 stage)
  5. Numbers (2 stages)
  6. Colors & Shapes (2 stages)
  7. Reading (2 stages)
  8. Advanced Skills (3 stages)

- **20+ Stages** with progressive difficulty
- **Star System**: Earn 1-3 stars per stage
- **Unlocking**: Complete stages to unlock new ones

### 3. Story Mode
- **5 Egyptian Stories**:
  - Color Adventure in Cairo
  - Number Adventure at Pyramids
  - Letter Hunt in Alexandria
  - Shape Mystery at Museum
  - Maze Adventure in Khan El-Khalili

- **AI Generation**: Create new stories using Groq
- **Interactive Choices**: Make decisions in stories
- **Farfour Integration**: Character appears in stories

### 4. Friend Mode
- **Speech-to-Speech**: Talk to Farfour using voice
- **Context-Aware**: Conversations based on your progress
- **Conversation History**: Saved locally
- **Hybrid AI**: Cloud (Groq + ElevenLabs) with local fallback

### 5. Assessment System
- **Multiple Types**: Multiple choice, matching, fill-in-blank, speaking
- **Adaptive Difficulty**: Easy, medium, hard
- **Question Generation**: Letters, numbers, colors, words
- **Egyptian Arabic Feedback**: Encouraging messages

### 6. Journey Map
- **Visual Path**: See all chapters and stages
- **Color-Coded**: Each chapter has unique color
- **Progress Bars**: Track completion per chapter
- **Star Display**: See stars earned per stage

---

## 🏗️ Architecture

### Project Structure

```
mobile_app/
├── lib/
│   ├── core/                    # Core functionality
│   │   ├── ai/                  # AI orchestration
│   │   ├── character/           # Farfour character system
│   │   ├── config/              # Configuration
│   │   └── game/                # Game logic
│   ├── data/                    # Data layer
│   │   ├── curriculum/          # Learning curriculum
│   │   └── models/              # Data models
│   ├── features/                # Feature modules
│   │   └── story_mode/          # Story generation & playback
│   ├── models/                  # Hive models
│   ├── screens/                 # UI screens
│   ├── services/                # Services
│   │   └── ai/                  # AI services (Groq, ElevenLabs)
│   ├── theme/                   # Design system
│   ├── utils/                   # Utilities
│   ├── widgets/                 # Reusable widgets
│   └── main.dart                # App entry point
├── assets/                      # Assets
│   ├── images/
│   ├── animations/
│   ├── sounds/
│   └── voices/
└── pubspec.yaml                 # Dependencies
```

### Key Technologies

#### State Management
- **Provider**: Legacy services
- **Riverpod**: New features (Farfour, etc.)

#### Persistence
- **Hive**: Local database for offline-first
- **SharedPreferences**: Simple key-value storage

#### AI Services
- **Groq**: Speech-to-Text (Whisper) + LLM (LLaMA 3.3 70B)
- **ElevenLabs**: Text-to-Speech
- **Local AI**: Fallback for offline mode

#### UI/UX
- **Material 3**: Modern design system
- **Flutter Animate**: Smooth animations
- **Confetti**: Celebration effects
- **Vibration**: Haptic feedback

---

## 🎨 Design System

### Colors
- **Primary**: Egyptian Blue (#2196F3)
- **Secondary**: Egyptian Gold (#FFB300)
- **Background**: Beige (#F5F5DC)
- **8 Chapter Colors**: Unique color per chapter

### Typography
- **30+ Text Styles**: Display, Headline, Title, Body, Label
- **Arabic-Optimized**: Larger sizes for readability
- **Responsive**: Adapts to screen size

### Components
- **SmartinoButton**: 7 types, 3 sizes, animations
- **SmartinoCard**: 4 types + specialized cards
- **Celebration Effects**: Confetti, haptics, animations

---

## 🔧 Configuration

### AI Mode
Configure in `lib/core/config/groq_config.dart` and `lib/core/config/elevenlabs_config.dart`:

```dart
// Cloud mode (default)
AIMode.cloud

// Local mode (offline)
AIMode.local

// Hybrid mode (automatic fallback)
AIMode.hybrid
```

### Egyptian Arabic
System prompt configured for Egyptian dialect in `GroqConfig`:

```dart
static const String systemPrompt = '''
أنت فرفور، صديق الأطفال المصريين...
تتكلم باللهجة المصرية...
''';
```

---

## 📊 Progress Tracking

### Star System
- **3 Stars**: 90%+ accuracy, <3 mistakes
- **2 Stars**: 70%+ accuracy, <5 mistakes
- **1 Star**: Completed (50%+ accuracy)

### Statistics
- Total stars earned
- Completion percentage
- Stages completed
- Best times
- Accuracy tracking

---

## 🧪 Testing

### Run Tests

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget_test.dart

# Integration tests
flutter test integration_test/
```

### Test Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 🚢 Deployment

### Build for Android

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

### Build for iOS

```bash
# Debug
flutter build ios --debug

# Release
flutter build ios --release
```

### Build for Web

```bash
flutter build web --release
```

---

## 📖 API Documentation

### AIOrchestrator

```dart
final aiOrchestrator = Provider.of<AIOrchestrator>(context);

// Process voice input
final result = await aiOrchestrator.processVoiceInput(
  audioBytes,
  context: {'game': 'color_learning', 'stage': 1},
);
```

### ProgressionManager

```dart
final progressionManager = Provider.of<ProgressionManager>(context);

// Check if stage is unlocked
bool isUnlocked = progressionManager.isStageUnlocked('chapter_1', 1);

// Update progress
await progressionManager.updateStageProgress(
  stageId: 'chapter_1_stage_1',
  stars: 3,
  correctAnswers: 9,
  totalQuestions: 10,
  timeTaken: Duration(minutes: 2),
);
```

### StoryGenerator

```dart
final storyGenerator = Provider.of<StoryGenerator>(context);

// Generate story
final story = await storyGenerator.generateGameRelatedStory(
  gameName: 'color_learning',
  difficulty: 'easy',
);
```

---

## 🤝 Contributing

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `flutter analyze` before committing
- Format code with `flutter format .`

### Commit Messages
```
feat: Add new feature
fix: Fix bug
docs: Update documentation
style: Format code
refactor: Refactor code
test: Add tests
chore: Update dependencies
```

---

## 📄 License

This project is part of a graduation project.

---

## 👥 Team

- **Lead Architect**: System Architect
- **AI Integration**: AI Engineer
- **UI/UX Design**: UI/UX Designer
- **Flutter Development**: Flutter Developer

---

## 📞 Support

For issues or questions:
1. Check the documentation in `.kiro/specs/smartino-super-app/`
2. Review the implementation status
3. Contact the development team

---

## 🎓 Academic Context

This project is a **graduation project** demonstrating:
- Advanced AI integration
- Educational technology
- Cultural adaptation
- Mobile app development
- Clean architecture
- User experience design

---

## 🔮 Future Enhancements

### Planned Features
- [ ] 5 Antura games (Unity → Flutter)
- [ ] 2 Singles games integration
- [ ] Complete Parent Dashboard
- [ ] Performance optimization
- [ ] Comprehensive testing
- [ ] Full documentation
- [ ] Store deployment

### Potential Additions
- [ ] Multiplayer mode
- [ ] Social sharing
- [ ] Achievements system
- [ ] Leaderboards
- [ ] More story themes
- [ ] Additional languages

---

## 📈 Version History

### v2.0.0 (Current)
- ✅ Complete AI integration
- ✅ Learning path system
- ✅ Story mode
- ✅ Design system
- ✅ Friend Mode
- ✅ Journey Map

### v1.0.0 (Legacy)
- Basic game functionality
- Simple AI integration
- Initial UI

---

## 🙏 Acknowledgments

- **Groq**: For AI services (Whisper, LLaMA)
- **ElevenLabs**: For TTS services
- **Flutter Team**: For the amazing framework
- **Antura Project**: For educational game inspiration
- **Egyptian Culture**: For story themes and context

---

**Built with ❤️ for Egyptian children**

**صُنع بحب للأطفال المصريين** 🇪🇬

