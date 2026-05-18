/// Smartino Super-App - Progression Manager
/// Manages learning path progression, stage unlocking, and star calculations
/// Requirements: 1.3, 1.4, 1.5

import 'package:flutter/foundation.dart';
import '../../models/stage_progress.dart';
import '../../data/curriculum/curriculum_data.dart';
import '../../services/local_storage_service.dart';

class ProgressionManager extends ChangeNotifier {
  final LocalStorageService _storage;
  final Map<String, StageProgress> _stageProgress = {};
  
  ProgressionManager(this._storage) {
    _loadProgress();
  }
  
  /// Load all stage progress from storage
  Future<void> _loadProgress() async {
    try {
      final box = await _storage.openBox<StageProgress>('stage_progress');
      for (var key in box.keys) {
        final progress = box.get(key);
        if (progress != null) {
          _stageProgress[key] = progress;
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading progress: $e');
    }
  }
  
  /// Get progress for a specific stage
  StageProgress? getStageProgress(String stageId) {
    return _stageProgress[stageId];
  }
  
  /// Check if a stage is unlocked
  bool isStageUnlocked(String chapterId, int stageNumber) {
    // First stage of first chapter is always unlocked
    if (chapterId == 'chapter_1' && stageNumber == 1) {
      return true;
    }
    
    // Check if previous stage is completed
    if (stageNumber > 1) {
      final prevStageId = '${chapterId}_stage_${stageNumber - 1}';
      final prevProgress = _stageProgress[prevStageId];
      return prevProgress != null && prevProgress.isCompleted;
    }
    
    // Check if previous chapter is completed
    final chapterNum = int.parse(chapterId.split('_')[1]);
    if (chapterNum > 1) {
      final prevChapterId = 'chapter_${chapterNum - 1}';
      return isChapterCompleted(prevChapterId);
    }
    
    return false;
  }
  
  /// Check if a chapter is completed
  bool isChapterCompleted(String chapterId) {
    final chapter = CurriculumData.chapters.firstWhere(
      (c) => c.id == chapterId,
      orElse: () => CurriculumData.chapters.first,
    );
    
    for (var stage in chapter.stages) {
      final progress = _stageProgress[stage.id];
      if (progress == null || !progress.isCompleted) {
        return false;
      }
    }
    
    return true;
  }
  
  /// Calculate stars earned based on performance
  /// 3 stars: 90%+ accuracy, < 3 mistakes
  /// 2 stars: 70%+ accuracy, < 5 mistakes
  /// 1 star: Completed
  static int calculateStars({
    required int correctAnswers,
    required int totalQuestions,
    required int mistakes,
    required Duration timeTaken,
    Duration? targetTime,
  }) {
    if (totalQuestions == 0) return 0;
    
    final accuracy = correctAnswers / totalQuestions;
    
    // 3 stars criteria
    if (accuracy >= 0.9 && mistakes < 3) {
      if (targetTime != null && timeTaken <= targetTime) {
        return 3;
      }
      if (targetTime == null) {
        return 3;
      }
    }
    
    // 2 stars criteria
    if (accuracy >= 0.7 && mistakes < 5) {
      return 2;
    }
    
    // 1 star for completion
    if (accuracy >= 0.5) {
      return 1;
    }
    
    return 0;
  }
  
  /// Get total stars earned across all stages
  int getTotalStarsEarned() {
    return _stageProgress.values.fold(0, (sum, progress) => sum + progress.bestStars);
  }
  
  /// Get overall completion percentage
  double getOverallCompletionPercentage() {
    int totalStages = 0;
    int completedStages = 0;
    
    for (var chapter in CurriculumData.chapters) {
      totalStages += chapter.stages.length;
      for (var stage in chapter.stages) {
        final progress = _stageProgress[stage.id];
        if (progress != null && progress.isCompleted) {
          completedStages++;
        }
      }
    }
    
    return totalStages > 0 ? (completedStages / totalStages) * 100 : 0.0;
  }
  
  /// Get max possible stars
  int getMaxPossibleStars() {
    int total = 0;
    for (var chapter in CurriculumData.chapters) {
      total += chapter.stages.length * 3; // 3 stars per stage
    }
    return total;
  }
  
  /// Check if stage is completed
  bool isStageCompleted(String stageId) {
    final progress = _stageProgress[stageId];
    return progress != null && progress.isCompleted;
  }
  
  /// Get stage stars
  int getStageStars(String stageId) {
    final progress = _stageProgress[stageId];
    return progress?.bestStars ?? 0;
  }
  
  /// Update stage progress after completing a game
  Future<void> updateStageProgress({
    required String stageId,
    required int stars,
    required int correctAnswers,
    required int totalQuestions,
    required Duration timeTaken,
  }) async {
    try {
      final existingProgress = _stageProgress[stageId];
      
      final newProgress = StageProgress(
        stageId: stageId,
        stars: stars,
        bestStars: existingProgress != null 
            ? (stars > existingProgress.bestStars ? stars : existingProgress.bestStars)
            : stars,
        isCompleted: stars > 0,
        attempts: (existingProgress?.attempts ?? 0) + 1,
        lastPlayedAt: DateTime.now(),
        correctAnswers: correctAnswers,
        totalQuestions: totalQuestions,
        bestTime: existingProgress != null && existingProgress.bestTime != null
            ? (timeTaken < existingProgress.bestTime! ? timeTaken : existingProgress.bestTime!)
            : timeTaken,
      );
      
      _stageProgress[stageId] = newProgress;
      
      // Save to storage
      final box = await _storage.openBox<StageProgress>('stage_progress');
      await box.put(stageId, newProgress);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating stage progress: $e');
    }
  }
  
  /// Get total stars earned across all stages
  int getTotalStars() {
    return _stageProgress.values.fold(0, (sum, progress) => sum + progress.bestStars);
  }
  
  /// Get completion percentage for a chapter
  double getChapterCompletion(String chapterId) {
    final chapter = CurriculumData.chapters.firstWhere(
      (c) => c.id == chapterId,
      orElse: () => CurriculumData.chapters.first,
    );
    
    if (chapter.stages.isEmpty) return 0.0;
    
    int completedStages = 0;
    for (var stage in chapter.stages) {
      final progress = _stageProgress[stage.id];
      if (progress != null && progress.isCompleted) {
        completedStages++;
      }
    }
    
    return completedStages / chapter.stages.length;
  }
  
  /// Get chapter progress (0.0 to 1.0)
  double getChapterProgress(String chapterId) {
    return getChapterCompletion(chapterId);
  }
  
  /// Check if chapter is unlocked
  bool isChapterUnlocked(String chapterId) {
    // First chapter is always unlocked
    if (chapterId == 'chapter_1') {
      return true;
    }
    
    // Check if previous chapter is completed
    final chapterNum = int.parse(chapterId.split('_')[1]);
    if (chapterNum > 1) {
      final prevChapterId = 'chapter_${chapterNum - 1}';
      return isChapterCompleted(prevChapterId);
    }
    
    return false;
  }
  
  /// Get overall completion percentage
  double getOverallCompletion() {
    int totalStages = 0;
    int completedStages = 0;
    
    for (var chapter in CurriculumData.chapters) {
      totalStages += chapter.stages.length;
      for (var stage in chapter.stages) {
        final progress = _stageProgress[stage.id];
        if (progress != null && progress.isCompleted) {
          completedStages++;
        }
      }
    }
    
    return totalStages > 0 ? completedStages / totalStages : 0.0;
  }
  
  /// Get next unlocked stage
  String? getNextUnlockedStage() {
    for (var chapter in CurriculumData.chapters) {
      for (var stage in chapter.stages) {
        final progress = _stageProgress[stage.id];
        if (progress == null || !progress.isCompleted) {
          if (isStageUnlocked(chapter.id, stage.stageNumber)) {
            return stage.id;
          }
        }
      }
    }
    return null;
  }
  
  /// Reset all progress (for testing or new profile)
  Future<void> resetProgress() async {
    try {
      _stageProgress.clear();
      final box = await _storage.openBox<StageProgress>('stage_progress');
      await box.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting progress: $e');
    }
  }
  
  /// Get statistics for parent dashboard
  Map<String, dynamic> getStatistics() {
    return {
      'totalStars': getTotalStars(),
      'overallCompletion': getOverallCompletion(),
      'completedStages': _stageProgress.values.where((p) => p.isCompleted).length,
      'totalStages': CurriculumData.chapters.fold(0, (sum, c) => sum + c.stages.length),
      'totalAttempts': _stageProgress.values.fold(0, (sum, p) => sum + p.attempts),
      'averageStars': _stageProgress.values.isEmpty 
          ? 0.0 
          : _stageProgress.values.fold(0, (sum, p) => sum + p.bestStars) / _stageProgress.values.length,
    };
  }
}
