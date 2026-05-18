import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:vibration/vibration.dart';
import '../../theme/app_theme.dart';
import 'dart:math';

/// Shape Learning Game - Interactive shape recognition with drag-and-drop
/// Child Psychology: Tactile learning, visual recognition, positive reinforcement
class ShapeLearningGame extends StatefulWidget {
  final String childName;

  const ShapeLearningGame({
    Key? key,
    required this.childName,
  }) : super(key: key);

  @override
  State<ShapeLearningGame> createState() => _ShapeLearningGameState();
}

class _ShapeLearningGameState extends State<ShapeLearningGame>
    with TickerProviderStateMixin {
  late AnimationController _mascotController;
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _stars = 0;
  int _currentShapeIndex = 0;
  String _feedback = '';
  bool _isDragging = false;

  final List<Map<String, dynamic>> _shapes = [
    {
      'name_en': 'Circle',
      'name_ar': 'دائرة',
      'shape': ShapeType.circle,
      'color': Color(0xFFFF5252),
    },
    {
      'name_en': 'Square',
      'name_ar': 'مربع',
      'shape': ShapeType.square,
      'color': Color(0xFF448AFF),
    },
    {
      'name_en': 'Triangle',
      'name_ar': 'مثلث',
      'shape': ShapeType.triangle,
      'color': Color(0xFF69F0AE),
    },
    {
      'name_en': 'Star',
      'name_ar': 'نجمة',
      'shape': ShapeType.star,
      'color': Color(0xFFFFD740),
    },
    {
      'name_en': 'Heart',
      'name_ar': 'قلب',
      'shape': ShapeType.heart,
      'color': Color(0xFFFF6B9D),
    },
  ];

  List<Map<String, dynamic>> _shuffledShapes = [];
  Map<String, dynamic>? _targetShape;

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

    _setupRound();
    _speakIntroduction();
  }

  void _setupRound() {
    _targetShape = _shapes[_currentShapeIndex];
    _shuffledShapes = List.from(_shapes)..shuffle();
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
      _feedback = 'مرحباً ${widget.childName}! دعنا نتعلم الأشكال!';
    });
  }

  void _handleShapeDrop(Map<String, dynamic> droppedShape) async {
    if (droppedShape['shape'] == _targetShape!['shape']) {
      // Correct shape!
      try {
        await _audioPlayer.play(AssetSource('sounds/sfx/correct.mp3'));
      } catch (e) {}

      try {
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 100);
        }
      } catch (e) {}

      setState(() {
        _stars++;
        _feedback = 'برافو ${widget.childName}! هذا ${_targetShape!['name_ar']}!';
      });

      _confettiController.play();

      await Future.delayed(Duration(seconds: 2));

      if (_currentShapeIndex < _shapes.length - 1) {
        setState(() {
          _currentShapeIndex++;
          _setupRound();
        });
      } else {
        _showCompletionDialog();
      }
    } else {
      // Wrong shape - encourage to try again
      setState(() {
        _feedback = 'قريب جداً ${widget.childName}! حاول مرة أخرى!';
      });
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
                'لقد تعلمت جميع الأشكال!',
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
                  Color(0xFFFCE4EC),
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
                // Header with stars
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 32),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
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
                            Icon(
                              Icons.star,
                              color: AppTheme.sunnyYellow,
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '$_stars',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().scale(),
                    ],
                  ),
                ),

                // Mascot with speech bubble
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 32),
                          padding: EdgeInsets.all(20),
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
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                          ),
                        ).animate().fadeIn().slideY(begin: -0.2),

                        SizedBox(height: 20),

                        AnimatedBuilder(
                          animation: _mascotController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + (_mascotController.value * 0.05),
                              child: Text(
                                '🐻',
                                style: TextStyle(fontSize: 120),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Drop target area
                Expanded(
                  flex: 2,
                  child: Center(
                    child: DragTarget<Map<String, dynamic>>(
                      onAccept: _handleShapeDrop,
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppTheme.magicalPurple,
                              width: 4,
                              style: BorderStyle.solid,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'اسحب ${_targetShape!['name_ar']} هنا',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.magicalPurple,
                                ),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),
                              SizedBox(height: 10),
                              Text(
                                _targetShape!['name_en'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.textMedium,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Draggable shapes
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: _shuffledShapes.map((shapeData) {
                        return Draggable<Map<String, dynamic>>(
                          data: shapeData,
                          feedback: Material(
                            color: Colors.transparent,
                            child: _buildShape(shapeData, 100, true),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: _buildShape(shapeData, 80, false),
                          ),
                          child: _buildShape(shapeData, 80, false),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShape(Map<String, dynamic> shapeData, double size, bool isFeedback) {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: ShapePainter(
          shapeType: shapeData['shape'],
          color: shapeData['color'],
        ),
      ),
    ).animate().scale(duration: 300.ms);
  }
}

enum ShapeType {
  circle,
  square,
  triangle,
  star,
  heart,
}

class ShapePainter extends CustomPainter {
  final ShapeType shapeType;
  final Color color;

  ShapePainter({required this.shapeType, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    switch (shapeType) {
      case ShapeType.circle:
        canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.width / 2,
          paint,
        );
        canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.width / 2,
          strokePaint,
        );
        break;

      case ShapeType.square:
        canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          paint,
        );
        canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          strokePaint,
        );
        break;

      case ShapeType.triangle:
        final path = Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
        canvas.drawPath(path, paint);
        canvas.drawPath(path, strokePaint);
        break;

      case ShapeType.star:
        final path = _createStarPath(size);
        canvas.drawPath(path, paint);
        canvas.drawPath(path, strokePaint);
        break;

      case ShapeType.heart:
        final path = _createHeartPath(size);
        canvas.drawPath(path, paint);
        canvas.drawPath(path, strokePaint);
        break;
    }
  }

  Path _createStarPath(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.4;
    final points = 5;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * pi / points) - pi / 2;
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  Path _createHeartPath(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(width / 2, height * 0.35);
    path.cubicTo(
      width / 2,
      height * 0.25,
      width * 0.4,
      height * 0.1,
      width * 0.25,
      height * 0.25,
    );
    path.cubicTo(
      width * 0.1,
      height * 0.4,
      width * 0.1,
      height * 0.55,
      width * 0.1,
      height * 0.55,
    );
    path.cubicTo(
      width * 0.1,
      height * 0.8,
      width / 2,
      height * 0.95,
      width / 2,
      height,
    );
    path.cubicTo(
      width / 2,
      height * 0.95,
      width * 0.9,
      height * 0.8,
      width * 0.9,
      height * 0.55,
    );
    path.cubicTo(
      width * 0.9,
      height * 0.55,
      width * 0.9,
      height * 0.4,
      width * 0.75,
      height * 0.25,
    );
    path.cubicTo(
      width * 0.6,
      height * 0.1,
      width / 2,
      height * 0.25,
      width / 2,
      height * 0.35,
    );
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
