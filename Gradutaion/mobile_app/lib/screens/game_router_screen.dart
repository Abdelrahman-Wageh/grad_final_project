import 'package:flutter/material.dart';
import 'package:smartino/screens/games/color_learning_game.dart';
import 'package:smartino/screens/games/number_learning_game.dart';
import 'package:smartino/screens/games/shape_learning_game.dart';
import 'package:smartino/screens/games/drawing_game.dart';
import 'package:smartino/screens/games/memory_game.dart';
import 'package:smartino/screens/games/forest_adventure_game.dart';
import 'package:smartino/screens/games/animal_sounds_game.dart';
import 'package:smartino/screens/games/story_time_game.dart';

/// Game Router Screen - Routes to specific game implementations
class GameRouterScreen extends StatelessWidget {
  const GameRouterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String gameId = ModalRoute.of(context)!.settings.arguments as String;
    final String childName = 'صديقي'; // Default child name, should come from profile

    // Route to appropriate game based on gameId
    switch (gameId) {
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
                Icon(Icons.error_outline, size: 80, color: Colors.red),
                SizedBox(height: 20),
                Text(
                  'عذراً، هذه اللعبة غير متوفرة حالياً',
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
