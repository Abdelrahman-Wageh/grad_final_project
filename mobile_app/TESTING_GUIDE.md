# Smartino Super-App - Testing Guide

**Last Updated**: January 26, 2026  
**Test Coverage**: Unit Tests, Widget Tests, Integration Tests

---

## 📋 TABLE OF CONTENTS

1. [Overview](#overview)
2. [Test Structure](#test-structure)
3. [Running Tests](#running-tests)
4. [Test Coverage](#test-coverage)
5. [Writing New Tests](#writing-new-tests)
6. [Continuous Integration](#continuous-integration)

---

## 🎯 OVERVIEW

The Smartino Super-App uses a comprehensive testing strategy to ensure quality and reliability:

- **Unit Tests**: Test individual functions and classes
- **Widget Tests**: Test UI components in isolation
- **Integration Tests**: Test complete user flows

### Testing Philosophy

1. **Test Behavior, Not Implementation**: Focus on what the code does, not how
2. **Keep Tests Simple**: Each test should verify one thing
3. **Use Descriptive Names**: Test names should explain what they test
4. **Maintain Independence**: Tests should not depend on each other
5. **Mock External Dependencies**: Use mocks for API calls, databases, etc.

---

## 📁 TEST STRUCTURE

```
mobile_app/
├── test/                           # Unit and Widget Tests
│   ├── services/                   # Service Tests
│   │   ├── groq_service_test.dart
│   │   └── ai_orchestrator_test.dart
│   ├── core/                       # Core Logic Tests
│   │   └── progression_manager_test.dart
│   ├── features/                   # Feature Tests
│   │   └── story_generator_test.dart
│   ├── widgets/                    # Widget Tests
│   │   ├── smartino_button_test.dart
│   │   └── farfour_widget_test.dart
│   └── widget_test.dart           # Main widget test
│
└── integration_test/               # Integration Tests
    ├── app_test.dart              # Main app flow tests
    ├── parent_dashboard_test.dart # Dashboard tests
    ├── friend_tab_test.dart       # Friend mode tests
    ├── game_flow_test.dart        # Game flow tests
    └── profile_progress_test.dart # Progress tracking tests
```

---

## 🚀 RUNNING TESTS

### Prerequisites

```bash
# Ensure Flutter is installed and up to date
flutter doctor

# Get dependencies
flutter pub get
```

### Run All Tests

```bash
# Run all unit and widget tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/services/groq_service_test.dart
```

### Run Integration Tests

```bash
# Run all integration tests
flutter test integration_test

# Run specific integration test
flutter test integration_test/parent_dashboard_test.dart

# Run on connected device
flutter test integration_test --device-id=<device_id>

# Run on Chrome (web)
flutter test integration_test --platform chrome
```

### Run Tests in Watch Mode

```bash
# Install flutter_test_runner (optional)
flutter pub global activate flutter_test_runner

# Run in watch mode
flutter test --watch
```

---

## 📊 TEST COVERAGE

### Current Coverage

#### Unit Tests (Services & Core Logic)
- ✅ **GroqService**: API configuration, error handling
- ✅ **AIOrchestrator**: Mode switching, fallback logic
- ✅ **ProgressionManager**: Star calculation, unlocking logic
- ✅ **StoryGenerator**: Template validation, story generation
- ⏳ **ElevenLabsService**: TTS functionality (pending)
- ⏳ **LocalStorageService**: Data persistence (pending)

#### Widget Tests (UI Components)
- ✅ **SmartinoButton**: All button types, sizes, states
- ✅ **FarfourWidget**: Character rendering, moods
- ⏳ **SmartinoCard**: Card types, interactions (pending)
- ⏳ **JourneyMapScreen**: Chapter display, navigation (pending)
- ⏳ **StoryPlayerScreen**: Story playback, choices (pending)

#### Integration Tests (User Flows)
- ✅ **App Launch**: Splash screen, navigation
- ✅ **Tab Navigation**: All main tabs
- ✅ **Parent Dashboard**: All tabs, data display
- ⏳ **Friend Mode**: AI conversations (pending)
- ⏳ **Game Flow**: Complete game session (pending)
- ⏳ **Progress Tracking**: Star earning, unlocking (pending)

### Coverage Goals

- **Unit Tests**: 80%+ coverage
- **Widget Tests**: 70%+ coverage
- **Integration Tests**: Critical user flows covered

---

## ✍️ WRITING NEW TESTS

### Unit Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:smartino/path/to/your/class.dart';

void main() {
  group('YourClass Tests', () {
    late YourClass instance;

    setUp(() {
      // Initialize before each test
      instance = YourClass();
    });

    tearDown(() {
      // Clean up after each test
      instance.dispose();
    });

    test('should do something correctly', () {
      // Arrange
      final input = 'test input';
      
      // Act
      final result = instance.doSomething(input);
      
      // Assert
      expect(result, equals('expected output'));
    });

    test('should handle errors gracefully', () {
      // Test error cases
      expect(
        () => instance.doSomething(null),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
```

### Widget Test Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartino/widgets/your_widget.dart';

void main() {
  group('YourWidget Tests', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      // Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YourWidget(
              title: 'Test Title',
            ),
          ),
        ),
      );

      // Verify
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('handles user interaction', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YourWidget(
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      // Interact
      await tester.tap(find.byType(YourWidget));
      await tester.pump();

      // Verify
      expect(wasPressed, isTrue);
    });
  });
}
```

### Integration Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smartino/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Feature Integration Tests', () {
    testWidgets('complete user flow', (tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate
      await tester.tap(find.text('Button Text'));
      await tester.pumpAndSettle();

      // Verify
      expect(find.text('Expected Text'), findsOneWidget);
    });
  });
}
```

---

## 🔄 CONTINUOUS INTEGRATION

### GitHub Actions (Recommended)

Create `.github/workflows/test.yml`:

```yaml
name: Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.35.0'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
      working-directory: mobile_app
    
    - name: Run tests
      run: flutter test --coverage
      working-directory: mobile_app
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        files: mobile_app/coverage/lcov.info
```

### Pre-commit Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/sh

# Run tests before commit
cd mobile_app
flutter test

# Check exit code
if [ $? -ne 0 ]; then
  echo "Tests failed. Commit aborted."
  exit 1
fi

echo "All tests passed!"
exit 0
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

---

## 🐛 DEBUGGING TESTS

### Common Issues

#### 1. Test Timeout
```dart
// Increase timeout for slow tests
testWidgets('slow test', (tester) async {
  // ...
}, timeout: const Timeout(Duration(minutes: 2)));
```

#### 2. Async Issues
```dart
// Always await pumpAndSettle for animations
await tester.pumpAndSettle();

// Or use pump with duration
await tester.pump(const Duration(seconds: 1));
```

#### 3. Widget Not Found
```dart
// Print widget tree for debugging
debugDumpApp();

// Or find by type instead of text
expect(find.byType(MyWidget), findsOneWidget);
```

#### 4. Provider/Riverpod Issues
```dart
// Wrap with ProviderScope for Riverpod
await tester.pumpWidget(
  ProviderScope(
    child: MaterialApp(
      home: MyWidget(),
    ),
  ),
);
```

---

## 📈 TEST METRICS

### Running Coverage Report

```bash
# Generate coverage
flutter test --coverage

# View coverage (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Coverage Goals by Module

| Module | Current | Target |
|--------|---------|--------|
| Services | 60% | 80% |
| Core Logic | 70% | 85% |
| Widgets | 50% | 70% |
| Features | 65% | 75% |
| Overall | 60% | 75% |

---

## 🎯 TESTING BEST PRACTICES

### DO ✅

1. **Write tests first** (TDD when possible)
2. **Test edge cases** (null, empty, invalid input)
3. **Use descriptive test names** (`should return error when input is null`)
4. **Keep tests independent** (no shared state)
5. **Mock external dependencies** (API calls, databases)
6. **Test user behavior** (not implementation details)
7. **Use setUp and tearDown** (for initialization and cleanup)

### DON'T ❌

1. **Don't test Flutter framework** (it's already tested)
2. **Don't test third-party packages** (trust their tests)
3. **Don't make tests depend on each other** (order shouldn't matter)
4. **Don't use real API calls** (use mocks)
5. **Don't ignore failing tests** (fix or remove them)
6. **Don't test private methods** (test public interface)
7. **Don't write overly complex tests** (keep them simple)

---

## 📚 RESOURCES

### Official Documentation
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)

### Testing Packages
- `flutter_test`: Core testing framework
- `integration_test`: Integration testing
- `mockito`: Mocking framework
- `bloc_test`: Testing for BLoC pattern
- `golden_toolkit`: Golden file testing

### Community Resources
- [Flutter Testing Best Practices](https://flutter.dev/docs/testing/best-practices)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)

---

## 🔧 TROUBLESHOOTING

### Tests Won't Run

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter test
```

### Integration Tests Fail

```bash
# Ensure device is connected
flutter devices

# Run with verbose output
flutter test integration_test -v
```

### Coverage Not Generated

```bash
# Install lcov (macOS)
brew install lcov

# Install lcov (Ubuntu)
sudo apt-get install lcov

# Generate coverage
flutter test --coverage
```

---

## 📞 SUPPORT

For testing issues or questions:
1. Check this guide first
2. Review Flutter testing documentation
3. Search existing issues on GitHub
4. Ask in team chat or create an issue

---

**Happy Testing!** 🧪✨

Remember: Good tests lead to confident code!
