import 'package:flutter/material.dart';
import 'dart:io';

class AppConstants {
  // Vibrant, Playful Colors for Kids! 🎨
  static const primaryColor = Color(0xFFFF6B9D); // Hot Pink
  static const secondaryColor = Color(0xFFC44569); // Deep Pink
  static const accentColor = Color(0xFFFFC93C); // Bright Yellow
  static const backgroundColor = Color(0xFFFFF8F0); // Warm Cream
  static const textColor = Color(0xFF2D3436); // Dark Gray
  static const successColor = Color(0xFF00B894); // Emerald Green
  static const warningColor = Color(0xFFFFD93D); // Golden Yellow
  static const errorColor = Color(0xFFFF6B6B); // Coral Red
  
  // Fun Game Colors - More Vibrant! 🌈
  static const forestGreen = Color(0xFF00B894); // Fresh Emerald
  static const castlePurple = Color(0xFFA29BFE); // Lavender Purple
  static const oceanBlue = Color(0xFF74B9FF); // Sky Blue
  static const sunsetOrange = Color(0xFFFF7675); // Coral Orange
  static const candyPink = Color(0xFFFF6B9D); // Hot Pink
  static const lemonYellow = Color(0xFFFFE66D); // Lemon Yellow
  static const mintGreen = Color(0xFF55EFC4); // Mint Green
  static const lavender = Color(0xFFA29BFE); // Lavender
  
  // Animation Durations
  static const shortAnimation = Duration(milliseconds: 300);
  static const mediumAnimation = Duration(milliseconds: 500);
  static const longAnimation = Duration(milliseconds: 800);
  
  // API Configuration
  // Use your computer's IP for physical Android devices
  // Use 10.0.2.2 for Android emulator (maps to host localhost)
  // Use localhost for iOS simulator and web
  static String get apiBaseUrl {
    if (Platform.isAndroid) {
      // For physical device, use your computer's IP address
      // For emulator, use 'http://10.0.2.2:8000'
      // Replace with your actual IP if different!
      return 'http://192.168.1.12:8000'; // Your computer's IP for physical device
    } else {
      return 'http://localhost:8000'; // iOS simulator, web, desktop
    }
  }
  
  static const String baseUrl = 'http://localhost:5000'; // Legacy Flask endpoint
  static const String adventureSpeechEndpoint = '/api/adventure_speech';
  static const String drawEndpoint = '/api/draw';
  static const String healthEndpoint = '/api/health';
  
  // Legacy endpoints (for backward compatibility)
  static const String sttEndpoint = '/api/stt';
  static const String nluEndpoint = '/api/nlu';
  static const String ttsEndpoint = '/api/tts';
  static const String drawingEndpoint = '/api/drawing';
  
  // Dry-run mode (for testing without backend)
  static const bool enableDryRun = true; // Set to false in production
  
  // Audio Configuration
  static const int sampleRate = 16000;
  static const int maxRecordingDuration = 10; // seconds
  
  // Game Configuration
  static const int maxScore = 1000;
  static const int objectivesPerLevel = 5;
  
  // Parent Dashboard
  static const String parentPinKey = 'parent_pin';
  static const String defaultParentPin = '1234';
  
  // Storage Keys
  static const String gameProgressKey = 'game_progress';
  static const String settingsKey = 'game_settings';
  static const String interactionLogsKey = 'interaction_logs';
}

class GameMessages {
  // Egyptian Arabic messages for the AI companion
  static const Map<String, String> arabicMessages = {
    'welcome': 'أهلاً وسهلاً! أنا عمتي فاضلة، هيا نلعب معاً!',
    'listening': 'أنا مستمعة لك، تكلم معي!',
    'thinking': 'دعني أفكر...',
    'encouragement': 'ممتاز! أنت ذكي جداً!',
    'help': 'هل تحتاج مساعدة؟',
    'celebration': 'واو! أنت رائع!',
    'forest_intro': 'هيا نستكشف الغابة معاً!',
    'castle_intro': 'دعنا نزور القلعة السحرية!',
    'drawing_challenge': 'تحدي الرسم! ارسم لي...',
  };
  
  // English fallback messages
  static const Map<String, String> englishMessages = {
    'welcome': 'Welcome! I\'m Abla Fadila, let\'s play together!',
    'listening': 'I\'m listening to you, speak to me!',
    'thinking': 'Let me think...',
    'encouragement': 'Excellent! You\'re very smart!',
    'help': 'Do you need help?',
    'celebration': 'Wow! You\'re amazing!',
    'forest_intro': 'Let\'s explore the forest together!',
    'castle_intro': 'Let\'s visit the magical castle!',
    'drawing_challenge': 'Drawing challenge! Draw me...',
  };
}
