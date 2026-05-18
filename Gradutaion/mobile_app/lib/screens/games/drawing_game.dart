import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:vibration/vibration.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/ai_service.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

/// Drawing Game with AI Analysis
/// Child Psychology: Creative expression, AI feedback, positive reinforcement
class DrawingGame extends StatefulWidget {
  final String childName;

  const DrawingGame({
    Key? key,
    required this.childName,
  }) : super(key: key);

  @override
  State<DrawingGame> createState() => _DrawingGameState();
}

class _DrawingGameState extends State<DrawingGame>
    with TickerProviderStateMixin {
  late AnimationController _mascotController;
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _stars = 0;
  int _currentChallengeIndex = 0;
  String _feedback = '';
  bool _isAnalyzing = false;

  final List<Map<String, dynamic>> _challenges = [
    {'name_en': 'Cat', 'name_ar': 'قطة', 'emoji': '🐱'},
    {'name_en': 'House', 'name_ar': 'بيت', 'emoji': '🏠'},
    {'name_en': 'Tree', 'name_ar': 'شجرة', 'emoji': '🌳'},
    {'name_en': 'Sun', 'name_ar': 'شمس', 'emoji': '☀️'},
    {'name_en': 'Car', 'name_ar': 'سيارة', 'emoji': '🚗'},
  ];

  final List<DrawingPoint> _points = [];
  Color _selectedColor = Colors.black;
  double _strokeWidth = 5.0;

  final List<Color> _colors = [
    Colors.black,
    Color(0xFFFF5252),
    Color(0xFF448AFF),
    Color(0xFF69F0AE),
    Color(0xFFFFD740),
    Color(0xFFFF6B9D),
    Color(0xFFA29BFE),
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

    _speakIntroduction();
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
    final challenge = _challenges[_currentChallengeIndex];
    setState(() {
      _feedback = 'مرحباً ${widget.childName}! ارسم ${challenge['name_ar']} ${challenge['emoji']}';
    });
  }

  void _handleAnalyzeDrawing() async {
    if (_points.isEmpty) {
      setState(() {
        _feedback = 'ارسم شيئاً أولاً ${widget.childName}!';
      });
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _feedback = 'دعني أرى رسمتك الجميلة...';
    });

    try {
      // Convert drawing to image
      final imageData = await _captureDrawing();
      
      // Send to AI service for analysis
      final aiService = Provider.of<AIService>(context, listen: false);
      final challenge = _challenges[_currentChallengeIndex];
      
      final result = await aiService.analyzeDrawing(
        imageData: imageData,
        challenge: challenge['name_en'],
      );

      // Process AI response
      final confidence = result['confidence'] ?? 0.0;
      final recognized = result['recognized'] ?? false;

      if (recognized || confidence > 0.6) {
        // Success!
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
          _feedback = 'رائع ${widget.childName}! رسمة جميلة جداً! 🎨';
          _isAnalyzing = false;
        });

        _confettiController.play();

        await Future.delayed(Duration(seconds: 2));

        if (_currentChallengeIndex < _challenges.length - 1) {
          setState(() {
            _currentChallengeIndex++;
            _points.clear();
          });
          _speakIntroduction();
        } else {
          _showCompletionDialog();
        }
      } else {
        // Encourage to try again
        setState(() {
          _feedback = 'رسمة جميلة ${widget.childName}! حاول مرة أخرى!';
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      // AI service not available - give positive feedback anyway
      setState(() {
        _stars++;
        _feedback = 'رائع ${widget.childName}! رسمة جميلة جداً! 🎨';
        _isAnalyzing = false;
      });

      _confettiController.play();

      await Future.delayed(Duration(seconds: 2));

      if (_currentChallengeIndex < _challenges.length - 1) {
        setState(() {
          _currentChallengeIndex++;
          _points.clear();
        });
        _speakIntroduction();
      } else {
        _showCompletionDialog();
      }
    }
  }

  Future<Uint8List> _captureDrawing() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size(400, 400);

    // Draw white background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    // Draw the points
    for (int i = 0; i < _points.length - 1; i++) {
      if (_points[i].offset != null && _points[i + 1].offset != null) {
        canvas.drawLine(
          _points[i].offset!,
          _points[i + 1].offset!,
          _points[i].paint,
        );
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    
    return byteData!.buffer.asUint8List();
  }

  void _clearDrawing() {
    setState(() {
      _points.clear();
    });
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
                '🎨',
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
                'أنت فنان موهوب!',
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
                  Color(0xFFFFF3E0),
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

                // Feedback
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

                // Drawing canvas
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: GestureDetector(
                        onPanStart: (details) {
                          setState(() {
                            _points.add(
                              DrawingPoint(
                                offset: details.localPosition,
                                paint: Paint()
                                  ..color = _selectedColor
                                  ..strokeWidth = _strokeWidth
                                  ..strokeCap = StrokeCap.round,
                              ),
                            );
                          });
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            _points.add(
                              DrawingPoint(
                                offset: details.localPosition,
                                paint: Paint()
                                  ..color = _selectedColor
                                  ..strokeWidth = _strokeWidth
                                  ..strokeCap = StrokeCap.round,
                              ),
                            );
                          });
                        },
                        onPanEnd: (details) {
                          setState(() {
                            _points.add(DrawingPoint(offset: null, paint: Paint()));
                          });
                        },
                        child: CustomPaint(
                          painter: DrawingPainter(_points),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  ),
                ),

                // Color picker
                Container(
                  height: 60,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _colors.length,
                    itemBuilder: (context, index) {
                      final color = _colors[index];
                      final isSelected = color == _selectedColor;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.transparent,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.5),
                                blurRadius: isSelected ? 15 : 5,
                                spreadRadius: isSelected ? 3 : 0,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),

                // Action buttons
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _clearDrawing,
                        icon: Icon(Icons.clear),
                        label: Text('مسح', textDirection: TextDirection.rtl),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isAnalyzing ? null : _handleAnalyzeDrawing,
                        icon: _isAnalyzing
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(Icons.check),
                        label: Text('تحليل', textDirection: TextDirection.rtl),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.leafGreen,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawingPoint {
  final Offset? offset;
  final Paint paint;

  DrawingPoint({required this.offset, required this.paint});
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].offset != null && points[i + 1].offset != null) {
        canvas.drawLine(
          points[i].offset!,
          points[i + 1].offset!,
          points[i].paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
