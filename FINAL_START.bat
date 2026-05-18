@echo off
cls
echo ========================================
echo Whispering Woods - Final Startup Script
echo ========================================
echo.

REM Check directory
if not exist "backend\app\main.py" (
    echo ERROR: Please run from project root
    pause
    exit /b 1
)

echo [Step 1/3] Starting Backend Server...
echo.
start "Backend - Whispering Woods" cmd /k "title Backend Server && cd /d %CD%\backend && conda activate ai_env && echo Starting backend... && python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload && pause"

echo Waiting 12 seconds for backend to fully start...
timeout /t 12 /nobreak >nul

echo.
echo [Step 2/3] Testing Backend...
curl -s http://127.0.0.1:8000/ >nul 2>&1
if errorlevel 1 (
    echo WARNING: Backend may not be ready yet
    echo Check the Backend window for errors
) else (
    echo ✓ Backend is responding!
)

echo.
echo [Step 3/3] Starting Flutter Web...
echo.
start "Flutter - Whispering Woods" cmd /k "title Flutter Web && cd /d %CD%\mobile_app && echo Starting Flutter web... && flutter run -d web-server --web-port 3000 --web-hostname 127.0.0.1 && pause"

echo.
echo ========================================
echo Startup Complete!
echo ========================================
echo.
echo Backend: http://127.0.0.1:8000
echo API Docs: http://127.0.0.1:8000/docs  
echo Flutter: http://127.0.0.1:3000
echo.
echo Opening browsers in 15 seconds...
echo (Flutter needs time to compile)
echo.
timeout /t 15 /nobreak >nul

start http://127.0.0.1:8000/docs
timeout /t 3 /nobreak >nul
start http://127.0.0.1:3000

echo.
echo ✓ Both servers are starting!
echo.
echo Check the separate windows for any errors.
echo The Flutter window will show compilation progress.
echo.
echo Press any key to exit this window...
pause >nul
