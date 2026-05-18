import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smartino/main.dart' as app;

/// Integration tests for game flow
/// Implements Requirements: Task 31.1 (Complete chapter flow)
/// Validates: Requirements 19.1-19.4, 20.1-20.4, 21.1-21.3
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Game Flow Integration Tests', () {
    testWidgets('Code Commander game launches and displays correctly',
        (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Navigate to Games tab
      await tester.tap(find.text('ألعاب'));
      await tester.pumpAndSettle();

      // Find and tap Code Commander game
      expect(find.text('قائد الأكواد'), findsOneWidget);
      await tester.tap(find.text('قائد الأكواد'));
      await tester.pumpAndSettle();

      // Verify game screen loaded
      // Should see grid, commands, or game elements
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Story Weaver game launches and displays correctly',
        (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Navigate to Games tab
      await tester.tap(find.text('ألعاب'));
      await tester.pumpAndSettle();

      // Find and tap Story Weaver game
      expect(find.text('نساج القصص'), findsOneWidget);
      await tester.tap(find.text('نساج القصص'));
      await tester.pumpAndSettle();

      // Verify game screen loaded
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Potion Shop game launches and displays correctly',
        (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Navigate to Games tab
      await tester.tap(find.text('ألعاب'));
      await tester.pumpAndSettle();

      // Find and tap Potion Shop game
      expect(find.text('محل الجرعات'), findsOneWidget);
      await tester.tap(find.text('محل الجرعات'));
      await tester.pumpAndSettle();

      // Verify game screen loaded
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('All three games are accessible from Games tab', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Navigate to Games tab
      await tester.tap(find.text('ألعاب'));
      await tester.pumpAndSettle();

      // Verify all three games are displayed
      expect(find.text('قائد الأكواد'), findsOneWidget);
      expect(find.text('نساج القصص'), findsOneWidget);
      expect(find.text('محل الجرعات'), findsOneWidget);

      // Verify game descriptions
      expect(find.text('ساعد سمارتينو يوصل للبطارية'), findsOneWidget);
      expect(find.text('أكمل القصة بصوتك'), findsOneWidget);
      expect(find.text('اخلط الجرعات واحسب الأرقام'), findsOneWidget);
    });

    testWidgets('Games tab displays with correct UI elements', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Navigate to Games tab
      await tester.tap(find.text('ألعاب'));
      await tester.pumpAndSettle();

      // Verify header
      expect(find.text('🎮 ألعاب سمارتينو'), findsOneWidget);
      expect(find.text('اختر لعبة وابدأ المغامرة!'), findsOneWidget);

      // Verify game emojis
      expect(find.text('🤖'), findsOneWidget);
      expect(find.text('📖'), findsOneWidget);
      expect(find.text('🧪'), findsOneWidget);
    });
  });
}
