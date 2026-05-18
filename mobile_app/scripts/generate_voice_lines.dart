/// Script to generate voice lines using ElevenLabs API
/// 
/// Run with: dart run scripts/generate_voice_lines.dart

import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = 'sk_e6db072fe0d437081c4b16f2625bcdf3a7c9e802e904b390';
const String voiceId = 'pNInz6obpgDQGcFmaJgB'; // Adam voice

final Map<String, String> voiceLines = {
  'bravo': 'برافو!',
  'excellent': 'ممتاز!',
  'try_again': 'حاول تاني',
  'great': 'رائع!',
  'well_done': 'أحسنت!',
  'lets_play': 'يلا نلعب!',
  'hello': 'إزيك يا بطل؟',
};

Future<void> main() async {
  print('🎙️ Generating voice lines using ElevenLabs...\n');
  
  final outputDir = Directory('assets/sounds/voices');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }
  
  int success = 0;
  int failed = 0;
  
  for (final entry in voiceLines.entries) {
    final filename = entry.key;
    final text = entry.value;
    
    print('Generating: $filename.mp3 ("$text")...');
    
    try {
      final audioData = await generateSpeech(text);
      final file = File('assets/sounds/voices/$filename.mp3');
      await file.writeAsBytes(audioData);
      print('✅ Success: $filename.mp3\n');
      success++;
    } catch (e) {
      print('❌ Failed: $filename.mp3 - $e\n');
      failed++;
    }
    
    // Rate limiting - wait 1 second between requests
    await Future.delayed(const Duration(seconds: 1));
  }
  
  print('\n📊 Summary:');
  print('✅ Success: $success');
  print('❌ Failed: $failed');
  print('📁 Output: assets/sounds/voices/');
}

Future<List<int>> generateSpeech(String text) async {
  final url = Uri.parse('https://api.elevenlabs.io/v1/text-to-speech/$voiceId');
  
  final response = await http.post(
    url,
    headers: {
      'Accept': 'audio/mpeg',
      'Content-Type': 'application/json',
      'xi-api-key': apiKey,
    },
    body: jsonEncode({
      'text': text,
      'model_id': 'eleven_multilingual_v2',
      'voice_settings': {
        'stability': 0.5,
        'similarity_boost': 0.75,
        'style': 0.5,
        'use_speaker_boost': true,
      },
    }),
  );
  
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to generate speech: ${response.statusCode} - ${response.body}');
  }
}
