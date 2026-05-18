/// Smartino Curriculum Data
/// Complete learning content for all chapters
library;

class CurriculumData {
  // Chapter 1: City of Lost Colors
  static const chapter1 = {
    'id': 'chapter_1',
    'title_en': 'City of Lost Colors',
    'title_ar': 'مدينة الألوان المفقودة',
    'description_en': 'Help Smartino find the lost colors!',
    'description_ar': 'ساعد سمارتينو في إيجاد الألوان المفقودة!',
    'stages': [
      {
        'id': 'chapter_1_stage_1',
        'title': 'Learn Colors',
        'type': 'vocabulary',
        'concepts': ['colors_basic'],
        'words': [
          {'en': 'Red', 'ar': 'أحمر', 'color': 0xFFFF5252},
          {'en': 'Blue', 'ar': 'أزرق', 'color': 0xFF448AFF},
          {'en': 'Green', 'ar': 'أخضر', 'color': 0xFF69F0AE},
          {'en': 'Yellow', 'ar': 'أصفر', 'color': 0xFFFFD740},
        ],
      },
      {
        'id': 'chapter_1_stage_2',
        'title': 'Color Sentences',
        'type': 'sentences',
        'concepts': ['colors_basic'],
        'sentences': [
          {'en': 'This is Red', 'ar': 'هذا أحمر'},
          {'en': 'This is Blue', 'ar': 'هذا أزرق'},
          {'en': 'This is Green', 'ar': 'هذا أخضر'},
          {'en': 'This is Yellow', 'ar': 'هذا أصفر'},
        ],
      },
      {
        'id': 'chapter_1_stage_3',
        'title': 'Colored Objects',
        'type': 'cumulative',
        'concepts': ['colors_basic', 'objects_basic'],
        'combinations': [
          {'en': 'Red Ball', 'ar': 'كرة حمراء', 'object': 'ball', 'color': 'red'},
          {'en': 'Blue Car', 'ar': 'سيارة زرقاء', 'object': 'car', 'color': 'blue'},
          {'en': 'Green Tree', 'ar': 'شجرة خضراء', 'object': 'tree', 'color': 'green'},
          {'en': 'Yellow Sun', 'ar': 'شمس صفراء', 'object': 'sun', 'color': 'yellow'},
        ],
      },
    ],
  };

  // Chapter 2: The Talking Zoo
  static const chapter2 = {
    'id': 'chapter_2',
    'title_en': 'The Talking Zoo',
    'title_ar': 'حديقة الحيوانات الناطقة',
    'description_en': 'Teach animals how to speak!',
    'description_ar': 'علم الحيوانات كيف تتكلم!',
    'prerequisites': ['colors_basic'],
    'stages': [
      {
        'id': 'chapter_2_stage_1',
        'title': 'Learn Animals',
        'type': 'vocabulary',
        'concepts': ['animals_basic'],
        'words': [
          {'en': 'Cat', 'ar': 'قطة', 'sound': 'meow', 'emoji': '🐱'},
          {'en': 'Dog', 'ar': 'كلب', 'sound': 'woof', 'emoji': '🐶'},
          {'en': 'Bird', 'ar': 'عصفور', 'sound': 'tweet', 'emoji': '🐦'},
          {'en': 'Fish', 'ar': 'سمكة', 'sound': 'bubble', 'emoji': '🐠'},
          {'en': 'Frog', 'ar': 'ضفدع', 'sound': 'ribbit', 'emoji': '🐸'},
        ],
      },
      {
        'id': 'chapter_2_stage_2',
        'title': 'Animal Sentences',
        'type': 'sentences',
        'concepts': ['animals_basic'],
        'sentences': [
          {'en': 'This is a Cat', 'ar': 'هذه قطة'},
          {'en': 'This is a Dog', 'ar': 'هذا كلب'},
          {'en': 'This is a Bird', 'ar': 'هذا عصفور'},
          {'en': 'This is a Fish', 'ar': 'هذه سمكة'},
        ],
      },
      {
        'id': 'chapter_2_stage_3',
        'title': 'Colored Animals',
        'type': 'cumulative',
        'concepts': ['animals_basic', 'colors_basic'],
        'combinations': [
          {'en': 'Green Frog', 'ar': 'ضفدع أخضر', 'animal': 'frog', 'color': 'green'},
          {'en': 'Yellow Bird', 'ar': 'عصفور أصفر', 'animal': 'bird', 'color': 'yellow'},
          {'en': 'Red Fish', 'ar': 'سمكة حمراء', 'animal': 'fish', 'color': 'red'},
          {'en': 'Blue Cat', 'ar': 'قطة زرقاء', 'animal': 'cat', 'color': 'blue'},
        ],
      },
    ],
  };

  // Chapter 3: Magic Numbers Castle
  static const chapter3 = {
    'id': 'chapter_3',
    'title_en': 'Magic Numbers Castle',
    'title_ar': 'قلعة الأرقام السحرية',
    'description_en': 'Count the magic numbers!',
    'description_ar': 'عد الأرقام السحرية!',
    'prerequisites': ['colors_basic', 'objects_basic'],
    'stages': [
      {
        'id': 'chapter_3_stage_1',
        'title': 'Learn Numbers',
        'type': 'vocabulary',
        'concepts': ['numbers_basic'],
        'words': [
          {'en': 'One', 'ar': 'واحد', 'value': 1},
          {'en': 'Two', 'ar': 'اثنان', 'value': 2},
          {'en': 'Three', 'ar': 'ثلاثة', 'value': 3},
          {'en': 'Four', 'ar': 'أربعة', 'value': 4},
          {'en': 'Five', 'ar': 'خمسة', 'value': 5},
          {'en': 'Six', 'ar': 'ستة', 'value': 6},
          {'en': 'Seven', 'ar': 'سبعة', 'value': 7},
          {'en': 'Eight', 'ar': 'ثمانية', 'value': 8},
          {'en': 'Nine', 'ar': 'تسعة', 'value': 9},
          {'en': 'Ten', 'ar': 'عشرة', 'value': 10},
        ],
      },
      {
        'id': 'chapter_3_stage_2',
        'title': 'Number Sentences',
        'type': 'sentences',
        'concepts': ['numbers_basic'],
        'sentences': [
          {'en': 'I see One', 'ar': 'أرى واحد'},
          {'en': 'I see Two', 'ar': 'أرى اثنان'},
          {'en': 'I see Three', 'ar': 'أرى ثلاثة'},
          {'en': 'I see Five', 'ar': 'أرى خمسة'},
        ],
      },
      {
        'id': 'chapter_3_stage_3',
        'title': 'Count Colored Objects',
        'type': 'cumulative',
        'concepts': ['numbers_basic', 'colors_basic', 'objects_basic'],
        'combinations': [
          {'en': 'Three Red Apples', 'ar': 'ثلاث تفاحات حمراء', 'count': 3, 'color': 'red', 'object': 'apple'},
          {'en': 'Two Blue Cars', 'ar': 'سيارتان زرقاوان', 'count': 2, 'color': 'blue', 'object': 'car'},
          {'en': 'Five Yellow Stars', 'ar': 'خمس نجوم صفراء', 'count': 5, 'color': 'yellow', 'object': 'star'},
          {'en': 'Four Green Trees', 'ar': 'أربع شجرات خضراء', 'count': 4, 'color': 'green', 'object': 'tree'},
        ],
      },
    ],
  };

  // All chapters
  static const allChapters = [chapter1, chapter2, chapter3];

  // Unlockable items for mascot
  static const unlockableItems = [
    {'id': 'hat_wizard', 'name_en': 'Wizard Hat', 'name_ar': 'قبعة ساحر', 'stars_required': 5, 'image': 'assets/items/hat_wizard.png'},
    {'id': 'wand_star', 'name_en': 'Star Wand', 'name_ar': 'عصا النجوم', 'stars_required': 10, 'image': 'assets/items/wand_star.png'},
    {'id': 'hat_crown', 'name_en': 'Crown', 'name_ar': 'تاج', 'stars_required': 15, 'image': 'assets/items/hat_crown.png'},
    {'id': 'cape_magic', 'name_en': 'Magic Cape', 'name_ar': 'عباءة سحرية', 'stars_required': 20, 'image': 'assets/items/cape_magic.png'},
    {'id': 'glasses_smart', 'name_en': 'Smart Glasses', 'name_ar': 'نظارة ذكية', 'stars_required': 25, 'image': 'assets/items/glasses_smart.png'},
  ];

  // Encouragement phrases (positive reinforcement only)
  static const encouragements = [
    {'en': 'You\'re doing great!', 'ar': 'أنت تقوم بعمل رائع!'},
    {'en': 'So close! Try once more!', 'ar': 'قريب جداً! حاول مرة أخرى!'},
    {'en': 'I believe in you!', 'ar': 'أنا أؤمن بك!'},
    {'en': 'You\'re learning so fast!', 'ar': 'أنت تتعلم بسرعة!'},
    {'en': 'Keep going!', 'ar': 'استمر!'},
    {'en': 'You can do it!', 'ar': 'أنت تستطيع!'},
  ];

  // Success phrases
  static const successPhrases = [
    {'en': 'Bravo!', 'ar': 'برافو!'},
    {'en': 'Excellent!', 'ar': 'ممتاز!'},
    {'en': 'Perfect!', 'ar': 'مثالي!'},
    {'en': 'Amazing!', 'ar': 'رائع!'},
    {'en': 'Wonderful!', 'ar': 'رائع جداً!'},
    {'en': 'You did it!', 'ar': 'لقد فعلتها!'},
  ];
}
