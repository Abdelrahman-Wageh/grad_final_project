# 🤖 AI Integration Guide for Smartino Games

## Overview

This document explains how the Smartino games integrate with your trained STT (Speech-to-Text), TTS (Text-to-Speech), and NLU (Natural Language Understanding) models.

## ✅ What I Implemented

### Games Completed (5/8):
1. ✅ **Color Learning Game** - 3 stages with curriculum integration
2. ✅ **Number Learning Game** - 3 stages with visual counting
3. ✅ **Shape Learning Game** - Drag-and-drop with shape recognition
4. ✅ **Drawing Game** - Canvas drawing with AI analysis integration
5. ✅ **Memory Game** - 4 difficulty levels with card matching

### AI Integration Points:

## 🎯 How AI Integration Works

### 1. **Drawing Game** (FULLY AI-INTEGRATED)
```dart
// Location: mobile_app/lib/screens/games/drawing_game.dart
// Lines: 120-150

// When child finishes drawing:
final aiService = Provider.of<AIService>(context, listen: false);
final result = await aiService.analyzeDrawing(
  imageData: imageData,  // PNG bytes of the drawing
  challenge: challenge['name_en'],  // What they should draw
);

// Your AI model receives:
// - Image data (Uint8List)
// - Challenge name (e.g., "Cat", "House")

// Your AI model should return:
// {
//   'confidence': 0.85,  // 0.0 to 1.0
//   'recognized': true,  // boolean
//   'feedback': 'Great cat drawing!'  // optional
// }
```

### 2. **Voice Interaction** (READY FOR YOUR MODELS)

All games are designed to work with voice, but currently use tap interaction. Here's how to add voice:

```dart
// Example: Color Learning Game with Voice
// Add this method to any game:

Future<void> _handleVoiceInteraction() async {
  final aiService = Provider.of<AIService>(context, listen: false);
  
  // 1. Start recording
  await aiService.startRecording();
  
  // 2. Wait for child to speak (3 seconds)
  await Future.delayed(Duration(seconds: 3));
  
  // 3. Stop recording and get audio path
  final audioPath = await aiService.stopRecording();
  
  // 4. Send to your STT model
  final sttResponse = await aiService._performSTT(audioPath);
  // Returns: {'text': 'red', 'confidence': 0.95}
  
  // 5. Send to your NLU model for validation
  final nluResponse = await aiService._performNLU(
    text: sttResponse['text'],
    gameState: 'color_learning',
    gameContext: 'vocabulary',
    stateData: {'current_color': 'red', 'stage': 1},
  );
  // Returns: {'response': 'Bravo! That is red!', 'correct': true}
  
  // 6. Generate TTS response
  final audioResponsePath = await aiService._performTTS(nluResponse['response']);
  
  // 7. Play response
  await aiService.playResponse(audioResponsePath);
}
```

### 3. **AI Service Endpoints** (YOUR BACKEND)

The AI Service expects these endpoints:

#### STT Endpoint
```
POST /api/stt
Content-Type: multipart/form-data

Body:
- audio: WAV file (16kHz, mono)

Response:
{
  "text": "red",
  "confidence": 0.95
}
```

#### NLU Endpoint
```
POST /api/nlu
Content-Type: application/json

Body:
{
  "text": "red",
  "game_state": "color_learning",
  "game_context": "vocabulary",
  "state_data": {
    "current_color": "red",
    "stage": 1,
    "expected_answer": "red"
  }
}

Response:
{
  "response": "برافو! هذا أحمر!",
  "correct": true,
  "confidence": 0.98
}
```

#### TTS Endpoint
```
POST /api/tts
Content-Type: application/json

Body:
{
  "text": "برافو! هذا أحمر!",
  "language": "ar"
}

Response:
Binary audio data (WAV format)
```

#### Drawing Analysis Endpoint
```
POST /api/analyze-drawing
Content-Type: multipart/form-data

Body:
- image: PNG file
- challenge: "Cat"

Response:
{
  "recognized": true,
  "confidence": 0.85,
  "feedback": "Great cat drawing!"
}
```

## 🔧 Configuration

Update the base URL in `mobile_app/lib/utils/app_constants.dart`:

```dart
class AppConstants {
  // Change this to your backend URL
  static const String baseUrl = 'http://your-backend-url.com';
  
  static const String sttEndpoint = '/api/stt';
  static const String nluEndpoint = '/api/nlu';
  static const String ttsEndpoint = '/api/tts';
  static const String drawingEndpoint = '/api/analyze-drawing';
}
```

## 🎮 Adding Voice to Existing Games

### Step 1: Add Voice Button to Game UI

```dart
// Add to any game's build method:
Positioned(
  bottom: 20,
  left: 0,
  right: 0,
  child: VoiceButton(
    onPressed: _handleVoiceInteraction,
    isRecording: _isRecording,
    isProcessing: _isProcessing,
  ),
),
```

### Step 2: Implement Voice Handler

```dart
bool _isRecording = false;
bool _isProcessing = false;

Future<void> _handleVoiceInteraction() async {
  final aiService = Provider.of<AIService>(context, listen: false);
  
  setState(() => _isRecording = true);
  
  try {
    await aiService.startRecording();
    await Future.delayed(Duration(seconds: 3));
    final audioPath = await aiService.stopRecording();
    
    setState(() {
      _isRecording = false;
      _isProcessing = true;
    });
    
    // Process with your models
    final result = await aiService.processVoiceInput(
      audioPath: audioPath!,
      gameProgress: gameProgress,
    );
    
    // Handle result
    if (result.success) {
      _handleCorrectAnswer();
    } else {
      _handleIncorrectAnswer();
    }
    
  } finally {
    setState(() {
      _isRecording = false;
      _isProcessing = false;
    });
  }
}
```

## 📊 Game State Data Structure

Each game sends context to your NLU model:

### Color Learning Game
```json
{
  "game_state": "color_learning",
  "game_context": "vocabulary",
  "state_data": {
    "stage": 1,
    "current_item_index": 2,
    "expected_answer": "green",
    "alternative_answers": ["أخضر", "Green"],
    "stars": 3
  }
}
```

### Number Learning Game
```json
{
  "game_state": "number_learning",
  "game_context": "cumulative",
  "state_data": {
    "stage": 3,
    "expected_count": 5,
    "expected_color": "yellow",
    "expected_object": "star",
    "expected_answer": "Five Yellow Stars"
  }
}
```

## 🎯 Fuzzy Matching (Built-in)

The Level Manager includes fuzzy matching with Levenshtein distance:

```dart
// Automatically allows up to 2 character differences
challenge.isCorrect("red");    // true
challenge.isCorrect("Red");    // true
challenge.isCorrect("red ");   // true
challenge.isCorrect("rad");    // true (1 char diff)
challenge.isCorrect("erd");    // true (2 char diff)
challenge.isCorrect("blue");   // false (too different)
```

## 🔄 Offline Fallback

When your AI backend is unavailable, games use:
1. **Rule-based validation** via Level Manager
2. **Positive feedback** from Curriculum Data
3. **Local TTS** (if available on device)

## 📝 Next Steps for Full AI Integration

1. **Train your models** on the curriculum data
2. **Deploy your backend** with the 4 endpoints
3. **Update app_constants.dart** with your URL
4. **Add voice buttons** to games (optional)
5. **Test with real children** and iterate

## 🎨 Curriculum Data Structure

All learning content is in `mobile_app/lib/data/curriculum/curriculum_data.dart`:

- **Chapter 1**: Colors (Red, Blue, Green, Yellow)
- **Chapter 2**: Animals (Cat, Dog, Bird, Fish, Frog)
- **Chapter 3**: Numbers (1-10)
- **Success Phrases**: Bravo, Excellent, Perfect, Amazing
- **Encouragement Phrases**: You're doing great, Try once more, I believe in you

## 🚀 Benefits of This Architecture

✅ **Hybrid**: Works online (AI-powered) and offline (rule-based)
✅ **Modular**: Easy to swap AI models
✅ **Testable**: Can test games without AI backend
✅ **Scalable**: Add new games easily
✅ **Child-Friendly**: Always positive, never says "wrong"

## 📞 Integration Checklist

- [ ] Backend deployed with 4 endpoints
- [ ] STT model trained on child speech (Arabic + English)
- [ ] NLU model trained on curriculum data
- [ ] TTS model with child-friendly voice
- [ ] Drawing recognition model trained
- [ ] app_constants.dart updated with backend URL
- [ ] Test with real audio samples
- [ ] Add voice buttons to games (optional)
- [ ] Test offline fallback
- [ ] Deploy to production

---

**Note**: The games work perfectly WITHOUT AI integration (tap mode). AI integration enhances the experience but is not required for the games to function.
