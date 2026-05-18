# 🚀 Install Flutter & Run Game Interface

## ⚠️ **Current Status**

Flutter is **not installed** on your system. You need to install it first to run the game interface.

---

## 📥 **Step 1: Install Flutter**

### **For Windows:**

1. **Download Flutter SDK:**
   - Go to: https://docs.flutter.dev/get-started/install/windows
   - Download the latest Flutter SDK (ZIP file)
   - Extract to a location like `C:\src\flutter` (avoid spaces in path)

2. **Add Flutter to PATH:**
   - Open System Properties → Environment Variables
   - Edit "Path" variable
   - Add: `C:\src\flutter\bin`
   - Click OK

3. **Verify Installation:**
   - Open **NEW** PowerShell/Command Prompt
   - Run: `flutter --version`
   - Should show Flutter version

4. **Run Flutter Doctor:**
   ```bash
   flutter doctor
   ```
   - This checks what else you need
   - Install Android Studio if needed
   - Install VS Code with Flutter extension (optional but recommended)

---

## 🎯 **Step 2: Install Android Studio (For Android Emulator)**

1. **Download Android Studio:**
   - https://developer.android.com/studio
   - Install it

2. **Set up Android SDK:**
   - Open Android Studio
   - Tools → SDK Manager
   - Install Android SDK (latest version)

3. **Create Emulator:**
   - Tools → Device Manager
   - Create Virtual Device
   - Choose a phone (e.g., Pixel 5)
   - Download system image
   - Finish

---

## 🚀 **Step 3: Run the Game**

Once Flutter is installed:

```bash
# Navigate to mobile app
cd mobile_app

# Get dependencies
flutter pub get

# Check devices
flutter devices

# Run on Android emulator
flutter run

# OR run on web (easier!)
flutter run -d chrome
```

---

## 🌐 **Alternative: Run on Web (Easiest!)**

If you want to test quickly without full Android setup:

```bash
# After installing Flutter
cd mobile_app
flutter run -d chrome
```

This opens the game in Chrome browser - perfect for testing!

---

## 📋 **Quick Checklist**

- [ ] Download Flutter SDK
- [ ] Extract to `C:\src\flutter` (or similar)
- [ ] Add to PATH
- [ ] Restart terminal
- [ ] Run `flutter doctor`
- [ ] Install Android Studio (for emulator) OR use web
- [ ] Run `flutter pub get` in `mobile_app/`
- [ ] Run `flutter run -d chrome` (web) or `flutter run` (emulator)

---

## 🆘 **If Installation is Too Complex**

### **Option 1: Use Web Version Only**
- Install Flutter (simpler, no Android Studio needed)
- Run: `flutter run -d chrome`
- Test in browser

### **Option 2: Use Physical Device**
- Install Flutter
- Connect your Android phone via USB
- Enable USB debugging
- Run: `flutter run`

### **Option 3: Ask Team Member**
- If someone else has Flutter set up
- They can run it and show you
- Or help you set it up

---

## 🎮 **After Installation**

Once Flutter is working:

1. **Start Backend** (Terminal 1):
   ```bash
   cd backend/app
   python main.py
   ```

2. **Start Game** (Terminal 2):
   ```bash
   cd mobile_app
   flutter run -d chrome
   ```

3. **See the Game Interface!** 🎉

---

## 📚 **Helpful Links**

- **Flutter Install:** https://docs.flutter.dev/get-started/install/windows
- **Flutter Docs:** https://docs.flutter.dev/
- **Android Studio:** https://developer.android.com/studio

---

**Need help with installation? Let me know which step you're stuck on!**


