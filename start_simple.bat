@echo off
echo ========================================
echo Starting Whispering Woods Application
echo ========================================
echo.

REM Check current directory
echo Current directory: %CD%
echo.

REM Basic checks
if not exist "backend" (
    echo ERROR: Run this from the project root directory
    pause
    exit
)

if not exist "mobile_app" (
    echo ERROR: Run this from the project root directory  
    pause
    exit
)

echo [1/3] Starting Backend Server...
echo Opening new window for backend...
start "Backend" cmd /c "cd /d %CD%\backend && conda activate ai_env && python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload && pause"

echo Waiting 10 seconds for backend to start...
timeout /t 10 /nobreak

echo.
echo [2/3] Starting Flutter Web...
echo Opening new window for Flutter...
start "Flutter Web" cmd /c "cd /d %CD%\mobile_app && flutter run -d web-server --web-port 3000 && pause"

echo Waiting 5 seconds...
timeout /t 5 /nobreak

echo.
echo [3/3] Opening browsers...
start http://127.0.0.1:8000/docs
timeout /t 2 /nobreak
start http://127.0.0.1:3000

echo.
echo ========================================
echo Startup Complete!
echo ========================================
echo Backend: http://127.0.0.1:8000
echo Frontend: http://127.0.0.1:3000
echo.
echo Check the separate windows for any errors.
echo Press any key to exit this window.
pause
