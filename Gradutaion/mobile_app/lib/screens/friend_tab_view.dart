import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/message.dart';
import '../models/conversation_history.dart';
import '../services/local_storage_service.dart';
import '../services/dual_brain_ai_service.dart';
import '../services/local_ai_service.dart';
import '../widgets/smartino_mascot_placeholder.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/microphone_button.dart';
import 'package:record/record.dart';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

/// Friend Tab - Open conversation mode with Smartino
/// Requirements: 16.1, 16.2, 16.3, 16.4, 16.5, 16.6, 16.7
class FriendTabView extends StatefulWidget {
  final String profileId;

  const FriendTabView({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  @override
  State<FriendTabView> createState() => _FriendTabViewState();
}

class _FriendTabViewState extends State<FriendTabView> {
  final ScrollController _scrollController = ScrollController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<Message> _messages = [];
  ConversationHistory? _conversationHistory;
  MascotMood _mascotMood = MascotMood.idle;
  bool _isRecording = false;
  bool _isProcessing = false;
  String? _currentAudioPath;

  @override
  void initState() {
    super.initState();
    _loadConversationHistory();
  }

  Future<void> _loadConversationHistory() async {
    final storageService = context.read<LocalStorageService>();

    // Load or create conversation history
    final histories =
        await storageService.getConversationHistories(widget.profileId);

    if (histories.isEmpty) {
      // Create new conversation
      _conversationHistory = ConversationHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        profileId: widget.profileId,
        messages: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await storageService.saveConversationHistory(_conversationHistory!);
    } else {
      // Load most recent conversation
      _conversationHistory = histories.first;
      _messages = _conversationHistory!.messages;
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
      _mascotMood = MascotMood.listening;
    });

    // Start recording
    await _audioRecorder.start();
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    setState(() {
      _isRecording = false;
      _isProcessing = true;
      _mascotMood = MascotMood.thinking;
    });

    // Stop recording and get audio path
    final path = await _audioRecorder.stop();

    if (path == null) {
      _showError('Recording failed');
      setState(() {
        _isProcessing = false;
        _mascotMood = MascotMood.idle;
      });
      return;
    }

    _currentAudioPath = path;
    await _processAudio(path);
  }

  Future<void> _processAudio(String audioPath) async {
    try {
      final localAIService = context.read<LocalAIService>();
      final dualBrainService = context.read<DualBrainAIService>();
      final storageService = context.read<LocalStorageService>();

      // Step 1: Transcribe audio (STT)
      // Requirement 16.2: Send audio to Whisper STT
      final transcription = await localAIService.transcribeAudio(audioPath);

      if (transcription.isEmpty) {
        _showError('Could not understand audio');
        setState(() {
          _isProcessing = false;
          _mascotMood = MascotMood.idle;
        });
        return;
      }

      // Add user message to chat
      final userMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.user,
        content: transcription,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(userMessage);
      });
      _scrollToBottom();

      // Step 2: Generate response (LLM)
      // Requirement 16.3: Send to Qwen LLM with conversation history
      final response = await dualBrainService.processInput(
        transcription,
        conversationHistory: _messages,
        useLLMMode: true, // Force LLM mode for Friend Tab
      );

      // Add assistant message to chat
      final assistantMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.assistant,
        content: response.text,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(assistantMessage);
        _mascotMood = MascotMood.happy;
      });
      _scrollToBottom();

      // Step 3: Synthesize speech (TTS)
      // Requirement 16.4: Send to TTS for voice output
      final ttsResult = await localAIService.synthesizeSpeech(response.text);

      if (ttsResult.audioPath != null) {
        // Play audio
        await _audioPlayer.play(DeviceFileSource(ttsResult.audioPath!));

        // Requirement 16.5: Animate lip-sync with visemes
        // TODO: Implement viseme animation when Rive mascot is ready
        // For now, just show happy mood while speaking
        setState(() {
          _mascotMood = MascotMood.happy;
        });

        // Wait for audio to finish
        await _audioPlayer.onPlayerComplete.first;
      }

      // Step 4: Save conversation history
      // Requirement 16.6, 16.7: Save to Hive for memory
      _conversationHistory!.messages = _messages;
      _conversationHistory!.updatedAt = DateTime.now();
      await storageService.saveConversationHistory(_conversationHistory!);

      setState(() {
        _isProcessing = false;
        _mascotMood = MascotMood.idle;
      });
    } catch (e) {
      _showError('Error: $e');
      setState(() {
        _isProcessing = false;
        _mascotMood = MascotMood.sad;
      });
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
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: const Text(
          'صاحبي - My Friend',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple.shade400,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Mascot at top
          // Requirement 16.1: Display Smartino with microphone button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade400,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: SmartinoMascotPlaceholder(
              mood: _mascotMood,
              size: 120,
              onTap: () {
                // Easter egg: tap mascot for reaction
                setState(() {
                  _mascotMood = MascotMood.excited;
                });
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    setState(() {
                      _mascotMood = MascotMood.idle;
                    });
                  }
                });
              },
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
                              color: Colors.purple.shade200,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Start a conversation with Smartino!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.purple.shade300,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Press and hold the microphone to speak',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.purple.shade200,
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
                  color: Colors.black.withOpacity(0.1),
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
