# Smartino Learning Path & Logic Flow

## Overview
This document defines how English/Arabic learning paths from Antura will be adapted and integrated into Smartino's progression system.

---

## 1. Learning Path Architecture

### 1.1 Curriculum Structure

```
Smartino Learning Journey
├── Chapter 1: Arabic Letters (حروف)
│   ├── Stage 1.1: Alef to Zay (أ - ز)
│   │   ├── Lesson: Letter Recognition
│   │   ├── Game: Balloons (from Antura)
│   │   ├── Game: Arabic Letter Adventure (from Singles)
│   │   └── Assessment: Letter Quiz
│   ├── Stage 1.2: Letter Sounds
│   │   ├── Lesson: Phonetics
│   │   ├── Game: FastCrowd (from Antura)
│   │   └── Assessment: Sound Matching
│   └── Stage 1.3: Letter Writing
│       ├── Lesson: Tracing
│       ├── Game: Drawing Game (current)
│       └── Assessment: Writing Test
│
├── Chapter 2: English Letters
│   ├── Stage 2.1: A to Z
│   ├── Stage 2.2: Letter Sounds
│   └── Stage 2.3: Letter Writing
│
├── Chapter 3: Arabic Words (كلمات)
│   ├── Stage 3.1: Simple Words
│   │   ├── Game: MissingLetter (from Antura)
│   │   ├── Game: MixedLetters (from Antura)
│   │   └── Assessment: Word Building
│   ├── Stage 3.2: Common Words
│   └── Stage 3.3: Word Families
│
├── Chapter 4: English Words
│   ├── Stage 4.1: Simple Words
│   ├── Stage 4.2: Common Words
│   └── Stage 4.3: Word Families
│
├── Chapter 5: Numbers (أرقام)
│   ├── Stage 5.1: 1-10
│   │   ├── Game: Number Learning (current)
│   │   ├── Game: Code Commander (current)
│   │   └── Assessment: Counting
│   ├── Stage 5.2: 11-20
│   └── Stage 5.3: 21-100
│
├── Chapter 6: Colors & Shapes (ألوان وأشكال)
│   ├── Stage 6.1: Basic Colors
│   │   ├── Game: Color Learning (current)
│   │   ├── Game: ColorTickle (from Antura)
│   │   └── Assessment: Color Matching
│   ├── Stage 6.2: Shapes
│   │   ├── Game: Shape Learning (current)
│   │   └── Assessment: Shape Recognition
│   └── Stage 6.3: Patterns
│
├── Chapter 7: Reading (قراءة)
│   ├── Stage 7.1: Simple Sentences
│   │   ├── Game: ReadingGame (from Antura)
│   │   └── Assessment: Comprehension
│   ├── Stage 7.2: Short Stories
│   │   ├── Game: Story Mode (new)
│   │   └── Assessment: Story Questions
│   └── Stage 7.3: Longer Texts
│
└── Chapter 8: Advanced Skills
    ├── Stage 8.1: Problem Solving
    │   ├── Game: Maze (from Antura)
    │   ├── Game: Puzzle (from Singles)
    │   └── Game: Code Commander (current)
    ├── Stage 8.2: Memory & Logic
    │   ├── Game: Memory Game (current)
    │   └── Game: HideAndSeek (from Antura)
    └── Stage 8.3: Creativity
        ├── Game: Drawing Game (current)
        └── Game: Story Weaver (current)
```

---

## 2. Progression System

### 2.1 Level Unlocking Logic

```dart
// lib/core/game/progression_manager.dart

class ProgressionManager {
  final HiveService _storage;
  
  /// Check if a stage is unlocked
  bool isStageUnlocked(String chapterId, String stageId) {
    // Chapter 1, Stage 1 is always unlocked
    if (chapterId == 'chapter_1' && stageId == 'stage_1') {
      return true;
    }
    
    // Check if previous stage is completed
    final previousStage = _getPreviousStage(chapterId, stageId);
    if (previousStage == null) return false;
    
    final progress = _storage.getStageProgress(
      previousStage.chapterId,
      previousStage.stageId,
    );
    
    // Unlock if previous stage has 70%+ completion
    return progress.completionPercentage >= 70;
  }
  
  /// Get stage progress
  StageProgress getStageProgress(String chapterId, String stageId) {
    return _storage.getStageProgress(chapterId, stageId);
  }
  
  /// Update stage progress
  Future<void> updateStageProgress({
    required String chapterId,
    required String stageId,
    required int starsEarned,
    required bool lessonCompleted,
    required bool assessmentPassed,
  }) async {
    final progress = StageProgress(
      chapterId: chapterId,
      stageId: stageId,
      starsEarned: starsEarned,
      lessonCompleted: lessonCompleted,
      assessmentPassed: assessmentPassed,
      lastPlayedAt: DateTime.now(),
    );
    
    await _storage.saveStageProgress(progress);
    
    // Check if chapter is completed
    if (_isChapterCompleted(chapterId)) {
      await _unlockNextChapter(chapterId);
    }
  }
  
  /// Calculate completion percentage
  double getOverallProgress() {
    final allStages = _getAllStages();
    final completedStages = allStages.where((stage) {
      final progress = getStageProgress(stage.chapterId, stage.stageId);
      return progress.completionPercentage >= 70;
    }).length;
    
    return (completedStages / allStages.length) * 100;
  }
}
```

### 2.2 Star System

```dart
// Stars earned based on performance
class StarCalculator {
  static int calculateStars({
    required int score,
    required int maxScore,
    required Duration timeTaken,
    required Duration targetTime,
    required int mistakes,
  }) {
    // Base stars from score
    final scorePercentage = (score / maxScore) * 100;
    int stars = 0;
    
    if (scorePercentage >= 90) {
      stars = 3;
    } else if (scorePercentage >= 70) {
      stars = 2;
    } else if (scorePercentage >= 50) {
      stars = 1;
    }
    
    // Bonus star for speed (if 3 stars already)
    if (stars == 3 && timeTaken <= targetTime) {
      stars = 4;  // Bonus star
    }
    
    // Penalty for too many mistakes
    if (mistakes > 5 && stars > 1) {
      stars -= 1;
    }
    
    return stars.clamp(0, 4);
  }
}
```

---

## 3. Assessment System

### 3.1 Assessment Types

```dart
enum AssessmentType {
  quiz,           // Multiple choice
  matching,       // Match items
  ordering,       // Put in order
  fillBlank,      // Fill in the blank
  speaking,       // Voice response
  drawing,        // Draw something
}

class Assessment {
  final String id;
  final String chapterId;
  final String stageId;
  final AssessmentType type;
  final List<Question> questions;
  final int passingScore;  // Percentage needed to pass
  
  Assessment({
    required this.id,
    required this.chapterId,
    required this.stageId,
    required this.type,
    required this.questions,
    this.passingScore = 70,
  });
  
  /// Check if assessment is passed
  bool isPassed(int score) {
    final percentage = (score / questions.length) * 100;
    return percentage >= passingScore;
  }
}
```

### 3.2 Adaptive Difficulty

```dart
class DifficultyAdapter {
  /// Adjust difficulty based on performance
  DifficultyLevel adjustDifficulty({
    required DifficultyLevel currentLevel,
    required List<GameResult> recentResults,
  }) {
    // Calculate average success rate from last 5 games
    final last5 = recentResults.take(5).toList();
    final successRate = last5.where((r) => r.success).length / last5.length;
    
    // Increase difficulty if success rate > 80%
    if (successRate > 0.8 && currentLevel != DifficultyLevel.hard) {
      return DifficultyLevel.values[currentLevel.index + 1];
    }
    
    // Decrease difficulty if success rate < 40%
    if (successRate < 0.4 && currentLevel != DifficultyLevel.easy) {
      return DifficultyLevel.values[currentLevel.index - 1];
    }
    
    return currentLevel;
  }
}
```

---

## 4. Game Integration Logic

### 4.1 Game Selection

```dart
class GameRouter {
  /// Get appropriate game for current stage
  Widget getGameForStage(String chapterId, String stageId) {
    final stage = _getStage(chapterId, stageId);
    
    switch (stage.gameType) {
      case GameType.letterRecognition:
        return BalloonsGame(stage: stage);  // From Antura
      
      case GameType.letterTracing:
        return ArabicLetterAdventureGame(stage: stage);  // From Singles
      
      case GameType.wordBuilding:
        return MissingLetterGame(stage: stage);  // From Antura
      
      case GameType.numberLearning:
        return NumberLearningGame(stage: stage);  // Current
      
      case GameType.colorLearning:
        return ColorLearningGame(stage: stage);  // Current
      
      case GameType.problemSolving:
        return CodeCommanderGame(stage: stage);  // Current
      
      case GameType.memory:
        return MemoryGame(stage: stage);  // Current
      
      case GameType.puzzle:
        return PuzzleGame(stage: stage);  // From Singles
      
      case GameType.reading:
        return ReadingGame(stage: stage);  // From Antura
      
      case GameType.story:
        return StoryMode(stage: stage);  // New
      
      default:
        throw UnimplementedError('Game type not implemented');
    }
  }
}
```

---

## 5. Friend Mode Integration

### 5.1 Contextual Conversations

```dart
class FriendModeContext {
  /// Generate context for AI based on current stage
  Map<String, dynamic> getContext({
    required String chapterId,
    required String stageId,
    required GameResult? lastResult,
  }) {
    return {
      'chapter': chapterId,
      'stage': stageId,
      'topic': _getTopicForStage(chapterId, stageId),
      'difficulty': _getCurrentDifficulty(),
      'lastResult': lastResult?.toJson(),
      'encouragement': _getEncouragementLevel(lastResult),
    };
  }
  
  String _getTopicForStage(String chapterId, String stageId) {
    // Map stage to topic for AI context
    if (chapterId == 'chapter_1') return 'Arabic letters';
    if (chapterId == 'chapter_2') return 'English letters';
    if (chapterId == 'chapter_3') return 'Arabic words';
    if (chapterId == 'chapter_5') return 'Numbers';
    if (chapterId == 'chapter_6') return 'Colors and shapes';
    return 'Learning';
  }
}
```

---

## 6. Data Models

### 6.1 Stage Progress Model

```dart
@HiveType(typeId: 10)
class StageProgress {
  @HiveField(0)
  final String chapterId;
  
  @HiveField(1)
  final String stageId;
  
  @HiveField(2)
  final int starsEarned;  // 0-4 stars
  
  @HiveField(3)
  final bool lessonCompleted;
  
  @HiveField(4)
  final bool assessmentPassed;
  
  @HiveField(5)
  final DateTime lastPlayedAt;
  
  @HiveField(6)
  final int totalAttempts;
  
  @HiveField(7)
  final int successfulAttempts;
  
  double get completionPercentage {
    if (!lessonCompleted) return 0;
    if (!assessmentPassed) return 50;
    return (starsEarned / 4) * 100;
  }
  
  double get successRate {
    if (totalAttempts == 0) return 0;
    return (successfulAttempts / totalAttempts) * 100;
  }
}
```

---

## 7. Migration from Antura

### 7.1 Curriculum Data Extraction

```python
# Script to extract Antura curriculum data

import json
import sqlite3

def extract_antura_curriculum(db_path):
    """Extract learning path from Antura SQLite database."""
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Extract stages
    cursor.execute("SELECT * FROM Stages")
    stages = cursor.fetchall()
    
    # Extract mini-games
    cursor.execute("SELECT * FROM MiniGames")
    games = cursor.fetchall()
    
    # Convert to Smartino format
    curriculum = {
        'chapters': [],
        'stages': [],
        'games': []
    }
    
    for stage in stages:
        curriculum['stages'].append({
            'id': stage[0],
            'chapter_id': stage[1],
            'name_ar': stage[2],
            'name_en': stage[3],
            'order': stage[4],
            'games': _get_games_for_stage(stage[0], games)
        })
    
    return curriculum

def save_to_json(curriculum, output_path):
    """Save curriculum to JSON for Flutter."""
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(curriculum, f, ensure_ascii=False, indent=2)
```

---

**Status**: Ready for Implementation  
**Dependencies**: Antura database access, game implementations  
**Priority**: High (Core Learning System)
