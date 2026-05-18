import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartino/widgets/character/farfour_widget.dart';
import 'package:smartino/core/character/farfour_controller.dart';

void main() {
  group('FarfourWidget Tests', () {
    testWidgets('FarfourWidget renders without error', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: FarfourWidget(),
            ),
          ),
        ),
      );

      expect(find.byType(FarfourWidget), findsOneWidget);
    });

    testWidgets('FarfourWidget shows character container', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: FarfourWidget(),
            ),
          ),
        ),
      );

      // Should find a container for the character
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('FarfourWidget responds to tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: FarfourWidget(),
            ),
          ),
        ),
      );

      // Tap on the widget
      await tester.tap(find.byType(FarfourWidget));
      await tester.pump();

      // Widget should handle tap without error
      expect(tester.takeException(), isNull);
    });

    testWidgets('FarfourWidget has correct size', (WidgetTester tester) async {
      const testSize = 150.0;

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: FarfourWidget(
                size: testSize,
              ),
            ),
          ),
        ),
      );

      final widget = tester.widget<FarfourWidget>(find.byType(FarfourWidget));
      expect(widget.size, equals(testSize));
    });
  });

  group('FarfourMood Tests', () {
    test('FarfourMood enum has all required moods', () {
      expect(FarfourMood.values.length, equals(8));
      expect(FarfourMood.values, contains(FarfourMood.idle));
      expect(FarfourMood.values, contains(FarfourMood.happy));
      expect(FarfourMood.values, contains(FarfourMood.thinking));
      expect(FarfourMood.values, contains(FarfourMood.excited));
      expect(FarfourMood.values, contains(FarfourMood.encouraging));
      expect(FarfourMood.values, contains(FarfourMood.talking));
      expect(FarfourMood.values, contains(FarfourMood.listening));
      expect(FarfourMood.values, contains(FarfourMood.sleeping));
    });

    test('FarfourMood has correct emoji representations', () {
      expect(FarfourMood.idle.emoji, equals('😊'));
      expect(FarfourMood.happy.emoji, equals('😄'));
      expect(FarfourMood.thinking.emoji, equals('🤔'));
      expect(FarfourMood.excited.emoji, equals('🤩'));
      expect(FarfourMood.encouraging.emoji, equals('💪'));
      expect(FarfourMood.talking.emoji, equals('🗣️'));
      expect(FarfourMood.listening.emoji, equals('👂'));
      expect(FarfourMood.sleeping.emoji, equals('😴'));
    });

    test('FarfourMood has correct Arabic names', () {
      expect(FarfourMood.idle.arabicName, equals('عادي'));
      expect(FarfourMood.happy.arabicName, equals('سعيد'));
      expect(FarfourMood.thinking.arabicName, equals('يفكر'));
      expect(FarfourMood.excited.arabicName, equals('متحمس'));
      expect(FarfourMood.encouraging.arabicName, equals('مشجع'));
      expect(FarfourMood.talking.arabicName, equals('يتكلم'));
      expect(FarfourMood.listening.arabicName, equals('يستمع'));
      expect(FarfourMood.sleeping.arabicName, equals('نائم'));
    });
  });
}
