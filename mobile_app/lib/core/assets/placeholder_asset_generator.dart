/// Placeholder Asset Generator
/// 
/// Generates placeholder assets for immediate functionality.
/// Replace with professional assets for production.

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' show cos, sin;

class PlaceholderAssetGenerator {
  /// Generate placeholder character image
  static Widget generateCharacter(String mood, {double size = 200}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: _getMoodColors(mood),
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          _getMoodEmoji(mood),
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }
  
  /// Generate placeholder balloon
  static Widget generateBalloon(Color color, String letter, {double size = 80}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Balloon body
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                color.withOpacity(0.8),
                color,
              ],
              center: const Alignment(-0.3, -0.3),
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                fontSize: size * 0.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
        // String
        Positioned(
          bottom: -20,
          child: Container(
            width: 2,
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.8),
                  Colors.white.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  /// Generate placeholder background
  static Widget generateBackground(String theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _getBackgroundColors(theme),
        ),
      ),
      child: CustomPaint(
        painter: _BackgroundPainter(theme),
        size: Size.infinite,
      ),
    );
  }
  
  /// Generate placeholder star
  static Widget generateStar(bool filled, {double size = 40}) {
    return Icon(
      filled ? Icons.star : Icons.star_border,
      size: size,
      color: filled ? const Color(0xFFFFD700) : Colors.grey,
      shadows: filled ? [
        Shadow(
          color: Colors.orange.withOpacity(0.5),
          blurRadius: 10,
        ),
      ] : null,
    );
  }
  
  /// Generate placeholder button
  static Widget generateButton(String text, VoidCallback onPressed, {bool enabled = true}) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: enabled ? 8 : 2,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  /// Generate placeholder card
  static Widget generateCard(String letter, {double size = 100}) {
    return Container(
      width: size,
      height: size * 1.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
      ),
    );
  }
  
  // Helper methods
  static List<Color> _getMoodColors(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return [Colors.yellow.shade300, Colors.orange.shade400];
      case 'excited':
        return [Colors.orange.shade300, Colors.red.shade400];
      case 'thinking':
        return [Colors.blue.shade300, Colors.purple.shade400];
      case 'sad':
        return [Colors.blue.shade200, Colors.grey.shade400];
      case 'celebrating':
        return [Colors.pink.shade300, Colors.purple.shade400];
      case 'speaking':
        return [Colors.green.shade300, Colors.teal.shade400];
      case 'sleeping':
        return [Colors.indigo.shade200, Colors.blue.shade300];
      default:
        return [Colors.cyan.shade300, Colors.blue.shade400];
    }
  }
  
  static String _getMoodEmoji(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return '😊';
      case 'excited':
        return '🤩';
      case 'thinking':
        return '🤔';
      case 'sad':
        return '😔';
      case 'celebrating':
        return '🎉';
      case 'speaking':
        return '🗣️';
      case 'sleeping':
        return '😴';
      default:
        return '😀';
    }
  }
  
  static List<Color> _getBackgroundColors(String theme) {
    switch (theme.toLowerCase()) {
      case 'pyramids':
        return [Color(0xFFFFE082), Color(0xFFD4A574)];
      case 'cairo':
        return [Color(0xFF81D4FA), Color(0xFF4FC3F7)];
      case 'nile':
        return [Color(0xFF80DEEA), Color(0xFF4DD0E1)];
      case 'desert':
        return [Color(0xFFFFCC80), Color(0xFFFFB74D)];
      case 'garden':
        return [Color(0xFFA5D6A7), Color(0xFF81C784)];
      default:
        return [Color(0xFF90CAF9), Color(0xFF64B5F6)];
    }
  }

  /// Generate placeholder particle
  static Widget generateParticle(String type, {double size = 32}) {
    IconData icon;
    Color color;
    
    switch (type.toLowerCase()) {
      case 'confetti':
        icon = Icons.celebration;
        color = Colors.purple;
        break;
      case 'star':
        icon = Icons.star;
        color = Colors.yellow;
        break;
      case 'sparkle':
        icon = Icons.auto_awesome;
        color = Colors.cyan;
        break;
      case 'heart':
        icon = Icons.favorite;
        color = Colors.pink;
        break;
      default:
        icon = Icons.circle;
        color = Colors.white;
    }
    
    return Icon(
      icon,
      size: size,
      color: color,
      shadows: [
        Shadow(
          color: color.withOpacity(0.5),
          blurRadius: 8,
        ),
      ],
    );
  }
  
  /// Generate placeholder icon
  static Widget generateIcon(String name, {double size = 48, Color? color}) {
    IconData icon;
    
    switch (name.toLowerCase()) {
      case 'game':
        icon = Icons.sports_esports;
        break;
      case 'story':
        icon = Icons.menu_book;
        break;
      case 'friend':
        icon = Icons.chat_bubble;
        break;
      case 'parent':
        icon = Icons.supervisor_account;
        break;
      case 'settings':
        icon = Icons.settings;
        break;
      default:
        icon = Icons.help_outline;
    }
    
    return Icon(
      icon,
      size: size,
      color: color ?? Colors.blue.shade700,
    );
  }
  
  /// Generate placeholder tile for games
  static Widget generateTile(String letter, {double size = 100, Color? color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color ?? Colors.blue.shade300,
            (color ?? Colors.blue.shade300).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Generate placeholder slot for games
  static Widget generateSlot({double size = 100}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.6),
          width: 3,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.add,
          size: size * 0.4,
          color: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
  
  /// Generate placeholder book
  static Widget generateBook(bool open, {double size = 200}) {
    return Container(
      width: size,
      height: size * 0.7,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.brown.shade400,
            Colors.brown.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: open
          ? Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
                Container(width: 4, color: Colors.brown.shade800),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Icon(
                Icons.menu_book,
                size: size * 0.4,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
    );
  }
  
  /// Generate loading animation
  static Widget generateLoading({double size = 50}) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: size * 0.1,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
      ),
    );
  }
  
  /// Generate success checkmark animation
  static Widget generateSuccess({double size = 100}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.green.shade400,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Icon(
        Icons.check,
        size: size * 0.6,
        color: Colors.white,
      ),
    );
  }
  
  /// Generate error indicator
  static Widget generateError({double size = 100}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.orange.shade400,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Icon(
        Icons.refresh,
        size: size * 0.6,
        color: Colors.white,
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final String theme;
  
  _BackgroundPainter(this.theme);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    // Draw simple decorative elements based on theme
    switch (theme.toLowerCase()) {
      case 'pyramids':
        _drawPyramids(canvas, size, paint);
        break;
      case 'cairo':
        _drawCityscape(canvas, size, paint);
        break;
      case 'nile':
        _drawWaves(canvas, size, paint);
        break;
      case 'desert':
        _drawDunes(canvas, size, paint);
        break;
      case 'garden':
        _drawFlowers(canvas, size, paint);
        break;
      case 'sky':
      default:
        _drawClouds(canvas, size, paint);
        break;
    }
  }
  
  void _drawPyramids(Canvas canvas, Size size, Paint paint) {
    // Large pyramid
    paint.color = Colors.brown.withOpacity(0.4);
    final path1 = Path()
      ..moveTo(size.width * 0.15, size.height * 0.75)
      ..lineTo(size.width * 0.35, size.height * 0.45)
      ..lineTo(size.width * 0.55, size.height * 0.75)
      ..close();
    canvas.drawPath(path1, paint);
    
    // Small pyramid
    paint.color = Colors.brown.withOpacity(0.3);
    final path2 = Path()
      ..moveTo(size.width * 0.5, size.height * 0.75)
      ..lineTo(size.width * 0.65, size.height * 0.55)
      ..lineTo(size.width * 0.8, size.height * 0.75)
      ..close();
    canvas.drawPath(path2, paint);
    
    // Sun
    paint.color = Colors.orange.withOpacity(0.3);
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.15),
      40,
      paint,
    );
  }
  
  void _drawCityscape(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.grey.withOpacity(0.2);
    
    // Buildings
    for (int i = 0; i < 5; i++) {
      final height = 100.0 + (i % 3) * 50;
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * (0.1 + i * 0.18),
          size.height * 0.8 - height,
          size.width * 0.15,
          height,
        ),
        paint,
      );
    }
  }
  
  void _drawWaves(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.blue.withOpacity(0.2);
    
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    
    for (double i = 0; i <= size.width; i += 50) {
      path.quadraticBezierTo(
        i + 25,
        size.height * 0.65,
        i + 50,
        size.height * 0.7,
      );
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  void _drawDunes(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.brown.withOpacity(0.2);
    
    // Multiple dune layers
    for (int layer = 0; layer < 3; layer++) {
      final path = Path();
      final yOffset = size.height * (0.6 + layer * 0.1);
      
      path.moveTo(0, yOffset);
      
      for (double i = 0; i <= size.width; i += 100) {
        path.quadraticBezierTo(
          i + 50,
          yOffset - 30 + layer * 10,
          i + 100,
          yOffset,
        );
      }
      
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      
      canvas.drawPath(path, paint);
    }
  }
  
  void _drawClouds(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.white.withOpacity(0.6);
    
    // Cloud 1
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.2), 30, paint);
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.18), 40, paint);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.2), 35, paint);
    
    // Cloud 2
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.25), 35, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.23), 45, paint);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.25), 30, paint);
    
    // Cloud 3
    canvas.drawCircle(Offset(size.width * 0.45, size.height * 0.35), 25, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.33), 35, paint);
    canvas.drawCircle(Offset(size.width * 0.55, size.height * 0.35), 28, paint);
  }
  
  void _drawFlowers(Canvas canvas, Size size, Paint paint) {
    final colors = [
      Colors.pink,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.yellow,
    ];
    
    for (int i = 0; i < 8; i++) {
      paint.color = colors[i % colors.length].withOpacity(0.4);
      
      final x = size.width * (0.1 + i * 0.11);
      final y = size.height * (0.7 + (i % 2) * 0.1);
      
      // Flower petals
      for (int petal = 0; petal < 5; petal++) {
        final angle = (petal * 72) * 3.14159 / 180;
        canvas.drawCircle(
          Offset(
            x + 15 * cos(angle),
            y + 15 * sin(angle),
          ),
          12,
          paint,
        );
      }
      
      // Flower center
      paint.color = Colors.yellow.withOpacity(0.6);
      canvas.drawCircle(Offset(x, y), 8, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
