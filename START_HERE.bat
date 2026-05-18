@echo off
echo ========================================
echo Starting Whispering Woods Application
echo ========================================
echo.

REM Check if we're in the right directory
if not exist "backend" (
    echo ERROR: Please run this from the project root directory
    echo Current directory: %CD%
    pause
    exit /b 1
)

if not exist "mobile_app" (
    echo ERROR: Please run this from the project root directory
    echo Current directory: %CD%
    pause
    exit /b 1
)

echo Current directory: %CD%
echo.

echo [1/2] Starting Backend Server...
echo.
start "Whispering Woods Backend" cmd /k "cd /d %CD%\backend && conda activate ai_env && python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload"

echo Waiting 10 seconds for backend to initialize...
timeout /t 10 /nobreak >nul

echo.
echo [2/2] Starting Flutter Web App...
echo.
start "Whispering Woods Flutter" cmd /k "cd /d %CD%\mobile_app && flutter run -d web-server --web-port 3000 --web-hostname 127.0.0.1"

echo.
echo ========================================
echo Startup Complete!
echo ========================================
echo.
echo Backend API: http://127.0.0.1:8000
echo API Docs: http://127.0.0.1:8000/docs
echo Flutter Web: http://127.0.0.1:3000
echo.
echo Note: Flutter may take 30-60 seconds to compile
echo.
echo Opening browsers in 15 seconds...
timeout /t 15 /nobreak >nul

start http://127.0.0.1:8000/docs
timeout /t 3 /nobreak >nul
start http://127.0.0.1:3000

echo.
echo Both applications are starting!
echo Check the separate terminal windows for logs.
echo Close those windows to stop the servers.
echo.
pause
