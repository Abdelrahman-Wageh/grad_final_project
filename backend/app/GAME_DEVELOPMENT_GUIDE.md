# 🎮 Game Development Guide - Whispering Woods

## 📋 **What is This Project?**

This is an **AI-powered educational game** for children (ages 4-8) that teaches:
- 🎨 **Colors** (الألوان)
- 🦁 **Animals** (الحيوانات)  
- 🔢 **Numbers** (الأرقام)

---

## 🏗️ **Project Architecture**

```
┌─────────────────────────────────────────────────────────┐
│                    MOBILE APP (Frontend)                 │
│              📱 Flutter App (mobile_app/)                │
│                                                           │
│  ┌─────────────────────────────────────────────────┐   │
│  │         Interactive Game Interface              │   │
│  │  - Visual game scenes                           │   │
│  │  - Character animations                         │   │
│  │  - User interactions                            │   │
│  │  - Drawing canvas                               │   │
│  └─────────────────────────────────────────────────┘   │
│                        ↕️ HTTP Requests                  │
└─────────────────────────────────────────────────────────┘
                          ↕️
┌─────────────────────────────────────────────────────────┐
│              BACKEND API (What You're Looking At)        │
│         🐍 FastAPI Server (backend/app/)                │
│                                                           │
│  ┌─────────────────────────────────────────────────┐   │
│  │              AI Services                         │   │
│  │  • STT (Speech-to-Text) - Understands child     │   │
│  │  • NLU (Natural Language) - Understands intent  │   │
│  │  • TTS (Text-to-Speech) - Character voice       │   │
│  │  • CV (Computer Vision) - Recognizes drawings   │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 🎯 **What You're Responsible For**

You need to build the **Interactive Game Interface** in the **mobile app** (`mobile_app/` directory).

### **What the Backend Does (Already Built):**
- ✅ Receives audio from child → Converts to text (STT)
- ✅ Understands what child said → Generates response (NLU)
- ✅ Converts response to speech → Returns audio (TTS)
- ✅ Recognizes drawings → Checks if correct (CV)

### **What You Need to Build (Frontend Game):**
- 🎮 **Visual game scenes** (colors, animals, numbers worlds)
- 🎨 **Drawing interface** (canvas for children to draw)
- 🎤 **Voice recording** (capture child's speech)
- 🔊 **Audio playback** (play character's voice response)
- 🎭 **Character animations** (Smartino character)
- 📊 **Game state management** (track progress, scores)
- 🎯 **Interactive elements** (buttons, puzzles, challenges)

---

## 🔌 **How to Connect Game to Backend**

### **1. Main Speech Pipeline** (`POST /api/adventure_speech`)

**When to use:** When child speaks to the character

**Flow:**
```
Child speaks → Record audio → Convert to base64 → Send to API → Get response audio → Play response
```

**Example Request:**
```json
{
  "audio_base64": "base64_encoded_audio_here",
  "audio_format": "wav",
  "game_state": {
    "state": "FOREST_ADVENTURE",
    "context": "introduction",
    "level": 1,
    "state_data": {}
  },
  "player_id": "player_123",
  "character_type": "wizard"
}
```

**Example Response:**
```json
{
  "audio_base64": "base64_encoded_response_audio",
  "audio_format": "wav",
  "text_response": "برافو عليك! جامد أوي! 🌟",
  "metadata": {
    "response_key": "SUCCESS",
    "transcribed_text": "أحمر",
    "detected_emotion": "happy"
  }
}
```

### **2. Drawing Recognition** (`POST /api/draw`)

**When to use:** When child draws something

**Flow:**
```
Child draws → Capture canvas → Convert to base64 → Send to API → Get recognition result
```

**Example Request:**
```json
{
  "image_base64": "base64_encoded_drawing_image",
  "challenge": "DRAW_CAT",
  "game_state": {
    "state": "DRAWING_CHALLENGE",
    "context": "animals",
    "level": 2
  },
  "player_id": "player_123"
}
```

**Example Response:**
```json
{
  "prediction": "cat",
  "confidence": 0.95,
  "is_correct": true,
  "response_key": "DRAW_SUCCESS",
  "text_response": "ممتاز! رسمت القطة بشكل رائع! برافو!",
  "metadata": {
    "confidence": 0.95,
    "processing_time_ms": 250
  }
}
```

---

## 📁 **Where is the Frontend?**

The frontend is in: **`mobile_app/`** directory

It's a **Flutter** mobile app. To see it:

1. **Navigate to mobile app:**
   ```bash
   cd ../../mobile_app
   ```

2. **Run the app:**
   ```bash
   flutter run
   ```

3. **Or open in your IDE:**
   - Open `mobile_app/` folder in VS Code or Android Studio
   - The main code is in `mobile_app/lib/`

---

## 🎮 **Game States You Need to Implement**

Based on `models/game_context.py`, your game has 3 chapters:

### **1. Colors Chapter** (مدينة الألوان المفقودة) 🎨
- **Concepts:** أحمر، أزرق، أخضر، أصفر، برتقالي، بنفسجي
- **Tasks:** Find colors, identify colors, color mixing

### **2. Animals Chapter** (حديقة الحيوانات الناطقة) 🦁
- **Concepts:** قطة، كلب، عصفور، سمكة، أرنب، فيل
- **Tasks:** Identify animals, feed animals, animal sounds

### **3. Numbers Chapter** (قلعة الأرقام السحرية) 🔢
- **Concepts:** واحد، اتنين، تلاتة، أربعة، خمسة، ستة...
- **Tasks:** Count objects, number sequences, counting

---

## 🛠️ **How to Test Your Game**

### **Option 1: Use Swagger UI (Current)**
- Go to: `http://127.0.0.1:8000/docs`
- Test endpoints manually
- Good for understanding API structure

### **Option 2: Build Mobile App**
- Build the Flutter app in `mobile_app/`
- Connect it to this backend
- Test the full game experience

### **Option 3: Create a Simple Web Test Page**
- Create an HTML page that calls the API
- Test voice recording and playback
- Test drawing recognition

---

## 📝 **Next Steps for You**

1. **Explore the mobile app:**
   ```bash
   cd ../../mobile_app
   ls lib/
   ```

2. **Understand the game structure:**
   - Check `mobile_app/lib/` for game screens
   - Look for game state management
   - Find where API calls should be made

3. **Start building:**
   - Create game scenes for each chapter
   - Add voice recording functionality
   - Add drawing canvas
   - Connect to backend API endpoints

4. **Test integration:**
   - Make sure backend is running (`python main.py`)
   - Test API calls from your game
   - Verify audio playback works
   - Test drawing recognition

---

## 🔗 **API Endpoints Summary**

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/adventure_speech` | POST | Main speech pipeline (STT→NLU→TTS) |
| `/api/draw` | POST | Drawing recognition |
| `/api/health` | GET | Check API health |
| `/api/system-health` | GET | Detailed system status |
| `/docs` | GET | API documentation (Swagger UI) |

---

## 💡 **Key Points to Remember**

1. **This backend = AI brain** (processes speech, generates responses)
2. **Your game = Visual interface** (what children see and interact with)
3. **They work together:** Game sends data → Backend processes → Game displays results
4. **DRY_RUN mode:** Currently returns placeholder data (safe for testing)
5. **Real mode:** When ready, set `DRY_RUN = False` in `config.py`

---

## 🆘 **Need Help?**

- **API Documentation:** `http://127.0.0.1:8000/docs` (Swagger UI)
- **Backend Code:** `backend/app/`
- **Frontend Code:** `mobile_app/lib/`
- **Game Models:** `backend/app/models/game_context.py`

---

**Good luck building your interactive game! 🎮✨**
