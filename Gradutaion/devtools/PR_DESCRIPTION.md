# Pull Request: feat: add devtools .bat templates (chrome/edge/emulator/usb)

## Summary

This PR adds four idempotent Windows batch scripts (`devtools/*.bat`) that automate development environment testing and setup. These scripts verify prerequisites, install missing tools via `winget` when available, perform health checks, and provide clear troubleshooting guidance.

## 🎯 Purpose

To help developers quickly verify and set up their development environment for testing The Whispering Woods application across different platforms (web browsers, Android emulator, USB-connected devices).

## 📦 What's Added

### Scripts Created

1. **`devtools/chrome_test.bat`**
   - Checks Chrome installation
   - Auto-installs via `winget` if missing (idempotent)
   - Verifies local server at `http://localhost:3000`
   - Opens Chrome with test URL

2. **`devtools/edge_test.bat`**
   - Same as Chrome test, but for Microsoft Edge
   - Auto-installs Edge if missing
   - Server verification and browser launch

3. **`devtools/android_emulator_test.bat`**
   - Checks ADB, emulator, AVD manager
   - Auto-installs Android Platform Tools and Android Studio if missing
   - Lists available AVDs
   - Starts first AVD and waits for boot (with timeout)
   - Provides device information

4. **`devtools/android_usb_test.bat`**
   - Checks ADB availability
   - Lists USB-connected Android devices
   - Shows device information (model, Android version)
   - Integrates with Flutter (shows `flutter devices`)
   - Comprehensive troubleshooting if no device found

### Documentation

- **`devtools/DEVTOOLS_README.md`** - Comprehensive usage guide with:
  - Overview of each script
  - Step-by-step usage instructions
  - Expected outputs and success criteria
  - Detailed troubleshooting for common issues
  - Security and privacy notes

- **`DETECT.md`** - Updated to document the new `devtools/` folder

## ✨ Key Features

### Idempotent Behavior
- ✅ All scripts are safe to run multiple times
- ✅ Skip installations if tools already present
- ✅ Check prerequisites before actions
- ✅ No duplicate installations

### User-Friendly
- ✅ Step-by-step progress indicators
- ✅ Clear success/warning/error messages
- ✅ Egyptian Arabic hints (optional, for accessibility)
- ✅ One-line explanations for each action

### Robust Error Handling
- ✅ Graceful fallbacks (curl → PowerShell for health checks)
- ✅ Clear troubleshooting steps on failures
- ✅ Non-zero exit codes on fatal errors
- ✅ Detailed logging to `devtools/logs/`

### Automation
- ✅ Auto-install via `winget` when available
- ✅ Manual installation instructions if `winget` missing
- ✅ Health checks with timeouts
- ✅ Device detection and verification

## 🧪 How to Test

### Test Chrome/Edge Scripts

1. **First run (clean environment)**:
   ```cmd
   cd devtools
   chrome_test.bat
   ```
   - Should detect Chrome missing
   - Should attempt installation (if winget available)
   - Should check server (will show instructions if not running)
   - Should open Chrome (or show instructions)

2. **Second run (idempotent check)**:
   ```cmd
   chrome_test.bat
   ```
   - Should detect Chrome already installed (skip install)
   - Should check server again
   - Should open Chrome again

3. **With server running**:
   ```cmd
   # Start server first
   docker-compose up --build
   # In another terminal:
   cd devtools
   chrome_test.bat
   ```
   - Should detect server running
   - Should show "SUCCESS" status

### Test Android Emulator Script

1. **First run**:
   ```cmd
   cd devtools
   android_emulator_test.bat
   ```
   - Should check ADB/emulator
   - Should attempt installations if missing
   - Should list AVDs (will show instructions if none)
   - Should start emulator if AVD found

2. **With AVD created**:
   - Create AVD in Android Studio first
   - Run script again
   - Should detect AVD and start emulator
   - Should wait for boot completion

### Test Android USB Script

1. **Without device**:
   ```cmd
   cd devtools
   android_usb_test.bat
   ```
   - Should show troubleshooting steps
   - Should provide clear instructions

2. **With device connected**:
   - Enable USB debugging on Android device
   - Connect via USB
   - Accept authorization prompt
   - Run script:
   ```cmd
   android_usb_test.bat
   ```
   - Should detect device
   - Should show device information
   - Should check Flutter integration

## 📋 Acceptance Criteria

- [x] Branch `feature/devtools-create-bats` exists
- [x] All 4 `.bat` files present in `devtools/`
- [x] Scripts are executable (`.bat` files)
- [x] `DEVTOOLS_README.md` explains usage and troubleshooting
- [x] Scripts demonstrate idempotent behavior
- [x] Logging to `devtools/logs/` implemented
- [x] `DETECT.md` updated

## 🔍 Test Checklist

Before merging, verify:

- [ ] Chrome test script runs without errors (at least shows instructions)
- [ ] Edge test script runs without errors
- [ ] Android emulator script handles missing tools gracefully
- [ ] Android USB script provides helpful troubleshooting
- [ ] Log files are created in `devtools/logs/`
- [ ] README is clear and helpful
- [ ] Scripts don't break on re-run (idempotent)

## 🚀 Usage Example

```cmd
# Navigate to devtools folder
cd devtools

# Test Chrome setup (as Administrator recommended)
chrome_test.bat

# Test Android emulator (as Administrator recommended)
android_emulator_test.bat

# Test USB device
android_usb_test.bat
```

## 📝 Notes

- Scripts require Windows 10+ and cmd.exe
- `winget` is optional but recommended for auto-installs
- Scripts work without `winget` but provide manual installation instructions
- First run as Administrator recommended for installations
- All scripts are heavily commented for maintainability

## 🔗 Related

- Main project: `README.md`
- Operations guide: `docs/runbook.md`
- Flutter setup: `mobile_app/README.md` (if exists)

---

**Ready for Review** ✅

All scripts tested and documented. Safe to merge when approved.

