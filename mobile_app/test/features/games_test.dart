/// Tests for Game System
/// 
/// Tests game registry, game creation, and game mechanics.

import 'package:flutter_test/flutter_test.dart';
import 'package:smartino/features/games/game_registry.dart';

void main() {
  group('GameRegistry Tests', () {
    test('should have all 5 games registered', () {
      expect(GameRegistry.allGames.length, 5);
    });

    test('should get game by ID', () {
      final game = GameRegistry.getGameById('letter_balloons');
      expect(game, isNotNull);
      expect(game!.nameAr, 'البالونات');
      expect(game.type, GameType.letterBalloons);
    });

    test('should return null for invalid game ID', () {
      final game = GameRegistry.getGameById('invalid_game');
      expect(game, isNull);
    });

    test('should get game by type', () {
      final game = GameRegistry.getGameByType(GameType.fastCrowd);
      expect(game, isNotNull);
      expect(game!.id, 'fast_crowd');
    });

    test('should get games for chapter 1', () {
      final games = GameRegistry.getGamesForChapter(1);
      expect(games.length, 1);
      expect(games[0].type, GameType.letterBalloons);
    });

    test('should get games for chapter 8 (all games)', () {
      final games = GameRegistry.getGamesForChapter(8);
      expect(games.length, 5);
    });

    test('should get random game', () {
      final game = GameRegistry.getRandomGame();
      expect(game, isNotNull);
      expect(GameRegistry.allGames.contains(game), true);
    });

    test('all games should have valid properties', () {
      for (final game in GameRegistry.allGames) {
        expect(game.id.isNotEmpty, true);
        expect(game.nameAr.isNotEmpty, true);
        expect(game.nameEn.isNotEmpty, true);
        expect(game.description.isNotEmpty, true);
        expect(game.targetLetters.isNotEmpty, true);
        expect(game.targetScore, greaterThan(0));
      }
    });

    test('all game IDs should be unique', () {
      final ids = GameRegistry.allGames.map((g) => g.id).toList();
      final uniqueIds = ids.toSet();
      expect(ids.length, uniqueIds.length);
    });

    test('should create game widget by type', () {
      final widget = GameRegistry.createGameByType(
        GameType.letterBalloons,
        'test_stage',
        ['أ', 'ب'],
        10,
      );
      expect(widget, isNotNull);
    });

    test('should create game by ID', () {
      final widget = GameRegistry.createGame('fast_crowd', 'test_stage');
      expect(widget, isNotNull);
    });

    test('should return null for invalid game ID in createGame', () {
      final widget = GameRegistry.createGame('invalid', 'test_stage');
      expect(widget, isNull);
    });
  });

  group('GameInfo Tests', () {
    test('should create GameInfo with all properties', () {
      const game = GameInfo(
        id: 'test_game',
        nameAr: 'لعبة تجريبية',
        nameEn: 'Test Game',
        description: 'Test description',
        icon: Icons.games,
        type: GameType.letterBalloons,
        targetLetters: ['أ', 'ب', 'ت'],
        targetScore: 15,
      );

      expect(game.id, 'test_game');
      expect(game.nameAr, 'لعبة تجريبية');
      expect(game.nameEn, 'Test Game');
      expect(game.targetScore, 15);
      expect(game.targetLetters.length, 3);
    });

    test('should use default target score', () {
      const game = GameInfo(
        id: 'test',
        nameAr: 'test',
        nameEn: 'test',
        description: 'test',
        icon: Icons.games,
        type: GameType.reading,
        targetLetters: ['أ'],
      );

      expect(game.targetScore, 10);
    });
  });

  group('GameType Tests', () {
    test('should have all game types', () {
      expect(GameType.values.length, 5);
      expect(GameType.values.contains(GameType.letterBalloons), true);
      expect(GameType.values.contains(GameType.fastCrowd), true);
      expect(GameType.values.contains(GameType.missingLetter), true);
      expect(GameType.values.contains(GameType.mixedLetters), true);
      expect(GameType.values.contains(GameType.reading), true);
    });
  });

  group('Chapter Game Distribution Tests', () {
    test('chapter 1 should have 1 game', () {
      final games = GameRegistry.getGamesForChapter(1);
      expect(games.length, 1);
    });

    test('chapter 2 should have 2 games', () {
      final games = GameRegistry.getGamesForChapter(2);
      expect(games.length, 2);
    });

    test('chapter 8 should have all games', () {
      final games = GameRegistry.getGamesForChapter(8);
      expect(games.length, GameRegistry.allGames.length);
    });

    test('invalid chapter should return default game', () {
      final games = GameRegistry.getGamesForChapter(99);
      expect(games.length, 1);
      expect(games[0].type, GameType.letterBalloons);
    });
  });
}
