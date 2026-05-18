@echo off
echo ========================================
echo Manual Startup Helper
echo ========================================
echo.

echo This will open 2 command windows for you to run manually:
echo.
echo Window 1: Backend Server
echo Window 2: Flutter Web App
echo.
echo Press any key to continue...
pause

echo Opening Backend window...
start "Backend - Run Manually" cmd /k "echo Run these commands: && echo 1. cd %CD%\backend && echo 2. conda activate ai_env && echo 3. python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload && echo. && echo Copy and paste each command above"

timeout /t 2

echo Opening Flutter window...
start "Flutter - Run Manually" cmd /k "echo Run these commands: && echo 1. cd %CD%\mobile_app && echo 2. flutter run -d web-server --web-port 3000 && echo. && echo Copy and paste each command above"

echo.
echo Two windows opened with manual instructions.
echo Follow the commands in each window.
echo.
echo When both are running, open:
echo Backend: http://127.0.0.1:8000/docs
echo Frontend: http://127.0.0.1:3000
echo.
pause
