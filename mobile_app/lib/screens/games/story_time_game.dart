import 'package:flutter/material.dart';
import 'package:smartino/widgets/celebration_animations.dart';

/// Story Time Game
/// Interactive storytelling with comprehension questions
class StoryTimeGame extends StatefulWidget {
  final String childName;

  const StoryTimeGame({
    Key? key,
    required this.childName,
  }) : super(key: key);

  @override
  State<StoryTimeGame> createState() => _StoryTimeGameState();
}

class _StoryTimeGameState extends State<StoryTimeGame>
    with SingleTickerProviderStateMixin {
  int _currentStoryIndex = 0;
  int _currentPage = 0;
  int _score = 0;
  bool _showQuestion = false;
  String? _selectedAnswer;
  late AnimationController _pageAnimationController;

  final List<Map<String, dynamic>> _stories = [
    {
      'title': 'الأرنب الصغير',
      'titleEn': 'The Little Rabbit',
      'emoji': '🐰',
      'pages': [
        {
          'text': 'كان يا مكان، أرنب صغير يعيش في الغابة.',
          'image': '🐰🌳',
        },
        {
          'text': 'كان الأرنب يحب أكل الجزر كثيراً.',
          'image': '🐰🥕',
        },
        {
          'text': 'في يوم من الأيام، وجد حديقة مليئة بالجزر.',
          'image': '🐰🥕🥕🥕',
        },
        {
          'text': 'أكل الأرنب حتى شبع وشكر الله.',
          'image': '🐰😊',
        },
      ],
      'question': 'ماذا يحب الأرنب أن يأكل؟',
      'options': ['الجزر', 'التفاح', 'الخبز', 'الحلوى'],
      'correctAnswer': 'الجزر',
    },
    {
      'title': 'القطة والفأر',
      'titleEn': 'The Cat and Mouse',
      'emoji': '🐱',
      'pages': [
        {
          'text': 'كانت هناك قطة صغيرة تلعب في البيت.',
          'image': '🐱🏠',
        },
        {
          'text': 'رأت فأراً صغيراً يجري بسرعة.',
          'image': '🐱🐭',
        },
        {
          'text': 'لكن القطة قررت أن تكون صديقة للفأر.',
          'image': '🐱❤️🐭',
        },
        {
          'text': 'وأصبحا أفضل الأصدقاء.',
          'image': '🐱🤝🐭',
        },
      ],
      'question': 'ماذا فعلت القطة مع الفأر؟',
      'options': ['أكلته', 'صادقته', 'طاردته', 'تركته'],
      'correctAnswer': 'صادقته',
    },
    {
      'title': 'الطائر الطيب',
      'titleEn': 'The Kind Bird',
      'emoji': '🐦',
      'pages': [
        {
          'text': 'كان هناك طائر جميل يعيش على شجرة.',
          'image': '🐦🌳',
        },
        {
          'text': 'رأى طائراً صغيراً جائعاً.',
          'image': '🐦🐤',
        },
        {
          'text': 'أعطاه الطائر الكبير بعض الطعام.',
          'image': '🐦🍞🐤',
        },
        {
          'text': 'شكره الطائر الصغير كثيراً.',
          'image': '🐦😊🐤',
        },
      ],
      'question': 'لماذا أعطى الطائر الكبير الطعام للطائر الصغير؟',
      'options': ['لأنه طيب', 'لأنه خائف', 'لأنه غاضب', 'لأنه نائم'],
      'correctAnswer': 'لأنه طيب',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final story = _stories[_currentStoryIndex];
    if (_currentPage < story['pages'].length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageAnimationController.forward(from: 0);
    } else {
      setState(() {
        _showQuestion = true;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageAnimationController.forward(from: 0);
    }
  }

  void _checkAnswer(String answer) {
    final story = _stories[_currentStoryIndex];
    setState(() {
      _selectedAnswer = answer;
    });

    if (answer == story['correctAnswer']) {
      setState(() {
        _score += 10;
      });

      CelebrationAnimations.showSuccess(
        context,
        message: 'إجابة صحيحة! أحسنت يا ${widget.childName}!',
        onComplete: () {
          if (_currentStoryIndex < _stories.length - 1) {
            setState(() {
              _currentStoryIndex++;
              _currentPage = 0;
              _showQuestion = false;
              _selectedAnswer = null;
            });
          } else {
            _showCompletionDialog();
          }
        },
      );
    } else {
      CelebrationAnimations.showEncouragement(
        context,
        message: 'حاول مرة أخرى!',
        onComplete: () {
          setState(() {
            _selectedAnswer = null;
          });
        },
      );
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          '🎉 أحسنت!',
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'لقد أكملت جميع القصص!',
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'النقاط: $_score',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              'العودة للقائمة',
              textDirection: TextDirection.rtl,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentStoryIndex = 0;
                _currentPage = 0;
                _score = 0;
                _showQuestion = false;
                _selectedAnswer = null;
              });
            },
            child: const Text(
              'اقرأ مرة أخرى',
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final story = _stories[_currentStoryIndex];
    final page = story['pages'][_currentPage];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'وقت القصة',
          textDirection: TextDirection.rtl,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'النقاط: $_score',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _showQuestion ? _buildQuestionView(story) : _buildStoryView(story, page),
      ),
    );
  }

  Widget _buildStoryView(Map<String, dynamic> story, Map<String, dynamic> page) {
    return Column(
      children: [
        // Story title
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                story['emoji'],
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 12),
              Text(
                story['title'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),

        // Progress indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: LinearProgressIndicator(
            value: (_currentPage + 1) / story['pages'].length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Page content
        Expanded(
          child: FadeTransition(
            opacity: _pageAnimationController,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image/Emoji
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.blue[200]!,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        page['image'],
                        style: const TextStyle(fontSize: 80),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Story text
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      page['text'],
                      style: const TextStyle(
                        fontSize: 22,
                        height: 1.8,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Navigation buttons
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: _currentPage > 0 ? _previousPage : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('السابق'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
              Text(
                'صفحة ${_currentPage + 1} من ${story['pages'].length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _nextPage,
                icon: const Icon(Icons.arrow_forward),
                label: Text(
                  _currentPage < story['pages'].length - 1 ? 'التالي' : 'السؤال',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionView(Map<String, dynamic> story) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Question icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.purple[50],
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '❓',
                style: TextStyle(fontSize: 60),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Question text
          Text(
            story['question'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 40),

          // Answer options
          ...List.generate(
            story['options'].length,
            (index) {
              final option = story['options'][index];
              final isSelected = _selectedAnswer == option;
              final isCorrect = option == story['correctAnswer'];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedAnswer == null
                        ? () => _checkAnswer(option)
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: isSelected
                          ? (isCorrect ? Colors.green : Colors.red)
                          : Colors.white,
                      foregroundColor: isSelected ? Colors.white : Colors.black,
                      side: BorderSide(
                        color: isSelected
                            ? (isCorrect ? Colors.green : Colors.red)
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
