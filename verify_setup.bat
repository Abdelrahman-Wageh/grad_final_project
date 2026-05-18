@echo off
echo ========================================
echo Verifying Whispering Woods Setup
echo ========================================
echo.

set "ERRORS=0"

echo [1/8] Checking directory structure...
if exist "backend" (
    echo   ✓ backend directory found
) else (
    echo   ✗ backend directory NOT found
    set /a ERRORS+=1
)

if exist "mobile_app" (
    echo   ✓ mobile_app directory found
) else (
    echo   ✗ mobile_app directory NOT found
    set /a ERRORS+=1
)

echo.
echo [2/8] Checking backend files...
if exist "backend\app\main.py" (
    echo   ✓ backend\app\main.py found
) else (
    echo   ✗ backend\app\main.py NOT found
    set /a ERRORS+=1
)

if exist "backend\app\config.py" (
    echo   ✓ backend\app\config.py found
) else (
    echo   ✗ backend\app\config.py NOT found
    set /a ERRORS+=1
)

if exist "backend\requirements.txt" (
    echo   ✓ backend\requirements.txt found
) else (
    echo   ✗ backend\requirements.txt NOT found
    set /a ERRORS+=1
)

echo.
echo [3/8] Checking Flutter files...
if exist "mobile_app\pubspec.yaml" (
    echo   ✓ mobile_app\pubspec.yaml found
) else (
    echo   ✗ mobile_app\pubspec.yaml NOT found
    set /a ERRORS+=1
)

if exist "mobile_app\lib\main.dart" (
    echo   ✓ mobile_app\lib\main.dart found
) else (
    echo   ✗ mobile_app\lib\main.dart NOT found
    set /a ERRORS+=1
)

echo.
echo [4/8] Checking asset directories...
if exist "mobile_app\assets\images" (
    echo   ✓ assets\images directory found
) else (
    echo   ✗ assets\images directory NOT found
    set /a ERRORS+=1
)

if exist "mobile_app\assets\animations" (
    echo   ✓ assets\animations directory found
) else (
    echo   ✗ assets\animations directory NOT found
    set /a ERRORS+=1
)

if exist "mobile_app\assets\sounds" (
    echo   ✓ assets\sounds directory found
) else (
    echo   ✗ assets\sounds directory NOT found
    set /a ERRORS+=1
)

if exist "mobile_app\assets\voices" (
    echo   ✓ assets\voices directory found
) else (
    echo   ✗ assets\voices directory NOT found
    set /a ERRORS+=1
)

echo.
echo [5/8] Checking conda...
conda --version >nul 2>&1
if errorlevel 1 (
    echo   ✗ Conda NOT found in PATH
    set /a ERRORS+=1
) else (
    echo   ✓ Conda found
    conda --version
)

echo.
echo [6/8] Checking conda environment ai_env...
conda env list | findstr "ai_env" >nul
if errorlevel 1 (
    echo   ✗ Conda environment 'ai_env' NOT found
    echo   Create it with: conda create -n ai_env python=3.9
    set /a ERRORS+=1
) else (
    echo   ✓ Conda environment 'ai_env' found
)

echo.
echo [7/8] Checking Flutter...
flutter --version >nul 2>&1
if errorlevel 1 (
    echo   ✗ Flutter NOT found in PATH
    set /a ERRORS+=1
) else (
    echo   ✓ Flutter found
    flutter --version | findstr "Flutter"
)

echo.
echo [8/8] Checking ports...
netstat -an | findstr ":8000" >nul
if errorlevel 1 (
    echo   ✓ Port 8000 is available
) else (
    echo   ⚠ Port 8000 is already in use
    echo   Close any running servers on port 8000
)

netstat -an | findstr ":3000" >nul
if errorlevel 1 (
    echo   ✓ Port 3000 is available
) else (
    echo   ⚠ Port 3000 is already in use
    echo   Close any running servers on port 3000
)

echo.
echo ========================================
if %ERRORS%==0 (
    echo ✓ ALL CHECKS PASSED!
    echo You're ready to run START_HERE.bat
) else (
    echo ✗ Found %ERRORS% error^(s^)
    echo Please fix the issues above before starting
)
echo ========================================
echo.
pause
