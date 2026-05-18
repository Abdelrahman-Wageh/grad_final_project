# Whispering Woods Mobile App - Flutter

## Overview
This is the Flutter mobile application for the Whispering Woods educational adventure game. It provides an interactive AI-powered learning experience for children ages 4-8.

## Features
- Voice interaction with AI companion
- Drawing recognition
- Multiple educational games
- Parent dashboard with PIN protection
- Offline mode support
- Multi-platform (Android, iOS, Web)

## Prerequisites
- Flutter SDK 3.35.0 or higher (3.35.7 recommended)
- Dart SDK 3.9.0 or higher (3.9.2 recommended)
- Android Studio (for Android development)
- Xcode (for iOS development, macOS only)

## Installation

### 1. Install Dependencies
```bash
cd mobile_app
flutter pub get
```

### 2. Run on Different Platforms

#### Chrome/Web
```bash
flutter run -d chrome
```

#### Android Emulator
```bash
# First, start an emulator
flutter emulators --launch Pixel_3a_API_34

# Then run the app
flutter run
```

#### Physical Android Device
```bash
# Connect device via USB with USB debugging enabled
flutter run
```

#### iOS Simulator (macOS only)
```bash
flutter run -d ios
```

## Configuration

### API Endpoints
The app automatically configures the backend URL based on the platform:
- **Android Emulator**: `http://10.0.2.2:8000`
- **iOS Simulator/Web**: `http://localhost:8000`
- **Physical Device**: Configure in `lib/utils/app_constants.dart`

### Dry-Run Mode
Set `enableDryRun = true` in `lib/utils/app_constants.dart` to use placeholder responses without a backend.

## Project Structure
```
mobile_app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/                      # Data models
│   │   ├── game_state.dart
│   │   └── interaction_log.dart
│   ├── screens/                     # App screens
│   │   ├── splash_screen.dart
│   │   ├── home_screen.dart
│   │   ├── character_selection_screen.dart
│   │   ├── game_screen.dart
│   │   ├── parent_dashboard.dart
│   │   └── self_test_screen.dart
│   ├── services/                    # Business logic
│   │   ├── api_client.dart          # API communication
│   │   ├── ai_service.dart          # AI interaction
│   │   ├── game_service.dart        # Game state management
│   │   └── storage_service.dart     # Local storage
│   ├── widgets/                     # Reusable widgets
│   │   ├── ai_companion_widget.dart
│   │   ├── character_animation.dart
│   │   ├── game_world.dart
│   │   ├── progress_indicator.dart
│   │   └── voice_button.dart
│   └── utils/
│       └── app_constants.dart       # App configuration
├── assets/                          # Static assets
│   ├── images/
│   ├── animations/
│   ├── sounds/
│   ├── voices/
│   └── fonts/
└── pubspec.yaml                     # Dependencies

```

## Key Features

### 1. Voice Interaction
- Real-time voice recording
- Speech-to-text processing
- Text-to-speech responses
- Egyptian Arabic support

### 2. Drawing Recognition
- Canvas for drawing
- AI-powered recognition
- Educational challenges
- Instant feedback

### 3. Multiple Games
- Forest Adventure
- Number Gate Puzzle
- Color Learning
- Shape Recognition
- And more...

### 4. Parent Dashboard
- PIN-protected access (default: 1234)
- View play time statistics
- Check interaction logs
- Monitor progress
- Configure settings

### 5. Offline Mode
- Automatic fallback when backend is unavailable
- Cached responses
- Local game logic
- Sync when online

## Building for Production

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (macOS only)
```bash
flutter build ios --release
# Then open Xcode to archive and upload
```

### Web
```bash
flutter build web --release
# Output: build/web/
```

## Testing

### Run Tests
```bash
flutter test
```

### Run Self-Test Screen (Debug builds only)
Navigate to `/self-test` route in debug builds to test backend connectivity.

## Permissions

### Android
- `INTERNET` - Network communication
- `RECORD_AUDIO` - Voice recording
- `WRITE_EXTERNAL_STORAGE` - Save drawings
- `READ_EXTERNAL_STORAGE` - Load resources

### iOS
- Microphone access - Voice recording
- Internet access - Backend communication

## Troubleshooting

### Backend Connection Issues

#### Android Emulator
Make sure the backend is accessible at `http://10.0.2.2:8000`:
```bash
adb reverse tcp:8000 tcp:8000
```

#### Physical Device
1. Connect device to same WiFi as development machine
2. Update `app_constants.dart` with your computer's IP address:
```dart
static String get apiBaseUrl {
  return 'http://YOUR_IP_ADDRESS:8000';
}
```

### Dependency Issues
```bash
# Clean and reinstall
flutter clean
flutter pub get
```

### Build Issues
```bash
# Update Flutter
flutter upgrade

# Check for issues
flutter doctor -v
```

## Assets

### Required Assets
Due to the empty asset folders, you'll need to add:

#### Images (`assets/images/`)
- Character avatars (bird, cat, dog, etc.)
- Game backgrounds
- UI elements

#### Animations (`assets/animations/`)
- Lottie JSON animations
- Character animations

#### Sounds (`assets/sounds/`)
- Button clicks
- Success sounds
- Background music

#### Voices (`assets/voices/`)
- Sample voice recordings
- Tutorial audio

#### Fonts (`assets/fonts/`)
- `KidsFont-Regular.ttf`
- `KidsFont-Bold.ttf`

You can use placeholder assets or download free resources from:
- Images: [Freepik](https://www.freepik.com/)
- Animations: [LottieFiles](https://lottiefiles.com/)
- Sounds: [Freesound](https://freesound.org/)
- Fonts: [Google Fonts](https://fonts.google.com/)

## Development Tips

### Hot Reload
Press `r` in terminal while app is running to hot reload changes.

### Debug Mode
The app includes a self-test screen accessible via `/self-test` route in debug builds.

### Logging
All API calls are logged to console in debug builds.

## Support
For issues or questions, please refer to the main project README or create an issue on GitHub.

## License
MIT License - See main project LICENSE file

