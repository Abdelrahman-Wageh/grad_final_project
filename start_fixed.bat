@echo off
echo ========================================
echo Starting Whispering Woods (Fixed)
echo ========================================
echo.

echo Current directory: %CD%
echo.

REM Check directories exist
if not exist "backend" (
    echo ERROR: backend folder not found
    pause
    exit
)

if not exist "mobile_app" (
    echo ERROR: mobile_app folder not found
    pause
    exit
)

echo [1/2] Starting Backend Server...
start "Backend Server" cmd /k "cd /d %CD%\backend && conda activate ai_env && cd app && python main.py"

echo Waiting 8 seconds for backend...
timeout /t 8 /nobreak

echo [2/2] Starting Flutter Web...
start "Flutter Web" cmd /k "cd /d %CD%\mobile_app && flutter run -d web-server --web-port 3000"

echo.
echo Servers starting...
echo Backend: http://127.0.0.1:8000
echo Frontend: http://127.0.0.1:3000
echo.
echo Opening browsers in 10 seconds...
timeout /t 10 /nobreak

start http://127.0.0.1:8000/docs
timeout /t 2 /nobreak
start http://127.0.0.1:3000

echo.
echo Done! Check the server windows for any errors.
pause
