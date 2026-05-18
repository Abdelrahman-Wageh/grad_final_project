@echo off
REM ========================================
REM Smartino Complete Startup Script
REM Starts Backend + Flutter Web
REM ========================================

echo.
echo ========================================
echo   SMARTINO COMPLETE STARTUP
echo ========================================
echo.

REM Check if backend directory exists
if not exist "backend" (
    echo ERROR: backend directory not found!
    echo Please run this script from the project root directory.
    pause
    exit /b 1
)

REM Check if mobile_app directory exists
if not exist "mobile_app" (
    echo ERROR: mobile_app directory not found!
    echo Please run this script from the project root directory.
    pause
    exit /b 1
)

echo [1/4] Starting Backend Server...
echo.

REM Start backend in a new window
start "Smartino Backend" cmd /k "cd backend && python -m app.main"

echo Waiting for backend to initialize (5 seconds)...
timeout /t 5 /nobreak >nul

echo.
echo [2/4] Backend started successfully!
echo Backend URL: http://localhost:8000
echo.

echo [3/4] Starting Flutter Web App...
echo.

REM Start Flutter web in a new window
start "Smartino Flutter Web" cmd /k "cd mobile_app && flutter run -d chrome --web-port 8080"

echo.
echo [4/4] Flutter Web starting...
echo.

echo ========================================
echo   SMARTINO IS STARTING!
echo ========================================
echo.
echo Backend:  http://localhost:8000
echo Frontend: http://localhost:8080
echo.
echo Two windows have been opened:
echo   1. Backend Server (Python FastAPI)
echo   2. Flutter Web App (Chrome)
echo.
echo Close those windows to stop the services.
echo.
echo Press any key to exit this launcher...
pause >nul
