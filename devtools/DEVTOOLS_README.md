# 🔧 Development Tools - Whispering Woods

## 🚀 Quick Start - Enhanced Scripts

**Just double-click `chrome_test.bat` or `edge_test.bat` - Everything is automated!**

The enhanced scripts will:
1. ✅ Check all prerequisites (Python, Node.js, Chrome/Edge)
2. ✅ Automatically start backend server (port 8000) if needed
3. ✅ Automatically start frontend server (port 3000) if needed
4. ✅ Wait for servers to be ready
5. ✅ Open your browser to `http://localhost:3000`

**No manual steps needed!** The scripts handle everything step-by-step with clear progress messages.

---

## 📋 Enhanced Scripts Overview

### `chrome_test.bat` - Enhanced Chrome Test ⚡
**What it does step-by-step:**
1. Checks Chrome installation
2. Checks Python 3.14 installation
3. Checks Node.js installation
4. Verifies backend/frontend directories exist
5. **Starts backend server automatically** (creates venv, installs deps if needed)
6. **Starts frontend server automatically** (installs npm packages if needed)
7. Waits for both servers to be ready (with progress updates)
8. Opens Chrome with `http://localhost:3000`

**First run:** May take 3-5 minutes (one-time setup)
**Subsequent runs:** ~10-30 seconds

### `edge_test.bat` - Enhanced Edge Test ⚡
Same as Chrome test, but opens Microsoft Edge instead.

---

## 📋 All Available Scripts

### 1. `chrome_test.bat` (Enhanced)
**Purpose**: Fully automated Chrome testing with server management.

**Features:**
- ✅ Automatic prerequisite checking
- ✅ Automatic server startup
- ✅ Progress indicators
- ✅ Error handling with fix instructions
- ✅ Detailed logging

**When to use**: Anytime you want to test the web application - just double-click!

---

### 2. `edge_test.bat` (Enhanced)
**Purpose**: Same as Chrome test, but for Microsoft Edge.

**Features**: Same as Chrome test.

**When to use**: When you prefer Edge browser or Chrome isn't installed.

---

### 3. `android_emulator_test.bat`
**Purpose**: Checks Android SDK tools, installs if needed, and starts an Android emulator.

**What it does:**
- ✅ Checks for ADB (Android Debug Bridge)
- ✅ Checks for Android Emulator
- ✅ Installs Android Platform Tools and Android Studio if missing
- ✅ Lists available AVDs (Android Virtual Devices)
- ✅ Starts the first available AVD
- ✅ Waits for emulator to boot (up to 5 minutes)
- ✅ Verifies device is ready

**When to use**: When you want to test the Flutter mobile app on an Android emulator.

---

### 4. `android_usb_test.bat`
**Purpose**: Detects and verifies USB-connected Android devices.

**What it does:**
- ✅ Checks for ADB
- ✅ Lists connected USB Android devices
- ✅ Shows device information (model, Android version, manufacturer)
- ✅ Checks Flutter integration
- ✅ Provides troubleshooting steps if no device found

**When to use**: When you have a physical Android device connected via USB.

---

## 🚀 How to Run Enhanced Scripts

### Method 1: Double-Click (Recommended)
1. Navigate to `devtools` folder
2. Double-click `chrome_test.bat` or `edge_test.bat`
3. Wait for the script to complete (watch the progress messages)
4. Browser opens automatically!

### Method 2: Command Line
```cmd
cd devtools
chrome_test.bat
```

### Method 3: Run as Administrator (First Time)
If you need to install tools:
1. Right-click the `.bat` file
2. Select **"Run as administrator"**
3. Click **"Yes"** if prompted

---

## 📊 Step-by-Step Process (What You'll See)

When you run an enhanced script, you'll see:

```
============================================================
  Enhanced Chrome Test - Whispering Woods
  Checking prerequisites and starting servers...
============================================================

[Step 1/8] Checking Chrome installation...
  OK - Chrome found

[Step 2/8] Checking Python installation...
  OK - Python 3.14.0 found

[Step 3/8] Checking Node.js installation...
  OK - Node.js v22.21.0 found

[Step 4/8] Checking backend directory...
  OK - Backend directory found

[Step 5/8] Checking frontend directory...
  OK - Frontend directory found

[Step 6/8] Ensuring backend server is running...
  Backend server is not running, starting it...
  Creating virtual environment...
  Installing dependencies...
  Starting backend server on port 8000...
  Waiting for backend to start...
  Still waiting... (3/90 seconds)
  Still waiting... (6/90 seconds)
  OK - Backend server is now running!

[Step 7/8] Ensuring frontend server is running...
  Frontend server is not running, starting it...
  Installing dependencies...
  Starting frontend server on port 3000...
  Waiting for frontend to start...
  Still waiting... (3/90 seconds)
  OK - Frontend server is now running!

[Step 8/8] Opening Chrome...
  OK - Chrome opened with http://localhost:3000

============================================================
  SUCCESS - Everything is running!
============================================================
```

---

## 🐛 Troubleshooting

### Error: "Python not found"
**Solution:**
1. Install Python 3.14 from: https://www.python.org/downloads/
2. ✅ **Important:** Check "Add Python to PATH" during installation
3. Restart your computer
4. Re-run the script

**Verify installation:**
```cmd
python --version
```

### Error: "Node.js not found"
**Solution:**
1. Install Node.js from: https://nodejs.org/
2. Restart your computer
3. Re-run the script

**Verify installation:**
```cmd
node --version
npm --version
```

### Error: "Backend did not start"
**Common causes:**
- Port 8000 already in use
- Virtual environment creation failed
- Dependencies failed to install

**Troubleshooting steps:**
```cmd
REM 1. Check if port is in use
netstat -ano | findstr :8000

REM 2. Kill process if needed (replace PID with actual process ID)
taskkill /PID <PID> /F

REM 3. Manually start backend
cd backend
.venv\Scripts\activate
uvicorn app.main:app --port 8000
```

**If virtual environment issues:**
```cmd
REM Delete and recreate venv
cd backend
rmdir /s /q .venv
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

### Error: "Frontend did not start"
**Common causes:**
- Port 3000 already in use
- npm packages failed to install
- React Scripts not installed

**Troubleshooting steps:**
```cmd
REM 1. Check if port is in use
netstat -ano | findstr :3000

REM 2. Manually start frontend
cd promotional_website
npm install
npm start
```

**If npm install fails:**
```cmd
REM Clear npm cache and reinstall
cd promotional_website
rmdir /s /q node_modules
del package-lock.json
npm cache clean --force
npm install
```

### Servers Start But Browser Shows Error
**Possible causes:**
1. **Servers still initializing** - Wait 10-30 seconds and refresh
2. **Port conflict** - Check if another application is using ports 8000/3000
3. **Server errors** - Check the minimized server windows for error messages

**Check server status:**
```cmd
REM Check backend health
curl http://localhost:8000/api/health

REM Check frontend
curl http://localhost:3000
```

### Script Hangs at "Waiting for server..."
**Solution:**
1. Press `Ctrl+C` to stop the script
2. Check server windows for error messages
3. Manually start servers (see troubleshooting above)
4. Once servers are running, re-run the script (it will detect them)

---

## 📝 Logging

All scripts create detailed logs in `devtools/logs/`:
- `chrome_test_YYYYMMDD_HHMMSS.log`
- `edge_test_YYYYMMDD_HHMMSS.log`
- `edge_test_YYYYMMDD_HHMMSS.log`
- `android_emulator_test_YYYYMMDD_HHMMSS.log`
- `android_usb_test_YYYYMMDD_HHMMSS.log`

**View latest log:**
```cmd
REM Windows
dir /O-D devtools\logs\*.log

REM View specific log
type devtools\logs\chrome_test_*.log
```

**Log contents:**
- Timestamp of each step
- Success/failure messages
- Error details
- Installation attempts
- Server status checks

---

## 🎯 What Happens After Script Runs

### Server Windows
When servers start, you'll see two minimized windows:
- **"Backend Server"** - FastAPI on port 8000
- **"Frontend Server"** - React dev server on port 3000

### To Stop Servers:
1. **Close the minimized windows** - Click X on each window
2. **Use Task Manager** - End the `cmd.exe` processes
3. **Command line:**
   ```cmd
   REM Find process IDs
   netstat -ano | findstr :8000
   netstat -ano | findstr :3000
   
   REM Kill processes (replace PID)
   taskkill /PID <PID> /F
   ```

### To Restart Everything:
Just run the script again! It will:
- ✅ Detect running servers
- ✅ Skip starting them
- ✅ Open browser immediately

---

## 🔄 Idempotent Behavior

These scripts are **fully idempotent** - safe to run multiple times:

- ✅ **Already running servers:** Detected and skipped
- ✅ **Existing venv:** Used, not recreated
- ✅ **Installed dependencies:** Skipped, not reinstalled
- ✅ **Open browser:** Opens new tab, doesn't duplicate

**First run:** ~3-5 minutes (one-time setup)
**Subsequent runs:** ~10-30 seconds

---

## 📊 Configuration

You can modify these settings at the top of each script:

```batch
set "FRONTEND_URL=http://localhost:3000"
set "BACKEND_URL=http://localhost:8000"
set "BACKEND_PORT=8000"
set "FRONTEND_PORT=3000"
set "SERVER_START_TIMEOUT=90"
```

**Custom ports:**
If you need different ports, edit the script and change the values above.

---

## 🌐 Network Access

### Local Development:
- Backend: `http://localhost:8000`
- Frontend: `http://localhost:3000`

### Mobile App Testing:

**Android Emulator:**
- Backend: `http://10.0.2.2:8000`
- Frontend: `http://10.0.2.2:3000`

**Physical Device:**
1. Find your computer's IP: `ipconfig` (look for IPv4 Address)
2. Update Flutter app constants:
   ```dart
   static const String apiBaseUrl = 'http://192.168.1.100:8000';
   ```
3. Ensure firewall allows connections

---

## ⚡ Performance Tips

### First Run (One-Time Setup):
- Creating venv: ~30 seconds
- Installing Python deps: ~2-3 minutes (depending on internet speed)
- Installing npm packages: ~1-2 minutes
- **Total:** ~3-5 minutes

### Subsequent Runs:
- Starting backend: ~5-10 seconds
- Starting frontend: ~10-20 seconds
- Opening browser: Instant
- **Total:** ~10-30 seconds

### Speed Up Subsequent Runs:
- Don't close server windows between runs
- Scripts will detect running servers and skip startup
- Browser opens immediately

---

## 🆘 Getting Help

### 1. Check Logs First
```cmd
type devtools\logs\chrome_test_*.log
```

### 2. Verify Prerequisites
```cmd
python --version
node --version
npm --version
```

### 3. Check Server Status
```cmd
REM Backend health check
curl http://localhost:8000/api/health

REM Frontend check
curl http://localhost:3000
```

### 4. Manual Startup
If automated startup fails, start servers manually:
```cmd
REM Backend
cd backend
.venv\Scripts\activate
uvicorn app.main:app --port 8000

REM Frontend (new terminal)
cd promotional_website
npm start
```

### 5. Common Issues
- **Port already in use:** See troubleshooting section above
- **Virtual environment issues:** Delete `.venv` and recreate
- **npm install fails:** Clear cache and reinstall
- **Python not found:** Add Python to PATH

---

## 📚 Additional Scripts

### `detect_env.ps1`
PowerShell script to detect your development environment.

**Run:**
```powershell
powershell -ExecutionPolicy Bypass -File devtools\detect_env.ps1
```

**Output:** `devtools/detect_env.json` with system information.

---

## ✅ Success Indicators

When everything works, you'll see:

```
============================================================
  SUCCESS - Everything is running!
  نجاح - كل شيء يعمل!
============================================================

  Backend:  http://localhost:8000
  Frontend: http://localhost:3000
  Browser:  Chrome opened

  To stop servers:
  - Close the "Backend Server" and "Frontend Server" windows
  - Or press Ctrl+C in their windows

  Log file: devtools\logs\chrome_test_*.log
```

And your browser will open to the application! 🎉

---

## 🎓 For Developers

### Script Architecture
- **Idempotent:** Safe to run multiple times
- **Error handling:** Clear messages with fix instructions
- **Logging:** Detailed logs for debugging
- **Progress indicators:** Real-time status updates
- **Timeout handling:** Prevents infinite waits

### Extending Scripts
To add more checks or steps:
1. Add new step number
2. Update total step count in banner
3. Add error handling
4. Add logging
5. Test thoroughly

---

## 📞 Support

If you encounter issues:
1. Check the troubleshooting section
2. Review logs in `devtools/logs/`
3. Verify prerequisites are installed
4. Try manual server startup
5. Check for port conflicts

---

**Last Updated:** 2025-10-31  
**Version:** Enhanced with automatic server management
