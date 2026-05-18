/// ElevenLabs TTS Configuration
/// High-quality Text-to-Speech for Egyptian Arabic

class ElevenLabsConfig {
  // API Credentials
  static const String apiKey = 'sk_e6db072fe0d437081c4b16f2625bcdf3a7c9e802e904b390';
  static const String baseUrl = 'https://api.elevenlabs.io/v1';
  
  // Voice Settings for Egyptian Arabic Child-Friendly Voice
  // Using Adam voice (friendly, clear, suitable for children)
  static const String voiceId = 'pNInz6obpgDQGcFmaJgB'; // Adam voice
  
  // Voice Settings
  static const double stability = 0.5;  // Lower = more expressive
  static const double similarityBoost = 0.75;
  static const double style = 0.3;  // Playful style
  static const bool useSpeakerBoost = true;
  
  // Audio Settings
  static const String outputFormat = 'mp3_44100_128';
  static const String modelId = 'eleven_multilingual_v2';  // Supports Arabic
  
  // Timeout settings
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Cache settings
  static const int maxCacheSize = 100; // Maximum cached audio files
  static const Duration cacheExpiry = Duration(days: 7);
  
  // Common phrases to pre-cache
  static const List<String> commonPhrases = [
    'برافو!',
    'ممتاز!',
    'أنت شاطر!',
    'حاول تاني',
    'تمام كده!',
    'يلا نلعب!',
    'إزيك يا بطل؟',
  ];
}
