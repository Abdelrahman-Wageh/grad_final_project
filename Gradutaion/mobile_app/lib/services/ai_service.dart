import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/game_state.dart';
import '../models/interaction_log.dart';
import '../models/challenge.dart';
import '../utils/app_constants.dart';
import '../logic/level_manager/level_manager.dart';
import '../data/curriculum/curriculum_data.dart';

class AIService extends ChangeNotifier {
  final Dio _dio = Dio();
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  final Connectivity _connectivity = Connectivity();
  
  bool _isRecording = false;
  bool _isProcessing = false;
  bool _isPlaying = false;
  bool _isOnline = true;
  String? _lastResponse;
  Duration _responseTime = Duration.zero;
  List<double> _audioWaveform = [];
  Timer? _waveformTimer;

  bool get isRecording => _isRecording;
  bool get isProcessing => _isProcessing;
  bool get isPlaying => _isPlaying;
  bool get isOnline => _isOnline;
  String? get lastResponse => _lastResponse;
  Duration get responseTime => _responseTime;
  List<double> get audioWaveform => _audioWaveform;

  AIService() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    
    // Monitor network connectivity
    _connectivity.onConnectivityChanged.listen((result) {
      _isOnline = result != ConnectivityResult.none;
      notifyListeners();
    });
    
    // Check initial connectivity
    _checkConnectivity();
  }
  
  Future<void> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _isOnline = result != ConnectivityResult.none;
    notifyListeners();
  }

  Future<bool> requestPermissions() async {
    final microphoneStatus = await Permission.microphone.request();
    final storageStatus = await Permission.storage.request();
    
    return microphoneStatus.isGranted && storageStatus.isGranted;
  }

  Future<void> startRecording() async {
    if (_isRecording) return;
    
    try {
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        throw Exception('Microphone permission not granted');
      }

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: AppConstants.sampleRate,
          bitRate: 128000,
        ),
        path: '${Directory.systemTemp.path}/recording.wav',
      );
      
      _isRecording = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error starting recording: $e');
      rethrow;
    }
  }

  Future<String?> stopRecording() async {
    if (!_isRecording) return null;
    
    try {
      final path = await _recorder.stop();
      _isRecording = false;
      notifyListeners();
      return path;
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      _isRecording = false;
      notifyListeners();
      return null;
    }
  }

  Future<InteractionLog> processVoiceInput({
    required String audioPath,
    required GameProgress gameProgress,
  }) async {
    final stopwatch = Stopwatch()..start();
    _isProcessing = true;
    notifyListeners();

    try {
      // Step 1: Speech-to-Text
      final sttResponse = await _performSTT(audioPath);
      final transcribedText = sttResponse['text'] as String?;
      
      // Step 2: Natural Language Understanding
      final nluResponse = await _performNLU(
        text: transcribedText,
        gameState: gameProgress.currentState.name,
        gameContext: gameProgress.currentContext.name,
        stateData: gameProgress.stateData,
      );
      
      final aiResponse = nluResponse['response'] as String?;
      
      // Step 3: Text-to-Speech
      String? audioResponsePath;
      if (aiResponse != null) {
        audioResponsePath = await _performTTS(aiResponse);
      }

      stopwatch.stop();
      _responseTime = stopwatch.elapsed;
      _lastResponse = aiResponse;
      
      // Create interaction log
      final log = InteractionLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        gameState: gameProgress.currentState.name,
        gameContext: gameProgress.currentContext.name,
        childQuery: transcribedText,
        aiResponse: aiResponse,
        success: aiResponse != null,
        responseTime: _responseTime,
        metadata: {
          'audioPath': audioPath,
          'responseAudioPath': audioResponsePath,
          'sttConfidence': sttResponse['confidence'],
          'nluConfidence': nluResponse['confidence'],
        },
      );

      return log;
    } catch (e) {
      stopwatch.stop();
      _responseTime = stopwatch.elapsed;
      debugPrint('Error processing voice input: $e');
      
      return InteractionLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        gameState: gameProgress.currentState.name,
        gameContext: gameProgress.currentContext.name,
        childQuery: null,
        aiResponse: null,
        success: false,
        responseTime: _responseTime,
        metadata: {'error': e.toString()},
      );
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> _performSTT(String audioPath) async {
    try {
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(audioPath),
      });

      final response = await _dio.post(
        AppConstants.sttEndpoint,
        data: formData,
      );

      return response.data;
    } catch (e) {
      debugPrint('STT Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _performNLU({
    required String? text,
    required String gameState,
    required String gameContext,
    required Map<String, dynamic> stateData,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.nluEndpoint,
        data: {
          'text': text,
          'game_state': gameState,
          'game_context': gameContext,
          'state_data': stateData,
        },
      );

      return response.data;
    } catch (e) {
      debugPrint('NLU Error: $e');
      rethrow;
    }
  }

  Future<String?> _performTTS(String text) async {
    try {
      final response = await _dio.post(
        AppConstants.ttsEndpoint,
        data: {'text': text},
        options: Options(responseType: ResponseType.bytes),
      );

      // Save audio file
      final tempDir = Directory.systemTemp;
      final audioFile = File('${tempDir.path}/response_${DateTime.now().millisecondsSinceEpoch}.wav');
      await audioFile.writeAsBytes(response.data);
      
      return audioFile.path;
    } catch (e) {
      debugPrint('TTS Error: $e');
      return null;
    }
  }

  Future<void> playResponse(String audioPath) async {
    if (_isPlaying) return;
    
    try {
      _isPlaying = true;
      notifyListeners();
      
      await _player.play(DeviceFileSource(audioPath));
      
      // Wait for playback to complete
      await _player.onPlayerComplete.first;
      
    } catch (e) {
      debugPrint('Error playing audio: $e');
    } finally {
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> analyzeDrawing({
    required Uint8List imageData,
    required String challenge,
  }) async {
    try {
      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          imageData,
          filename: 'drawing.png',
        ),
        'challenge': challenge,
      });

      final response = await _dio.post(
        AppConstants.drawingEndpoint,
        data: formData,
      );

      return response.data;
    } catch (e) {
      debugPrint('Drawing Analysis Error: $e');
      rethrow;
    }
  }

  void stopPlayback() {
    _player.stop();
    _isPlaying = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }
}
