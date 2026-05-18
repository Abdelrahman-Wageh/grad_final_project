/// Story Model - Represents an AI-generated story
/// Stories are related to games and educational content

import 'package:hive/hive.dart';

part 'story.g.dart';

@HiveType(typeId: 20)
class Story {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String titleAr;
  
  @HiveField(2)
  final String titleEn;
  
  @HiveField(3)
  final String theme;  // Game-related theme
  
  @HiveField(4)
  final List<StorySegment> segments;
  
  @HiveField(5)
  final String difficulty;  // easy, medium, hard
  
  @HiveField(6)
  final List<String> learningObjectives;
  
  @HiveField(7)
  final String? thumbnailPath;
  
  @HiveField(8)
  final DateTime createdAt;
  
  @HiveField(9)
  final bool isCompleted;
  
  Story({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.theme,
    required this.segments,
    this.difficulty = 'easy',
    this.learningObjectives = const [],
    this.thumbnailPath,
    DateTime? createdAt,
    this.isCompleted = false,
  }) : createdAt = createdAt ?? DateTime.now();
  
  // Convenience getter for title (defaults to Arabic)
  String get title => titleAr;
  
  int get estimatedDuration => segments.length * 30; // seconds per segment
  
  Story copyWith({
    String? id,
    String? titleAr,
    String? titleEn,
    String? theme,
    List<StorySegment>? segments,
    String? difficulty,
    List<String>? learningObjectives,
    String? thumbnailPath,
    DateTime? createdAt,
    bool? isCompleted,
  }) {
    return Story(
      id: id ?? this.id,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      theme: theme ?? this.theme,
      segments: segments ?? this.segments,
      difficulty: difficulty ?? this.difficulty,
      learningObjectives: learningObjectives ?? this.learningObjectives,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

@HiveType(typeId: 21)
class StorySegment {
  @HiveField(0)
  final String textAr;
  
  @HiveField(1)
  final String textEn;
  
  @HiveField(2)
  final String? imagePath;
  
  @HiveField(3)
  final List<StoryChoice>? choices;  // Interactive choices
  
  @HiveField(4)
  final String? audioPath;  // TTS audio
  
  StorySegment({
    required this.textAr,
    required this.textEn,
    this.imagePath,
    this.choices,
    this.audioPath,
  });
}

@HiveType(typeId: 22)
class StoryChoice {
  @HiveField(0)
  final String textAr;
  
  @HiveField(1)
  final String textEn;
  
  @HiveField(2)
  final int nextSegmentIndex;
  
  @HiveField(3)
  final String? consequence;  // What happens after this choice
  
  StoryChoice({
    required this.textAr,
    required this.textEn,
    required this.nextSegmentIndex,
    this.consequence,
  });
}

/// Story themes related to games
enum StoryTheme {
  colors('colors', 'الألوان', 'Colors'),
  numbers('numbers', 'الأرقام', 'Numbers'),
  letters('letters', 'الحروف', 'Letters'),
  shapes('shapes', 'الأشكال', 'Shapes'),
  animals('animals', 'الحيوانات', 'Animals'),
  adventure('adventure', 'المغامرة', 'Adventure'),
  friendship('friendship', 'الصداقة', 'Friendship'),
  problemSolving('problem_solving', 'حل المشكلات', 'Problem Solving');
  
  final String id;
  final String nameAr;
  final String nameEn;
  
  const StoryTheme(this.id, this.nameAr, this.nameEn);
}

/// Pre-defined Egyptian story templates
class EgyptianStoryTemplates {
  /// Story: Farfour's Color Adventure in Cairo
  static Story colorAdventure() {
    return Story(
      id: 'color_adventure_cairo',
      titleAr: 'مغامرة فرفور الملونة في القاهرة',
      titleEn: "Farfour's Colorful Adventure in Cairo",
      theme: 'colors',
      difficulty: 'easy',
      learningObjectives: ['تعلم الألوان', 'التعرف على معالم القاهرة'],
      segments: [
        StorySegment(
          textAr: 'كان يا مكان، في مدينة القاهرة الجميلة، كلب صغير اسمه فرفور. فرفور كان يحب الألوان كتير!',
          textEn: 'Once upon a time in beautiful Cairo, there was a little dog named Farfour. Farfour loved colors very much!',
        ),
        StorySegment(
          textAr: 'في يوم من الأيام، قرر فرفور يروح يزور برج القاهرة. البرج كان لونه إيه؟ أحمر! 🔴',
          textEn: 'One day, Farfour decided to visit Cairo Tower. What color was the tower? Red! 🔴',
          choices: [
            StoryChoice(
              textAr: 'يلا نلعب لعبة الألوان!',
              textEn: "Let's play the colors game!",
              nextSegmentIndex: 2,
            ),
            StoryChoice(
              textAr: 'كمل الحدوتة',
              textEn: 'Continue the story',
              nextSegmentIndex: 3,
            ),
          ],
        ),
        StorySegment(
          textAr: 'بعد كده، فرفور راح النيل. المياه كانت زرقاء جميلة! 💙 وشاف سمكة صفراء! 💛',
          textEn: 'Then, Farfour went to the Nile. The water was beautiful blue! 💙 And he saw a yellow fish! 💛',
        ),
        StorySegment(
          textAr: 'فرفور فرح جداً لأنه اتعلم ألوان كتير النهاردة! أنت كمان تقدر تتعلم الألوان! 🌈',
          textEn: 'Farfour was very happy because he learned many colors today! You can learn colors too! 🌈',
        ),
      ],
    );
  }
  
  /// Story: Farfour Counts the Pyramids
  static Story numberAdventure() {
    return Story(
      id: 'number_adventure_pyramids',
      titleAr: 'فرفور يعد الأهرامات',
      titleEn: 'Farfour Counts the Pyramids',
      theme: 'numbers',
      difficulty: 'easy',
      learningObjectives: ['تعلم الأرقام من 1 إلى 10', 'التعرف على الأهرامات'],
      segments: [
        StorySegment(
          textAr: 'فرفور راح يزور الأهرامات! كان متحمس جداً! 🏜️',
          textEn: 'Farfour went to visit the Pyramids! He was very excited! 🏜️',
        ),
        StorySegment(
          textAr: 'شاف هرم واحد كبير... اتنين... تلاتة! كام هرم شاف فرفور؟ تلاتة أهرامات! 🔺🔺🔺',
          textEn: 'He saw one big pyramid... two... three! How many pyramids did Farfour see? Three pyramids! 🔺🔺🔺',
        ),
        StorySegment(
          textAr: 'بعدين شاف جمال! واحد، اتنين، تلاتة، أربعة، خمسة جمال! 🐪',
          textEn: 'Then he saw camels! One, two, three, four, five camels! 🐪',
          choices: [
            StoryChoice(
              textAr: 'يلا نلعب لعبة الأرقام!',
              textEn: "Let's play the numbers game!",
              nextSegmentIndex: 3,
            ),
            StoryChoice(
              textAr: 'كمل الحدوتة',
              textEn: 'Continue the story',
              nextSegmentIndex: 4,
            ),
          ],
        ),
        StorySegment(
          textAr: 'فرفور اتعلم يعد لحد عشرة! أنت كمان تقدر! 🎉',
          textEn: 'Farfour learned to count to ten! You can too! 🎉',
        ),
      ],
    );
  }
  
  /// Story: Farfour's Letter Hunt in Alexandria
  static Story letterAdventure() {
    return Story(
      id: 'letter_adventure_alexandria',
      titleAr: 'فرفور يبحث عن الحروف في الإسكندرية',
      titleEn: "Farfour's Letter Hunt in Alexandria",
      theme: 'letters',
      difficulty: 'medium',
      learningObjectives: ['تعلم الحروف العربية', 'التعرف على الإسكندرية'],
      segments: [
        StorySegment(
          textAr: 'فرفور سافر الإسكندرية عشان يدور على الحروف المفقودة! 🔍',
          textEn: 'Farfour traveled to Alexandria to search for the missing letters! 🔍',
        ),
        StorySegment(
          textAr: 'لقى حرف "أ" عند قلعة قايتباي! أ... أسد! 🦁',
          textEn: 'He found the letter "أ" at Qaitbay Citadel! أ... أسد (Lion)! 🦁',
        ),
        StorySegment(
          textAr: 'وحرف "ب" كان مخبي عند البحر! ب... بحر! 🌊',
          textEn: 'And the letter "ب" was hiding by the sea! ب... بحر (Sea)! 🌊',
        ),
        StorySegment(
          textAr: 'فرفور لقى كل الحروف! أنت كمان تقدر تتعلم الحروف! 📚',
          textEn: 'Farfour found all the letters! You can learn letters too! 📚',
        ),
      ],
    );
  }
  
  /// Story: Farfour and the Shape Mystery
  static Story shapeAdventure() {
    return Story(
      id: 'shape_adventure_museum',
      titleAr: 'فرفور ولغز الأشكال في المتحف',
      titleEn: 'Farfour and the Shape Mystery at the Museum',
      theme: 'shapes',
      difficulty: 'easy',
      learningObjectives: ['تعلم الأشكال الهندسية', 'التعرف على المتحف المصري'],
      segments: [
        StorySegment(
          textAr: 'فرفور راح المتحف المصري ولقى أشكال غريبة! 🏛️',
          textEn: 'Farfour went to the Egyptian Museum and found strange shapes! 🏛️',
        ),
        StorySegment(
          textAr: 'شاف دائرة ذهبية! ⭕ دي كانت قرص الشمس!',
          textEn: 'He saw a golden circle! ⭕ It was the sun disk!',
        ),
        StorySegment(
          textAr: 'ولقى مثلث كبير! 🔺 ده كان شكل الهرم!',
          textEn: 'And found a big triangle! 🔺 It was the pyramid shape!',
        ),
        StorySegment(
          textAr: 'فرفور اتعلم كل الأشكال! يلا نلعب لعبة الأشكال! 🎨',
          textEn: 'Farfour learned all the shapes! Let\'s play the shapes game! 🎨',
        ),
      ],
    );
  }
  
  /// Story: Farfour's Maze Adventure in Khan El-Khalili
  static Story mazeAdventure() {
    return Story(
      id: 'maze_adventure_khan',
      titleAr: 'فرفور في متاهة خان الخليلي',
      titleEn: "Farfour's Maze Adventure in Khan El-Khalili",
      theme: 'problem_solving',
      difficulty: 'medium',
      learningObjectives: ['حل المشكلات', 'التفكير المنطقي', 'التعرف على خان الخليلي'],
      segments: [
        StorySegment(
          textAr: 'فرفور راح خان الخليلي وتاه في الشوارع الضيقة! 🏪',
          textEn: 'Farfour went to Khan El-Khalili and got lost in the narrow streets! 🏪',
        ),
        StorySegment(
          textAr: 'لازم يلاقي الطريق للخروج! هيروح يمين ولا شمال؟ 🤔',
          textEn: 'He needs to find the way out! Should he go right or left? 🤔',
          choices: [
            StoryChoice(
              textAr: 'يروح يمين',
              textEn: 'Go right',
              nextSegmentIndex: 2,
            ),
            StoryChoice(
              textAr: 'يروح شمال',
              textEn: 'Go left',
              nextSegmentIndex: 3,
            ),
          ],
        ),
        StorySegment(
          textAr: 'برافو! فرفور لقى محل الحلويات! 🍬 بس لسه محتاج يلاقي الخروج!',
          textEn: 'Bravo! Farfour found the sweets shop! 🍬 But he still needs to find the exit!',
        ),
        StorySegment(
          textAr: 'فرفور استخدم ذكاءه ولقى الطريق! أنت كمان ذكي زيه! 🧠',
          textEn: 'Farfour used his intelligence and found the way! You are smart like him! 🧠',
        ),
      ],
    );
  }
  
  /// Story: Alef's Big Dream (Teaching letter 'أ')
  static Story alefBigDream() {
    return Story(
      id: 'alef_big_dream',
      titleAr: 'ألف وحلمه الكبير',
      titleEn: "Alef's Big Dream",
      theme: 'letters',
      difficulty: 'easy',
      learningObjectives: ['تعلم حرف الألف', 'كلمات تبدأ بحرف أ'],
      segments: [
        StorySegment(
          textAr: 'في يوم من الأيام، كان فيه أرنب صغير اسمه ألف. \nألف كان عنده حلم كبير جدًا: إنه يكتشف الأماكن العجيبة حوالين الغابة ويعرف كل الحيوانات اللي فيها.',
          textEn: 'Once upon a time, there was a little rabbit named Alef. \nAlef had a very big dream: to discover the wondrous places around the forest and know all the animals in it.',
        ),
        StorySegment(
          textAr: 'ألف كان يحب يقول كلمة ألف كتير لأنه أول حرف في اسمه.\n\n"أ" زي أرنب\n\n"أ" زي أزهار\n\n"أ" زي أصدقاء',
          textEn: 'Alef loved saying the word "Alef" a lot because it was the first letter of his name.\n\n"A" for Rabbit\n\n"A" for Flowers\n\n"A" for Friends',
        ),
        StorySegment(
          textAr: 'في الصباح، صحى ألف وقال:\n\n"النهاردة هبدأ مغامرتي الكبيرة!"',
          textEn: 'In the morning, Alef woke up and said:\n\n"Today I will start my big adventure!"',
        ),
        StorySegment(
          textAr: 'ركض أرنبنا الصغير وسط الأشجار ولقى أسد نائم. الأسد كان ضخم ومخيف، بس ألف قال له بأدب:\n\n"صباح الخير يا أسد، أنا أرنب صغير اسمي ألف وعايز أتعلم عن الغابة!"',
          textEn: 'Our little rabbit ran through the trees and found a sleeping lion. The lion was huge and scary, but Alef said to him politely:\n\n"Good morning, Lion, I am a little rabbit named Alef and I want to learn about the forest!"',
        ),
        StorySegment(
          textAr: 'الأسد ابتسم وقال:\n\n"أهلاً يا ألف، حلو إنك جاي تتعلم. تعال شوف أشجار التفاح اللي عندنا!"',
          textEn: 'The lion smiled and said:\n\n"Welcome, Alef, it\'s great that you came to learn. Come see the apple trees we have!"',
        ),
        StorySegment(
          textAr: 'ركض ألف مع الأسد لحد أشجار التفاح. شاف التفاح الأحمر والليمون الأصفر، وقال:\n\n"واو! \'أ\' زي أشجار و\'أ\' زي أكل!"',
          textEn: 'Alef ran with the lion to the apple trees. He saw the red apples and yellow lemons, and said:\n\n"Wow! \'A\' for Trees and \'A\' for Food!"',
        ),
        StorySegment(
          textAr: 'بعدها، ألف قابل أسدًا صغيرًا اسمه أسامة وعصفور اسمه أمير. كلهم لعبوا مع بعض وقالوا كلمات تبدأ بـ "أ":\n\nألف: أرنب\n\nأمير: عصفور\n\nأسامة: أسد صغير\n\nأشجار: التفاح والليمون\n\nأصدقاء: كل الحيوانات اللي لعبت مع بعض',
          textEn: 'After that, Alef met a little lion named Osama and a bird named Amir. They all played together and said words starting with "A":\n\nAlef: Rabbit\n\nAmir: Bird\n\nOsama: Little Lion\n\nTrees: Apple and Lemon\n\nFriends: All the animals who played together',
        ),
        StorySegment(
          textAr: 'وفي آخر اليوم، ألف رجع بيتهم وقال:\n\n"أنا فرحان جدًا! اتعلمت حرف الألف وكمان كلمات كتير تبدأ به. بكرة هبدأ مغامرة جديدة وأتعلم حرف جديد!"',
          textEn: 'At the end of the day, Alef returned home and said:\n\n"I am very happy! I learned the letter Alif and many words starting with it. Tomorrow I will start a new adventure and learn a new letter!"',
        ),
      ],
    );
  }

  /// Get all story templates
  static List<Story> getAllTemplates() {
    return [
      colorAdventure(),
      numberAdventure(),
      letterAdventure(),
      shapeAdventure(),
      mazeAdventure(),
      alefBigDream(),
    ];
  }
}
