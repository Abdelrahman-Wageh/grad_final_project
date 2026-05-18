import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

/// Error Boundary Widget - Catches all Flutter exceptions
/// Shows cute "Sleeping Bear" animation instead of red error screen
class ErrorBoundary extends StatelessWidget {
  final Widget child;
  final Function(FlutterErrorDetails)? onError;

  const ErrorBoundary({
    Key? key,
    required this.child,
    this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }

  static void initialize() {
    // Override Flutter's error widget
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return ErrorBoundaryWidget(details: details);
    };
  }
}

/// The actual error display widget
class ErrorBoundaryWidget extends StatefulWidget {
  final FlutterErrorDetails details;

  const ErrorBoundaryWidget({
    Key? key,
    required this.details,
  }) : super(key: key);

  @override
  State<ErrorBoundaryWidget> createState() => _ErrorBoundaryWidgetState();
}

class _ErrorBoundaryWidgetState extends State<ErrorBoundaryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Log error for debugging
    debugPrint('🐛 Error caught by ErrorBoundary: ${widget.details.exception}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.magicalGradient,
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Sleeping Bear Animation
                    _buildSleepingBear(),
                    
                    const SizedBox(height: 32),
                    
                    // Error Title
                    Text(
                      'عفواً! حدث خطأ صغير',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate(onPlay: (controller) => controller.repeat())
                        .fadeIn(duration: 600.ms)
                        .scale(begin: const Offset(0.8, 0.8)),
                    
                    const SizedBox(height: 16),
                    
                    // Friendly Message
                    Text(
                      'لا تقلق! سنصلح الأمر معاً',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 600.ms),
                    
                    const SizedBox(height: 48),
                    
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Retry Button
                        _buildActionButton(
                          icon: Icons.refresh_rounded,
                          label: 'حاول مرة أخرى',
                          color: AppTheme.sunnyYellow,
                          onPressed: () {
                            // Restart the app
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/',
                              (route) => false,
                            );
                          },
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Go Home Button
                        _buildActionButton(
                          icon: Icons.home_rounded,
                          label: 'العودة للبداية',
                          color: AppTheme.leafGreen,
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/home',
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),
                    
                    const SizedBox(height: 32),
                    
                    // Debug Info (only in debug mode)
                    if (const bool.fromEnvironment('dart.vm.product') == false)
                      _buildDebugInfo(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSleepingBear() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_controller.value * 0.1),
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '🐻💤',
                style: const TextStyle(fontSize: 80),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
        shadowColor: color.withOpacity(0.5),
      ),
    );
  }

  Widget _buildDebugInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🐛 Debug Info:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.details.exception.toString(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontFamily: 'monospace',
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Backend Connection Error Widget
class BackendErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const BackendErrorWidget({
    Key? key,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.magicalGradient,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Sleeping Server Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '🖥️💤',
                    style: TextStyle(fontSize: 60),
                  ),
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.8, 0.8)),
              
              const SizedBox(height: 32),
              
              Text(
                'الخادم نائم!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                'لا يمكن الاتصال بالخادم\nتأكد من تشغيل Backend',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 24),
                label: const Text(
                  'حاول الاتصال مرة أخرى',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.sunnyYellow,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  shadowColor: AppTheme.sunnyYellow.withOpacity(0.5),
                ),
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
