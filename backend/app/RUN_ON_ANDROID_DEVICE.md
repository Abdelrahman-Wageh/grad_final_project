# 📱 Run App on Android Device - Step by Step

## 🎯 **Quick Steps:**

1. **Enable USB Debugging** on your Android device
2. **Connect device** via USB
3. **Find your computer's IP address**
4. **Update API URL** in the app (important!)
5. **Run Flutter** on your device

---

## 📋 **Step 1: Enable USB Debugging on Android**

### **For Android 8.0 and above:**
1. Go to **Settings** → **About phone**
2. Tap **Build number** 7 times (you'll see "You are now a developer!")
3. Go back to **Settings** → **System** → **Developer options**
4. Enable **USB debugging**
5. Enable **Install via USB** (if available)

### **For older Android:**
1. Go to **Settings** → **Developer options**
2. Enable **USB debugging**

---

## 🔌 **Step 2: Connect Device**

1. **Connect your Android device** to your computer via USB cable
2. On your phone, when prompted, **allow USB debugging** (check "Always allow" if you want)
3. You should see a notification: "USB debugging connected"

---

## 🌐 **Step 3: Find Your Computer's IP Address**

**Important:** Your Android device can't access `localhost` or `127.0.0.1`. You need your computer's local IP address.

### **On Windows (PowerShell):**
```powershell
ipconfig
```
Look for **IPv4 Address** under your active network adapter (usually starts with `192.168.` or `10.0.`)

Example: `192.168.1.100`

### **On Windows (Command Prompt):**
```cmd
ipconfig | findstr IPv4
```

---

## ⚙️ **Step 4: Update API URL in App**

You need to change the backend URL so your Android device can reach it.

### **Option A: Update app_constants.dart (Recommended)**

Edit: `mobile_app/lib/utils/app_constants.dart`

Change:
```dart
static String get apiBaseUrl {
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:8000'; // Android emulator
  } else {
    return 'http://localhost:8000'; // iOS simulator, web, desktop
  }
}
```

To:
```dart
static String get apiBaseUrl {
  if (Platform.isAndroid) {
    // Use your computer's IP address (replace with your actual IP)
    return 'http://192.168.1.100:8000'; // Replace with your IP!
  } else {
    return 'http://localhost:8000'; // iOS simulator, web, desktop
  }
}
```

**Replace `192.168.1.100` with YOUR computer's IP address!**

### **Option B: Use Environment Variable (Advanced)**

You can also set it via environment variable, but Option A is simpler.

---

## 🚀 **Step 5: Start Backend on Your Computer**

**Important:** Make sure your backend is running and accessible from your network.

1. **Open a terminal** on your computer
2. **Start the backend:**
   ```bash
   cd backend\app
   python main.py
   ```

3. **Make sure it's listening on all interfaces:**
   - Check `config.py` - `HOST` should be `"0.0.0.0"` (not `"127.0.0.1"`)
   - This allows connections from other devices on your network

---

## 📱 **Step 6: Run Flutter on Your Device**

1. **Make sure device is connected:**
   ```bash
   flutter devices
   ```
   You should see your Android device listed

2. **Run the app:**
   ```bash
   cd mobile_app
   flutter run
   ```
   Flutter will automatically detect your device and install the app!

---

## ✅ **Troubleshooting**

### **Problem: Device not detected**
**Solution:**
- Make sure USB debugging is enabled
- Try different USB cable
- Try different USB port
- On phone: Revoke USB debugging authorizations, then reconnect

### **Problem: "No devices found"**
**Solution:**
```bash
flutter doctor
```
Fix any issues it reports. You might need:
- Android SDK installed
- ADB (Android Debug Bridge) in PATH

### **Problem: Backend connection failed**
**Solution:**
1. **Check firewall:** Windows Firewall might be blocking port 8000
   - Go to Windows Defender Firewall → Allow an app
   - Allow Python or add port 8000 exception

2. **Check IP address:** Make sure you're using the correct IP
   - Both devices must be on the same Wi-Fi network
   - Try pinging your computer from phone (use network tools app)

3. **Check backend is running:**
   - On your computer, open browser: `http://YOUR_IP:8000/docs`
   - Should see Swagger UI

4. **Test connection from phone:**
   - Open Chrome on phone
   - Go to: `http://YOUR_IP:8000/docs`
   - Should see Swagger UI (if not, firewall/network issue)

### **Problem: "Connection refused"**
**Solution:**
- Backend must listen on `0.0.0.0`, not `127.0.0.1`
- Check `backend/app/config.py`:
  ```python
  HOST: str = "0.0.0.0"  # Not "127.0.0.1"
  ```

### **Problem: App installs but crashes**
**Solution:**
- Check device logs: `flutter logs`
- Make sure backend is accessible from phone
- Check API URL is correct

---

## 🔥 **Quick Checklist**

- [ ] USB debugging enabled on Android
- [ ] Device connected via USB
- [ ] Device shows in `flutter devices`
- [ ] Found computer's IP address
- [ ] Updated `app_constants.dart` with correct IP
- [ ] Backend running on `0.0.0.0:8000`
- [ ] Backend accessible from phone browser
- [ ] Firewall allows port 8000
- [ ] Both devices on same Wi-Fi network

---

## 🎯 **Alternative: Use Wi-Fi Debugging (No USB!)**

If you want to debug wirelessly:

1. **Connect via USB first** (one time setup)
2. **Enable Wi-Fi debugging:**
   ```bash
   adb tcpip 5555
   ```
3. **Disconnect USB**
4. **Connect via Wi-Fi:**
   ```bash
   adb connect YOUR_PHONE_IP:5555
   ```
5. **Run Flutter:**
   ```bash
   flutter run
   ```

---

## 📝 **Summary**

1. Enable USB debugging → Connect device
2. Find your IP: `ipconfig` → Look for IPv4
3. Update `app_constants.dart` → Change Android URL to `http://YOUR_IP:8000`
4. Start backend: `python main.py` (make sure HOST = "0.0.0.0")
5. Run: `flutter run`

**That's it! Your app will install and run on your Android device! 🎉**

