# 🎨 PHASE 3-4 VISUAL GUIDE

## Friend Tab - Voice Conversation Interface

```
┌─────────────────────────────────────────────────────────────┐
│  صاحبي - My Friend                                    [←]   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│                    ╭─────────────╮                          │
│                    │   🟣 😊 🟣   │  ← Smartino Mascot      │
│                    │  Breathing   │     (Animated)          │
│                    │  & Blinking  │                          │
│                    ╰─────────────╯                          │
│                       idle                                   │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ╭──────────────────────────────────────────────╮          │
│  │ 👤 Hello Smartino!                    10:30 │          │
│  ╰──────────────────────────────────────────────╯          │
│                                                              │
│          ╭──────────────────────────────────────────╮      │
│          │ 🤖 Hello! How are you today?      10:30 │      │
│          ╰──────────────────────────────────────────╯      │
│                                                              │
│  ╭──────────────────────────────────────────────╮          │
│  │ 👤 I'm learning colors!               10:31 │          │
│  ╰──────────────────────────────────────────────╯          │
│                                                              │
│          ╭──────────────────────────────────────────╮      │
│          │ 🤖 That's wonderful! What's your   10:31│      │
│          │    favorite color?                       │      │
│          ╰──────────────────────────────────────────╯      │
│                                                              │
│                        ⋮                                     │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│                   Hold to speak                             │
│                                                              │
│                    ╭─────────╮                              │
│                    │    🎤    │  ← Microphone Button        │
│                    │  Press   │     (Animated)              │
│                    │  & Hold  │                              │
│                    ╰─────────╯                              │
│                                                              │
│              Press and hold to record                       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Mascot Mood States

### 1. Idle (Purple)
```
    ╭─────────╮
    │  🟣😊🟣  │  ← Default state
    │ Breathing │     Breathing animation
    │ Blinking  │     Random blinking
    ╰─────────╯
       idle
```

### 2. Listening (Blue)
```
    ╭─────────╮
    │  🔵👂🔵  │  ← Recording audio
    │ Listening │     Pulse animation
    │   ...    │     
    ╰─────────╯
     listening
```

### 3. Thinking (Orange)
```
    ╭─────────╮
    │  🟠🤔🟠  │  ← Processing AI
    │ Thinking  │     Rotating animation
    │   ...    │     
    ╰─────────╯
     thinking
```

### 4. Happy (Green)
```
    ╭─────────╮
    │  🟢😄🟢  │  ← Response ready
    │  Happy   │     Bounce animation
    │    !     │     
    ╰─────────╯
      happy
```

### 5. Excited (Pink)
```
    ╭─────────╮
    │  🟣🎉🟣  │  ← On tap
    │ Excited! │     Big bounce
    │   !!!    │     
    ╰─────────╯
     excited
```

### 6. Sad (Grey)
```
    ╭─────────╮
    │  ⚫😢⚫  │  ← On error
    │   Sad    │     Slow breathing
    │   ...    │     
    ╰─────────╯
       sad
```

---

## Microphone Button States

### 1. Idle State
```
    Hold to speak
    
    ╭─────────╮
    │  🟣🎤🟣  │  ← Purple gradient
    │  Ready   │     No animation
    ╰─────────╯
    
    Press and hold to record
```

### 2. Recording State
```
    Listening... 🎤
    
    ╭─────────╮
    │  🔴🎤🔴  │  ← Red gradient
    │Recording │     Pulse animation
    ╰─────────╯     Glowing shadow
    
    (Release to send)
```

### 3. Processing State
```
    Thinking... 🤔
    
    ╭─────────╮
    │  ⚫⏳⚫  │  ← Grey gradient
    │Processing│     Disabled
    ╰─────────╯
    
    (Please wait)
```

---

## Voice Conversation Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    USER INTERACTION                          │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                    ╭───────────────╮
                    │ Press & Hold  │
                    │  Mic Button   │
                    ╰───────────────╯
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  STEP 1: AUDIO RECORDING                                     │
│  - Mascot mood: LISTENING (blue)                             │
│  - Mic button: RED with pulse                                │
│  - Status: "Listening... 🎤"                                 │
│  - Record audio using 'record' package                       │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                    ╭───────────────╮
                    │ Release Button│
                    ╰───────────────╯
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  STEP 2: SPEECH-TO-TEXT (Whisper)                           │
│  - Mascot mood: THINKING (orange)                            │
│  - Status: "Thinking... 🤔"                                  │
│  - Send audio to LocalAIService.transcribeAudio()            │
│  - Backend: POST /api/stt/transcribe                         │
│  - Model: E:\Projects\Models\Whisper\...                     │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  STEP 3: DISPLAY USER MESSAGE                                │
│  - Add blue chat bubble (right-aligned)                      │
│  - Content: Transcribed text                                 │
│  - Timestamp: Current time                                   │
│  - Auto-scroll to bottom                                     │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  STEP 4: LLM RESPONSE GENERATION (Qwen)                      │
│  - Mascot mood: THINKING (orange)                            │
│  - Send text to DualBrainAIService.processInput()            │
│  - Mode: LLM (forced for Friend Tab)                         │
│  - Include conversation history for context                  │
│  - Backend: POST /api/llm/generate                           │
│  - Model: E:\Projects\Models\LLMs\Qwen\...                   │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  STEP 5: DISPLAY ASSISTANT MESSAGE                           │
│  - Add purple chat bubble (left-aligned)                     │
│  - Content: LLM response text                                │
│  - Timestamp: Current time                                   │
│  - Auto-scroll to bottom                                     │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  STEP 6: TEXT-TO-SPEECH (Coqui)                              │
│  - Mascot mood: HAPPY (green)                                │
│  - Send text to LocalAIService.synthesizeSpeech()            │
│  - Backend: POST /api/tts/synthesize                         │
│  - Model: E:\Projects\Models\TTS                             │
│  - Play audio using 'audioplayers' package                   │
│  - TODO: Animate lip-sync with visemes (needs Rive)          │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  STEP 7: SAVE CONVERSATION HISTORY                           │
│  - Save both messages to Hive                                │
│  - Update ConversationHistory.updatedAt                      │
│  - Persist to local database                                 │
│  - Context maintained for next conversation                  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                    ╭───────────────╮
                    │ Mascot: IDLE  │
                    │ Ready for next│
                    ╰───────────────╯
```

---

## Chat Bubble Design

### User Message (Right-Aligned)
```
                                    ╭──────────────────────╮
                                    │ 👤 Hello Smartino!  │
                                    │                      │
                                    │ 10:30               │
                                    ╰──────────────────────╯
                                    
    - Background: Blue (#42A5F5)
    - Text: White
    - Border radius: 20px (top), 4px (bottom-right)
    - Shadow: Subtle drop shadow
    - Avatar: Person icon (blue circle)
```

### Assistant Message (Left-Aligned)
```
    ╭──────────────────────────────────╮
    │ 🤖 Hello! How are you today?     │
    │                                  │
    │ 10:30                           │
    ╰──────────────────────────────────╯
    
    - Background: Purple (#E1BEE7)
    - Text: Black (#212121)
    - Border radius: 20px (top), 4px (bottom-left)
    - Shadow: Subtle drop shadow
    - Avatar: Face icon (purple circle)
```

---

## Empty State

```
┌─────────────────────────────────────────────────────────────┐
│                                                              │
│                                                              │
│                        💬                                    │
│                                                              │
│              Start a conversation with Smartino!            │
│                                                              │
│            Press and hold the microphone to speak           │
│                                                              │
│                                                              │
│                                                              │
│                                                              │
│                                                              │
│                    ╭─────────╮                              │
│                    │    🎤    │                              │
│                    ╰─────────╯                              │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Animation Details

### Breathing Animation
- **Duration**: 2000ms
- **Curve**: easeInOut
- **Scale**: 0.95 → 1.05 → 0.95
- **Loop**: Infinite reverse

### Blinking Animation
- **Duration**: 150ms
- **Curve**: easeInOut
- **Scale Y**: 1.0 → 0.1 → 1.0
- **Trigger**: Random (2-5 seconds)

### Bounce Animation (Tap)
- **Duration**: 300ms
- **Curve**: elasticOut
- **Scale**: 1.0 → 1.2 → 1.0
- **Trigger**: On tap

### Pulse Animation (Recording)
- **Duration**: 1000ms
- **Curve**: easeInOut
- **Scale**: 1.0 → 1.2 → 1.0
- **Loop**: Infinite reverse

---

## Color Palette

### Mascot Moods
- **Idle**: Purple (#AB47BC)
- **Listening**: Blue (#42A5F5)
- **Thinking**: Orange (#FFA726)
- **Happy**: Green (#66BB6A)
- **Excited**: Pink (#EC407A)
- **Sad**: Grey (#9E9E9E)

### UI Elements
- **User Bubble**: Blue (#42A5F5)
- **Assistant Bubble**: Purple (#E1BEE7)
- **Background**: Purple Tint (#F3E5F5)
- **Mic Button Idle**: Purple (#AB47BC)
- **Mic Button Recording**: Red (#EF5350)
- **Mic Button Processing**: Grey (#9E9E9E)

---

## Haptic Feedback

### Microphone Button
- **On Press**: Medium impact
- **On Release**: Light impact

### Mascot Tap
- **On Tap**: Light impact

---

## Sound Effects (Future)

### Planned Sounds
- **Recording Start**: Soft "beep"
- **Recording Stop**: Soft "boop"
- **Message Sent**: Whoosh
- **Message Received**: Gentle chime
- **Error**: Gentle error tone

---

## Accessibility

### Features
- **Large Touch Targets**: 80px mic button
- **High Contrast**: Vibrant colors
- **Clear Status Text**: "Listening...", "Thinking..."
- **Visual Feedback**: Color changes, animations
- **Haptic Feedback**: Physical confirmation

---

## Performance

### Optimizations
- **60 FPS Animations**: TickerProviderStateMixin
- **Efficient Rebuilds**: AnimatedBuilder
- **Lazy Loading**: ListView.builder for messages
- **Const Constructors**: Where possible

---

**Status**: Phase 3-4 Complete ✅  
**Next**: Phase 5 (Procedural Game Generation)

