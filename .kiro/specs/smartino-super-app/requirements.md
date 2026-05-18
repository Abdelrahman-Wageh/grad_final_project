# Smartino Super-App - Requirements Document

## 1. Executive Summary

### 1.1 Project Vision
Transform two existing educational systems into **Smartino** (صديقي الذكي - "My Smart Friend"), a world-class Speech-to-Speech AI-driven educational super-app for Egyptian children aged 4-8, featuring the character "Farfour" (فرفور).

### 1.2 Mission Statement
Build a unified educational platform that combines:
- **Source A (Antura)**: Award-winning learning paths, level progression, and character animations
- **Source B (Singles)**: Completed mini-games with polished mechanics
- **New AI Engine**: Real-time Speech-to-Speech interaction using Groq API
- **Smartino Architecture**: Modern Flutter-based system with offline-first capabilities

### 1.3 Core Objectives
1. Extract and adapt the "Antura" dog character → rebrand as "Farfour" (فرفور)
2. Integrate mini-games from Singles as playable modules
3. Implement Speech-to-Speech AI using Groq (Whisper + GPT-OSS-120b)
4. Create unified UI/UX design system blending both sources
5. Build AI-generated story system with Farfour as protagonist

---

## 2. Source System Analysis

### 2.1 Source A: Antura System
**Location**: `E:\Projects\github\Graduation-Project\Graduation Project Final\Antura-main`

#### 2.1.1 Key Assets to Extract
- **Character**: Antura dog (3D model, animations, behaviors)
- **Learning Paths**: English/Arabic curriculum structure
- **Level Progression**: Journey system, stage unlocking
- **Game Mechanics**: 18+ mini-games (Balloons, ColorTickle, DancingDots, Egg, FastCrowd, HideAndSeek, MakeFriends, Maze, MissingLetter, MixedLetters, ReadingGame, Scanner, SickLetters, TakeMeHome, ThrowBalls, Tobogan)
- **UI Elements**: Intro sequences, reward animations
- **Audio**: Sound effects, music tracks
- **Localization**: Arabic/English language bundles

#### 2.1.2 Technical Architecture
- **Platform**: Unity 6.x (C#)
- **Languages**: Arabic, Darija, English, French, Polish, etc.
- **Content Structure**: Addressable Assets, modular language bundles
- **Database**: SQLite for progress tracking

#### 2.1.3 Learning System
- **Chapters**: Structured curriculum with stages
- **Assessments**: Built-in testing system
- **Rewards**: Bone collection, pet customization
- **Progression**: Linear journey with unlockable content

### 2.2 Source B: Singles Mini-Games
**Location**: `E:\Projects\github\Graduation-Project\Singles`

#### 2.2.1 Available Games
1. **Arabic Letter Adventure**: Letter recognition and tracing
2. **Flutter Puzzle Hack**: Sliding puzzle mechanics

#### 2.2.2 Integration Strategy
- Extract game logic and UI components
- Adapt to Smartino design language
- Integrate as standalone modules within main app
- Maintain original gameplay while unifying visuals

### 2.3 Current Smartino System
**Location**: `E:\Projects\github\Graduation-Project\mobile_app`

#### 2.3.1 Existing Features
- ✅ Flutter-based architecture (Dart)
- ✅ Local AI integration (STT, TTS, LLM)
- ✅ Friend Mode with voice conversation
- ✅ 5 implemented games (Color Learning, Number Learning, Shape Learning, Drawing, Memory)
- ✅ Code Commander game (procedural generation, A* pathfinding)
- ✅ Parent Dashboard with PIN protection
- ✅ Offline-first architecture with Hive storage
- ✅ Riverpod state management
- ✅ Living mascot system (placeholder)

#### 2.3.2 Current Backend
**Location**: `E:\Projects\github\Graduation-Project\backend`
- FastAPI server
- Whisper STT (fine-tuned Egyptian Arabic)
- Qwen LLM (GGUF quantized for 6GB VRAM)
- Rule-based NLU service
- TTS integration (ElevenLabs ready)

---

## 3. User Stories & Acceptance Criteria

### 3.1 Character Transformation: Antura → Farfour

#### US-3.1.1: Character Asset Migration
**As a** developer  
**I want to** extract Antura's 3D model and animations from Unity  
**So that** I can rebrand it as Farfour in Flutter

**Acceptance Criteria**:
- [ ] 3.1.1.1: Antura 3D model exported from Unity (FBX/glTF format)
- [ ] 3.1.1.2: All animation clips extracted (idle, walk, run, jump, celebrate, sad, etc.)
- [ ] 3.1.1.3: Textures and materials exported
- [ ] 3.1.1.4: Character renamed to "Farfour" in all assets
- [ ] 3.1.1.5: Character integrated into Flutter using flame_3d or similar

#### US-3.1.2: Character Behavior System
**As a** child user  
**I want** Farfour to react to my actions with animations  
**So that** the experience feels alive and engaging

**Acceptance Criteria**:
- [ ] 3.1.2.1: Idle animations play when no interaction
- [ ] 3.1.2.2: Celebration animations trigger on success
- [ ] 3.1.2.3: Encouraging animations on mistakes
- [ ] 3.1.2.4: Smooth transitions between animation states
- [ ] 3.1.2.5: Lip-sync with TTS audio (basic)

### 3.2 AI Engine: Speech-to-Speech Integration

#### US-3.2.1: Groq API Integration
**As a** developer  
**I want to** integrate Groq API for STT and LLM  
**So that** children can have real-time voice conversations

**Acceptance Criteria**:
- [ ] 3.2.1.1: Groq API key configured: `REDACTED`
- [ ] 3.2.1.2: Whisper model integrated for Egyptian Arabic STT
- [ ] 3.2.1.3: GPT-OSS-120b model integrated for conversation
- [ ] 3.2.1.4: System prompt configured for Egyptian Arabic dialect
- [ ] 3.2.1.5: Child-appropriate content filtering enabled

#### US-3.2.2: Friend Mode Conversation
**As a** child user  
**I want to** talk to Farfour in Egyptian Arabic  
**So that** I can learn through natural conversation

**Acceptance Criteria**:
- [ ] 3.2.2.1: Voice recording captures child's speech
- [ ] 3.2.2.2: STT transcribes to Egyptian Arabic text
- [ ] 3.2.2.3: LLM generates contextual response
- [ ] 3.2.2.4: TTS speaks response in Egyptian Arabic
- [ ] 3.2.2.5: Conversation history maintained
- [ ] 3.2.2.6: Response time < 3 seconds end-to-end

#### US-3.2.3: ElevenLabs TTS Integration
**As a** developer  
**I want to** integrate ElevenLabs for high-quality TTS  
**So that** Farfour's voice sounds natural and engaging

**Acceptance Criteria**:
- [ ] 3.2.3.1: ElevenLabs API integrated (key to be provided)
- [ ] 3.2.3.2: Egyptian Arabic voice selected
- [ ] 3.2.3.3: Child-friendly voice parameters configured
- [ ] 3.2.3.4: Audio caching for common phrases
- [ ] 3.2.3.5: Fallback to local TTS if API unavailable

### 3.3 Learning Path Integration

#### US-3.3.1: Antura Curriculum Adaptation
**As a** developer  
**I want to** extract Antura's learning paths  
**So that** Smartino has structured educational content

**Acceptance Criteria**:
- [ ] 3.3.1.1: English learning path extracted and adapted
- [ ] 3.3.1.2: Arabic learning path extracted and adapted
- [ ] 3.3.1.3: Level progression system implemented
- [ ] 3.3.1.4: Assessment system integrated
- [ ] 3.3.1.5: Reward system adapted (stars instead of bones)

#### US-3.3.2: Journey Map System
**As a** child user  
**I want to** see my learning progress on a visual map  
**So that** I feel motivated to continue

**Acceptance Criteria**:
- [ ] 3.3.2.1: Visual journey map displays stages
- [ ] 3.3.2.2: Completed stages marked with stars
- [ ] 3.3.2.3: Current stage highlighted
- [ ] 3.3.2.4: Locked stages shown as grayed out
- [ ] 3.3.2.5: Smooth scrolling and animations

### 3.4 Mini-Games Integration

#### US-3.4.1: Singles Games Migration
**As a** developer  
**I want to** integrate games from Singles folder  
**So that** Smartino has diverse gameplay options

**Acceptance Criteria**:
- [ ] 3.4.1.1: Arabic Letter Adventure integrated
- [ ] 3.4.1.2: Flutter Puzzle Hack integrated
- [ ] 3.4.1.3: Games accessible from main menu
- [ ] 3.4.1.4: Progress tracked per game
- [ ] 3.4.1.5: Unified UI/UX applied

#### US-3.4.2: Antura Games Adaptation
**As a** developer  
**I want to** adapt selected Antura games to Flutter  
**So that** Smartino has proven educational mechanics

**Acceptance Criteria**:
- [ ] 3.4.2.1: Priority games identified (5-8 games)
- [ ] 3.4.2.2: Game mechanics documented
- [ ] 3.4.2.3: Flutter implementation completed
- [ ] 3.4.2.4: Educational value preserved
- [ ] 3.4.2.5: Performance optimized for mobile

### 3.5 UI/UX Design System

#### US-3.5.1: Unified Design Language
**As a** UI/UX designer  
**I want to** create a consistent design system  
**So that** all components feel cohesive

**Acceptance Criteria**:
- [ ] 3.5.1.1: Color palette defined (primary, secondary, accent)
- [ ] 3.5.1.2: Typography system established
- [ ] 3.5.1.3: Component library created
- [ ] 3.5.1.4: Animation guidelines documented
- [ ] 3.5.1.5: Accessibility standards met

#### US-3.5.2: "Juicy" UI Implementation
**As a** child user  
**I want** every interaction to feel satisfying  
**So that** I enjoy using the app

**Acceptance Criteria**:
- [ ] 3.5.2.1: Button presses have haptic feedback
- [ ] 3.5.2.2: Transitions are smooth (60 FPS)
- [ ] 3.5.2.3: Success moments have celebrations
- [ ] 3.5.2.4: Micro-animations on all interactions
- [ ] 3.5.2.5: Sound effects synchronized with visuals

### 3.6 Story Generation System

#### US-3.6.1: AI-Generated Stories
**As a** child user  
**I want to** choose a story where Farfour is the hero  
**So that** I can experience personalized adventures

**Acceptance Criteria**:
- [ ] 3.6.1.1: Story templates defined (5+ themes)
- [ ] 3.6.1.2: LLM generates story based on template
- [ ] 3.6.1.3: Farfour integrated as protagonist
- [ ] 3.6.1.4: Story narrated with TTS
- [ ] 3.6.1.5: Interactive choices affect story

#### US-3.6.2: Story Selection Interface
**As a** child user  
**I want to** see story options with preview images  
**So that** I can choose what interests me

**Acceptance Criteria**:
- [ ] 3.6.2.1: Story cards display title and thumbnail
- [ ] 3.6.2.2: Difficulty indicator shown
- [ ] 3.6.2.3: Estimated duration displayed
- [ ] 3.6.2.4: Previously completed stories marked
- [ ] 3.6.2.5: Smooth card animations

---

## 4. Technical Requirements

### 4.1 Architecture

#### TR-4.1.1: Flutter Framework
- Flutter SDK 3.35.0+
- Dart 3.9.0+
- Null-safety enabled
- Material Design 3

#### TR-4.1.2: State Management
- Riverpod for reactive state
- Provider for legacy compatibility
- Hive for local persistence

#### TR-4.1.3: AI Integration
- Groq API for STT (Whisper)
- Groq API for LLM (GPT-OSS-120b)
- ElevenLabs for TTS
- Fallback to local models

### 4.2 Performance

#### TR-4.2.1: Responsiveness
- App launch < 2 seconds
- Screen transitions < 300ms
- Voice response < 3 seconds
- 60 FPS animations

#### TR-4.2.2: Memory
- Peak memory < 500MB
- No memory leaks
- Efficient asset loading
- Image caching

### 4.3 Compatibility

#### TR-4.3.1: Platforms
- Android 8.0+ (API 26+)
- iOS 12.0+
- Web (Chrome, Safari)

#### TR-4.3.2: Devices
- Phones (4.5" - 7")
- Tablets (7" - 12")
- Low-end devices (2GB RAM)

### 4.4 Security

#### TR-4.4.1: Data Protection
- No PII stored without consent
- Encrypted local storage
- Secure API communication
- Parent PIN protection

#### TR-4.4.2: Content Safety
- Child-appropriate content filtering
- No external links without parent approval
- Safe search for stories
- Moderated AI responses

---

## 5. Non-Functional Requirements

### 5.1 Usability
- Age-appropriate UI (4-8 years)
- Minimal text, maximum visuals
- Clear audio instructions
- Intuitive navigation

### 5.2 Accessibility
- Screen reader support
- High contrast mode
- Adjustable text size
- Colorblind-friendly palette

### 5.3 Localization
- Egyptian Arabic (primary)
- Modern Standard Arabic
- English (secondary)
- RTL support

### 5.4 Offline Support
- Core features work offline
- Local AI models available
- Cached content
- Sync when online

---

## 6. Success Metrics

### 6.1 Technical Metrics
- 99% crash-free rate
- < 3s average response time
- 60 FPS sustained
- < 100MB app size

### 6.2 User Metrics
- 80%+ completion rate per session
- 10+ minutes average session
- 70%+ daily return rate
- 4.5+ star rating

### 6.3 Educational Metrics
- Measurable learning progress
- Skill improvement over time
- Engagement with all game types
- Parent satisfaction

---

## 7. Constraints & Assumptions

### 7.1 Constraints
- 6GB VRAM for local AI models
- Mobile device limitations
- API rate limits (Groq, ElevenLabs)
- Unity → Flutter migration complexity

### 7.2 Assumptions
- Groq API key remains valid
- ElevenLabs key will be provided
- Source assets are accessible
- Target devices have internet (for AI features)

---

## 8. Dependencies

### 8.1 External Services
- Groq API (STT, LLM)
- ElevenLabs API (TTS)
- Firebase (optional, analytics)

### 8.2 Source Assets
- Antura Unity project
- Singles Flutter projects
- Current Smartino codebase

### 8.3 Development Tools
- Flutter SDK
- Unity Editor (for asset extraction)
- Blender (for 3D model conversion)
- Figma (for UI design)

---

## 9. Risks & Mitigation

### 9.1 Technical Risks
| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Unity → Flutter asset conversion | High | Medium | Use standard formats (FBX, PNG), test early |
| API rate limits | Medium | High | Implement caching, local fallbacks |
| Performance on low-end devices | High | Medium | Optimize assets, progressive loading |
| 3D character in Flutter | High | Medium | Use 2D sprite sheets as fallback |

### 9.2 Project Risks
| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Scope creep | High | High | Strict prioritization, MVP focus |
| Timeline delays | Medium | Medium | Agile sprints, regular reviews |
| Asset licensing issues | High | Low | Verify licenses, use open assets |

---

## 10. Prioritization

### 10.1 Must Have (MVP)
1. Farfour character (2D sprites minimum)
2. Groq API integration (STT + LLM)
3. Friend Mode conversation
4. 3 core games from current system
5. Basic learning path
6. Parent dashboard

### 10.2 Should Have
1. ElevenLabs TTS
2. 2 games from Singles
3. 3 games from Antura
4. Story generation
5. Journey map
6. Reward system

### 10.3 Could Have
1. 3D Farfour character
2. Advanced animations
3. More Antura games
4. Multiplayer features
5. Social sharing

### 10.4 Won't Have (This Release)
1. VR/AR features
2. Live multiplayer
3. Video content
4. External integrations

---

## 11. Approval & Sign-off

**Requirements Author**: Lead Flutter Engineer  
**Date**: January 25, 2026  
**Version**: 1.0

**Stakeholder Approval**:
- [ ] Product Owner
- [ ] Technical Lead
- [ ] UI/UX Designer
- [ ] Educational Content Expert

---

**Next Steps**: Proceed to Design Document (design.md)
