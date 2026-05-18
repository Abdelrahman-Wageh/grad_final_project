import 'package:flutter/material.dart';
import 'package:smartino/widgets/celebration_animations.dart';
import 'package:smartino/utils/custom_page_route.dart';

/// Animal Sounds Learning Game
/// Teaches children to recognize animal sounds and names
class AnimalSoundsGame extends StatefulWidget {
  final String childName;

  const AnimalSoundsGame({
    Key? key,
    required this.childName,
  }) : super(key: key);

  @override
  State<AnimalSoundsGame> createState() => _AnimalSoundsGameState();
}

class _AnimalSoundsGameState extends State<AnimalSoundsGame>
    with SingleTickerProviderStateMixin {
  int _currentLevel = 0;
  int _score = 0;
  bool _isPlaying = false;
  String? _selectedAnimal;
  late AnimationController _animationController;

  final List<Map<String, dynamic>> _animals = [
    {
      'name': 'قطة',
      'nameEn': 'Cat',
      'emoji': '🐱',
      'sound': 'meow',
      'color': Colors.orange,
    },
    {
      'name': 'كلب',
      'nameEn': 'Dog',
      'emoji': '🐶',
      'sound': 'woof',
      'color': Colors.brown,
    },
    {
      'name': 'بقرة',
      'nameEn': 'Cow',
      'emoji': '🐮',
      'sound': 'moo',
      'color': Colors.pink,
    },
    {
      'name': 'خروف',
      'nameEn': 'Sheep',
      'emoji': '🐑',
      'sound': 'baa',
      'color': Colors.grey,
    },
    {
      'name': 'أسد',
      'nameEn': 'Lion',
      'emoji': '🦁',
      'sound': 'roar',
      'color': Colors.amber,
    },
    {
      'name': 'فيل',
      'nameEn': 'Elephant',
      'emoji': '🐘',
      'sound': 'trumpet',
      'color': Colors.blueGrey,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _playAnimalSound(String sound) {
    setState(() {
      _isPlaying = true;
    });

    // Simulate sound playing
    _animationController.forward().then((_) {
      _animationController.reverse();
      setState(() {
        _isPlaying = false;
      });
    });

    // TODO: Integrate with TTS service to play actual animal sounds
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔊 Playing: $sound'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _checkAnswer(String selectedAnimal) {
    final correctAnimal = _animals[_currentLevel];

    setState(() {
      _selectedAnimal = selectedAnimal;
    });

    if (selectedAnimal == correctAnimal['name']) {
      // Correct answer
      setState(() {
        _score += 10;
      });

      CelebrationAnimations.showSuccess(
        context,
        message: 'أحسنت! ${correctAnimal['name']} صحيح!',
        onComplete: () {
          setState(() {
            _selectedAnimal = null;
            if (_currentLevel < _animals.length - 1) {
              _currentLevel++;
            } else {
              _showCompletionDialog();
            }
          });
        },
      );
    } else {
      // Wrong answer
      CelebrationAnimations.showEncouragement(
        context,
        message: 'حاول مرة أخرى يا ${widget.childName}!',
        onComplete: () {
          setState(() {
            _selectedAnimal = null;
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
              'لقد أكملت جميع المستويات!',
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
                _currentLevel = 0;
                _score = 0;
                _selectedAnimal = null;
              });
            },
            child: const Text(
              'العب مرة أخرى',
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentAnimal = _animals[_currentLevel];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'أصوات الحيوانات',
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (_currentLevel + 1) / _animals.length,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 20),

              // Level indicator
              Text(
                'المستوى ${_currentLevel + 1} من ${_animals.length}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 40),

              // Animal display with sound button
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_animationController.value * 0.2),
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: () => _playAnimalSound(currentAnimal['sound']),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: currentAnimal['color'].withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: currentAnimal['color'],
                        width: 4,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentAnimal['emoji'],
                            style: const TextStyle(fontSize: 80),
                          ),
                          const SizedBox(height: 10),
                          Icon(
                            _isPlaying ? Icons.volume_up : Icons.volume_off,
                            size: 40,
                            color: currentAnimal['color'],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'اضغط على الحيوان لسماع صوته',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 40),

              // Question
              const Text(
                'ما هو هذا الحيوان؟',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 30),

              // Answer options
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: _animals.length,
                  itemBuilder: (context, index) {
                    final animal = _animals[index];
                    final isSelected = _selectedAnimal == animal['name'];
                    final isCorrect = animal['name'] == currentAnimal['name'];

                    return GestureDetector(
                      onTap: _selectedAnimal == null
                          ? () => _checkAnswer(animal['name'])
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isCorrect ? Colors.green : Colors.red)
                                  .withOpacity(0.2)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? (isCorrect ? Colors.green : Colors.red)
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              animal['emoji'],
                              style: const TextStyle(fontSize: 48),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              animal['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
