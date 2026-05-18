import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/premium_kid_theme.dart';

/// 🎬 Premium Loading & State Animations
/// Impressive, engaging animations for different app states
class PremiumLoadingStates {
  /// Main loading indicator with animated circles
  static Widget loadingIndicator({
    double size = 60,
    Color color = const Color(0xFFFF006E),
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer rotating ring
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeWidth: 4,
            ),
          )
              .animate()
              .rotate(duration: 2000.ms)
              .then()
              .rotate(duration: 2000.ms),
          // Middle pulsing ring
          Container(
            width: size * 0.7,
            height: size * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
            ),
          )
              .animate()
              .scaleXY(begin: 0.8, end: 1.2, duration: 1000.ms)
              .then()
              .scaleXY(begin: 1.2, end: 0.8, duration: 1000.ms),
          // Center icon
          Text(
            '✨',
            style: TextStyle(fontSize: size * 0.4),
          ),
        ],
      ),
    );
  }

  /// Bouncing balls loader
  static Widget bouncingBallsLoader({
    double size = 15,
    Color color = const Color(0xFFFF006E),
  }) {
    return SizedBox(
      width: size * 4,
      height: size * 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return _BouncingBall(
            size: size,
            color: color,
            delay: index * 100,
          );
        }),
      ),
    );
  }

  /// Animated dots loader
  static Widget dotsLoader({
    double size = 10,
    Color color = const Color(0xFFFF006E),
  }) {
    return SizedBox(
      width: size * 5,
      height: size * 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          4,
          (index) => _AnimatedDot(
            size: size,
            color: color,
            delay: index * 150,
          ),
        ),
      ),
    );
  }

  /// Liquid swipe loading indicator
  static Widget liquidSwipeLoader({
    double width = 100,
    Color color = const Color(0xFFFF006E),
  }) {
    return Center(
      child: _LiquidSwipeLoader(
        width: width,
        color: color,
      ),
    );
  }

  /// Gradient animated loader
  static Widget gradientLoader({
    double size = 60,
    LinearGradient gradient = PremiumKidTheme.magentaPinkGradient,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
            ),
            child: Material(
              color: Colors.transparent,
              child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
          )
              .animate()
              .rotate(duration: 2000.ms)
              .then()
              .rotate(duration: 2000.ms),
        ],
      ),
    );
  }

  /// Full screen loading overlay
  static Widget fullScreenLoader({
    String? message,
    Color backgroundColor = Colors.black87,
  }) {
    return Container(
      color: backgroundColor.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            gradientLoader(),
            if (message != null) ...[
              SizedBox(height: 24),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .then(delay: 300.ms)
                  .shimmer(duration: 2000.ms),
            ],
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms);
  }

  /// Success state animation
  static Widget successAnimation({
    VoidCallback? onComplete,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return _SuccessAnimation(
      onComplete: onComplete,
      duration: duration,
    );
  }

  /// Error state animation
  static Widget errorAnimation({
    String? message,
    VoidCallback? onRetry,
  }) {
    return _ErrorAnimation(
      message: message,
      onRetry: onRetry,
    );
  }

  /// Empty state illustration
  static Widget emptyState({
    String title = 'Nothing here yet!',
    String subtitle = 'Come back later for new adventures',
    IconData icon = Icons.inbox,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: PremiumKidTheme.premiumCream,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 50,
              color: PremiumKidTheme.vibrantMagenta,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scaleXY(begin: 0.5, end: 1, duration: 600.ms),
          SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1F2E),
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(begin: 0.3, end: 0),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 400.ms)
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  /// Skill loading animation
  static Widget skillLoadingAnimation({
    String skillName = 'Learning',
    double progress = 0.65,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          skillName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1F2E),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms),
        SizedBox(height: 16),
        _SkillLoadingBar(progress: progress),
        SizedBox(height: 12),
        Text(
          '${(progress * 100).toStringAsFixed(0)}%',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: PremiumKidTheme.vibrantMagenta,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 200.ms),
      ],
    );
  }
}

/// Bouncing ball animation component
class _BouncingBall extends StatefulWidget {
  final double size;
  final Color color;
  final int delay;

  const _BouncingBall({
    required this.size,
    required this.color,
    required this.delay,
  });

  @override
  State<_BouncingBall> createState() => _BouncingBallState();
}

class _BouncingBallState extends State<_BouncingBall>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    Future.delayed(Duration(milliseconds: widget.delay)).then((_) {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final curve = Curves.easeInOut;
        final value = curve.transform(_controller.value);
        final offset = Offset(0, -40 * (value * value - value));

        return Transform.translate(
          offset: offset,
          child: Container(
            width: widget.size,
            height: widget.size,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
            ),
          ),
        );
      },
    );
  }
}

/// Animated dot component
class _AnimatedDot extends StatelessWidget {
  final double size;
  final Color color;
  final int delay;

  const _AnimatedDot({
    required this.size,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scaleXY(
          begin: 0.5,
          end: 1.2,
          duration: const Duration(milliseconds: 500),
          delay: Duration(milliseconds: delay),
        );
  }
}

/// Liquid swipe loader
class _LiquidSwipeLoader extends StatefulWidget {
  final double width;
  final Color color;

  const _LiquidSwipeLoader({
    required this.width,
    required this.color,
  });

  @override
  State<_LiquidSwipeLoader> createState() => _LiquidSwipeLoaderState();
}

class _LiquidSwipeLoaderState extends State<_LiquidSwipeLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: widget.width,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Align(
                alignment: Alignment(-1 + (_controller.value * 2), 0),
                child: Container(
                  width: widget.width * 0.3,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.color.withOpacity(0),
                        widget.color,
                        widget.color,
                        widget.color.withOpacity(0),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Success animation
class _SuccessAnimation extends StatefulWidget {
  final VoidCallback? onComplete;
  final Duration duration;

  const _SuccessAnimation({
    this.onComplete,
    required this.duration,
  });

  @override
  State<_SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<_SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: PremiumKidTheme.successBright,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 60,
            ),
          )
              .animate()
              .scaleXY(begin: 0, end: 1, duration: 400.ms, curve: Curves.elasticOut)
              .then()
              .rotate(
                begin: 0,
                end: 0.1,
                duration: 100.ms,
              )
              .then()
              .rotate(
                begin: 0.1,
                end: -0.1,
                duration: 100.ms,
              )
              .then()
              .rotate(
                begin: -0.1,
                end: 0,
                duration: 100.ms,
              ),
          SizedBox(height: 24),
          const Text(
            'Great Job! 🎉',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1F2E),
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 200.ms)
              .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}

/// Error animation
class _ErrorAnimation extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const _ErrorAnimation({
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: PremiumKidTheme.errorBright,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_rounded,
              color: Colors.white,
              size: 60,
            ),
          )
              .animate()
              .scaleXY(begin: 0, end: 1, duration: 400.ms, curve: Curves.elasticOut),
          SizedBox(height: 24),
          Text(
            message ?? 'Oops! Something went wrong',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1F2E),
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 200.ms),
          SizedBox(height: 16),
          if (onRetry != null)
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 400.ms),
        ],
      ),
    );
  }
}

/// Skill loading bar
class _SkillLoadingBar extends StatefulWidget {
  final double progress;

  const _SkillLoadingBar({required this.progress});

  @override
  State<_SkillLoadingBar> createState() => _SkillLoadingBarState();
}

class _SkillLoadingBarState extends State<_SkillLoadingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0, end: widget.progress).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: 12,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(6),
          ),
          child: FractionallySizedBox(
            widthFactor: _animation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: PremiumKidTheme.magentaPinkGradient,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        );
      },
    );
  }
}
