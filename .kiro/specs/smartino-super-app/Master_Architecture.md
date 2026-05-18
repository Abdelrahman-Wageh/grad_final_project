# Smartino Super-App - Master Architecture Document

## Document Overview
**Version**: 1.0  
**Date**: January 25, 2026  
**Author**: Lead System Architect  
**Purpose**: Complete technical blueprint for merging Antura + Singles → Smartino

---

## Table of Contents
1. [System Overview](#1-system-overview)
2. [Source System Analysis](#2-source-system-analysis)
3. [Target Architecture](#3-target-architecture)
4. [AI Engine Architecture](#4-ai-engine-architecture)
5. [Character System](#5-character-system)
6. [Game Integration Strategy](#6-game-integration-strategy)
7. [UI/UX Design System](#7-uiux-design-system)
8. [Data Architecture](#8-data-architecture)
9. [Migration Strategy](#9-migration-strategy)
10. [Implementation Roadmap](#10-implementation-roadmap)

---

## 1. System Overview

### 1.1 Vision
Transform three distinct systems into a unified educational super-app:
- **Antura** (Unity/C#) → Learning paths, character, 18+ games
- **Singles** (Flutter) → 2 polished mini-games
- **Current Smartino** (Flutter) → 5 games, AI integration, infrastructure

### 1.2 Architecture Philosophy
```
┌─────────────────────────────────────────────────────────────┐
│                    SMARTINO SUPER-APP                        │
│                   (Flutter + Dart)                           │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   Antura     │  │   Singles    │  │   Current    │     │
│  │   Assets     │  │   Games      │  │   Smartino   │     │
│  │  (Adapted)   │  │  (Migrated)  │  │  (Enhanced)  │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
├─────────────────────────────────────────────────────────────┤
│              UNIFIED AI ENGINE (Groq + Local)                │
├─────────────────────────────────────────────────────────────┤
│           OFFLINE-FIRST DATA LAYER (Hive + SQLite)          │
└─────────────────────────────────────────────────────────────┘
```

### 1.3 Key Principles
1. **Offline-First**: Core features work without internet
2. **Hybrid AI**: Cloud (Groq) + Local (on-device) models
3. **Modular Games**: Each game is independent module
4. **Unified UX**: Consistent design across all sources
5. **Performance**: 60 FPS, <3s response time



---

## 2. Source System Analysis

### 2.1 Antura System Deep Dive

#### 2.1.1 Asset Structure
```
Antura-main/Assets/
├── _core/                    # Core systems
│   ├── Pets/                 # Antura character (TARGET)
│   │   ├── Models/           # 3D models
│   │   ├── Animations/       # Animation clips
│   │   └── Textures/         # Character textures
│   ├── Audio/                # Sound effects, music
│   └── Prefabs/              # Reusable components
├── _games/                   # 18+ mini-games (TARGET)
│   ├── Balloons/
│   ├── ColorTickle/
│   ├── DancingDots/
│   ├── Egg/
│   ├── FastCrowd/
│   ├── HideAndSeek/
│   ├── MakeFriends/
│   ├── Maze/
│   ├── MissingLetter/
│   ├── MixedLetters/
│   ├── ReadingGame/
│   ├── Scanner/
│   ├── SickLetters/
│   ├── TakeMeHome/
│   ├── ThrowBalls/
│   └── Tobogan/
├── _config/                  # Learning paths (TARGET)
│   ├── content_Arabic/
│   ├── content_LearnEnglish/
│   └── common/
└── _lang_bundles/            # Localization (TARGET)
    ├── arabic/
    └── english/
```

#### 2.1.2 Learning Path Structure
```yaml
# Antura's curriculum structure
Journey:
  - Stage 1: Letters (Alef, Ba, Ta...)
    - MiniGame: Balloons (letter recognition)
    - MiniGame: FastCrowd (letter matching)
    - Assessment: Letter quiz
  - Stage 2: Words
    - MiniGame: MissingLetter
    - MiniGame: MixedLetters
  - Stage 3: Sentences
    - MiniGame: ReadingGame
```

#### 2.1.3 Character System (Antura)
```csharp
// Unity C# structure (to be adapted)
public class AnturaController {
    public AnimationClip idle;
    public AnimationClip walk;
    public AnimationClip run;
    public AnimationClip celebrate;
    public AnimationClip sad;
    public AnimationClip bite;
    public AnimationClip sleep;
    
    public void PlayAnimation(string animName) {
        // Animation logic
    }
}
```

**Adaptation Strategy**:
1. Export FBX/glTF from Unity
2. Convert to sprite sheets for 2D (fallback)
3. Use Rive for vector animations (optimal)
4. Rename "Antura" → "Farfour" everywhere

### 2.2 Singles Games Analysis

#### 2.2.1 Arabic Letter Adventure
```
Singles/arabic_letter_adventure/
├── lib/
│   ├── screens/
│   │   ├── letter_selection_screen.dart
│   │   ├── tracing_screen.dart
│   │   └── quiz_screen.dart
│   ├── models/
│   │   └── arabic_letter.dart
│   └── widgets/
│       ├── letter_card.dart
│       └── tracing_canvas.dart
```

**Key Features**:
- Letter recognition
- Tracing mechanics
- Quiz system
- Progress tracking

**Integration Plan**:
- Copy `lib/` to `mobile_app/lib/games/arabic_letter_adventure/`
- Adapt UI to Smartino theme
- Connect to unified progress system

#### 2.2.2 Flutter Puzzle Hack
```
Singles/flutter-puzzle-hack/
├── lib/
│   ├── puzzle/
│   │   ├── puzzle_board.dart
│   │   ├── puzzle_tile.dart
│   │   └── puzzle_solver.dart
│   └── models/
│       └── puzzle_state.dart
```

**Key Features**:
- Sliding puzzle mechanics
- Multiple difficulty levels
- Timer and move counter
- Hint system

**Integration Plan**:
- Copy to `mobile_app/lib/games/puzzle_game/`
- Add Farfour character to tiles
- Integrate with reward system

### 2.3 Current Smartino System

#### 2.3.1 Existing Architecture
```
mobile_app/
├── lib/
│   ├── core/                 # Core systems
│   │   ├── config/           # App configuration
│   │   ├── game/             # Game engine
│   │   └── ai/               # AI integration
│   ├── screens/              # UI screens
│   │   ├── games/            # 5 existing games
│   │   ├── friend_tab_view.dart
│   │   └── main_navigation_screen.dart
│   ├── services/             # Business logic
│   │   ├── ai_service.dart
│   │   ├── local_ai_service.dart
│   │   ├── dual_brain_ai_service.dart
│   │   └── storage_service.dart
│   ├── models/               # Data models
│   └── widgets/              # Reusable widgets
└── backend/                  # FastAPI backend
    ├── app/
    │   ├── services/
    │   │   ├── stt_service.py
    │   │   ├── nlu_service.py
    │   │   └── tts_service.py
    │   └── main.py
```

#### 2.3.2 Existing Games
1. **Color Learning** (3 stages)
2. **Number Learning** (3 stages)
3. **Shape Learning** (drag-and-drop)
4. **Drawing Game** (AI analysis)
5. **Memory Game** (4 difficulty levels)
6. **Code Commander** (procedural, A* pathfinding)

#### 2.3.3 AI Integration
```dart
// Current AI service structure
class DualBrainAIService {
  // Brain 1: Groq API (cloud)
  Future<String> processWithGroq(String text);
  
  // Brain 2: Local LLM (on-device)
  Future<String> processWithLocal(String text);
  
  // Hybrid: Choose based on connectivity
  Future<String> process(String text);
}
```



---

## 3. Target Architecture

### 3.1 System Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Home    │  │  Friend  │  │  Games   │  │  Parent  │   │
│  │  Screen  │  │   Mode   │  │  Screen  │  │Dashboard │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
├─────────────────────────────────────────────────────────────┤
│                    GAME MODULE LAYER                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Antura   │  │ Singles  │  │ Current  │  │  Story   │   │
│  │  Games   │  │  Games   │  │  Games   │  │  Mode    │   │
│  │  (8)     │  │  (2)     │  │  (6)     │  │  (New)   │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
├─────────────────────────────────────────────────────────────┤
│                    BUSINESS LOGIC LAYER                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Game    │  │  Level   │  │ Progress │  │  Reward  │   │
│  │ Manager  │  │ Manager  │  │ Tracker  │  │ Manager  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
├─────────────────────────────────────────────────────────────┤
│                    AI ENGINE LAYER                           │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │   STT    │  │   LLM    │  │   TTS    │  │   CV     │   │
│  │ (Groq/   │  │ (Groq/   │  │(ElevenL/ │  │ (Local)  │   │
│  │  Local)  │  │  Local)  │  │  Local)  │  │          │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
├─────────────────────────────────────────────────────────────┤
│                    DATA LAYER                                │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Hive    │  │ SQLite   │  │  Cache   │  │  Assets  │   │
│  │ (Local)  │  │(Progress)│  │ Manager  │  │ Manager  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Module Structure

```
mobile_app/
├── lib/
│   ├── core/                           # Core systems
│   │   ├── config/
│   │   │   ├── app_config.dart         # App-wide configuration
│   │   │   ├── ai_config.dart          # AI settings
│   │   │   └── game_config.dart        # Game settings
│   │   ├── game/
│   │   │   ├── game_engine.dart        # Base game engine
│   │   │   ├── level_manager.dart      # Level progression
│   │   │   └── difficulty_adapter.dart # Dynamic difficulty
│   │   ├── ai/
│   │   │   ├── ai_orchestrator.dart    # AI coordinator
│   │   │   ├── groq_client.dart        # Groq API client
│   │   │   └── local_ai_client.dart    # Local models
│   │   └── character/
│   │       ├── farfour_controller.dart # Character controller
│   │       └── animation_manager.dart  # Animation system
│   │
│   ├── features/                       # Feature modules
│   │   ├── home/
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── home_controller.dart
│   │   ├── friend_mode/
│   │   │   ├── screens/
│   │   │   │   └── friend_tab_view.dart
│   │   │   ├── widgets/
│   │   │   │   ├── voice_button.dart
│   │   │   │   └── conversation_bubble.dart
│   │   │   └── friend_controller.dart
│   │   ├── games/
│   │   │   ├── antura_games/          # Adapted from Antura
│   │   │   │   ├── balloons/
│   │   │   │   ├── color_tickle/
│   │   │   │   ├── fast_crowd/
│   │   │   │   ├── maze/
│   │   │   │   ├── missing_letter/
│   │   │   │   ├── mixed_letters/
│   │   │   │   └── reading_game/
│   │   │   ├── singles_games/         # Migrated from Singles
│   │   │   │   ├── arabic_letter_adventure/
│   │   │   │   └── puzzle_game/
│   │   │   ├── current_games/         # Existing Smartino
│   │   │   │   ├── color_learning/
│   │   │   │   ├── number_learning/
│   │   │   │   ├── shape_learning/
│   │   │   │   ├── drawing_game/
│   │   │   │   ├── memory_game/
│   │   │   │   └── code_commander/
│   │   │   └── game_router.dart       # Game selection
│   │   ├── story_mode/                # NEW: AI-generated stories
│   │   │   ├── screens/
│   │   │   │   ├── story_selection_screen.dart
│   │   │   │   └── story_player_screen.dart
│   │   │   ├── models/
│   │   │   │   └── story.dart
│   │   │   └── story_generator.dart
│   │   └── parent_dashboard/
│   │       ├── screens/
│   │       └── widgets/
│   │
│   ├── services/                       # Business logic
│   │   ├── ai/
│   │   │   ├── groq_service.dart       # NEW: Groq integration
│   │   │   ├── elevenlabs_service.dart # NEW: ElevenLabs TTS
│   │   │   ├── dual_brain_service.dart # Hybrid AI
│   │   │   └── conversation_manager.dart
│   │   ├── game/
│   │   │   ├── game_session_manager.dart
│   │   │   ├── progress_tracker.dart
│   │   │   └── reward_manager.dart
│   │   ├── storage/
│   │   │   ├── hive_service.dart
│   │   │   ├── sqlite_service.dart
│   │   │   └── cache_manager.dart
│   │   └── asset/
│   │       ├── asset_loader.dart
│   │       └── animation_loader.dart
│   │
│   ├── models/                         # Data models
│   │   ├── character/
│   │   │   └── farfour.dart
│   │   ├── game/
│   │   │   ├── game_state.dart
│   │   │   ├── level.dart
│   │   │   └── challenge.dart
│   │   ├── learning/
│   │   │   ├── curriculum.dart
│   │   │   ├── learning_path.dart
│   │   │   └── assessment.dart
│   │   └── user/
│   │       ├── child_profile.dart
│   │       └── progress.dart
│   │
│   ├── widgets/                        # Reusable widgets
│   │   ├── character/
│   │   │   ├── farfour_widget.dart
│   │   │   └── farfour_overlay.dart
│   │   ├── game/
│   │   │   ├── game_header.dart
│   │   │   ├── score_display.dart
│   │   │   └── celebration_overlay.dart
│   │   └── common/
│   │       ├── smartino_button.dart
│   │       ├── smartino_card.dart
│   │       └── loading_indicator.dart
│   │
│   ├── theme/
│   │   ├── smartino_theme.dart         # Unified theme
│   │   ├── colors.dart
│   │   ├── typography.dart
│   │   └── animations.dart
│   │
│   └── main.dart                       # App entry point
│
├── assets/
│   ├── characters/
│   │   └── farfour/                    # Farfour assets
│   │       ├── sprites/                # 2D sprites
│   │       ├── animations/             # Rive/Lottie
│   │       └── sounds/                 # Character sounds
│   ├── games/
│   │   ├── antura/                     # Antura game assets
│   │   ├── singles/                    # Singles game assets
│   │   └── current/                    # Current game assets
│   ├── audio/
│   │   ├── music/
│   │   ├── sfx/
│   │   └── voices/
│   └── images/
│       ├── backgrounds/
│       ├── ui/
│       └── icons/
│
└── backend/                            # FastAPI backend
    ├── app/
    │   ├── services/
    │   │   ├── groq_service.py         # NEW: Groq integration
    │   │   ├── elevenlabs_service.py   # NEW: ElevenLabs
    │   │   ├── stt_service.py
    │   │   ├── nlu_service.py
    │   │   └── tts_service.py
    │   └── main.py
    └── requirements.txt
```

### 3.3 Technology Stack

#### 3.3.1 Frontend (Flutter)
```yaml
dependencies:
  # Core
  flutter_sdk: 3.35.0+
  dart_sdk: 3.9.0+
  
  # State Management
  flutter_riverpod: ^2.4.0
  provider: ^6.0.5
  
  # UI/Animation
  flutter_animate: ^4.2.0
  lottie: ^2.7.0
  rive: ^0.12.0              # NEW: For Farfour animations
  confetti: ^0.7.0
  
  # Audio
  audioplayers: ^5.2.1
  record: ^6.1.2
  flutter_tts: ^3.8.0
  speech_to_text: ^6.5.0
  
  # AI/ML
  http: ^1.1.0
  dio: ^5.3.2
  
  # Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  sqflite: ^2.3.0            # NEW: For Antura-style progress
  
  # Utilities
  permission_handler: ^11.0.1
  connectivity_plus: ^5.0.0
  path_provider: ^2.1.1
  uuid: ^4.2.0
```

#### 3.3.2 Backend (Python)
```python
# requirements.txt
fastapi>=0.115.0
uvicorn[standard]>=0.32.0
groq>=0.4.0                  # NEW: Groq SDK
elevenlabs>=0.2.0            # NEW: ElevenLabs SDK
torch>=2.1.0
transformers>=4.35.0
llama-cpp-python>=0.2.0
librosa>=0.10.0
```

