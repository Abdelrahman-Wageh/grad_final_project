import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Microphone button for voice recording in Friend Tab
/// Requirements: 16.1
class MicrophoneButton extends StatefulWidget {
  final bool isRecording;
  final bool isProcessing;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;

  const MicrophoneButton({
    Key? key,
    required this.isRecording,
    required this.isProcessing,
    required this.onStartRecording,
    required this.onStopRecording,
  }) : super(key: key);

  @override
  State<MicrophoneButton> createState() => _MicrophoneButtonState();
}

class _MicrophoneButtonState extends State<MicrophoneButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isProcessing) {
      HapticFeedback.mediumImpact();
      widget.onStartRecording();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isRecording) {
      HapticFeedback.lightImpact();
      widget.onStopRecording();
    }
  }

  void _handleTapCancel() {
    if (widget.isRecording) {
      widget.onStopRecording();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status text
          if (widget.isRecording)
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Listening... 🎤',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            )
          else if (widget.isProcessing)
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Thinking... 🤔',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Hold to speak',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),

          // Microphone button
          GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.isRecording ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.isProcessing
                            ? [Colors.grey.shade400, Colors.grey.shade600]
                            : widget.isRecording
                                ? [Colors.red.shade400, Colors.red.shade600]
                                : [
                                    Colors.purple.shade400,
                                    Colors.purple.shade600
                                  ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.isRecording
                              ? Colors.red.withOpacity(0.4)
                              : Colors.purple.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: widget.isRecording ? 8 : 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isProcessing
                          ? Icons.hourglass_empty
                          : widget.isRecording
                              ? Icons.mic
                              : Icons.mic_none,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),

          // Instruction text
          if (!widget.isRecording && !widget.isProcessing)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Press and hold to record',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
}
