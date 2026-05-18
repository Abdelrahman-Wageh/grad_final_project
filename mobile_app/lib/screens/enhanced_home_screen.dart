import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/premium_kid_theme.dart';
import '../widgets/premium_buttons.dart';

/// 🏠 Premium Enhanced Home Screen
/// An impressive, engaging entry point for kids
class EnhancedHomeScreen extends StatefulWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onParentModePressed;
  final String childName;
  final int currentLevel;
  final int currentXP;
  final int totalXPForLevel;

  const EnhancedHomeScreen({
    Key? key,
    required this.onPlayPressed,
    required this.onParentModePressed,
    this.childName = 'Adventure Seeker',
    this.currentLevel = 1,
    this.currentXP = 150,
    this.totalXPForLevel = 1000,
  }) : super(key: key);

  @override
  State<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends State<EnhancedHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _characterController;
  late AnimationController _starController;
  late Animation<double> _characterScale;
  late Animation<double> _characterY;

  @override
  void initState() {
    super.initState();
    _characterController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _starController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _characterScale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _characterController, curve: Curves.easeInOut),
    );

    _characterY = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: _characterController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _characterController.dispose();
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: PremiumKidTheme.premiumCream,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  PremiumKidTheme.premiumCream,
                  PremiumKidTheme.premiumWhite,
                  Colors.blue[100]!,
                ],
              ),
            ),
          ),

          // Animated background particles
          ..._buildBackgroundParticles(screenSize),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      _buildHeader(context),
                      _buildCharacterSection(screenSize),
                      _buildProgressSection(),
                      _buildStatsSection(),
                      const Spacer(),
                      _buildActionButtons(context),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Premium header with welcome message
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Text(
            '✨ Welcome back, ${widget.childName}! ✨',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1F2E),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: -0.3, end: 0),
          SizedBox(height: 8),
          Text(
            'Ready for an amazing adventure?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(begin: -0.2, end: 0),
        ],
      ),
    );
  }

  /// Animated character display
  Widget _buildCharacterSection(Size screenSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Glow background
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    PremiumKidTheme.vibrantMagenta.withOpacity(0.2),
                    PremiumKidTheme.vibrantMagenta.withOpacity(0),
                  ],
                ),
              ),
            )
                .animate()
                .scaleXY(begin: 0.8, end: 1.2, duration: 2000.ms)
                .then()
                .scaleXY(begin: 1.2, end: 0.8, duration: 2000.ms),

            // Character emoji/avatar
            AnimatedBuilder(
              animation: Listenable.merge([_characterScale, _characterY]),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _characterY.value),
                  child: Transform.scale(
                    scale: _characterScale.value,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: PremiumKidTheme.vibrantMagenta.withOpacity(0.3),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '🎮',
                          style: TextStyle(fontSize: 100),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Floating stars
            ..._buildFloatingStars(screenSize),
          ],
        ),
      ),
    );
  }

  /// Progress and level information
  Widget _buildProgressSection() {
    final progressPercent =
        widget.currentXP / widget.totalXPForLevel;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          // Level badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: PremiumKidTheme.magentaPinkGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: PremiumKidTheme.vibrantMagenta.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🌟',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(width: 8),
                Text(
                  'Level ${widget.currentLevel}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 400.ms)
              .slideY(begin: 0.2, end: 0),
          SizedBox(height: 16),
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Experience to next level',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    '${widget.currentXP}/${widget.totalXPForLevel}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: PremiumKidTheme.vibrantMagenta,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: progressPercent,
                  minHeight: 14,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    PremiumKidTheme.vibrantMagenta,
                  ),
                )
                    .animate()
                    .scaleX(begin: 0, end: 1, duration: 1000.ms, delay: 600.ms)
                    .then()
                    .shimmer(duration: 3000.ms),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Stats display (achievements, streak, etc.)
  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _buildStatCard('🎯', '15', 'Completed'),
          SizedBox(width: 12),
          _buildStatCard('🔥', '7', 'Day Streak'),
          SizedBox(width: 12),
          _buildStatCard('⭐', '82', 'Total Stars'),
        ],
      ),
    );
  }

  /// Individual stat card
  Widget _buildStatCard(String emoji, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
            SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1F2E),
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 600.ms, delay: 800.ms)
          .slideY(begin: 0.3, end: 0),
    );
  }

  /// Action buttons
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          PremiumButton(
            label: '🚀 START ADVENTURE 🚀',
            onPressed: widget.onPlayPressed,
            gradient: PremiumKidTheme.rainbowGradient,
            fontSize: 18,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 1000.ms)
              .slideY(begin: 0.4, end: 0)
              .then()
              .shimmer(duration: 2000.ms, delay: 500.ms),
          SizedBox(height: 16),
          GradientBorderButton(
            label: '👨‍👩‍👧 Parent Dashboard',
            onPressed: widget.onParentModePressed,
            gradient: PremiumKidTheme.blueTurquoiseGradient,
            icon: Icons.family_restroom,
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 1200.ms)
              .slideY(begin: 0.4, end: 0),
        ],
      ),
    );
  }

  /// Floating star animations
  List<Widget> _buildFloatingStars(Size screenSize) {
    return [
      Positioned(
        top: 20,
        left: 20,
        child: _buildFloatingStar(0),
      ),
      Positioned(
        top: 40,
        right: 30,
        child: _buildFloatingStar(1),
      ),
      Positioned(
        bottom: 50,
        left: 40,
        child: _buildFloatingStar(2),
      ),
      Positioned(
        bottom: 40,
        right: 20,
        child: _buildFloatingStar(3),
      ),
    ];
  }

  Widget _buildFloatingStar(int index) {
    return AnimatedBuilder(
      animation: _starController,
      builder: (context, child) {
        final value = (_starController.value + (index * 0.25)) % 1.0;
        final offset = Offset(
          10 * (value - 0.5) * 2,
          -20 * (value * value - value),
        );

        return Transform.translate(
          offset: offset,
          child: Text(
            '✨',
            style: TextStyle(fontSize: 20),
          ),
        );
      },
    );
  }

  /// Background particles
  List<Widget> _buildBackgroundParticles(Size screenSize) {
    return [
      Positioned(
        top: screenSize.height * 0.2,
        left: screenSize.width * 0.1,
        child: Opacity(
          opacity: 0.3,
          child: Text(
            '🎮',
            style: TextStyle(fontSize: 60),
          ),
        )
            .animate()
            .fadeIn(duration: 1000.ms)
            .rotate(duration: 8000.ms)
            .then()
            .rotate(duration: 8000.ms),
      ),
      Positioned(
        bottom: screenSize.height * 0.15,
        right: screenSize.width * 0.1,
        child: Opacity(
          opacity: 0.25,
          child: Text(
            '🎯',
            style: TextStyle(fontSize: 50),
          ),
        )
            .animate()
            .fadeIn(duration: 1000.ms, delay: 200.ms)
            .rotate(duration: 10000.ms)
            .then()
            .rotate(duration: 10000.ms),
      ),
    ];
  }
}
