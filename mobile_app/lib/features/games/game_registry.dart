/// Game Registry
/// 
/// Central registry for all available games in Smartino.
/// Maps game IDs to their implementations.

import 'package:flutter/material.dart';
import 'letter_balloons_game.dart';
import 'fast_crowd_game.dart';
import 'missing_letter_game.dart';
import 'mixed_letters_game.dart';
import 'reading_game.dart';

enum GameType {
  letterBalloons,
  fastCrowd,
  missingLetter,
  mixedLetters,
  reading,
}

class GameInfo {
  final String id;
  final String nameAr;
  final String nameEn;
  final String description;
  final IconData icon;
  final GameType type;
  final List<String> targetLetters;
  final int targetScore;

  const GameInfo({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.description,
    required this.icon,
    required this.type,
    required this.targetLetters,
    this.targetScore = 10,
  });
}

class GameRegistry {
  static const List<GameInfo> allGames = [
    GameInfo(
      id: 'letter_balloons',
      nameAr: 'البالونات',
      nameEn: 'Letter Balloons',
      description: 'اضغط على البالونات التي تحتوي على الحرف الصحيح',
      icon: Icons.celebration,
      type: GameType.letterBalloons,
      targetLetters: ['أ', 'ب', 'ت', 'ث', 'ج'],
      targetScore: 10,
    ),
    GameInfo(
      id: 'fast_crowd',
      nameAr: 'الزحمة السريعة',
      nameEn: 'Fast Crowd',
      description: 'اختار كل الحروف الصحيحة من الزحمة',
      icon: Icons.groups,
      type: GameType.fastCrowd,
      targetLetters: ['ح', 'خ', 'د', 'ذ', 'ر'],
      targetScore: 10,
    ),
    GameInfo(
      id: 'missing_letter',
      nameAr: 'الحرف الناقص',
      nameEn: 'Missing Letter',
      description: 'اختار الحرف الناقص لإكمال الكلمة',
      icon: Icons.text_fields,
      type: GameType.missingLetter,
      targetLetters: ['ز', 'س', 'ش', 'ص', 'ض'],
      targetScore: 8,
    ),
    GameInfo(
      id: 'mixed_letters',
      nameAr: 'الحروف المخلوطة',
      nameEn: 'Mixed Letters',
      description: 'رتب الحروف لتكوين الكلمة الصحيحة',
      icon: Icons.shuffle,
      type: GameType.mixedLetters,
      targetLetters: ['ط', 'ظ', 'ع', 'غ', 'ف'],
      targetScore: 8,
    ),
    GameInfo(
      id: 'reading',
      nameAr: 'القراءة',
      nameEn: 'Reading',
      description: 'اقرأ الجملة وأجب على السؤال',
      icon: Icons.menu_book,
      type: GameType.reading,
      targetLetters: ['ق', 'ك', 'ل', 'م', 'ن'],
      targetScore: 6,
    ),
  ];

  /// Get game info by ID
  static GameInfo? getGameById(String gameId) {
    try {
      return allGames.firstWhere((game) => game.id == gameId);
    } catch (e) {
      return null;
    }
  }

  /// Get game info by type
  static GameInfo? getGameByType(GameType type) {
    try {
      return allGames.firstWhere((game) => game.type == type);
    } catch (e) {
      return null;
    }
  }

  /// Launch a game by ID
  static Widget? createGame(String gameId, String stageId) {
    final gameInfo = getGameById(gameId);
    if (gameInfo == null) return null;

    return createGameByType(
      gameInfo.type,
      stageId,
      gameInfo.targetLetters,
      gameInfo.targetScore,
    );
  }

  /// Create game widget by type
  static Widget createGameByType(
    GameType type,
    String stageId,
    List<String> targetLetters,
    int targetScore,
  ) {
    switch (type) {
      case GameType.letterBalloons:
        return LetterBalloonsGame(
          stageId: stageId,
          targetLetters: targetLetters,
          targetScore: targetScore,
        );
      case GameType.fastCrowd:
        return FastCrowdGame(
          stageId: stageId,
          targetLetters: targetLetters,
          targetScore: targetScore,
        );
      case GameType.missingLetter:
        return MissingLetterGame(
          stageId: stageId,
          targetLetters: targetLetters,
          targetScore: targetScore,
        );
      case GameType.mixedLetters:
        return MixedLettersGame(
          stageId: stageId,
          targetLetters: targetLetters,
          targetScore: targetScore,
        );
      case GameType.reading:
        return ReadingGame(
          stageId: stageId,
          targetLetters: targetLetters,
          targetScore: targetScore,
        );
    }
  }

  /// Get games for a specific chapter
  static List<GameInfo> getGamesForChapter(int chapterNumber) {
    // Distribute games across chapters
    switch (chapterNumber) {
      case 1:
        return [allGames[0]]; // Letter Balloons
      case 2:
        return [allGames[0], allGames[1]]; // Balloons + Fast Crowd
      case 3:
        return [allGames[1], allGames[2]]; // Fast Crowd + Missing Letter
      case 4:
        return [allGames[2], allGames[3]]; // Missing Letter + Mixed Letters
      case 5:
        return [allGames[3], allGames[4]]; // Mixed Letters + Reading
      case 6:
        return [allGames[0], allGames[4]]; // Balloons + Reading
      case 7:
        return [allGames[1], allGames[3]]; // Fast Crowd + Mixed Letters
      case 8:
        return allGames; // All games
      default:
        return [allGames[0]];
    }
  }

  /// Get random game for a stage
  static GameInfo getRandomGame() {
    return allGames[DateTime.now().millisecondsSinceEpoch % allGames.length];
  }
}
