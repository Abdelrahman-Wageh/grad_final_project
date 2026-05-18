import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _floatingAnimation = Tween<double>(begin: -15, end: 15).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatingController.dispose();
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
              const Color(0xFFFFF8F0),
              const Color(0xFFFFE6F0),
              const Color(0xFFE6F3FF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 20),
                    // Big "Start" button to go to main navigation
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: _buildStartButton(context),
                    ),
                    const SizedBox(height: 20),
                    // Info text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'اضغط للدخول إلى عالم سمارتينو! 🚀',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: const Color(0xFF636E72),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 600.ms)
                          .slideY(begin: -0.3, end: 0, duration: 600.ms, delay: 600.ms),
                    ),
                    const Spacer(),
                    const SizedBox(height: 80), // Space for floating action button
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _buildParentButton(context),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        // Navigate to main navigation screen with 4 tabs
        Navigator.pushReplacementNamed(context, '/main');
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6C5CE7),
              Color(0xFFA29BFE),
              Color(0xFF74B9FF),
            ],
          ),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C5CE7).withOpacity(0.5),
              blurRadius: 30,
              spreadRadius: 5,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🎮',
                style: TextStyle(fontSize: 50),
              ),
              const SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ابدأ المغامرة',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  Text(
                    'Start Adventure',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 40,
              ),
            ],
          ),
        ),
      )
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.5))
          .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.05, 1.05),
              duration: 1500.ms,
              curve: Curves.easeInOut)
          .then()
          .scale(
              begin: const Offset(1.05, 1.05),
              end: const Offset(1, 1),
              duration: 1500.ms,
              curve: Curves.easeInOut),
    )
        .animate()
        .fadeIn(duration: 800.ms, delay: 400.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 800.ms, delay: 400.ms, curve: Curves.elasticOut);
  }

  Widget _buildHeader(BuildContext context) {
    final gameService = Provider.of<GameService>(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Animated Character Avatar
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatingAnimation.value),
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFFF6B9D),
                              Color(0xFFFFC93C),
                              Color(0xFF74B9FF),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B9D).withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 5,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '🎮',
                            style: TextStyle(fontSize: 60),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          
          const SizedBox(height: 20),
          
          // Greeting with Fun Emojis
          Text(
            'مرحباً! 👋',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
            textDirection: TextDirection.rtl,
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(begin: -0.3, end: 0, duration: 600.ms, delay: 200.ms),
          
          const SizedBox(height: 8),
          
          Text(
            'أي لعبة تريد أن نلعب اليوم؟ 🎯',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFF636E72),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
            textDirection: TextDirection.rtl,
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 400.ms)
              .slideY(begin: -0.3, end: 0, duration: 600.ms, delay: 400.ms),
        ],
      ),
    );
  }

  Widget _buildParentButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        // Haptic feedback on tap
        HapticFeedback.mediumImpact();
        _showParentDashboard(context);
      },
      backgroundColor: const Color(0xFFFF6B9D),
      elevation: 8,
      icon: const Icon(Icons.family_restroom, size: 28),
      label: const Text(
        'لوحة الآباء',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textDirection: TextDirection.rtl,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 1500.ms, curve: Curves.easeInOut)
        .then()
        .scale(begin: const Offset(1.05, 1.05), end: const Offset(1, 1), duration: 1500.ms, curve: Curves.easeInOut);
  }

  void _showParentDashboard(BuildContext context) {
    // Show PIN dialog first
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text(
          '🔒 أدخل رمز الآباء',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          obscureText: true,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 4,
          style: const TextStyle(fontSize: 24, letterSpacing: 8),
          decoration: InputDecoration(
            hintText: '****',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          onSubmitted: (value) {
            if (value == '1234') { // Default PIN
              Navigator.pop(context);
              Navigator.pushNamed(context, '/parent');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    '❌ رمز خاطئ',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: const Color(0xFFFF6B6B),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              );
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', textDirection: TextDirection.rtl),
          ),
        ],
      ),
    );
  }
}