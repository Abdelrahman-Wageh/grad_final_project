/// Global app configuration constants
class AppConfig {
  // App Information
  static const String appName = 'Smartino';
  static const String appNameArabic = 'صديقي الذكي';
  static const String version = '1.0.0';
  static const String buildNumber = '1';

  // Target Audience
  static const int minAge = 4;
  static const int maxAge = 8;
  static const List<String> educationLevels = ['KG1', 'KG2', 'Primary'];

  // Performance Targets
  static const int targetFPS = 60;
  static const int maxLoadTimeMs = 2000; // 2 seconds
  static const int maxTTSResponseMs = 100;
  static const int maxSTTResponseMs = 200;
  static const int maxAppSizeMB = 100;

  // Reward System
  static const int starsPerTreasure = 5;
  static const int maxStars = 1000;

  // Difficulty Thresholds
  static const double difficultyIncreaseThreshold = 0.90; // 90% success
  static const double difficultyDecreaseThreshold = 0.40; // 40% success
  static const int difficultyWindowSize = 5; // Last 5 games

  // Spaced Repetition (SM-2)
  static const double initialEaseFactor = 2.5;
  static const int initialInterval = 1; // days
  static const double minEaseFactor = 1.3;

  // Voice Settings
  static const int maxRecordingDurationSeconds = 10;
  static const int idleTimeoutSeconds = 10; // For attention-seeking animation

  // Animation Settings
  static const int breathingAnimationDurationMs = 3000;
  static const int blinkAnimationDurationMs = 200;
  static const int lipSyncToleranceMs = 50;

  // UI Constants
  static const double buttonBorderRadius = 32.0;
  static const double minTouchTargetSize = 64.0;
  static const double bodyFontSize = 24.0;
  static const double heading1FontSize = 36.0;
  static const double heading2FontSize = 28.0;
  static const double buttonFontSize = 22.0;

  // Game Settings
  static const int easyGridSize = 4;
  static const int mediumGridSize = 6;
  static const int hardGridSize = 8;

  static const int easyMaxNumber = 10;
  static const int mediumMaxNumber = 20;
  static const int hardMaxNumber = 50;

  // Fuzzy Matching
  static const int maxLevenshteinDistance = 2;
  static const double fuzzyMatchThreshold = 0.8;

  // Storage Keys
  static const String devSettingsBox = 'dev_settings';
  static const String profilesBox = 'profiles';
  static const String conversationsBox = 'conversations';
  static const String progressBox = 'progress';
  static const String srCardsBox = 'sr_cards';
  static const String settingsBox = 'settings';

  // API Endpoints (for future online features)
  static const String baseUrl = 'https://api.smartino.app';
  static const String syncEndpoint = '/api/v1/sync';
  static const String analyticsEndpoint = '/api/v1/analytics';

  // Feature Flags
  static const bool enableOnlineFeatures = false;
  static const bool enableCloudSync = false;
  static const bool enableAnalytics = false;
  static const bool enableCrashReporting = false;

  // Debug Settings
  static const bool isDebugMode = true; // Set to false for production
  static const bool showPerformanceOverlay = false;
  static const bool enableVerboseLogging = false;

  // Localization
  static const String defaultLocale = 'ar'; // Arabic
  static const List<String> supportedLocales = ['ar', 'en'];

  // Chapters
  static const List<String> chapterIds = [
    'city_of_lost_colors',
    'talking_zoo',
    'magic_numbers_castle',
  ];

  static const Map<String, String> chapterNames = {
    'city_of_lost_colors': 'City of Lost Colors',
    'talking_zoo': 'Talking Zoo',
    'magic_numbers_castle': 'Magic Numbers Castle',
  };

  static const Map<String, String> chapterNamesArabic = {
    'city_of_lost_colors': 'مدينة الألوان المفقودة',
    'talking_zoo': 'حديقة الحيوانات الناطقة',
    'magic_numbers_castle': 'قلعة الأرقام السحرية',
  };

  // Procedural Games
  static const List<String> proceduralGames = [
    'code_commander',
    'story_weaver',
    'potion_shop',
  ];

  static const Map<String, String> gameNames = {
    'code_commander': 'Code Commander',
    'story_weaver': 'Story Weaver',
    'potion_shop': 'Potion Shop',
  };

  static const Map<String, String> gameNamesArabic = {
    'code_commander': 'قائد الأكواد',
    'story_weaver': 'نساج القصص',
    'potion_shop': 'متجر الجرعات',
  };

  // Positive Reinforcement Messages
  static const List<String> encouragementMessages = [
    "So close! Try once more! 💪",
    "You're doing great! Let's try again! ⭐",
    "Almost there! You can do it! 🌟",
    "Nice try! One more time! 🎯",
    "Keep going! You're learning! 🚀",
    "That was good! Try again! 💫",
  ];

  static const List<String> encouragementMessagesArabic = [
    "قريب جداً! حاول مرة أخرى! 💪",
    "أنت رائع! لنحاول مرة أخرى! ⭐",
    "تقريباً هناك! أنت تستطيع! 🌟",
    "محاولة جيدة! مرة أخرى! 🎯",
    "استمر! أنت تتعلم! 🚀",
    "كان جيداً! حاول مرة أخرى! 💫",
  ];

  static const List<String> celebrationMessages = [
    "Amazing! You did it! 🎉",
    "Perfect! You're a star! ⭐",
    "Excellent work! 🌟",
    "Fantastic! Keep it up! 🎊",
    "Wonderful! You're brilliant! 💫",
  ];

  static const List<String> celebrationMessagesArabic = [
    "رائع! لقد فعلتها! 🎉",
    "مثالي! أنت نجم! ⭐",
    "عمل ممتاز! 🌟",
    "رائع! استمر! 🎊",
    "رائع! أنت مذهل! 💫",
  ];

  // Prevent instantiation
  AppConfig._();
}
