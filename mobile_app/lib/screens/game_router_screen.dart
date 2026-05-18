import 'package:flutter/material.dart';
import 'package:smartino/screens/games/color_learning_game.dart';
import 'package:smartino/screens/games/number_learning_game.dart';
import 'package:smartino/screens/games/shape_learning_game.dart';
import 'package:smartino/screens/games/drawing_game.dart';
import 'package:smartino/screens/games/memory_game.dart';
import 'package:smartino/screens/games/forest_adventure_game.dart';
import 'package:smartino/screens/games/animal_sounds_game.dart';
import 'package:smartino/screens/games/story_time_game.dart';

// New game imports
import '../features/games/letter_balloons_game.dart';
import '../features/games/fast_crowd_game.dart';
import '../features/games/missing_letter_game.dart';
import '../features/games/mixed_letters_game.dart';
import '../features/games/reading_game.dart';

import '../features/story_mode/screens/story_player_screen.dart';
import '../features/story_mode/models/story.dart';

/// Game Router Screen - Routes to specific game implementations
class GameRouterScreen extends StatelessWidget {
  const GameRouterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    
    String gameId = '';
    String stageId = '';
    String profileId = 'default';

    if (args is String) {
      gameId = args;
    } else if (args is Map<String, dynamic>) {
      gameId = args['gameType'] ?? args['gameId'] ?? '';
      stageId = args['stageId'] ?? '';
      profileId = args['profileId'] ?? 'default';
    }

    final String childName = 'صديقي'; // Default child name, should come from profile

    // Route to appropriate game based on gameId
    switch (gameId) {
      // Original Games
      case 'color_learning':
        return ColorLearningGame(childName: childName);
      case 'number_learning':
        return NumberLearningGame(childName: childName);
      case 'shape_learning':
        return ShapeLearningGame(childName: childName);
      case 'drawing_game':
        return DrawingGame(childName: childName);
      case 'memory_game':
        return MemoryGame(childName: childName);
      case 'animal_sounds':
        return AnimalSoundsGame(childName: childName);
      case 'story_time':
        return StoryTimeGame(childName: childName);
      case 'forest_adventure':
        return ForestAdventureGame(childName: childName);
      
      // Antura Games
      case 'balloons':
        return LetterBalloonsGame(
          stageId: stageId,
          targetLetters: ['أ', 'ب', 'ت'], // This would ideally come from the stage config
        );
      case 'fast_crowd':
        return FastCrowdGame(
          stageId: stageId,
          targetLetters: ['ا', 'ل', 'م'],
        );
      case 'missing_letter':
        return MissingLetterGame(
          stageId: stageId,
          targetLetters: ['ا', 'و', 'ي'],
        );
      case 'mixed_letters':
        return MixedLettersGame(
          stageId: stageId,
          targetLetters: ['ك', 'ت', 'ب'],
        );
      case 'reading_game':
        return ReadingGame(
          stageId: stageId,
          targetLetters: ['أ', 'ب'],
        );
      
      case 'storytelling':
        String? storyId;
        if (args is Map<String, dynamic>) {
          final games = args['games'] as List?;
          if (games != null && games.isNotEmpty) {
            storyId = games[0] as String?;
          }
        }
        final story = EgyptianStoryTemplates.getAllTemplates().firstWhere(
          (s) => s.id == storyId,
          orElse: () => EgyptianStoryTemplates.alefBigDream(),
        );
        return StoryPlayerScreen(story: story);
      
      default:
        // Fallback for unknown game IDs
        return Scaffold(
          appBar: AppBar(
            title: Text('لعبة غير متوفرة', textDirection: TextDirection.rtl),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.blue),
                SizedBox(height: 20),
                Text(
                  'عذراً، هذه اللعبة جاري تطويرها: $gameId',
                  style: TextStyle(fontSize: 20),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('العودة', textDirection: TextDirection.rtl),
                ),
              ],
            ),
          ),
        );
    }
  }
}
