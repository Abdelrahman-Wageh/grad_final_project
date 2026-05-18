# 🎮 How to Run the Game Interface - Step by Step

## 📋 **Prerequisites**

Before running the game interface, make sure you have:

1. ✅ **Flutter SDK** installed
2. ✅ **Android Studio** or **VS Code** with Flutter extension
3. ✅ **Android Emulator** or **Physical Device** (or iOS Simulator for Mac)

---

## 🚀 **Step-by-Step Instructions**

### **Step 1: Check Flutter Installation**

Open a terminal and check if Flutter is installed:

```bash
flutter --version
```

**If Flutter is NOT installed:**
- Download from: https://flutter.dev/docs/get-started/install
- Follow installation guide for Windows
- Add Flutter to your PATH

---

### **Step 2: Navigate to Mobile App Directory**

```bash
# From backend/app/ directory
cd ../../mobile_app

# Or from project root
cd mobile_app
```

---

### **Step 3: Install Dependencies**

```bash
flutter pub get
```

This will download all required packages (takes a few minutes first time).

---

### **Step 4: Check Available Devices**

```bash
flutter devices
```

You should see:
- Android emulator (if running)
- Physical device (if connected)
- Chrome (for web testing)

**If no devices:**
- **For Android:** Start Android Studio → Tools → Device Manager → Create/Start Emulator
- **For Physical Device:** Enable USB debugging on your phone

---

### **Step 5: Run the App**

#### **Option A: Run on Default Device**
```bash
flutter run
```

#### **Option B: Run on Specific Device**
```bash
# List devices first
flutter devices

# Then run on specific device
flutter run -d <device-id>
```

#### **Option C: Run on Web (Easiest for Testing)**
```bash
flutter run -d chrome
```

---

### **Step 6: Start Backend API (In Another Terminal)**

**Important:** The game needs the backend API running!

1. Open a **new terminal window**
2. Navigate to backend:
   ```bash
   cd backend/app
   ```
3. Start the API:
   ```bash
   python main.py
   ```
4. You should see: `Uvicorn running on http://127.0.0.1:8000`

---

## 🎯 **What You'll See**

When the app runs, you'll see:

1. **Splash Screen** → App loading
2. **Main Navigation** → Tabs at bottom:
   - 🏠 Home
   - 🎮 Games
   - 👤 Profile
   - 👥 Friend (AI Companion)

3. **Games Tab** → List of available games:
   - 🎨 Color Learning Game
   - 🦁 Animal Sounds Game
   - 🔢 Number Learning Game
   - ✏️ Drawing Game
   - 🌲 Forest Adventure Game
   - And more...

4. **Tap any game** → Opens the interactive game interface!

---

## 🛠️ **Troubleshooting**

### **Problem: "flutter: command not found"**
**Solution:** 
- Install Flutter SDK
- Add to PATH environment variable
- Restart terminal

### **Problem: "No devices found"**
**Solution:**
- For Android: Start Android Studio emulator
- For iOS (Mac only): Start iOS Simulator
- For Web: Use `flutter run -d chrome`

### **Problem: "pub get failed"**
**Solution:**
```bash
flutter clean
flutter pub get
```

### **Problem: "Backend connection failed"**
**Solution:**
1. Make sure backend is running (`python main.py`)
2. Check API URL in `mobile_app/lib/utils/app_constants.dart`
3. For Android emulator, use `10.0.2.2:8000` instead of `localhost:8000`

### **Problem: "Gradle build failed" (Android)**
**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

---

## 📱 **Running on Different Platforms**

### **Android Emulator**
1. Open Android Studio
2. Tools → Device Manager
3. Create/Start an emulator
4. Run: `flutter run`

### **Physical Android Device**
1. Enable Developer Options on phone
2. Enable USB Debugging
3. Connect via USB
4. Run: `flutter run`

### **iOS Simulator (Mac only)**
1. Open Xcode
2. Xcode → Open Developer Tool → Simulator
3. Choose a device
4. Run: `flutter run`

### **Web Browser (Easiest!)**
```bash
flutter run -d chrome
```
- Opens in Chrome browser
- Good for quick testing
- Some features may not work (camera, microphone)

---

## 🎮 **Quick Start (Fastest Way)**

If you just want to see it quickly:

```bash
# Terminal 1: Start Backend
cd backend/app
python main.py

# Terminal 2: Run Mobile App
cd mobile_app
flutter run -d chrome
```

This will:
- ✅ Start backend API on port 8000
- ✅ Open game in Chrome browser
- ✅ You can interact with games immediately!

---

## 📝 **Development Workflow**

1. **Edit game code:**
   - Files in `mobile_app/lib/screens/games/`
   - Save changes

2. **Hot Reload:**
   - Press `r` in terminal (if app is running)
   - Or click hot reload button in IDE

3. **Hot Restart:**
   - Press `R` in terminal
   - Full app restart

4. **Stop app:**
   - Press `q` in terminal
   - Or stop from IDE

---

## ✅ **Success Checklist**

- [ ] Flutter installed and working
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Device/emulator available
- [ ] Backend API running (`python main.py`)
- [ ] App launches successfully
- [ ] Can navigate to Games tab
- [ ] Can open a game
- [ ] Game interface displays correctly

---

## 🆘 **Still Having Issues?**

1. **Check Flutter doctor:**
   ```bash
   flutter doctor
   ```
   Fix any issues it reports

2. **Check backend is running:**
   - Visit: http://127.0.0.1:8000/docs
   - Should see Swagger UI

3. **Check mobile app logs:**
   - Look at terminal output when running `flutter run`
   - Check for error messages

4. **Try web version first:**
   ```bash
   flutter run -d chrome
   ```
   This is the easiest way to test!

---

**Once running, you'll see the beautiful game interface! 🎮✨**


