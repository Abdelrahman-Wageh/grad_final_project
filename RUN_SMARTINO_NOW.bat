@echo off
echo ========================================
echo    SMARTINO - Run Everything Now
echo ========================================
echo.
echo This will start:
echo 1. Backend (Python FastAPI)
echo 2. Flutter (Web on Chrome)
echo.
echo Press any key to start...
pause >nul

echo.
echo [1/2] Starting Backend...
echo.
start "Smartino Backend" cmd /k "cd backend && python -m app.main"

echo Waiting 5 seconds for backend to start...
timeout /t 5 /nobreak >nul

echo.
echo [2/2] Starting Flutter...
echo.
start "Smartino Flutter" cmd /k "cd mobile_app && flutter run -d chrome"

echo.
echo ========================================
echo    Both services are starting!
echo ========================================
echo.
echo Backend: http://localhost:8000
echo Flutter: http://localhost:8080
echo.
echo To see Friend Mode:
echo 1. Wait for app to load
echo 2. Select Farfour character
echo 3. Click through home screen
echo 4. Click 3rd tab (💬 صاحبي)
echo 5. Press microphone and speak!
echo.
echo Press any key to exit this window...
pause >nul
