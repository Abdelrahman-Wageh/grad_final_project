import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/message.dart';
import '../models/conversation_history.dart';
import '../providers/ai_service_provider.dart';
import '../providers/storage_service_provider.dart';
import '../core/character/farfour_controller.dart';
import '../widgets/character/farfour_widget.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/microphone_button.dart';
import '../theme/smartino_colors.dart';
import '../theme/smartino_typography.dart';
import '../utils/celebration_utils.dart';
import 'package:record/record.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

/// Friend Tab - Open conversation mode with Farfour
/// Enhanced with AIOrchestrator and context-aware conversations
/// Requirements: 16.1, 16.2, 16.3, 16.4, 16.5, 16.6, 16.7, 20.1, 20.2
class FriendTabView extends ConsumerStatefulWidget {
  final String profileId;

  const FriendTabView({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  @override
  ConsumerState<FriendTabView> createState() => _FriendTabViewState();
}

class _FriendTabViewState extends ConsumerState<FriendTabView> {
  final ScrollController _scrollController = ScrollController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<Message> _messages = [];
  ConversationHistory? _conversationHistory;
  bool _isRecording = false;
  bool _isProcessing = false;
  String? _currentAudioPath;
  Map<String, dynamic> _conversationContext = {};

  @override
  void initState() {
    super.initState();
    _loadConversationHistory();
    _loadConversationContext();
  }

  Future<void> _loadConversationContext() async {
    // Build basic context - progression manager will be added later if needed
    _conversationContext = {
      'totalStars': 0,
      'completedStages': 0,
      'overallCompletion': 0.0,
      'nextStage': null,
      'profileId': widget.profileId,
    };
  }

  Future<void> _loadConversationHistory() async {
    final storageService = ref.read(localStorageServiceProvider);

    // Load or create conversation history
    final histories = storageService.getConversationsForProfile(widget.profileId);

    if (histories.isEmpty) {
      // Create new conversation
      _conversationHistory = await storageService.createConversation(widget.profileId);
    } else {
      // Load most recent conversation
      _conversationHistory = histories.first;
      // Load messages for this conversation
      _messages = storageService.getRecentMessages(_conversationHistory!.id, count: 50);
    }

    setState(() {});
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _startRecording() async {
    if (_isProcessing) return;

    final hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) {
      _showError('Microphone permission required');
      return;
    }

    setState(() {
      _isRecording = true;
    });
    
    // Farfour starts listening
    ref.read(farfourControllerProvider.notifier).listen();

    // Start recording
    if (kIsWeb) {
      await _audioRecorder.start(
        const RecordConfig(),
        path: '', // Path is ignored on web
      );
    } else {
      final tempDir = await Directory.systemTemp.createTemp('smartino_recording');
      final recordingPath = '${tempDir.path}/recording.wav';
      await _audioRecorder.start(
        const RecordConfig(),
        path: recordingPath,
      );
      _currentAudioPath = recordingPath;
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    setState(() {
      _isRecording = false;
      _isProcessing = true;
    });
    
    // Farfour starts thinking
    ref.read(farfourControllerProvider.notifier).think();

    // Stop recording and get path/URL
    final path = await _audioRecorder.stop();

    if (path == null || path.isEmpty) {
      _showError('Recording failed');
      setState(() {
        _isProcessing = false;
      });
      ref.read(farfourControllerProvider.notifier).idle();
      return;
    }

    if (kIsWeb) {
      // On web, stop() returns a blob URL. We need to fetch the bytes.
      try {
        final audioBytes = await _fetchBlobBytes(path);
        await _processAudioBytes(audioBytes, path);
      } catch (e) {
        _showError('Failed to read recording: $e');
        setState(() => _isProcessing = false);
        ref.read(farfourControllerProvider.notifier).idle();
      }
    } else {
      await _processAudio(path);
    }
  }

  Future<Uint8List> _fetchBlobBytes(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch blob: ${response.statusCode}');
    }
    return response.bodyBytes;
  }

  Future<void> _processAudioBytes(Uint8List audioBytes, String originalPath) async {
    try {
      final aiOrchestrator = ref.read(aiOrchestratorProvider);
      
      final result = await aiOrchestrator.processVoiceInput(
        audioBytes,
        context: _conversationContext,
      );

      await _handleAIResult(result, originalPath);
    } catch (e) {
      _showError('Error processing audio: $e');
      setState(() => _isProcessing = false);
      ref.read(farfourControllerProvider.notifier).idle();
    }
  }

  Future<void> _processAudio(String audioPath) async {
    try {
      final audioFile = File(audioPath);
      final audioBytes = await audioFile.readAsBytes();
      
      final aiOrchestrator = ref.read(aiOrchestratorProvider);
      
      final result = await aiOrchestrator.processVoiceInput(
        audioBytes,
        context: _conversationContext,
      );

      await _handleAIResult(result, audioPath);
    } catch (e) {
      _showError('Error: $e');
      setState(() => _isProcessing = false);
      ref.read(farfourControllerProvider.notifier).idle();
    }
  }

  Future<void> _handleAIResult(Map<String, dynamic> result, String audioPath) async {
    try {
      final storageService = ref.read(localStorageServiceProvider);

      if (result['success'] != true) {
        _showError(result['error'] as String? ?? 'Processing failed');
        setState(() {
          _isProcessing = false;
        });
        ref.read(farfourControllerProvider.notifier).idle();
        return;
      }

      final responseText = result['text'] as String? ?? 'Response';
      final audioResponsePath = result['audioPath'] as String?;

      // Add user message to chat and save
      final userMessage = await storageService.saveMessage(
        conversationId: _conversationHistory!.id,
        role: MessageRole.user,
        content: 'Audio message',
        audioPath: audioPath,
      );

      setState(() {
        _messages.add(userMessage);
      });
      _scrollToBottom();

      // Add assistant message to chat and save
      final assistantMessage = await storageService.saveMessage(
        conversationId: _conversationHistory!.id,
        role: MessageRole.assistant,
        content: responseText,
      );

      setState(() {
        _messages.add(assistantMessage);
      });
      _scrollToBottom();

      // Farfour speaks response text
      ref.read(farfourControllerProvider.notifier).speak(responseText);

      // AIOrchestrator already played the audio via its own player
      // so we don't need to play it again here.

      // Farfour celebrates if appropriate
      if (responseText.contains('رائع') || responseText.contains('ممتاز')) {
        ref.read(farfourControllerProvider.notifier).celebrate();
        await CelebrationUtils.celebrateSuccess(context, message: 'محادثة رائعة! 💬');
      } else {
        ref.read(farfourControllerProvider.notifier).happy();
      }

      setState(() {
        _isProcessing = false;
      });
      
      // Return to idle after a moment
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          ref.read(farfourControllerProvider.notifier).idle();
        }
      });
    } catch (e) {
      _showError('Error handling result: $e');
      setState(() {
        _isProcessing = false;
      });
      ref.read(farfourControllerProvider.notifier).idle();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SmartinoColors.background,
      appBar: AppBar(
        title: Text(
          'صاحبي فرفور - My Friend Farfour',
          style: SmartinoTypography.headlineMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: SmartinoColors.primary,
        elevation: 0,
        actions: [
          // Show conversation context info
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('محادثة ذكية'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('فرفور يعرف تقدمك:'),
                      const SizedBox(height: 8),
                      Text('⭐ نجوم: ${_conversationContext['totalStars'] ?? 0}'),
                      Text('📚 مراحل مكتملة: ${_conversationContext['completedStages'] ?? 0}'),
                      Text('📊 التقدم: ${((_conversationContext['overallCompletion'] ?? 0.0) * 100).toStringAsFixed(0)}%'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('حسناً'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Farfour at top
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: SmartinoColors.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: const FarfourOverlay(
                  alignment: Alignment.center,
                ),
              ),

              // Chat messages
              Expanded(
                child: _conversationHistory == null
                    ? const Center(child: CircularProgressIndicator())
                    : _messages.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 64,
                                  color: SmartinoColors.primary.withOpacity(0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'ابدأ محادثة مع فرفور!',
                                  style: SmartinoTypography.headlineSmall.copyWith(
                                    color: SmartinoColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'اضغط واستمر على الميكروفون للتحدث',
                                  style: SmartinoTypography.bodyMedium.copyWith(
                                    color: SmartinoColors.textHint,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              return ChatBubble(message: _messages[index]);
                            },
                          ),
              ),

              // Microphone button at bottom
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: SmartinoColors.shadowMedium,
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: MicrophoneButton(
                  isRecording: _isRecording,
                  isProcessing: _isProcessing,
                  onStartRecording: _startRecording,
                  onStopRecording: _stopRecording,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
