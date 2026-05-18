import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:vibration/vibration.dart';
import '../../theme/app_theme.dart';
import 'dart:math';

/// Memory Card Matching Game
/// Child Psychology: Memory training, pattern recognition, increasing difficulty
class MemoryGame extends StatefulWidget {
  final String childName;

  const MemoryGame({
    Key? key,
    required this.childName,
  }) : super(key: key);

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame>
    with TickerProviderStateMixin {
  late AnimationController _mascotController;
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _stars = 0;
  int _currentLevel = 1;
  int _moves = 0;
  String _feedback = '';

  List<MemoryCard> _cards = [];
  MemoryCard? _firstCard;
  MemoryCard? _secondCard;
  bool _isChecking = false;
  int _matchedPairs = 0;

  final List<String> _emojis = [
    '🐱', '🐶', '🐻', '🦊', '🐼',
    '🦁', '🐯', '🐸', '🐵', '🐨',
    '🦄', '🐷', '🐮', '🐔', '🐧',
    '🦋', '🐝', '🐞', '🦀', '🐙',
  ];

  @override
  void initState() {
    super.initState();
    
    _mascotController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _confettiController = ConfettiController(
      duration: Duration(seconds: 2),
    );

    _setupLevel();
    _speakIntroduction();
  }

  void _setupLevel() {
    int pairCount;
    switch (_currentLevel) {
      case 1:
        pairCount = 4; // 8 cards
        break;
      case 2:
        pairCount = 6; // 12 cards
        break;
      case 3:
        pairCount = 8; // 16 cards
        break;
      default:
        pairCount = 10; // 20 cards
    }

    // Select random emojis
    final selectedEmojis = (_emojis..shuffle()).take(pairCount).toList();
    
    // Create pairs
    List<MemoryCard> cards = [];
    for (int i = 0; i < selectedEmojis.length; i++) {
      cards.add(MemoryCard(id: i * 2, emoji: selectedEmojis[i]));
      cards.add(MemoryCard(id: i * 2 + 1, emoji: selectedEmojis[i]));
    }

    // Shuffle cards
    cards.shuffle();

    setState(() {
      _cards = cards;
      _matchedPairs = 0;
      _moves = 0;
      _firstCard = null;
      _secondCard = null;
    });
  }

  @override
  void dispose() {
    _mascotController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _speakIntroduction() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _feedback = 'مرحباً ${widget.childName}! ابحث عن الأزواج المتطابقة!';
    });
  }

  void _handleCardTap(MemoryCard card) async {
    if (_isChecking || card.isMatched || card.isFlipped) return;

    setState(() {
      card.isFlipped = true;
    });

    if (_firstCard == null) {
      _firstCard = card;
    } else if (_secondCard == null) {
      _secondCard = card;
      _moves++;
      _isChecking = true;

      // Check for match
      await Future.delayed(Duration(milliseconds: 500));

      if (_firstCard!.emoji == _secondCard!.emoji) {
        // Match found!
        try {
          await _audioPlayer.play(AssetSource('sounds/sfx/correct.mp3'));
        } catch (e) {}

        try {
          if (await Vibration.hasVibrator() ?? false) {
            Vibration.vibrate(duration: 100);
          }
        } catch (e) {}

        setState(() {
          _firstCard!.isMatched = true;
          _secondCard!.isMatched = true;
          _matchedPairs++;
          _feedback = 'رائع ${widget.childName}! زوج متطابق! 🎉';
        });

        _confettiController.play();

        // Check if level complete
        if (_matchedPairs == _cards.length / 2) {
          await Future.delayed(Duration(seconds: 1));
          _handleLevelComplete();
        }
      } else {
        // No match
        setState(() {
          _feedback = 'حاول مرة أخرى ${widget.childName}!';
        });

        await Future.delayed(Duration(milliseconds: 1000));

        setState(() {
          _firstCard!.isFlipped = false;
          _secondCard!.isFlipped = false;
        });
      }

      setState(() {
        _firstCard = null;
        _secondCard = null;
        _isChecking = false;
      });
    }
  }

  void _handleLevelComplete() {
    setState(() {
      _stars++;
    });

    if (_currentLevel < 4) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: AppTheme.magicalGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🎉',
                  style: TextStyle(fontSize: 80),
                ).animate().scale(duration: 500.ms),
                SizedBox(height: 16),
                Text(
                  'رائع ${widget.childName}!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 8),
                Text(
                  'أكملت المستوى $_currentLevel في $_moves حركة!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _currentLevel++;
                      _setupLevel();
                      _speakIntroduction();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.sunnyYellow,
                    foregroundColor: AppTheme.textDark,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'المستوى التالي',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: AppTheme.magicalGradient,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🏆',
                style: TextStyle(fontSize: 80),
              ).animate().scale(duration: 500.ms),
              SizedBox(height: 16),
              Text(
                'مذهل ${widget.childName}!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 8),
              Text(
                'أكملت جميع المستويات!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: AppTheme.sunnyYellow, size: 40),
                  SizedBox(width: 8),
                  Text(
                    '$_stars',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.sunnyYellow,
                  foregroundColor: AppTheme.textDark,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'إنهاء',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = _currentLevel <= 2 ? 4 : 5;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE1F5FE),
                  Color(0xFFFFF9C4),
                ],
              ),
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: [
                AppTheme.magicalPurple,
                AppTheme.sunnyYellow,
                AppTheme.leafGreen,
                Colors.red,
                Colors.blue,
              ],
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 32),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Text(
                              'المستوى $_currentLevel',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star, color: AppTheme.sunnyYellow, size: 24),
                                SizedBox(width: 5),
                                Text(
                                  '$_stars',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Feedback
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    _feedback,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ).animate().fadeIn().slideY(begin: -0.2),

                SizedBox(height: 20),

                // Game grid
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _cards.length,
                      itemBuilder: (context, index) {
                        final card = _cards[index];
                        return _buildCard(card);
                      },
                    ),
                  ),
                ),

                // Moves counter
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'الحركات: $_moves',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.magicalPurple,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(MemoryCard card) {
    return GestureDetector(
      onTap: () => _handleCardTap(card),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: card.isFlipped || card.isMatched
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.magicalPurple,
                    AppTheme.magicalPurpleLight,
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.sunnyYellow,
                    AppTheme.sunnyYellowLight,
                  ],
                ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: card.isFlipped || card.isMatched
              ? Text(
                  card.emoji,
                  style: TextStyle(fontSize: 40),
                )
              : Icon(
                  Icons.question_mark,
                  size: 40,
                  color: Colors.white,
                ),
        ),
      ).animate(
        target: card.isFlipped || card.isMatched ? 1 : 0,
      ).flipH(duration: 300.ms),
    );
  }
}

class MemoryCard {
  final int id;
  final String emoji;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.emoji,
    this.isFlipped = false,
    this.isMatched = false,
  });
}
