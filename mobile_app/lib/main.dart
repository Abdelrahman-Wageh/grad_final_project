import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/interaction_log.dart';
import 'models/game_state.dart';
import 'models/challenge.dart';
import 'data/models/child_profile.dart';
import 'models/spaced_repetition_card.dart';
import 'models/conversation_history.dart';
import 'models/message.dart';
import 'core/config/dev_settings.dart';
import 'core/config/ai_mode_adapter.dart';
import 'core/config/app_initializer.dart';
import 'services/ai_service.dart';
import 'services/game_service.dart';
import 'services/storage_service.dart';
import 'services/hybrid_connectivity_service.dart';
import 'services/hybrid_ai_service.dart';
import 'services/hybrid_storage_service.dart';
import 'services/local_storage_service.dart';
import 'services/local_ai_service.dart';
import 'services/dual_brain_ai_service.dart';
import 'services/spaced_repetition_manager.dart';
import 'services/difficulty_adapter.dart';
import 'services/game_session_manager.dart';
import 'services/reward_manager_v2.dart';
import 'services/performance_optimizer.dart';
import 'services/sound_manager.dart';
// Smartino AI Services
import 'services/ai/groq_service.dart';
import 'services/ai/elevenlabs_service.dart';
import 'core/ai/ai_orchestrator.dart';
import 'features/story_mode/story_generator.dart';
import 'core/game/progression_manager.dart';
import 'screens/game_screen.dart';
import 'screens/journey_map_screen.dart';
import 'screens/games_screen.dart';
import 'features/story_mode/screens/story_selection_screen.dart';
import 'screens/game_router_screen.dart';
import 'screens/parent_dashboard.dart';
import 'screens/splash_screen.dart';
import 'screens/character_selection_screen.dart';
import 'screens/home_screen.dart';
import 'screens/self_test_screen.dart';
import 'screens/friend_tab_view.dart';
import 'screens/dev_settings_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/games/code_commander_game.dart';
import 'screens/games/story_weaver_game.dart';
import 'screens/games/potion_shop_game.dart';
import 'utils/app_constants.dart';
import 'theme/app_theme.dart';
import 'theme/smartino_theme.dart';
import 'theme/premium_kid_theme.dart';
import 'screens/enhanced_home_screen.dart';
import 'widgets/error_boundary.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Error Boundary - Catch all Flutter exceptions
  ErrorBoundary.initialize();
  
  // Initialize app (Hive, AI models, etc.)
  await AppInitializer.initialize();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Wrap app with Riverpod ProviderScope
  // Requirements: 26.1, 26.5
  runApp(
    const ProviderScope(
      child: KidsAICompanionApp(),
    ),
  );
}

class KidsAICompanionApp extends StatelessWidget {
  const KidsAICompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get storage service for dependency injection
    final storage = LocalStorageService();
    
    return provider.MultiProvider(
      providers: [
        // Core Services (Legacy)
        provider.ChangeNotifierProvider(create: (_) => GameService()),
        provider.ChangeNotifierProvider(create: (_) => AIService()),
        provider.ChangeNotifierProvider(create: (_) => StorageService()),
        
        // Hybrid Services (Legacy)
        provider.ChangeNotifierProvider(create: (_) => HybridConnectivityService()),
        provider.ChangeNotifierProxyProvider<HybridConnectivityService, HybridAIService>(
          create: (context) => HybridAIService(
            provider.Provider.of<HybridConnectivityService>(context, listen: false),
          ),
          update: (context, connectivity, previous) =>
              previous ?? HybridAIService(connectivity),
        ),
        provider.ChangeNotifierProxyProvider<HybridConnectivityService, HybridStorageService>(
          create: (context) => HybridStorageService(
            provider.Provider.of<HybridConnectivityService>(context, listen: false),
          ),
          update: (context, connectivity, previous) =>
              previous ?? HybridStorageService(connectivity),
        ),
        
        // Phase 1-2: Local AI & Storage
        provider.Provider(create: (_) => storage),
        provider.Provider(create: (_) => LocalAIService()),
        provider.Provider(create: (_) => DualBrainAIService()),
        
        // Phase 6: Spaced Repetition & Difficulty
        provider.Provider(create: (_) => SpacedRepetitionManager(storage)),
        provider.Provider(create: (_) => DifficultyAdapter()),
        provider.Provider(create: (context) {
          final spacedRep = provider.Provider.of<SpacedRepetitionManager>(context, listen: false);
          final difficultyAdapter = provider.Provider.of<DifficultyAdapter>(context, listen: false);
          return GameSessionManager(spacedRep, difficultyAdapter, storage);
        }),
        
        // Phase 7: Reward System
        provider.Provider(create: (_) => RewardManagerV2(storage)),
        
        // Phase 8: Performance & Sound
        provider.Provider(create: (_) => PerformanceOptimizer()),
        provider.Provider(create: (_) => SoundManager()),
        
        // Smartino AI Services (Phase 2)
        provider.Provider(create: (_) => GroqService()),
        provider.Provider(create: (_) => ElevenLabsService()),
        provider.Provider(create: (context) {
          final groqService = provider.Provider.of<GroqService>(context, listen: false);
          final elevenLabsService = provider.Provider.of<ElevenLabsService>(context, listen: false);
          final localAIService = provider.Provider.of<LocalAIService>(context, listen: false);
          final storage = provider.Provider.of<LocalStorageService>(context, listen: false);
          return AIOrchestrator(
            groqService: groqService,
            elevenLabsService: elevenLabsService,
            localAIService: localAIService,
            storage: storage,
          );
        }),
        provider.Provider(create: (context) {
          final groqService = provider.Provider.of<GroqService>(context, listen: false);
          return StoryGenerator(groqService);
        }),
        
        // Smartino Progression System (Phase 3)
        provider.ChangeNotifierProvider(create: (context) {
          final storage = provider.Provider.of<LocalStorageService>(context, listen: false);
          return ProgressionManager(storage);
        }),
      ],
      child: MaterialApp(
        title: 'Smartino - صديقي الذكي',
        debugShowCheckedModeBanner: false,
        theme: PremiumKidTheme.lightTheme,
        darkTheme: PremiumKidTheme.darkTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/character-selection': (context) => const CharacterSelectionScreen(),
          '/home': (context) => EnhancedHomeScreen(
            childName: 'Player',
            currentLevel: 5,
            currentXP: 2500,
            totalXPForLevel: 5000,
            onPlayPressed: () {
              Navigator.pushNamed(context, '/main');
            },
            onParentModePressed: () {
              Navigator.pushNamed(context, '/parent');
            },
          ),
          '/main': (context) => const MainNavigationScreen(profileId: 'default'),
          '/game': (context) => const GameRouterScreen(),
          '/game-old': (context) => const GameScreen(),
          '/parent': (context) => const ParentDashboard(),
          '/friend': (context) => const FriendTabView(profileId: 'default'),
          '/dev-settings': (context) => const DevSettingsScreen(),
          '/journey-map': (context) => const JourneyMapScreen(profileId: 'default'),
          '/story-selection': (context) => const StorySelectionScreen(profileId: 'default'),
          '/games': (context) => const GamesScreen(),
          // Debug route - only available in debug builds
          if (kDebugMode) '/self-test': (context) => const SelfTestScreen(),
        },
        onGenerateRoute: (settings) {
          // Handle routes with parameters
          if (settings.name == '/main-nav') {
            final args = settings.arguments as Map<String, dynamic>?;
            final profileId = args?['profileId'] as String? ?? 'default';
            return MaterialPageRoute(
              builder: (_) => MainNavigationScreen(profileId: profileId),
            );
          }
          
          if (settings.name == '/code-commander') {
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null) {
              return MaterialPageRoute(
                builder: (_) => CodeCommanderGame(
                  level: args['level'],
                  profile: args['profile'],
                ),
              );
            }
          }
          
          if (settings.name == '/story-weaver') {
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null) {
              return MaterialPageRoute(
                builder: (_) => StoryWeaverGame(
                  level: args['level'],
                  profile: args['profile'],
                ),
              );
            }
          }
          
          if (settings.name == '/potion-shop') {
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null) {
              return MaterialPageRoute(
                builder: (_) => PotionShopGame(
                  level: args['level'],
                  profile: args['profile'],
                ),
              );
            }
          }
          
          return null;
        },
      ),
    );
  }
}
