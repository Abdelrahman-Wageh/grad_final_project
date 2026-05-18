@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Starting The Whispering Woods Application
echo ========================================
echo.

REM Store the original directory
set "ORIGINAL_DIR=%CD%"
echo Current directory: %ORIGINAL_DIR%
echo.

REM Check if we're in the right directory
if not exist "backend" (
    echo ERROR: backend folder not found in current directory
    echo Please run this script from the project root directory
    echo Current directory: %CD%
    pause
    exit /b 1
)

if not exist "mobile_app" (
    echo ERROR: mobile_app folder not found in current directory
    echo Please run this script from the project root directory
    echo Current directory: %CD%
    pause
    exit /b 1
)

REM Check if conda is installed
echo Checking conda installation...
conda --version 2>nul
if errorlevel 1 (
    echo ERROR: Conda is not installed or not in PATH
    echo Please install Anaconda/Miniconda and add it to your PATH
    pause
    exit /b 1
) else (
    echo Conda found:
    conda --version
)

REM Check if Flutter is installed
echo Checking Flutter installation...
flutter --version 2>nul
if errorlevel 1 (
    echo ERROR: Flutter is not installed or not in PATH
    echo Please install Flutter and add it to your PATH
    pause
    exit /b 1
) else (
    echo Flutter found:
    flutter --version | findstr "Flutter"
)

echo.
echo [1/4] Setting up backend with conda environment ai_env...
cd /d "%ORIGINAL_DIR%\backend"
echo Current directory: %CD%

REM Check if requirements.txt exists
if not exist "requirements.txt" (
    echo ERROR: requirements.txt not found in backend directory
    echo Expected path: %CD%\requirements.txt
    pause
    exit /b 1
)

REM Check if ai_env conda environment exists
echo Checking if conda environment 'ai_env' exists...
conda env list | findstr "ai_env" >nul
if errorlevel 1 (
    echo ERROR: Conda environment 'ai_env' not found
    echo Please create the environment first with: conda create -n ai_env python=3.9
    echo Then activate it and install requirements: conda activate ai_env && pip install -r requirements.txt
    pause
    exit /b 1
) else (
    echo ✓ Conda environment 'ai_env' found
)

REM Install/update requirements in ai_env
echo Installing/updating Python dependencies in ai_env...
call conda activate ai_env
if errorlevel 1 (
    echo ERROR: Failed to activate conda environment 'ai_env'
    pause
    exit /b 1
)

pip install -r requirements.txt
if errorlevel 1 (
    echo ERROR: Failed to install backend dependencies in ai_env
    echo Try running: conda activate ai_env && pip install --upgrade pip
    pause
    exit /b 1
)

echo.
echo [2/4] Setting up Flutter dependencies...
cd /d "%ORIGINAL_DIR%\mobile_app"
echo Current directory: %CD%

REM Check if pubspec.yaml exists
if not exist "pubspec.yaml" (
    echo ERROR: pubspec.yaml not found in mobile_app directory
    echo Expected path: %CD%\pubspec.yaml
    pause
    exit /b 1
)

echo Installing Flutter dependencies...
flutter pub get
if errorlevel 1 (
    echo ERROR: Failed to install Flutter dependencies
    echo Try running: flutter clean && flutter pub get
    pause
    exit /b 1
)

echo.
echo [3/4] Starting Backend Server...
cd /d "%ORIGINAL_DIR%\backend"
echo Starting backend in new window with conda ai_env...
start "Whispering Woods Backend" cmd /k "cd /d "%CD%" && call conda activate ai_env && python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload"

echo Waiting for backend to initialize...
timeout /t 8 /nobreak >nul

echo.
echo [4/4] Starting Flutter Web App...
cd /d "%ORIGINAL_DIR%\mobile_app"
echo Starting Flutter web app in new window...
start "Whispering Woods Flutter Web" cmd /k "cd /d "%CD%" && flutter run -d web-server --web-port 3000 --web-hostname 127.0.0.1"

echo.
echo ========================================
echo Application Startup Complete!
echo ========================================
echo.
echo Backend API: http://127.0.0.1:8000
echo API Documentation: http://127.0.0.1:8000/docs
echo Flutter Web App: http://127.0.0.1:3000
echo.
echo Note: It may take 30-60 seconds for Flutter web to fully compile and start
echo.
echo Press any key to open the applications in your browser...
pause >nul

REM Open applications in default browser
echo Opening backend documentation...
start http://127.0.0.1:8000/docs
timeout /t 3 /nobreak >nul
echo Opening Flutter web app...
start http://127.0.0.1:3000

echo.
echo Both applications should now be starting!
echo Check the separate terminal windows for any error messages.
echo Close those terminal windows to stop the servers.
echo.
pause
