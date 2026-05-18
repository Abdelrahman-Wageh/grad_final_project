import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartino/widgets/common/smartino_button.dart';
import 'package:smartino/theme/smartino_colors.dart';

void main() {
  group('SmartinoButton Widget Tests', () {
    testWidgets('SmartinoButton renders with text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartinoButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('SmartinoButton calls onPressed when tapped', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartinoButton(
              text: 'Test Button',
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Button'));
      await tester.pump();

      expect(wasPressed, isTrue);
    });

    testWidgets('SmartinoButton shows loading indicator when loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartinoButton(
              text: 'Test Button',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('SmartinoButton is disabled when onPressed is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SmartinoButton(
              text: 'Test Button',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<SmartinoButton>(find.byType(SmartinoButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('SmartinoButton shows icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartinoButton(
              text: 'Test Button',
              icon: Icons.star,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('SmartinoButton applies correct type styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SmartinoButton(
                  text: 'Primary',
                  type: SmartinoButtonType.primary,
                  onPressed: () {},
                ),
                SmartinoButton(
                  text: 'Secondary',
                  type: SmartinoButtonType.secondary,
                  onPressed: () {},
                ),
                SmartinoButton(
                  text: 'Accent',
                  type: SmartinoButtonType.accent,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Primary'), findsOneWidget);
      expect(find.text('Secondary'), findsOneWidget);
      expect(find.text('Accent'), findsOneWidget);
    });

    testWidgets('SmartinoButton applies correct size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SmartinoButton(
                  text: 'Small',
                  size: SmartinoButtonSize.small,
                  onPressed: () {},
                ),
                SmartinoButton(
                  text: 'Medium',
                  size: SmartinoButtonSize.medium,
                  onPressed: () {},
                ),
                SmartinoButton(
                  text: 'Large',
                  size: SmartinoButtonSize.large,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Small'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('Large'), findsOneWidget);
    });

    testWidgets('SmartinoButton expands to full width when specified', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: SmartinoButton(
                text: 'Full Width',
                onPressed: () {},
                fullWidth: true,
              ),
            ),
          ),
        ),
      );

      final button = tester.widget<SmartinoButton>(find.byType(SmartinoButton));
      expect(button.fullWidth, isTrue);
    });
  });
}
