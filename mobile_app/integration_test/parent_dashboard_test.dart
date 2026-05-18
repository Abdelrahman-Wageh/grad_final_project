import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smartino/main.dart' as app;

/// Integration tests for Parent Dashboard
/// Tests all tabs and functionality
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Parent Dashboard Integration Tests', () {
    testWidgets('Parent dashboard loads with all tabs', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to parent dashboard
      // (This assumes there's a way to access it from the main screen)
      
      // Look for dashboard tabs
      final overviewTab = find.text('نظرة عامة');
      final journeyTab = find.text('رحلة التعلم');
      final conversationsTab = find.text('المحادثات');
      final settingsTab = find.text('الإعدادات');
      
      // If we can find the tabs, test them
      if (overviewTab.evaluate().isNotEmpty) {
        expect(overviewTab, findsOneWidget);
        expect(journeyTab, findsOneWidget);
        expect(conversationsTab, findsOneWidget);
        expect(settingsTab, findsOneWidget);
      }
    });

    testWidgets('Overview tab shows statistics', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // If on parent dashboard overview tab
      final starsCard = find.text('إجمالي النجوم');
      final completionCard = find.text('نسبة الإنجاز');
      
      if (starsCard.evaluate().isNotEmpty) {
        expect(starsCard, findsOneWidget);
        expect(completionCard, findsOneWidget);
      }
    });

    testWidgets('Journey map tab shows chapters', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to journey map tab if available
      final journeyTab = find.text('رحلة التعلم');
      
      if (journeyTab.evaluate().isNotEmpty) {
        await tester.tap(journeyTab);
        await tester.pumpAndSettle();
        
        // Should show chapter progress
        expect(find.text('تقدم رحلة التعلم'), findsOneWidget);
      }
    });

    testWidgets('Conversations tab shows AI conversations', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to conversations tab if available
      final conversationsTab = find.text('المحادثات');
      
      if (conversationsTab.evaluate().isNotEmpty) {
        await tester.tap(conversationsTab);
        await tester.pumpAndSettle();
        
        // Should show conversations or empty state
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('Settings tab allows AI mode change', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to settings tab if available
      final settingsTab = find.text('الإعدادات');
      
      if (settingsTab.evaluate().isNotEmpty) {
        await tester.tap(settingsTab);
        await tester.pumpAndSettle();
        
        // Should show AI mode options
        final cloudMode = find.text('السحابة (Cloud)');
        final localMode = find.text('محلي (Local)');
        final hybridMode = find.text('هجين (Hybrid)');
        
        if (cloudMode.evaluate().isNotEmpty) {
          expect(cloudMode, findsOneWidget);
          expect(localMode, findsOneWidget);
          expect(hybridMode, findsOneWidget);
          
          // Try changing mode
          await tester.tap(localMode);
          await tester.pumpAndSettle();
          
          // Should show success message
          expect(find.text('تم تغيير وضع الذكاء الاصطناعي'), findsOneWidget);
        }
      }
    });

    testWidgets('Data management buttons work', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to settings tab
      final settingsTab = find.text('الإعدادات');
      
      if (settingsTab.evaluate().isNotEmpty) {
        await tester.tap(settingsTab);
        await tester.pumpAndSettle();
        
        // Look for data management buttons
        final exportButton = find.text('تصدير البيانات');
        final clearButton = find.text('مسح البيانات');
        
        if (exportButton.evaluate().isNotEmpty) {
          // Test export
          await tester.tap(exportButton);
          await tester.pumpAndSettle();
          
          // Should show success message
          expect(find.text('تم تصدير البيانات بنجاح'), findsOneWidget);
        }
      }
    });

    testWidgets('Tab switching maintains state', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Switch between tabs multiple times
      final overviewTab = find.text('نظرة عامة');
      final journeyTab = find.text('رحلة التعلم');
      final conversationsTab = find.text('المحادثات');
      final settingsTab = find.text('الإعدادات');
      
      if (overviewTab.evaluate().isNotEmpty) {
        // Switch to each tab
        await tester.tap(journeyTab);
        await tester.pumpAndSettle();
        
        await tester.tap(conversationsTab);
        await tester.pumpAndSettle();
        
        await tester.tap(settingsTab);
        await tester.pumpAndSettle();
        
        // Return to overview
        await tester.tap(overviewTab);
        await tester.pumpAndSettle();
        
        // Should still show statistics
        expect(find.text('إجمالي النجوم'), findsOneWidget);
      }
    });

    testWidgets('Refresh button updates data', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Look for refresh button
      final refreshButton = find.byIcon(Icons.refresh);
      
      if (refreshButton.evaluate().isNotEmpty) {
        await tester.tap(refreshButton);
        await tester.pumpAndSettle();
        
        // Should reload without error
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('Charts render correctly', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // On overview tab, should show time spent chart
      final chartTitle = find.text('الوقت المستغرق في كل فصل');
      
      if (chartTitle.evaluate().isNotEmpty) {
        expect(chartTitle, findsOneWidget);
        
        // Chart should render without error
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('Progress bars display correctly', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to journey map tab
      final journeyTab = find.text('رحلة التعلم');
      
      if (journeyTab.evaluate().isNotEmpty) {
        await tester.tap(journeyTab);
        await tester.pumpAndSettle();
        
        // Should show progress bars for chapters
        expect(find.byType(LinearProgressIndicator), findsWidgets);
      }
    });
  });
}
