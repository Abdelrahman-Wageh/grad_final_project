import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../services/game_service.dart';
import '../services/storage_service.dart';
import '../utils/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  
  @override
  void initState() {
    super.initState();
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    
    _rotateController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
    
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize services
    final gameService = Provider.of<GameService>(context, listen: false);
    final storageService = Provider.of<StorageService>(context, listen: false);
    
    await storageService.initialize();
    await storageService.loadGameProgress();
    
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      // Check if character is already selected
      final hasCharacter = await storageService.hasSelectedCharacter();
      
      if (hasCharacter) {
        // Navigate to new main navigation screen
        Navigator.pushReplacementNamed(
          context,
          '/main-nav',
          arguments: {'profileId': 'default'},
        );
      } else {
        Navigator.pushReplacementNamed(context, '/character-selection');
      }
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFF6B9D),
              const Color(0xFFFFC93C),
              const Color(0xFF74B9FF),
              const Color(0xFFA29BFE),
            ],
            stops: const [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo with Multiple Effects
              AnimatedBuilder(
                animation: _bounceController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _bounceController.value * 20),
                    child: AnimatedBuilder(
                      animation: _rotateController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotateController.value * 0.1,
                          child: AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1.0 + (_pulseController.value * 0.2),
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white,
                                        Color(0xFFFFF8F0),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 30,
                                        spreadRadius: 5,
                                        offset: const Offset(0, 15),
                                      ),
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.5),
                                        blurRadius: 20,
                                        spreadRadius: -5,
                                        offset: const Offset(0, -10),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '🎮',
                                      style: TextStyle(fontSize: 80),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              )
                  .animate()
                  .scale(
                    duration: 1000.ms,
                    curve: Curves.elasticOut,
                    begin: const Offset(0, 0),
                    end: const Offset(1, 1),
                  )
                  .then()
                  .shimmer(
                    duration: 2000.ms,
                    color: Colors.white.withOpacity(0.8),
                  ),
              
              const SizedBox(height: 50),
              
              // App Title with Fun Styling
              const Text(
                'Whispering Woods',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(3, 3),
                      blurRadius: 10,
                      color: Colors.black26,
                    ),
                    Shadow(
                      offset: Offset(-3, -3),
                      blurRadius: 10,
                      color: Colors.white30,
                    ),
                  ],
                  letterSpacing: 2,
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: 1000.ms,
                    delay: 500.ms,
                  )
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 1000.ms,
                    delay: 500.ms,
                    curve: Curves.easeOut,
                  ),
              
              const SizedBox(height: 12),
              
              // Subtitle with Emoji
              const Text(
                '✨ مغامرة تعليمية تفاعلية ✨',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 5,
                      color: Colors.black26,
                    ),
                  ],
                ),
                textDirection: TextDirection.rtl,
              )
                  .animate()
                  .fadeIn(
                    duration: 1000.ms,
                    delay: 1000.ms,
                  )
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 1000.ms,
                    delay: 1000.ms,
                    curve: Curves.easeOut,
                  ),
              
              const SizedBox(height: 60),
              
              // Fun Loading Indicator
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 4,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: 500.ms,
                    delay: 1500.ms,
                  )
                  .scale(
                    duration: 1000.ms,
                    delay: 1500.ms,
                    begin: const Offset(0, 0),
                    end: const Offset(1, 1),
                    curve: Curves.elasticOut,
                  )
                  .then()
                  .shimmer(
                    duration: 2000.ms,
                    color: Colors.white.withOpacity(0.5),
                  ),
              
              const SizedBox(height: 30),
              
              // Loading Text with Emoji
              const Text(
                '🚀 جاري تحميل مغامرتك...',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black26,
                    ),
                  ],
                ),
                textDirection: TextDirection.rtl,
              )
                  .animate()
                  .fadeIn(
                    duration: 500.ms,
                    delay: 2000.ms,
                  )
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 500.ms,
                    delay: 2000.ms,
                  ),
              
              const SizedBox(height: 40),
              
              // Fun Decorative Elements
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  '🌟',
                  '✨',
                  '🎨',
                  '🌈',
                  '🎯',
                ].map((emoji) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 24),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.3, 1.3),
                        duration: 1000.ms,
                        curve: Curves.easeInOut,
                      )
                      .then()
                      .scale(
                        begin: const Offset(1.3, 1.3),
                        end: const Offset(1, 1),
                        duration: 1000.ms,
                        curve: Curves.easeInOut,
                      ),
                )).toList(),
              )
                  .animate()
                  .fadeIn(
                    duration: 1000.ms,
                    delay: 2500.ms,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
