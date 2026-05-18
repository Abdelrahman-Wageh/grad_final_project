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
  
  final List<GameCard> _games = [
    GameCard(
      id: 'forest_adventure',
      titleArabic: '🌳 مغامرة الغابة',
      descriptionArabic: 'استكشف الغابة السحرية',
      emoji: '🌳',
      gradient: const [Color(0xFF00B894), Color(0xFF00CEB8)],
      shadowColor: const Color(0xFF00B894),
    ),
    GameCard(
      id: 'color_learning',
      titleArabic: '🎨 تعلم الألوان',
      descriptionArabic: 'اكتشف عالم الألوان',
      emoji: '🎨',
      gradient: const [Color(0xFFFF7675), Color(0xFFFF6B9D)],
      shadowColor: const Color(0xFFFF7675),
    ),
    GameCard(
      id: 'number_learning',
      titleArabic: '🔢 تعلم الأرقام',
      descriptionArabic: 'احسب وتعلم الأرقام',
      emoji: '🔢',
      gradient: const [Color(0xFF74B9FF), Color(0xFF0984E3)],
      shadowColor: const Color(0xFF74B9FF),
    ),
    GameCard(
      id: 'shape_learning',
      titleArabic: '⭐ تعلم الأشكال',
      descriptionArabic: 'تعرف على الأشكال',
      emoji: '⭐',
      gradient: const [Color(0xFFA29BFE), Color(0xFF6C5CE7)],
      shadowColor: const Color(0xFFA29BFE),
    ),
    GameCard(
      id: 'drawing_game',
      titleArabic: '🖌️ لعبة الرسم',
      descriptionArabic: 'ارسم وأبدع',
      emoji: '🖌️',
      gradient: const [Color(0xFFFFE66D), Color(0xFFFFD93D)],
      shadowColor: const Color(0xFFFFE66D),
    ),
    GameCard(
      id: 'memory_game',
      titleArabic: '🧠 لعبة الذاكرة',
      descriptionArabic: 'اختبر ذاكرتك',
      emoji: '🧠',
      gradient: const [Color(0xFF55EFC4), Color(0xFF00B894)],
      shadowColor: const Color(0xFF55EFC4),
    ),
    GameCard(
      id: 'animal_sounds',
      titleArabic: '🐾 أصوات الحيوانات',
      descriptionArabic: 'تعلم أصوات الحيوانات',
      emoji: '🐾',
      gradient: const [Color(0xFFFF6B9D), Color(0xFFC44569)],
      shadowColor: const Color(0xFFFF6B9D),
    ),
    GameCard(
      id: 'story_time',
      titleArabic: '📚 وقت القصة',
      descriptionArabic: 'استمع إلى القصص',
      emoji: '📚',
      gradient: const [Color(0xFFFD79A8), Color(0xFFE84393)],
      shadowColor: const Color(0xFFFD79A8),
    ),
  ];

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
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _games.length,
                  itemBuilder: (context, index) {
                    return _buildGameCard(_games[index], index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildParentButton(context),
    );
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

  Widget _buildGameCard(GameCard game, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.elasticOut,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          // Haptic feedback on tap
          HapticFeedback.mediumImpact();
          // Fun bounce animation on tap
          _startGameWithAnimation(context, game.id);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: game.gradient,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: game.shadowColor.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: game.shadowColor.withOpacity(0.3),
                blurRadius: 40,
                spreadRadius: -5,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                // Haptic feedback on tap
                HapticFeedback.mediumImpact();
                _startGame(context, game.id);
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Big Emoji Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          game.emoji,
                          style: const TextStyle(fontSize: 50),
                        ),
                      ),
                    )
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.5))
                        .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1500.ms, curve: Curves.easeInOut)
                        .then()
                        .scale(begin: const Offset(1.1, 1.1), end: const Offset(1, 1), duration: 1500.ms, curve: Curves.easeInOut),
                    
                    const SizedBox(height: 16),
                    
                    // Title
                    Text(
                      game.titleArabic,
                      style: const TextStyle(
                        fontSize: 22,
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
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Description
                    Text(
                      game.descriptionArabic,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
            .animate()
            .shimmer(duration: 3000.ms, delay: (index * 200).ms, color: Colors.white.withOpacity(0.3)),
      ),
    );
  }

  void _startGameWithAnimation(BuildContext context, String gameId) {
    // Create a temporary scale animation
    setState(() {
      // This will trigger a rebuild with animation
    });
    
    // Small delay for visual feedback
    Future.delayed(const Duration(milliseconds: 100), () {
      _startGame(context, gameId);
    });
  }

  void _startGame(BuildContext context, String gameId) {
    final gameService = Provider.of<GameService>(context, listen: false);
    gameService.startGame(gameId);
    
    Navigator.pushNamed(context, '/game', arguments: gameId);
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

class GameCard {
  final String id;
  final String titleArabic;
  final String descriptionArabic;
  final String emoji;
  final List<Color> gradient;
  final Color shadowColor;

  GameCard({
    required this.id,
    required this.titleArabic,
    required this.descriptionArabic,
    required this.emoji,
    required this.gradient,
    required this.shadowColor,
  });
}
