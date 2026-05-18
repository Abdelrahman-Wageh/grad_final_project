/// Curriculum Data - Complete learning path structure
/// 8 Chapters with stages, adapted from Antura system

class CurriculumData {
  static const List<Chapter> chapters = [
    // Chapter 1: The Mystery of the Magic Map
    Chapter(
      id: 'chapter_1',
      nameAr: 'لغز الخريطة السحرية',
      nameEn: 'Mystery of the Magic Map',
      titleAr: 'المغامرة تبدأ: فرفور يجد الخريطة',
      titleEn: 'The Adventure Begins: Farfour Finds the Map',
      icon: '🗺️',
      stages: [
        Stage(
          id: 'stage_1_1',
          chapterId: 'chapter_1',
          nameAr: 'حروف البداية',
          nameEn: 'Start Letters',
          titleAr: 'حدوتة حرف الألف: ألف وحلمه الكبير',
          titleEn: "Alef's Story: Alef and His Big Dream",
          order: 1,
          stageNumber: 1,
          gameType: 'storytelling',
          games: ['alef_big_dream'],
          learningObjectives: ['التعرف على حرف الألف', 'بداية مغامرة فرفور وألف'],
        ),
        Stage(
          id: 'stage_1_2',
          chapterId: 'chapter_1',
          nameAr: 'أصوات الغابة',
          nameEn: 'Jungle Sounds',
          titleAr: 'حدوتة حرف الباء: فرفور في البحر',
          titleEn: 'Ba’s Story: Farfour at the Sea',
          order: 2,
          stageNumber: 2,
          gameType: 'storytelling',
          games: ['letter_adventure_alexandria'],
          learningObjectives: ['تمييز صوت حرف الباء'],
        ),
        Stage(
          id: 'stage_1_3',
          chapterId: 'chapter_1',
          nameAr: 'كتابة الرموز',
          nameEn: 'Writing Symbols',
          titleAr: 'حدوتة حرف التاء: فرفور والتفاح',
          titleEn: 'Ta’s Story: Farfour and the Apples',
          order: 3,
          stageNumber: 3,
          gameType: 'storytelling',
          games: ['color_adventure_cairo'],
          learningObjectives: ['التعرف على حرف التاء'],
        ),
      ],
    ),
    
    // Chapter 2: The Talking Trees
    Chapter(
      id: 'chapter_2',
      nameAr: 'الأشجار المتكلمة',
      nameEn: 'The Talking Trees',
      titleAr: 'فرفور في غابة الحروف: ج ح خ',
      titleEn: 'Farfour in the Letter Jungle: Jeem to Kha',
      icon: '🌳',
      stages: [
        Stage(
          id: 'stage_2_1',
          chapterId: 'chapter_2',
          nameAr: 'حروف الطبيعة',
          nameEn: 'Nature Letters',
          titleAr: 'سر حروف الغابة العميقة',
          titleEn: 'Secret of the Deep Forest Letters',
          order: 1,
          stageNumber: 1,
          gameType: 'balloons',
          games: ['balloons', 'arabic_letter_adventure'],
          learningObjectives: ['التعرف على ج ح خ'],
        ),
        Stage(
          id: 'stage_2_2',
          chapterId: 'chapter_2',
          nameAr: 'همس الأشجار',
          nameEn: 'Tree Whispers',
          titleAr: 'من ينادي فرفور؟',
          titleEn: 'Who is Calling Farfour?',
          order: 2,
          stageNumber: 2,
          gameType: 'fast_crowd',
          games: ['fast_crowd'],
          learningObjectives: ['نطق الحروف الجديدة'],
        ),
      ],
    ),
    
    // Chapter 3: The Singing River
    Chapter(
      id: 'chapter_3',
      nameAr: 'النهر المغني',
      nameEn: 'The Singing River',
      titleAr: 'رحلة في نهر الحروف: د ذ ر ز',
      titleEn: 'Journey in the Letter River: Dal to Zay',
      icon: '🛶',
      stages: [
        Stage(
          id: 'stage_3_1',
          chapterId: 'chapter_3',
          nameAr: 'أمواج الحروف',
          nameEn: 'Letter Waves',
          titleAr: 'صيد الكلمات المفقودة',
          titleEn: 'Fishing for Missing Words',
          order: 1,
          stageNumber: 1,
          gameType: 'missing_letter',
          games: ['missing_letter', 'mixed_letters'],
          learningObjectives: ['تكوين كلمات مائية'],
        ),
        Stage(
          id: 'stage_3_2',
          chapterId: 'chapter_3',
          nameAr: 'لغز النهر',
          nameEn: 'River Mystery',
          titleAr: 'ترتيب حروف الشلال',
          titleEn: 'Arranging Waterfall Letters',
          order: 2,
          stageNumber: 2,
          gameType: 'missing_letter',
          games: ['missing_letter', 'mixed_letters'],
          learningObjectives: ['الطلاقة في القراءة'],
        ),
      ],
    ),
    
    // Chapter 4: The Golden Pyramids
    Chapter(
      id: 'chapter_4',
      nameAr: 'الأهرامات الذهبية',
      nameEn: 'The Golden Pyramids',
      titleAr: 'سر الأهرامات: س ش ص ض',
      titleEn: 'Secret of the Pyramids: Seen to Daad',
      icon: '🏛️',
      stages: [
        Stage(
          id: 'stage_4_1',
          chapterId: 'chapter_4',
          nameAr: 'رموز القدماء',
          nameEn: 'Ancient Symbols',
          titleAr: 'الحروف المحفورة في الذهب',
          titleEn: 'Letters Carved in Gold',
          order: 1,
          stageNumber: 1,
          gameType: 'missing_letter',
          games: ['missing_letter', 'mixed_letters'],
          learningObjectives: ['التعرف على س ش ص ض'],
        ),
      ],
    ),
    
    // Chapter 5: The Counting Grotto
    Chapter(
      id: 'chapter_5',
      nameAr: 'كهف الأرقام',
      nameEn: 'The Counting Grotto',
      titleAr: 'حراس الكنز: الأرقام السحرية',
      titleEn: 'Guardians of the Treasure: Magic Numbers',
      icon: '🔢',
      stages: [
        Stage(
          id: 'stage_5_1',
          chapterId: 'chapter_5',
          nameAr: 'العد العجيب',
          nameEn: 'Wondrous Counting',
          titleAr: 'فتح باب المغارة: 1 إلى 10',
          titleEn: 'Opening the Cave Door: 1 to 10',
          order: 1,
          stageNumber: 1,
          gameType: 'number_learning',
          games: ['number_learning', 'code_commander'],
          learningObjectives: ['العد لفتح المسارات'],
        ),
        Stage(
          id: 'stage_5_2',
          chapterId: 'chapter_5',
          nameAr: 'تحدي الحراس',
          nameEn: 'Guardians Challenge',
          titleAr: 'الأرقام الكبيرة: 11 إلى 20',
          titleEn: 'The Big Numbers: 11 to 20',
          order: 2,
          stageNumber: 2,
          gameType: 'number_learning',
          games: ['number_learning'],
          learningObjectives: ['إكمال لغز الأرقام'],
        ),
      ],
    ),
    
    // Chapter 6: The Artists' Oasis
    Chapter(
      id: 'chapter_6',
      nameAr: 'واحة الألوان',
      nameEn: 'The Artists\' Oasis',
      titleAr: 'تلوين طريق العودة: الألوان والأشكال',
      titleEn: 'Painting the Way Home: Colors & Shapes',
      icon: '🎨',
      stages: [
        Stage(
          id: 'stage_6_1',
          chapterId: 'chapter_6',
          nameAr: 'سحر الألوان',
          nameEn: 'Color Magic',
          titleAr: 'إعادة الألوان للواحة',
          titleEn: 'Bringing Colors Back to the Oasis',
          order: 1,
          stageNumber: 1,
          gameType: 'color_learning',
          games: ['color_learning', 'color_tickle'],
          learningObjectives: ['تمييز ألوان المغامرة'],
        ),
        Stage(
          id: 'stage_6_2',
          chapterId: 'chapter_6',
          nameAr: 'أشكال الرمال',
          nameEn: 'Sand Shapes',
          titleAr: 'لغز أشكال الكثبان الرملية',
          titleEn: 'Mystery of the Dune Shapes',
          order: 2,
          stageNumber: 2,
          gameType: 'shape_learning',
          games: ['shape_learning'],
          learningObjectives: ['التعرف على أشكال الواحة'],
        ),
      ],
    ),
    
    // Chapter 7: The Ancient Library
    Chapter(
      id: 'chapter_7',
      nameAr: 'المكتبة القديمة',
      nameEn: 'The Ancient Library',
      titleAr: 'قراءة المخطوطات السرية',
      titleEn: 'Reading the Secret Manuscripts',
      icon: '📕',
      stages: [
        Stage(
          id: 'stage_7_1',
          chapterId: 'chapter_7',
          nameAr: 'جمع الجمل',
          nameEn: 'Gathering Sentences',
          titleAr: 'نطق الكلمات السحرية',
          titleEn: 'Pronouncing Magic Words',
          order: 1,
          stageNumber: 1,
          gameType: 'reading_game',
          games: ['reading_game'],
          learningObjectives: ['قراءة جمل المغامرة'],
        ),
        Stage(
          id: 'stage_7_2',
          chapterId: 'chapter_7',
          nameAr: 'كتاب القصص',
          nameEn: 'Story Book',
          titleAr: 'فرفور يكتب قصته الخاصة',
          titleEn: 'Farfour Writes His Own Story',
          order: 2,
          stageNumber: 2,
          gameType: 'story_mode',
          games: ['story_mode'],
          learningObjectives: ['فهم نهاية المغامرة'],
        ),
      ],
    ),
    
    // Chapter 8: The Hero's Trial
    Chapter(
      id: 'chapter_8',
      nameAr: 'اختبار البطل',
      nameEn: 'The Hero\'s Trial',
      titleAr: 'التحدي الكبير: كن بطلاً مع فرفور',
      titleEn: 'The Big Challenge: Be a Hero with Farfour',
      icon: '🧠',
      stages: [
        Stage(
          id: 'stage_8_1',
          chapterId: 'chapter_8',
          nameAr: 'دهاليز العقل',
          nameEn: 'Minds Corridors',
          titleAr: 'حل لغز القلعة الأخير',
          titleEn: 'Solving the Last Castle Mystery',
          order: 1,
          stageNumber: 1,
          gameType: 'maze',
          games: ['maze', 'puzzle', 'code_commander'],
          learningObjectives: ['التفكير المنطقي النهائي'],
        ),
        Stage(
          id: 'stage_8_2',
          chapterId: 'chapter_8',
          nameAr: 'الذاكرة الذهبية',
          nameEn: 'Golden Memory',
          titleAr: 'تذكر كل شيء عن الرحلة',
          titleEn: 'Remembering Everything About the Trip',
          order: 2,
          stageNumber: 2,
          gameType: 'memory_game',
          games: ['memory_game', 'hide_and_seek'],
          learningObjectives: ['تقوية ذاكرة الأبطال'],
        ),
        Stage(
          id: 'stage_8_3',
          chapterId: 'chapter_8',
          nameAr: 'وسام الملك',
          nameEn: 'King\'s Medal',
          titleAr: 'احتفال النصر الكبير',
          titleEn: 'The Great Victory Celebration',
          order: 3,
          stageNumber: 3,
          gameType: 'drawing_game',
          games: ['drawing_game', 'story_weaver'],
          learningObjectives: ['التعبير الإبداعي عن الفوز'],
        ),
      ],
    ),
  ];
  
  /// Chapter 1 getter
  static Chapter get chapter1 => chapters[0];
  
  /// Chapter 3 getter
  static Chapter get chapter3 => chapters[2];
  
  /// Get chapter by ID
  static Chapter? getChapter(String chapterId) {
    try {
      return chapters.firstWhere((c) => c.id == chapterId);
    } catch (e) {
      return null;
    }
  }
  
  /// Get stage by ID
  static Stage? getStage(String chapterId, String stageId) {
    final chapter = getChapter(chapterId);
    if (chapter == null) return null;
    
    try {
      return chapter.stages.firstWhere((s) => s.id == stageId);
    } catch (e) {
      return null;
    }
  }
  
  /// Get all stages
  static List<Stage> getAllStages() {
    return chapters.expand((chapter) => chapter.stages).toList();
  }
  
  /// Get all chapters (alias for compatibility)
  static List<Chapter> get allChapters => chapters;
  
  /// Get total number of stages
  static int get totalStages => getAllStages().length;
}

/// Chapter model
class Chapter {
  final String id;
  final String nameAr;
  final String nameEn;
  final String titleAr;
  final String titleEn;
  final String icon;
  final List<Stage> stages;
  
  const Chapter({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.titleAr,
    required this.titleEn,
    required this.icon,
    required this.stages,
  });
  
  // Alias properties for compatibility
  String get emoji => icon;
  String get descriptionAr => titleAr;
  String get descriptionEn => titleEn;
}

/// Stage model
class Stage {
  final String id;
  final String chapterId;
  final String nameAr;
  final String nameEn;
  final String titleAr;
  final String titleEn;
  final int order;
  final int stageNumber;
  final String gameType;
  final List<String> games;
  final List<String> learningObjectives;
  
  const Stage({
    required this.id,
    required this.chapterId,
    required this.nameAr,
    required this.nameEn,
    required this.titleAr,
    required this.titleEn,
    required this.order,
    required this.stageNumber,
    required this.gameType,
    required this.games,
    required this.learningObjectives,
  });
}
