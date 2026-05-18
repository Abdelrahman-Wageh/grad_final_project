# How to Start Whispering Woods Application

## Quick Start

**Simply double-click:** `START_HERE.bat`

This will automatically:
1. Start the backend server on http://127.0.0.1:8000
2. Start the Flutter web app on http://127.0.0.1:3000
3. Open both in your browser

---

## What Was Fixed

### Backend Issues Fixed:
✅ **Import errors** - All imports now use `app.` prefix for proper module resolution
✅ **Logging conflict** - Renamed custom `logging/` directory to `audit_logging/`
✅ **Module not found** - Fixed all relative imports in services
✅ **Conda environment** - Properly activates `ai_env` environment

### Flutter Issues Fixed:
✅ **Missing asset directories** - Created all required asset folders:
  - `assets/images/`
  - `assets/animations/`
  - `assets/sounds/`
  - `assets/voices/`
  - `assets/data/`

---

## Manual Startup (if batch file doesn't work)

### Terminal 1 - Backend:
```cmd
cd backend
conda activate ai_env
python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
```

### Terminal 2 - Flutter:
```cmd
cd mobile_app
flutter run -d web-server --web-port 3000
```

---

## URLs

- **Backend API**: http://127.0.0.1:8000
- **API Documentation**: http://127.0.0.1:8000/docs
- **Flutter Web App**: http://127.0.0.1:3000

---

## Troubleshooting

### Backend won't start:
1. Make sure conda environment `ai_env` exists: `conda env list`
2. Activate it manually: `conda activate ai_env`
3. Install requirements: `cd backend && pip install -r requirements.txt`

### Flutter won't start:
1. Run `flutter doctor` to check installation
2. Run `flutter pub get` in mobile_app directory
3. Make sure Chrome or Edge browser is installed

### Port already in use:
- Close any existing servers running on ports 8000 or 3000
- Or change ports in the batch file

---

## Files Changed

### Backend (`backend/app/`):
- `main.py` - Fixed imports to use `app.` prefix
- `api_endpoints.py` - Fixed imports
- `services/*.py` - Fixed all service imports
- `audit_logging/` - Renamed from `logging/` to avoid conflict

### Flutter (`mobile_app/`):
- Created missing asset directories

### Root:
- `START_HERE.bat` - Main startup script
- `HOW_TO_START.md` - This file

---

## Notes

- Backend runs in **DRY_RUN mode** by default (no real AI models needed)
- Flutter web compilation takes 30-60 seconds on first run
- Both servers run with auto-reload for development
- Close the terminal windows to stop the servers

---

## Success Indicators

✅ Backend window shows: `Application startup complete`
✅ Flutter window shows: `Waiting for connection from debug service on Web Server...`
✅ Browser opens to API docs and Flutter app
✅ No red error messages in terminal windows

---

**Everything should now work perfectly!** 🎉
