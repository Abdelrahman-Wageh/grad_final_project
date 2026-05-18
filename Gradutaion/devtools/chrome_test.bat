@echo off
REM ============================================================================
REM Enhanced Chrome Test Script - Whispering Woods Development Tools
REM FULLY AUTOMATED: Checks prerequisites, FIXES issues, starts servers, keeps running
REM ============================================================================

REM Set UTF-8 console encoding
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

REM Configuration
set "FRONTEND_URL=http://localhost:3000"
set "BACKEND_URL=http://localhost:8000"
set "BACKEND_PORT=8000"
set "FRONTEND_PORT=3000"
set "TIMEOUT_SECONDS=60"
set "SERVER_START_TIMEOUT=120"
set "KEEP_WINDOWS_OPEN=1"

REM Project paths (relative to script location)
set "SCRIPT_DIR=%~dp0"
REM Remove trailing backslash if present
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

REM Resolve PROJECT_ROOT properly using FOR to get full path
for %%I in ("%SCRIPT_DIR%\..") do set "PROJECT_ROOT=%%~fI"

REM Ensure directories exist
if not exist "%PROJECT_ROOT%" (
    echo ERROR: Cannot find project root directory
    echo Script location: %SCRIPT_DIR%
    echo Expected project root: %PROJECT_ROOT%
    pause
    exit /b 1
)

REM Set directory paths
set "BACKEND_DIR=%PROJECT_ROOT%\backend"
set "FRONTEND_DIR=%PROJECT_ROOT%\promotional_website"

REM Logging - Create directory first, ensure it exists
set "LOG_DIR=%SCRIPT_DIR%\logs"
if not exist "%LOG_DIR%" (
    mkdir "%LOG_DIR%" 2>nul
    if not exist "%LOG_DIR%" (
        set "LOG_FILE="
    ) else (
        set "LOG_FILE=%LOG_DIR%\chrome_test_%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log"
        set "LOG_FILE=%LOG_FILE: =0%"
    )
) else (
    set "LOG_FILE=%LOG_DIR%\chrome_test_%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log"
    set "LOG_FILE=%LOG_FILE: =0%"
)

REM Change to project root
cd /d "%PROJECT_ROOT%" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Cannot change to project directory: %PROJECT_ROOT%
    pause
    exit /b 1
)

REM Function to log (only if LOG_FILE is set)
if defined LOG_FILE (
    call :log "==========================================" >nul 2>&1
    call :log "Enhanced Chrome Test Started" >nul 2>&1
    call :log "Time: %date% %time%" >nul 2>&1
    call :log "Project Root: %PROJECT_ROOT%" >nul 2>&1
    call :log "==========================================" >nul 2>&1
)

REM Clear screen and show banner
cls
echo.
echo ============================================================
echo   Enhanced Chrome Test - Whispering Woods
echo   FULLY AUTOMATED - Fixes issues and starts everything
echo   جاري التحقق والإصلاح التلقائي وبدء كل شيء
echo ============================================================
echo.
echo   This script will:
echo   - Check and fix prerequisites (Python, Node.js, Chrome)
echo   - Create virtual environments if needed
echo   - Install dependencies automatically
echo   - Start backend and frontend servers
echo   - Open Chrome with the application
echo.
echo   Press Ctrl+C at any time to exit
echo.
timeout /t 3 /nobreak >nul 2>&1
echo.

REM ============================================================================
REM Step 1: Check and Install Chrome
REM ============================================================================
echo [Step 1/10] Checking Chrome installation...
if defined LOG_FILE call :log "Checking Chrome..." >nul 2>&1
echo.

where chrome >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   ✓ Chrome found in PATH
    if defined LOG_FILE call :log "Chrome found in PATH" >nul 2>&1
    goto :check_python
)

if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" (
    set "CHROME_PATH=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
    echo   ✓ Chrome found in Program Files
    if defined LOG_FILE call :log "Chrome found" >nul 2>&1
    goto :check_python
)

if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" (
    set "CHROME_PATH=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
    echo   ✓ Chrome found in Program Files (x86)
    if defined LOG_FILE call :log "Chrome found" >nul 2>&1
    goto :check_python
)

REM Chrome not found - try to install
echo   ✗ Chrome not found - Attempting automatic installation...
if defined LOG_FILE call :log "Chrome not found, attempting installation..." >nul 2>&1
echo.

where winget >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   Installing Chrome via winget (this may take 2-3 minutes)...
    echo   جاري تثبيت Chrome (قد يستغرق 2-3 دقائق)...
    if defined LOG_FILE call :log "Installing Chrome via winget..." >nul 2>&1
    
    winget install --id=Google.Chrome -e --accept-package-agreements --accept-source-agreements 2>&1 | findstr /V "Downloading Installing"
    
    if %ERRORLEVEL% EQU 0 (
        echo   Waiting for installation to complete...
        timeout /t 10 /nobreak >nul 2>&1
        
        REM Re-check Chrome
        where chrome >nul 2>&1
        if %ERRORLEVEL% EQU 0 (
            echo   ✓ Chrome installed successfully!
            if defined LOG_FILE call :log "Chrome installed successfully" >nul 2>&1
            goto :check_python
        )
        
        if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" (
            set "CHROME_PATH=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
            echo   ✓ Chrome installed successfully!
            if defined LOG_FILE call :log "Chrome installed successfully" >nul 2>&1
            goto :check_python
        )
    )
)

REM Manual installation instructions
echo.
echo   ⚠ Chrome installation failed or requires manual installation
echo   ⚠ تثبيت Chrome فشل أو يتطلب تثبيت يدوي
echo.
echo   Please install Chrome manually:
echo   1. Visit: https://www.google.com/chrome/
echo   2. Download and run the installer
echo   3. Re-run this script after installation
echo.
if defined LOG_FILE call :log "Chrome installation failed" >nul 2>&1
echo   Press any key to continue anyway (browser won't open but servers will start)...
pause >nul
set "CHROME_MISSING=1"

:check_python
REM ============================================================================
REM Step 2: Check and Install Python
REM ============================================================================
echo.
echo [Step 2/10] Checking Python installation...
if defined LOG_FILE call :log "Checking Python..." >nul 2>&1
echo.

where python >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    python --version >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        for /f "tokens=2" %%i in ('python --version 2^>^&1') do set "PYTHON_VERSION=%%i"
        echo   ✓ Python !PYTHON_VERSION! found
        if defined LOG_FILE call :log "Python !PYTHON_VERSION! found" >nul 2>&1
        goto :check_node
    )
)

REM Python not found - try to install
echo   ✗ Python not found - Attempting automatic installation...
if defined LOG_FILE call :log "Python not found, attempting installation..." >nul 2>&1
echo.

where winget >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   Installing Python 3.14 via winget (this may take 5-10 minutes)...
    echo   ⚠ This is a large download - please wait...
    echo   جاري تثبيت Python (قد يستغرق 5-10 دقائق)...
    if defined LOG_FILE call :log "Installing Python via winget..." >nul 2>&1
    
    winget install --id=Python.Python.3.14 -e --accept-package-agreements --accept-source-agreements 2>&1 | findstr /V "Downloading Installing"
    
    if %ERRORLEVEL% EQU 0 (
        echo   Installation completed - Waiting for PATH refresh...
        if defined LOG_FILE call :log "Python installation completed" >nul 2>&1
        
        REM Re-check Python (may need new shell for PATH, but try anyway)
        timeout /t 5 /nobreak >nul 2>&1
        where python >nul 2>&1
        if %ERRORLEVEL% EQU 0 (
            python --version >nul 2>&1
            if %ERRORLEVEL% EQU 0 (
                for /f "tokens=2" %%i in ('python --version 2^>^&1') do set "PYTHON_VERSION=%%i"
                echo   ✓ Python !PYTHON_VERSION! installed successfully!
                if defined LOG_FILE call :log "Python installed successfully" >nul 2>&1
                goto :check_node
            )
        )
        
        echo   NOTE: Python installed but PATH may not be refreshed yet
        echo   If Python still not found, close this window and re-run the script
    )
)

REM Manual installation instructions
echo.
echo   ⚠ Python installation failed or requires manual installation
echo   ⚠ تثبيت Python فشل أو يتطلب تثبيت يدوي
echo.
echo   STEP-BY-STEP INSTALLATION INSTRUCTIONS:
echo   ========================================
echo   1. Visit: https://www.python.org/downloads/
echo   2. Download Python 3.14 (or latest version)
echo   3. Run the installer
echo   4. ✅ IMPORTANT: Check "Add Python to PATH" during installation
echo   5. Click "Install Now"
echo   6. Wait for installation to complete
echo   7. Close this window and re-run this script
echo.
if defined LOG_FILE call :log "Python installation failed" >nul 2>&1
echo   Cannot continue without Python. Press any key to exit...
pause >nul
exit /b 1

:check_node
REM ============================================================================
REM Step 3: Check and Install Node.js
REM ============================================================================
echo.
echo [Step 3/10] Checking Node.js installation...
if defined LOG_FILE call :log "Checking Node.js..." >nul 2>&1
echo.

where node >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    for /f "tokens=1" %%i in ('node --version 2^>^&1') do set "NODE_VERSION=%%i"
    echo   ✓ Node.js !NODE_VERSION! found
    if defined LOG_FILE call :log "Node.js !NODE_VERSION! found" >nul 2>&1
    goto :check_directories
)

REM Node.js not found - try to install
echo   ✗ Node.js not found - Attempting automatic installation...
if defined LOG_FILE call :log "Node.js not found, attempting installation..." >nul 2>&1
echo.

where winget >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   Installing Node.js LTS via winget (this may take 5-10 minutes)...
    echo   ⚠ This is a large download - please wait...
    echo   جاري تثبيت Node.js (قد يستغرق 5-10 دقائق)...
    if defined LOG_FILE call :log "Installing Node.js via winget..." >nul 2>&1
    
    winget install --id=OpenJS.NodeJS.LTS -e --accept-package-agreements --accept-source-agreements 2>&1 | findstr /V "Downloading Installing"
    
    if %ERRORLEVEL% EQU 0 (
        echo   Installation completed - Waiting for PATH refresh...
        if defined LOG_FILE call :log "Node.js installation completed" >nul 2>&1
        
        REM Re-check Node.js (may need new shell for PATH, but try anyway)
        timeout /t 5 /nobreak >nul 2>&1
        where node >nul 2>&1
        if %ERRORLEVEL% EQU 0 (
            for /f "tokens=1" %%i in ('node --version 2^>^&1') do set "NODE_VERSION=%%i"
            echo   ✓ Node.js !NODE_VERSION! installed successfully!
            if defined LOG_FILE call :log "Node.js installed successfully" >nul 2>&1
            goto :check_directories
        )
        
        echo   NOTE: Node.js installed but PATH may not be refreshed yet
        echo   If Node.js still not found, close this window and re-run the script
    )
)

REM Manual installation instructions
echo.
echo   ⚠ Node.js installation failed or requires manual installation
echo   ⚠ تثبيت Node.js فشل أو يتطلب تثبيت يدوي
echo.
echo   STEP-BY-STEP INSTALLATION INSTRUCTIONS:
echo   ========================================
echo   1. Visit: https://nodejs.org/
echo   2. Download the LTS version (recommended)
echo   3. Run the installer
echo   4. Click "Next" through the installation wizard
echo   5. ✅ Keep default options (adds Node.js to PATH automatically)
echo   6. Click "Install"
echo   7. Wait for installation to complete
echo   8. Close this window and re-run this script
echo.
if defined LOG_FILE call :log "Node.js installation failed" >nul 2>&1
echo   Cannot continue without Node.js. Press any key to exit...
pause >nul
exit /b 1

:check_directories
REM ============================================================================
REM Step 4-5: Check Backend and Frontend Directories
REM ============================================================================
echo.
echo [Step 4/10] Checking backend directory...
if defined LOG_FILE call :log "Checking backend directory..." >nul 2>&1
echo.

if not exist "%BACKEND_DIR%" (
    echo   ✗ Backend directory not found: %BACKEND_DIR%
    if defined LOG_FILE call :log "ERROR: Backend directory not found" >nul 2>&1
    echo.
    echo   STEP-BY-STEP FIX:
    echo   1. Make sure you're running this script from the correct location
    echo   2. The script should be in: devtools\chrome_test.bat
    echo   3. The backend should be in: backend\
    echo   4. Check your project structure
    echo.
    echo   Press any key to exit...
    pause >nul
    exit /b 1
)

if not exist "%BACKEND_DIR%\requirements.txt" (
    echo   ⚠ WARNING: requirements.txt not found
    if defined LOG_FILE call :log "WARNING: requirements.txt not found" >nul 2>&1
) else (
    echo   ✓ Backend directory found
)

echo.
echo [Step 5/10] Checking frontend directory...
if defined LOG_FILE call :log "Checking frontend directory..." >nul 2>&1
echo.

if not exist "%FRONTEND_DIR%" (
    echo   ✗ Frontend directory not found: %FRONTEND_DIR%
    if defined LOG_FILE call :log "ERROR: Frontend directory not found" >nul 2>&1
    echo.
    echo   STEP-BY-STEP FIX:
    echo   1. Make sure promotional_website directory exists
    echo   2. Check your project structure
    echo.
    echo   Press any key to exit...
    pause >nul
    exit /b 1
)

if not exist "%FRONTEND_DIR%\package.json" (
    echo   ✗ package.json not found
    if defined LOG_FILE call :log "ERROR: package.json not found" >nul 2>&1
    echo   Press any key to exit...
    pause >nul
    exit /b 1
) else (
    echo   ✓ Frontend directory found
)

REM ============================================================================
REM Step 6: Setup and Start Backend Server
REM ============================================================================
echo.
echo [Step 6/10] Setting up backend server...
if defined LOG_FILE call :log "Setting up backend server..." >nul 2>&1
echo.

REM Check if backend is already running
powershell -Command "try { $response = Invoke-WebRequest -Uri '%BACKEND_URL%/api/health' -TimeoutSec 3 -UseBasicParsing; exit $response.StatusCode } catch { exit 1 }" >nul 2>&1
if %ERRORLEVEL% EQU 200 (
    echo   ✓ Backend server is already running
    if defined LOG_FILE call :log "Backend already running" >nul 2>&1
    set "BACKEND_RUNNING=1"
    goto :setup_frontend
)

call :setup_backend
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo   ✗ Failed to setup backend server
    echo   See troubleshooting instructions above
    echo   Press any key to exit...
    pause >nul
    exit /b 1
)

:setup_frontend
REM ============================================================================
REM Step 7: Setup and Start Frontend Server
REM ============================================================================
echo.
echo [Step 7/10] Setting up frontend server...
if defined LOG_FILE call :log "Setting up frontend server..." >nul 2>&1
echo.

REM Check if frontend is already running
powershell -Command "try { $response = Invoke-WebRequest -Uri '%FRONTEND_URL%' -TimeoutSec 3 -UseBasicParsing; exit $response.StatusCode } catch { exit 1 }" >nul 2>&1
if %ERRORLEVEL% EQU 200 (
    echo   ✓ Frontend server is already running
    if defined LOG_FILE call :log "Frontend already running" >nul 2>&1
    set "FRONTEND_RUNNING=1"
    goto :open_browser
)

call :setup_frontend_server
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo   ✗ Failed to setup frontend server
    echo   See troubleshooting instructions above
    echo   Press any key to exit...
    pause >nul
    exit /b 1
)

:open_browser
REM ============================================================================
REM Step 8: Open Chrome
REM ============================================================================
echo.
echo [Step 8/10] Opening Chrome browser...
if defined LOG_FILE call :log "Opening Chrome..." >nul 2>&1
echo.

if defined CHROME_MISSING (
    echo   ⚠ Chrome not available - Skipping browser open
    echo   Servers are running - you can manually open: %FRONTEND_URL%
    goto :summary
)

timeout /t 2 /nobreak >nul 2>&1

if defined CHROME_PATH (
    start "" "!CHROME_PATH!" "%FRONTEND_URL%"
    echo   ✓ Chrome opened with %FRONTEND_URL%
) else (
    start "" chrome "%FRONTEND_URL%"
    echo   ✓ Chrome opened with %FRONTEND_URL%
)

if defined LOG_FILE call :log "Chrome opened successfully" >nul 2>&1

:summary
REM ============================================================================
REM Step 9-10: Summary and Keep Running
REM ============================================================================
echo.
echo [Step 9/10] Final Summary
echo ============================================================
echo.
echo   ✓ Backend Server:  %BACKEND_URL%
echo   ✓ Frontend Server: %FRONTEND_URL%
if not defined CHROME_MISSING (
    echo   ✓ Browser:        Chrome opened
) else (
    echo   ⚠ Browser:        Chrome not available (servers running)
)
echo.
echo [Step 10/10] Keeping Servers Running
echo ============================================================
echo.
echo   ✓ Backend and Frontend servers are running in separate windows
echo   ✓ Do NOT close those windows - they keep your servers running
echo.
echo   To stop servers:
echo   1. Close the "Backend Server" window
echo   2. Close the "Frontend Server" window
echo   3. Or press Ctrl+C in each window
echo.
echo   To access the application:
echo   - Frontend: %FRONTEND_URL%
echo   - Backend API: %BACKEND_URL%
echo   - Health Check: %BACKEND_URL%/api/health
echo.
if defined LOG_FILE (
    echo   Log file: %LOG_FILE%
    echo.
)
echo ============================================================
echo   SUCCESS - Everything is running!
echo   Servers will continue running until you close them.
echo ============================================================
echo.
if defined LOG_FILE call :log "Script completed successfully - servers running" >nul 2>&1

REM Keep window open
echo   This window will stay open. Press any key to close it...
echo   (Servers will continue running in their own windows)
pause >nul
exit /b 0

REM ============================================================================
REM Helper Functions
REM ============================================================================

:setup_backend
echo   Setting up backend server (this may take a few minutes on first run)...
if defined LOG_FILE call :log "Setting up backend..." >nul 2>&1

REM Make sure we're in project root (handle spaces in path)
cd /d "%PROJECT_ROOT%" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo   ✗ ERROR: Cannot access project root: %PROJECT_ROOT%
    echo   Check if the path contains special characters or is too long
    exit /b 1
)

REM Verify backend directory exists
if not exist "%BACKEND_DIR%" (
    echo   ✗ ERROR: Backend directory not found: %BACKEND_DIR%
    echo   Make sure you're running from the correct location
    exit /b 1
)

REM Create venv if needed
if not exist "%BACKEND_DIR%\.venv" (
    echo   → Creating Python virtual environment...
    if defined LOG_FILE call :log "Creating venv..." >nul 2>&1
    
    REM Change to backend directory (handle spaces)
    cd /d "%BACKEND_DIR%"
    if %ERRORLEVEL% NEQ 0 (
        echo   ✗ ERROR: Cannot change to backend directory
        exit /b 1
    )
    
    REM Create venv (handle potential errors)
    python -m venv .venv 2>nul
    set "VENV_CREATE_CODE=%ERRORLEVEL%"
    
    if !VENV_CREATE_CODE! NEQ 0 (
        REM Try with full Python path if relative doesn't work
        where python >nul 2>&1
        if %ERRORLEVEL% EQU 0 (
            for /f "delims=" %%P in ('where python') do (
                "%%P" -m venv .venv 2>nul
                set "VENV_CREATE_CODE=!ERRORLEVEL!"
            )
        )
    )
    
    if !VENV_CREATE_CODE! NEQ 0 (
        echo   ✗ Failed to create virtual environment
        if defined LOG_FILE call :log "ERROR: Failed to create venv" >nul 2>&1
        echo.
        echo   STEP-BY-STEP FIX:
        echo   1. Make sure Python is installed correctly
        echo   2. Try manually: cd "%BACKEND_DIR%" ^&^& python -m venv .venv
        echo   3. Check Python PATH in environment variables
        echo   4. Make sure you have write permissions in backend directory
        echo   5. Check if antivirus is blocking file creation
        exit /b 1
    )
    echo   ✓ Virtual environment created
    timeout /t 2 /nobreak >nul 2>&1
)

REM Verify venv structure
if not exist "%BACKEND_DIR%\.venv\Scripts\activate.bat" (
    echo   ✗ Virtual environment activation script not found
    echo   The venv may be corrupted. Try deleting .venv folder and re-running.
    echo.
    echo   STEP-BY-STEP FIX:
    echo   1. Close this script
    echo   2. Delete the folder: %BACKEND_DIR%\.venv
    echo   3. Re-run this script
    exit /b 1
)

REM Activate venv (change to backend directory first)
cd /d "%BACKEND_DIR%"
if %ERRORLEVEL% NEQ 0 (
    echo   ✗ Cannot change to backend directory
    exit /b 1
)

REM Activate venv using absolute path to avoid issues
call "%BACKEND_DIR%\.venv\Scripts\activate.bat" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo   ⚠ WARNING: Failed to activate venv, but continuing with full paths
    echo   Script will use full paths to Python/pip executables instead
    set "VENV_ACTIVATED=0"
) else (
    set "VENV_ACTIVATED=1"
)

REM Verify Python is available in venv
"%BACKEND_DIR%\.venv\Scripts\python.exe" --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo   ✗ Python not found in virtual environment
    echo   Virtual environment may be corrupted
    exit /b 1
)

REM Upgrade pip (use full path to avoid issues)
echo   → Upgrading pip...
if defined LOG_FILE call :log "Upgrading pip..." >nul 2>&1
"%BACKEND_DIR%\.venv\Scripts\python.exe" -m pip install --quiet --upgrade pip setuptools wheel >nul 2>&1

REM Verify requirements.txt exists
if not exist "%BACKEND_DIR%\requirements.txt" (
    echo   ✗ ERROR: requirements.txt not found in %BACKEND_DIR%
    exit /b 1
)

REM Check if dependencies are installed
"%BACKEND_DIR%\.venv\Scripts\pip.exe" show fastapi >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo   → Installing backend dependencies (this may take 2-3 minutes)...
    echo   ⚠ First time setup - downloading and extracting packages...
    echo   ⚠ This may show extraction progress - this is normal
    if defined LOG_FILE call :log "Installing dependencies..." >nul 2>&1
    
    REM Use full path to pip with proper error handling
    echo   → Running pip install (please wait, this may take time)...
    echo   ⚠ Extracting packages... Please wait...
    
    REM Run pip install with output, but continue on errors to capture them
    set "PIP_OUTPUT_FILE=%TEMP%\pip_install_output_%RANDOM%.txt"
    "%BACKEND_DIR%\.venv\Scripts\pip.exe" install --no-cache-dir --disable-pip-version-check -r "%BACKEND_DIR%\requirements.txt" > "%PIP_OUTPUT_FILE%" 2>&1
    set "PIP_EXIT_CODE=%ERRORLEVEL%"
    
    REM Show last few lines of output if there's an error
    if !PIP_EXIT_CODE! NEQ 0 (
        echo.
        echo   ⚠ Pip install encountered errors. Last few lines:
        powershell -Command "Get-Content '%PIP_OUTPUT_FILE%' -Tail 10"
        echo.
    )
    
    REM Clean up temp file
    if exist "%PIP_OUTPUT_FILE%" del "%PIP_OUTPUT_FILE%" >nul 2>&1
    
    if !PIP_EXIT_CODE! NEQ 0 (
        echo   ✗ Failed to install dependencies (exit code: !PIP_EXIT_CODE!)
        if defined LOG_FILE call :log "ERROR: pip install failed with code !PIP_EXIT_CODE!" >nul 2>&1
        echo.
        echo   STEP-BY-STEP FIX:
        echo   ========================================
        echo   1. Check internet connection
        echo   2. Try manually:
        echo      cd %BACKEND_DIR%
        echo      .venv\Scripts\activate
        echo      pip install -r requirements.txt
        echo.
        echo   3. If you see extraction/unzip errors (common causes):
        echo      a) Disk space full - Free up space: dir /s
        echo      b) File permissions - Run as Administrator
        echo      c) Corrupted cache - Try:
        echo         cd %BACKEND_DIR%
        echo         .venv\Scripts\activate
        echo         pip cache purge
        echo         pip install --no-cache-dir -r requirements.txt
        echo      d) Antivirus blocking - Temporarily disable or add exception
        echo.
        echo   4. If specific package fails during extraction:
        echo      - Note which package failed (last line before error)
        echo      - Try installing it separately:
        echo        cd %BACKEND_DIR%
        echo        .venv\Scripts\activate
        echo        pip install <package_name> --verbose --no-cache-dir
        echo.
        echo   5. If venv seems corrupted:
        echo      cd %BACKEND_DIR%
        echo      rmdir /s /q .venv
        echo      python -m venv .venv
        echo      .venv\Scripts\activate
        echo      pip install -r requirements.txt
        echo.
        echo   6. Check if requirements.txt exists: dir "%BACKEND_DIR%\requirements.txt"
        exit /b 1
    )
    echo   ✓ Dependencies installed successfully
) else (
    echo   ✓ Dependencies already installed
)

REM Start backend server (keep window open)
echo   → Starting backend server on port %BACKEND_PORT%...
if defined LOG_FILE call :log "Starting backend server..." >nul 2>&1

REM Verify uvicorn is installed before starting
"%BACKEND_DIR%\.venv\Scripts\pip.exe" show uvicorn >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo   ✗ uvicorn not found in virtual environment
    echo   Installing uvicorn...
    "%BACKEND_DIR%\.venv\Scripts\pip.exe" install uvicorn[standard] >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo   ✗ Failed to install uvicorn
        exit /b 1
    )
)

REM Verify main.py exists before starting
if not exist "%BACKEND_DIR%\app\main.py" (
    echo   ✗ ERROR: app\main.py not found in backend directory
    echo   Make sure the backend structure is correct
    exit /b 1
)

REM Start server with full path to avoid issues
REM Use full path to python.exe directly (no activation needed)
REM Use proper quoting for paths with spaces
start "Backend Server - Whispering Woods" cmd /k "cd /d \"%BACKEND_DIR%\" && echo ============================================================ && echo Backend Server - Whispering Woods && echo Running on port %BACKEND_PORT% && echo Press Ctrl+C to stop && echo ============================================================ && \"%BACKEND_DIR%\.venv\Scripts\python.exe\" -m uvicorn app.main:app --host 0.0.0.0 --port %BACKEND_PORT% --reload"

REM Wait for backend to start
echo   → Waiting for backend to start (up to %SERVER_START_TIMEOUT% seconds)...
set "WAIT_COUNT=0"

:wait_backend_loop
timeout /t 3 /nobreak >nul 2>&1
set /a WAIT_COUNT+=3

powershell -Command "try { $response = Invoke-WebRequest -Uri '%BACKEND_URL%/api/health' -TimeoutSec 3 -UseBasicParsing; exit $response.StatusCode } catch { exit 1 }" >nul 2>&1

if %ERRORLEVEL% EQU 200 (
    echo   ✓ Backend server is now running!
    if defined LOG_FILE call :log "Backend server started successfully" >nul 2>&1
    exit /b 0
)

if !WAIT_COUNT! GEQ %SERVER_START_TIMEOUT% (
    echo   ✗ TIMEOUT - Backend did not start within %SERVER_START_TIMEOUT% seconds
    if defined LOG_FILE call :log "TIMEOUT: Backend did not start" >nul 2>&1
    echo.
    echo   STEP-BY-STEP TROUBLESHOOTING:
    echo   ===============================
    echo   1. Check if port %BACKEND_PORT% is already in use:
    echo      netstat -ano ^| findstr :%BACKEND_PORT%
    echo.
    echo   2. If port is in use, kill the process:
    echo      taskkill /PID <PID_NUMBER> /F
    echo.
    echo   3. Try manually starting the backend:
    echo      cd %BACKEND_DIR%
    echo      .venv\Scripts\activate
    echo      uvicorn app.main:app --port %BACKEND_PORT%
    echo.
    echo   4. Check the backend server window for error messages
    echo   5. Check logs in: %BACKEND_DIR%\logs\
    exit /b 1
)

echo   ⏳ Still waiting... (!WAIT_COUNT!/%SERVER_START_TIMEOUT% seconds)
goto :wait_backend_loop

:setup_frontend_server
echo   Setting up frontend server (this may take a few minutes on first run)...
if defined LOG_FILE call :log "Setting up frontend..." >nul 2>&1

REM Change to frontend directory first
cd /d "%FRONTEND_DIR%"
if %ERRORLEVEL% NEQ 0 (
    echo   ✗ Cannot change to frontend directory: %FRONTEND_DIR%
    exit /b 1
)

REM Check if node_modules exists
if not exist "node_modules" (
    echo   → Installing frontend dependencies (this may take 2-3 minutes)...
    echo   ⚠ First time setup - downloading packages...
    echo   ⚠ This will extract many files - please wait...
    if defined LOG_FILE call :log "Installing npm dependencies..." >nul 2>&1
    
    REM Clear npm cache to avoid corruption issues
    echo   → Clearing npm cache (if needed)...
    call npm cache clean --force >nul 2>&1
    
    REM Install dependencies with error capture
    echo   → Running npm install (please wait, this may take time)...
    echo   ⚠ Extracting packages... Please wait...
    
    REM Capture npm output for debugging
    set "NPM_OUTPUT_FILE=%TEMP%\npm_install_output_%RANDOM%.txt"
    call npm install --loglevel=error > "%NPM_OUTPUT_FILE%" 2>&1
    set "NPM_EXIT_CODE=%ERRORLEVEL%"
    
    REM Show last few lines if error
    if !NPM_EXIT_CODE! NEQ 0 (
        echo.
        echo   ⚠ npm install encountered errors. Last few lines:
        powershell -Command "Get-Content '%NPM_OUTPUT_FILE%' -Tail 10"
        echo.
    )
    
    REM Clean up temp file
    if exist "%NPM_OUTPUT_FILE%" del "%NPM_OUTPUT_FILE%" >nul 2>&1
    
    if !NPM_EXIT_CODE! NEQ 0 (
        echo   ✗ Failed to install npm dependencies (exit code: !NPM_EXIT_CODE!)
        if defined LOG_FILE call :log "ERROR: npm install failed with code !NPM_EXIT_CODE!" >nul 2>&1
        echo.
        echo   STEP-BY-STEP FIX:
        echo   ========================================
        echo   1. Check internet connection
        echo   2. Try manually:
        echo      cd %FRONTEND_DIR%
        echo      npm install
        echo.
        echo   3. If you see extraction errors:
        echo      - Check disk space
        echo      - Delete node_modules folder
        echo      - Try: npm cache clean --force
        echo      - Then: npm install
        echo.
        echo   4. If specific package fails:
        echo      - Note which package failed
        echo      - Try: npm install <package_name> --verbose
        echo.
        exit /b 1
    )
    echo   ✓ Dependencies installed successfully
) else (
    echo   ✓ Dependencies already installed
)

REM Start frontend server (keep window open)
echo   → Starting frontend server on port %FRONTEND_PORT%...
if defined LOG_FILE call :log "Starting frontend server..." >nul 2>&1

REM Verify we can access frontend directory
cd /d "%FRONTEND_DIR%"
if %ERRORLEVEL% NEQ 0 (
    echo   ✗ Cannot change to frontend directory: %FRONTEND_DIR%
    echo   Check if the directory exists
    exit /b 1
)

REM Verify package.json exists
if not exist "package.json" (
    echo   ✗ package.json not found in frontend directory
    exit /b 1
)

REM Start server with explicit path handling
start "Frontend Server - Whispering Woods" cmd /k "cd /d \"%FRONTEND_DIR%\" && echo ============================================================ && echo Frontend Server Running on port %FRONTEND_PORT% && echo Press Ctrl+C to stop && echo ============================================================ && npm start"

REM Wait for frontend to start
echo   → Waiting for frontend to start (up to %SERVER_START_TIMEOUT% seconds)...
set "WAIT_COUNT=0"

:wait_frontend_loop
timeout /t 3 /nobreak >nul 2>&1
set /a WAIT_COUNT+=3

powershell -Command "try { $response = Invoke-WebRequest -Uri '%FRONTEND_URL%' -TimeoutSec 3 -UseBasicParsing; exit $response.StatusCode } catch { exit 1 }" >nul 2>&1

if %ERRORLEVEL% EQU 200 (
    echo   ✓ Frontend server is now running!
    if defined LOG_FILE call :log "Frontend server started successfully" >nul 2>&1
    exit /b 0
)

if !WAIT_COUNT! GEQ %SERVER_START_TIMEOUT% (
    echo   ✗ TIMEOUT - Frontend did not start within %SERVER_START_TIMEOUT% seconds
    if defined LOG_FILE call :log "TIMEOUT: Frontend did not start" >nul 2>&1
    echo.
    echo   STEP-BY-STEP TROUBLESHOOTING:
    echo   ===============================
    echo   1. Check if port %FRONTEND_PORT% is already in use:
    echo      netstat -ano ^| findstr :%FRONTEND_PORT%
    echo.
    echo   2. If port is in use, kill the process:
    echo      taskkill /PID <PID_NUMBER> /F
    echo.
    echo   3. Try manually starting the frontend:
    echo      cd %FRONTEND_DIR%
    echo      npm start
    echo.
    echo   4. Check the frontend server window for error messages
    echo   5. Make sure React Scripts is installed: npm list react-scripts
    exit /b 1
)

echo   ⏳ Still waiting... (!WAIT_COUNT!/%SERVER_START_TIMEOUT% seconds)
goto :wait_frontend_loop

:log
REM Only log if LOG_FILE is defined and directory exists
if not defined LOG_FILE exit /b 0
if not exist "%LOG_DIR%" exit /b 0
echo [%time%] %~1 >> "%LOG_FILE%" 2>nul
exit /b 0
