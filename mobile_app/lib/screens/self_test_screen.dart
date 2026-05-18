import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';

import '../services/api_client.dart';
import '../models/game_state.dart';
import '../utils/app_constants.dart';

/// Self-test screen for debugging backend connectivity (debug builds only)
class SelfTestScreen extends StatefulWidget {
  const SelfTestScreen({super.key});

  @override
  State<SelfTestScreen> createState() => _SelfTestScreenState();
}

class _SelfTestScreenState extends State<SelfTestScreen> {
  final ApiClient _apiClient = ApiClient();
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  
  String _status = 'Ready';
  String? _lastResponseKey;
  String? _lastResponseText;
  String? _drawPrediction;
  bool _isTesting = false;
  bool _isRecording = false;

  @override
  void dispose() {
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _testHealth() async {
    setState(() {
      _isTesting = true;
      _status = 'Testing health endpoint...';
    });

    try {
      final response = await _apiClient.healthCheck();
      setState(() {
        _status = 'Health check: ${response['status']}';
        if (response['dry_run_mode'] == true) {
          _status += '\nMode: DRY_RUN (Placeholder)';
        }
      });
    } catch (e) {
      setState(() {
        _status = 'Health check failed: $e';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  Future<void> _testAdventureSpeech() async {
    setState(() {
      _isTesting = true;
      _status = 'Recording audio sample...';
      _isRecording = true;
    });

    try {
      // Request permission
      if (!await _recorder.hasPermission()) {
        setState(() {
          _status = 'Microphone permission denied';
          _isTesting = false;
          _isRecording = false;
        });
        return;
      }

      // Record 2 seconds of audio
      final path = await _recorder.start(
        const RecordConfig(),
        path: 'test_audio.wav',
      );

      await Future.delayed(const Duration(seconds: 2));
      await _recorder.stop();

      setState(() {
        _status = 'Sending to backend...';
        _isRecording = false;
      });

      // Read audio file
      // Note: In real app, we'd read from path. For test, create minimal audio
      final testAudioBytes = _createTestAudioBytes();

      // Send to backend
      final gameState = GameState.forestAdventure;

      final response = await _apiClient.adventureSpeech(
        audioBytes: testAudioBytes,
        audioFormat: 'wav',
        gameState: gameState,
        playerId: 'self_test',
        characterType: 'bird',
      );

      setState(() {
        _lastResponseKey = response.responseKey;
        _lastResponseText = response.textResponse;
        _status = 'Response received!\nKey: ${response.responseKey}';
      });

      // Try to play audio (if base64 audio is present)
      if (response.audioBase64.isNotEmpty) {
        try {
          final audioBytes = response.audioBytes;
          // Note: AudioPlayer would need file path, this is simplified
          _status += '\nAudio response received (${audioBytes.length} bytes)';
        } catch (e) {
          _status += '\nCould not play audio: $e';
        }
      }
    } catch (e) {
      setState(() {
        _status = 'Adventure speech test failed: $e';
      });
    } finally {
      setState(() {
        _isTesting = false;
        _isRecording = false;
      });
    }
  }

  Future<void> _testDrawRecognition() async {
    setState(() {
      _isTesting = true;
      _status = 'Creating test drawing...';
    });

    try {
      // Create minimal test image (white square)
      final testImageBytes = _createTestImageBytes();

      final response = await _apiClient.recognizeDrawing(
        imageBytes: testImageBytes,
        challenge: 'DRAW_CAT',
        gameState: GameState.drawingGame,
        playerId: 'self_test',
      );

      setState(() {
        _drawPrediction = response.prediction;
        _status = 'Draw recognition:\n'
            'Prediction: ${response.prediction}\n'
            'Confidence: ${(response.confidence * 100).toStringAsFixed(1)}%\n'
            'Correct: ${response.isCorrect}';
      });
    } catch (e) {
      setState(() {
        _status = 'Draw recognition test failed: $e';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  Uint8List _createTestAudioBytes() {
    // Create minimal WAV file (silence) - 1 second
    // In production, read actual recorded file
    final sampleRate = 16000;
    final duration = 1;
    final samples = sampleRate * duration;
    
    // WAV header (44 bytes) + silence data
    final List<int> wavData = [];
    
    // Simple WAV header (simplified)
    wavData.addAll('RIFF'.codeUnits);
    wavData.addAll([0, 0, 0, 0]); // File size (placeholder)
    wavData.addAll('WAVE'.codeUnits);
    wavData.addAll('fmt '.codeUnits);
    wavData.addAll([16, 0, 0, 0]); // Subchunk size
    wavData.addAll([1, 0]); // Audio format (PCM)
    wavData.addAll([1, 0]); // Channels
    wavData.addAll([0x40, 0x1F, 0, 0]); // Sample rate
    wavData.addAll([0x80, 0x3E, 0, 0]); // Byte rate
    wavData.addAll([2, 0]); // Block align
    wavData.addAll([16, 0]); // Bits per sample
    wavData.addAll('data'.codeUnits);
    wavData.addAll([0, 0, 0, 0]); // Data size (placeholder)
    
    // Add silence (zeros)
    wavData.addAll(List.filled(samples * 2, 0));
    
    return Uint8List.fromList(wavData);
  }

  Uint8List _createTestImageBytes() {
    // Create minimal PNG (1x1 white pixel)
    // In production, read actual drawing
    // This is a simplified placeholder - real PNG would be larger
    final pngHeader = [
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
    ];
    
    // Minimal valid PNG (very simplified)
    // For test, we'll use a base64-encoded minimal white square PNG
    const minimalPng = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==';
    return base64Decode(minimalPng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backend Self-Test'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'API Base URL',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConstants.apiBaseUrl,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _status,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (_isRecording)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isTesting ? null : _testHealth,
              icon: const Icon(Icons.health_and_safety),
              label: const Text('Test Health Endpoint'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isTesting ? null : _testAdventureSpeech,
              icon: Icon(_isRecording ? Icons.mic : Icons.mic_none),
              label: const Text('Test Adventure Speech (STT→NLU→TTS)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isTesting ? null : _testDrawRecognition,
              icon: const Icon(Icons.draw),
              label: const Text('Test Draw Recognition'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            if (_lastResponseKey != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Adventure Speech Response',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('Response Key: $_lastResponseKey'),
                      if (_lastResponseText != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text('Text: $_lastResponseText'),
                        ),
                    ],
                  ),
                ),
              ),
            ],
            if (_drawPrediction != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Draw Recognition Response',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('Prediction: $_drawPrediction'),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instructions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('1. Make sure backend is running:\n   cd backend && uvicorn app.main:app --reload'),
                    SizedBox(height: 8),
                    Text('2. Test health endpoint first'),
                    SizedBox(height: 8),
                    Text('3. Test adventure speech (needs microphone permission)'),
                    SizedBox(height: 8),
                    Text('4. Test draw recognition'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

