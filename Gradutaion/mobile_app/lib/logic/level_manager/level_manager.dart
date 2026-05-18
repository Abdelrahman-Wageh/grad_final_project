/// Level Manager - Handles cumulative learning logic
/// Ensures each level builds on previous knowledge
library;

import 'dart:math';
import '../../data/curriculum/curriculum_data.dart';
import '../../models/challenge.dart';

class LevelManager {
  // Knowledge Graph: What concepts does each chapter require?
  static const Map<String, Set<String>> knowledgeGraph = {
    'chapter_1_stage_1': {'colors_basic'},
    'chapter_1_stage_2': {'colors_basic'},
    'chapter_1_stage_3': {'colors_basic', 'objects_basic'},
    
    'chapter_2_stage_1': {'animals_basic'},
    'chapter_2_stage_2': {'animals_basic'},
    'chapter_2_stage_3': {'animals_basic', 'colors_basic'},
    
    'chapter_3_stage_1': {'numbers_basic'},
    'chapter_3_stage_2': {'numbers_basic'},
    'chapter_3_stage_3': {'numbers_basic', 'colors_basic', 'objects_basic'},
  };

  // Concept Mastery Threshold
  static const int masteryThreshold = 5;

  /// Check if child can access a level
  static bool canAccessLevel(String levelId, Set<String> masteredConcepts) {
    Set<String>? required = knowledgeGraph[levelId];
    if (required == null) return true;
    
    return masteredConcepts.containsAll(required);
  }

  /// Get missing prerequisites for a level
  static Set<String> getMissingPrerequisites(
    String levelId,
    Set<String> masteredConcepts,
  ) {
    Set<String>? required = knowledgeGraph[levelId];
    if (required == null) return {};
    
    return required.difference(masteredConcepts);
  }

  /// Generate a challenge for a level
  static Challenge generateChallenge({
    required String levelId,
    required Set<String> masteredConcepts,
    required DifficultyLevel difficulty,
    String language = 'en',
  }) {
    // Get stage data from curriculum
    Map<String, dynamic>? stageData = _getStageData(levelId);
    if (stageData == null) {
      throw Exception('Stage not found: $levelId');
    }

    String type = stageData['type'];
    
    switch (type) {
      case 'vocabulary':
        return _generateVocabularyChallenge(stageData, difficulty, language);
      case 'sentences':
        return _generateSentenceChallenge(stageData, difficulty, language);
      case 'cumulative':
        return _generateCumulativeChallenge(stageData, difficulty, language);
      default:
        throw Exception('Unknown challenge type: $type');
    }
  }

  /// Get stage data from curriculum
  static Map<String, dynamic>? _getStageData(String levelId) {
    for (var chapter in CurriculumData.allChapters) {
      for (var stage in (chapter['stages'] as List)) {
        if (stage['id'] == levelId) {
          return stage;
        }
      }
    }
    return null;
  }

  /// Generate vocabulary challenge
  static Challenge _generateVocabularyChallenge(
    Map<String, dynamic> stageData,
    DifficultyLevel difficulty,
    String language,
  ) {
    List words = stageData['words'];
    var word = words[Random().nextInt(words.length)];
    
    return Challenge(
      type: ChallengeType.vocabulary,
      prompt: language == 'ar' 
        ? 'ما هذا؟' 
        : 'What is this?',
      expectedAnswer: language == 'ar' ? word['ar'] : word['en'],
      alternativeAnswers: [word['en'], word['ar']],
      difficulty: difficulty,
      data: word,
    );
  }

  /// Generate sentence challenge
  static Challenge _generateSentenceChallenge(
    Map<String, dynamic> stageData,
    DifficultyLevel difficulty,
    String language,
  ) {
    List sentences = stageData['sentences'];
    var sentence = sentences[Random().nextInt(sentences.length)];
    
    return Challenge(
      type: ChallengeType.sentence,
      prompt: language == 'ar'
        ? 'قل الجملة كاملة'
        : 'Say the full sentence',
      expectedAnswer: language == 'ar' ? sentence['ar'] : sentence['en'],
      alternativeAnswers: [sentence['en'], sentence['ar']],
      difficulty: difficulty,
      data: sentence,
    );
  }

  /// Generate cumulative challenge (combines multiple concepts)
  static Challenge _generateCumulativeChallenge(
    Map<String, dynamic> stageData,
    DifficultyLevel difficulty,
    String language,
  ) {
    List combinations = stageData['combinations'];
    var combination = combinations[Random().nextInt(combinations.length)];
    
    return Challenge(
      type: ChallengeType.cumulative,
      prompt: language == 'ar'
        ? 'ما هذا؟'
        : 'What is this?',
      expectedAnswer: language == 'ar' ? combination['ar'] : combination['en'],
      alternativeAnswers: [combination['en'], combination['ar']],
      difficulty: difficulty,
      data: combination,
    );
  }

  /// Adjust difficulty based on performance
  static DifficultyLevel adjustDifficulty(
    DifficultyLevel current,
    double recentSuccessRate,
  ) {
    if (recentSuccessRate > 0.9 && current != DifficultyLevel.hard) {
      // Child is doing too well - increase difficulty
      return DifficultyLevel.values[current.index + 1];
    } else if (recentSuccessRate < 0.5 && current != DifficultyLevel.easy) {
      // Child is struggling - decrease difficulty
      return DifficultyLevel.values[current.index - 1];
    }
    return current;
  }
}
