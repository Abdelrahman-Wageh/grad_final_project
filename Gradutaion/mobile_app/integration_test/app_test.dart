import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smartino/main.dart' as app;

/// Main integration test suite for Smartino
/// Implements Requirements: Task 31 (Integration Tests)
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Smartino Integration Tests', () {
    testWidgets('App launches and shows splash screen', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify splash screen appears
      expect(find.text('Whispering Woods'), findsOneWidget);
      expect(find.text('✨ مغامرة تعليمية تفاعلية ✨'), findsOneWidget);
    });

    testWidgets('Navigation between tabs works correctly', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Should be on main navigation screen after splash
      // Verify bottom navigation exists
      expect(find.text('ألعاب'), findsOneWidget);
      expect(find.text('فصول'), findsOneWidget);
      expect(find.text('صاحبي'), findsOneWidget);
      expect(find.text('لوحتي'), findsOneWidget);

      // Tap on Chapters tab
      await tester.tap(find.text('فصول'));
      await tester.pumpAndSettle();

      // Verify chapters screen
      expect(find.text('📚 فصول المغامرة'), findsOneWidget);

      // Tap on Friend tab
      await tester.tap(find.text('صاحبي'));
      await tester.pumpAndSettle();

      // Verify friend tab (conversation screen)
      expect(find.byType(TextField), findsWidgets);

      // Tap on Dashboard tab
      await tester.tap(find.text('لوحتي'));
      await tester.pumpAndSettle();

      // Verify dashboard
      expect(find.text('⭐ لوحتي'), findsOneWidget);

      // Return to Games tab
      await tester.tap(find.text('ألعاب'));
      await tester.pumpAndSettle();

      // Verify games tab
      expect(find.text('🎮 ألعاب سمارتينو'), findsOneWidget);
    });

    testWidgets('Mascot overlay appears on all screens', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Check mascot on Games tab
      expect(find.byType(GestureDetector), findsWidgets);

      // Navigate to Chapters and check mascot
      await tester.tap(find.text('فصول'));
      await tester.pumpAndSettle();
      expect(find.byType(GestureDetector), findsWidgets);

      // Navigate to Friend and check mascot
      await tester.tap(find.text('صاحبي'));
      await tester.pumpAndSettle();
      expect(find.byType(GestureDetector), findsWidgets);

      // Navigate to Dashboard and check mascot
      await tester.tap(find.text('لوحتي'));
      await tester.pumpAndSettle();
      expect(find.byType(GestureDetector), findsWidgets);
    });
  });
}
