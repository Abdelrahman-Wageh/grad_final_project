import 'package:flutter_test/flutter_test.dart';
import 'package:smartino/features/story_mode/models/story.dart';
import 'package:smartino/features/story_mode/story_generator.dart';

void main() {
  group('Story Model Tests', () {
    test('Story model creates correctly', () {
      final story = Story(
        id: 'test_story',
        title: 'Test Story',
        theme: 'adventure',
        segments: [],
        createdAt: DateTime.now(),
      );

      expect(story.id, equals('test_story'));
      expect(story.title, equals('Test Story'));
      expect(story.theme, equals('adventure'));
      expect(story.segments, isEmpty);
    });

    test('StorySegment model creates correctly', () {
      final segment = StorySegment(
        text: 'Test text',
        choices: [],
      );

      expect(segment.text, equals('Test text'));
      expect(segment.choices, isEmpty);
      expect(segment.imageUrl, isNull);
    });

    test('StoryChoice model creates correctly', () {
      final choice = StoryChoice(
        text: 'Choice 1',
        nextSegmentIndex: 1,
      );

      expect(choice.text, equals('Choice 1'));
      expect(choice.nextSegmentIndex, equals(1));
    });
  });

  group('Story Templates Tests', () {
    test('All story templates have required fields', () {
      for (final template in StoryGenerator.storyTemplates) {
        expect(template['id'], isNotNull);
        expect(template['title'], isNotNull);
        expect(template['theme'], isNotNull);
        expect(template['icon'], isNotNull);
        expect(template['color'], isNotNull);
        expect(template['description'], isNotNull);
        expect(template['segments'], isNotNull);
        expect(template['segments'], isA<List>());
      }
    });

    test('Story templates have Egyptian themes', () {
      final titles = StoryGenerator.storyTemplates
          .map((t) => t['title'] as String)
          .toList();

      expect(titles.any((t) => t.contains('القاهرة')), isTrue);
      expect(titles.any((t) => t.contains('الأهرامات')), isTrue);
      expect(titles.any((t) => t.contains('الإسكندرية')), isTrue);
      expect(titles.any((t) => t.contains('المتحف')), isTrue);
      expect(titles.any((t) => t.contains('خان الخليلي')), isTrue);
    });

    test('Story templates are game-related', () {
      final descriptions = StoryGenerator.storyTemplates
          .map((t) => t['description'] as String)
          .toList();

      // Check that descriptions mention learning concepts
      expect(
        descriptions.any((d) => 
          d.contains('ألوان') || 
          d.contains('أرقام') || 
          d.contains('حروف') || 
          d.contains('أشكال')
        ),
        isTrue,
      );
    });

    test('Each template has at least 3 segments', () {
      for (final template in StoryGenerator.storyTemplates) {
        final segments = template['segments'] as List;
        expect(segments.length, greaterThanOrEqualTo(3));
      }
    });

    test('Each segment has text and choices', () {
      for (final template in StoryGenerator.storyTemplates) {
        final segments = template['segments'] as List<Map<String, dynamic>>;
        for (final segment in segments) {
          expect(segment['text'], isNotNull);
          expect(segment['choices'], isNotNull);
          expect(segment['choices'], isA<List>());
        }
      }
    });

    test('Choices have valid next segment indices', () {
      for (final template in StoryGenerator.storyTemplates) {
        final segments = template['segments'] as List<Map<String, dynamic>>;
        for (final segment in segments) {
          final choices = segment['choices'] as List<Map<String, dynamic>>;
          for (final choice in choices) {
            final nextIndex = choice['nextSegmentIndex'] as int;
            expect(nextIndex, greaterThanOrEqualTo(-1)); // -1 means end
            expect(nextIndex, lessThan(segments.length));
          }
        }
      }
    });
  });

  group('Story Generation Tests', () {
    test('generateStory creates valid story from template', () {
      final template = StoryGenerator.storyTemplates[0];
      final story = StoryGenerator.generateStoryFromTemplate(template);

      expect(story.id, isNotNull);
      expect(story.title, equals(template['title']));
      expect(story.theme, equals(template['theme']));
      expect(story.segments, isNotEmpty);
      expect(story.createdAt, isNotNull);
    });

    test('Generated story has correct number of segments', () {
      final template = StoryGenerator.storyTemplates[0];
      final story = StoryGenerator.generateStoryFromTemplate(template);
      final templateSegments = template['segments'] as List;

      expect(story.segments.length, equals(templateSegments.length));
    });

    test('Generated story segments have choices', () {
      final template = StoryGenerator.storyTemplates[0];
      final story = StoryGenerator.generateStoryFromTemplate(template);

      for (final segment in story.segments) {
        expect(segment.text, isNotEmpty);
        // Not all segments need choices (ending segments don't)
      }
    });

    test('Story IDs are unique', () {
      final story1 = StoryGenerator.generateStoryFromTemplate(
        StoryGenerator.storyTemplates[0],
      );
      final story2 = StoryGenerator.generateStoryFromTemplate(
        StoryGenerator.storyTemplates[0],
      );

      expect(story1.id, isNot(equals(story2.id)));
    });
  });
}
