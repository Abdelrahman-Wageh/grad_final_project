@echo off
REM ============================================================================
REM Android USB Device Test Script - Whispering Woods Development Tools
REM Checks ADB, detects USB-connected Android devices, shows device info
REM Idempotent: skips install if tools already present
REM ============================================================================

REM Set UTF-8 console encoding for proper character display
chcp 65001 >nul 2>&1

REM ============================================================================
REM Initialize Logging
REM ============================================================================
set "SCRIPT_NAME=%~n0"
set "LOG_DIR=%~dp0logs"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
set "LOG_FILE=%LOG_DIR%\%SCRIPT_NAME%_%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log"
set "LOG_FILE=%LOG_FILE: =0%"

REM Enable delayed expansion for variables in loops
setlocal enabledelayedexpansion

REM Function to log output
call :log "=========================================="
call :log "Android USB Test Script Started"
call :log "Time: %date% %time%"
call :log "=========================================="

REM ============================================================================
REM Banner
REM ============================================================================
echo.
echo ============================================================
echo   Android USB Device Test - Whispering Woods Dev Tools
echo   USB Android device detection and verification
echo   اكتشاف وتأكيد أجهزة Android المتصلة عبر USB
echo ============================================================
echo.

REM ============================================================================
REM Step 1: Check winget availability
REM ============================================================================
echo [Step 1/7] Checking winget availability...
echo   جاري التحقق من وجود winget...
call :log "Checking winget..."

where winget >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set "HAVE_WINGET=1"
    echo   OK - winget found
    call :log "winget found"
) else (
    set "HAVE_WINGET=0"
    echo   WARNING - winget not found (optional - manual install available)
    echo   Install winget: https://aka.ms/getwinget
    echo   تحذير: winget غير موجود (اختياري - يمكن التثبيت يدوياً)
    call :log "winget not found"
)
echo.

REM ============================================================================
REM Step 2: Check ADB
REM ============================================================================
echo [Step 2/7] Checking ADB (Android Debug Bridge)...
echo   جاري التحقق من ADB...

call :log "Checking ADB..."

where adb >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   OK - ADB found in PATH
    call :log "ADB found in PATH"
    set "ADB_FOUND=1"
    goto :check_devices
)

REM Check Android SDK path
set "ANDROID_SDK_PATH=%LOCALAPPDATA%\Android\Sdk"
if exist "%ANDROID_SDK_PATH%\platform-tools\adb.exe" (
    echo   OK - ADB found in Android SDK
    call :log "ADB found in Android SDK"
    set "ADB_PATH=%ANDROID_SDK_PATH%\platform-tools\adb.exe"
    set "PATH=%PATH%;%ANDROID_SDK_PATH%\platform-tools"
    set "ADB_FOUND=1"
    goto :check_devices
)

REM ADB not found - attempt installation
echo   ADB not found - attempting installation...
echo   ADB غير موجود - جاري محاولة التثبيت...

if "%HAVE_WINGET%"=="1" (
    echo   Installing Android Platform Tools via winget...
    echo   جاري تثبيت أدوات Android Platform...
    call :log "Installing Android Platform Tools..."
    
    winget install --id=Google.PlatformTools -e --accept-package-agreements --accept-source-agreements --silent >nul 2>&1
    
    if %ERRORLEVEL% EQU 0 (
        echo   Installation completed - verifying...
        call :log "Platform Tools installation completed"
        timeout /t 3 /nobreak >nul 2>&1
        
        REM Re-check ADB
        where adb >nul 2>&1
        if %ERRORLEVEL% EQU 0 (
            echo   OK - ADB installed successfully
            call :log "ADB verified after installation"
            set "ADB_FOUND=1"
            goto :check_devices
        )
        
        REM Check common install location
        if exist "%ANDROID_SDK_PATH%\platform-tools\adb.exe" (
            set "PATH=%PATH%;%ANDROID_SDK_PATH%\platform-tools"
            set "ADB_FOUND=1"
            echo   OK - ADB found after installation
            goto :check_devices
        )
    ) else (
        echo   WARNING - winget install failed
        call :log "winget install failed with error %ERRORLEVEL%"
    )
)

REM ADB still not found
echo.
echo   ============================================================
echo   FAILED - ADB not found
echo   فشل - ADB غير موجود
echo   ============================================================
echo.
echo   Please install Android Platform Tools manually:
echo   يرجى تثبيت أدوات Android Platform يدوياً:
echo   1. Visit: https://developer.android.com/studio/releases/platform-tools
echo   2. Download and extract to a folder (e.g., C:\platform-tools)
echo   3. Add that folder to your PATH environment variable
echo   4. Re-run this script
echo.
call :log "ADB installation failed"
set "ADB_MISSING=1"
goto :check_devices

:check_devices
REM ============================================================================
REM Step 3: Check for USB Devices
REM ============================================================================
echo.
echo [Step 3/7] Checking for USB-connected Android devices...
echo   جاري التحقق من أجهزة Android المتصلة عبر USB...

call :log "Checking USB devices..."

REM Restart ADB server to ensure fresh connection
echo   Restarting ADB server...
echo   جاري إعادة تشغيل خادم ADB...
if defined ADB_PATH (
    "%ADB_PATH%" kill-server >nul 2>&1
    timeout /t 1 /nobreak >nul 2>&1
    "%ADB_PATH%" start-server >nul 2>&1
) else (
    adb kill-server >nul 2>&1
    timeout /t 1 /nobreak >nul 2>&1
    adb start-server >nul 2>&1
)

timeout /t 2 /nobreak >nul 2>&1

REM List devices
if defined ADB_PATH (
    "%ADB_PATH%" devices > "%TEMP%\adb_devices.txt" 2>&1
) else (
    adb devices > "%TEMP%\adb_devices.txt" 2>&1
)

call :log "ADB devices command executed"

REM Check for devices (excluding emulator and header line)
set "DEVICE_COUNT=0"
for /f "skip=1 tokens=1" %%A in ('type "%TEMP%\adb_devices.txt"') do (
    if not "%%A"=="List" if not "%%A"=="" (
        set /a DEVICE_COUNT+=1
    )
)

if !DEVICE_COUNT! EQU 0 (
    echo   WARNING - No USB devices found
    echo   تحذير - لم يتم العثور على أجهزة USB
    call :log "No USB devices detected"
    goto :troubleshoot_no_device
) else (
    echo   OK - Found !DEVICE_COUNT! device(s)
    echo   OK - تم العثور على !DEVICE_COUNT! جهاز
    echo.
    echo   Connected devices:
    echo   الأجهزة المتصلة:
    type "%TEMP%\adb_devices.txt"
    call :log "Devices found: !DEVICE_COUNT!"
    goto :get_device_info
)

:troubleshoot_no_device
REM ============================================================================
REM Step 4: Troubleshooting (No Device)
REM ============================================================================
echo.
echo [Step 4/7] Troubleshooting - No device found...
echo   جاري استكشاف الأخطاء - لم يتم العثور على جهاز...
echo.
echo   ============================================================
echo   NO USB DEVICE FOUND
echo   لم يتم العثور على جهاز USB
echo   ============================================================
echo.
echo   Please try these steps:
echo   يرجى تجربة هذه الخطوات:
echo.
echo   1. Enable USB Debugging on your Android device:
echo      Settings ^> About Phone ^> Tap "Build Number" 7 times
echo      Then: Settings ^> Developer Options ^> Enable "USB Debugging"
echo.
echo   2. Connect your device via USB cable
echo      Make sure USB cable supports data transfer (not charge-only)
echo.
echo   3. Accept the USB debugging authorization prompt on your device
echo      (A dialog should appear on your phone/tablet)
echo.
echo   4. Check Windows Device Manager:
echo      - Press Win+X, select "Device Manager"
echo      - Look for "Android" or "ADB" entries
echo      - If device shows with yellow warning, install OEM USB drivers
echo.
echo   5. Install OEM USB drivers if needed:
echo      - Samsung: https://developer.samsung.com/mobile/android-usb-driver.html
echo      - Google: https://developer.android.com/studio/run/oem-usb
echo      - Generic: https://adb.clockworkmod.com/
echo.
echo   6. Try restarting ADB server:
echo      adb kill-server
echo      adb start-server
echo      adb devices
echo.
echo   After trying these steps, re-run this script.
echo   بعد تجربة هذه الخطوات، أعد تشغيل هذا السكريبت.
echo.
call :log "No USB devices - troubleshooting shown"
set "NO_DEVICE=1"
goto :check_flutter

:get_device_info
REM ============================================================================
REM Step 5: Get Device Information
REM ============================================================================
echo.
echo [Step 5/7] Getting device information...
echo   جاري الحصول على معلومات الجهاز...

REM Get first device ID (skip header, get first line with device ID)
set "DEVICE_ID="
for /f "skip=1 tokens=1" %%A in ('type "%TEMP%\adb_devices.txt"') do (
    if not "%%A"=="List" if not "%%A"=="" if not defined DEVICE_ID (
        set "DEVICE_ID=%%A"
        goto :device_info_loop
    )
)

:device_info_loop
if not defined DEVICE_ID (
    echo   WARNING - Could not extract device ID
    call :log "Could not extract device ID"
    goto :check_flutter
)

echo   Using device: !DEVICE_ID!
call :log "Using device ID: !DEVICE_ID!"

REM Get device model
if defined ADB_PATH (
    "%ADB_PATH%" -s !DEVICE_ID! shell getprop ro.product.model > "%TEMP%\device_model.txt" 2>&1
    "%ADB_PATH%" -s !DEVICE_ID! shell getprop ro.build.version.release > "%TEMP%\device_version.txt" 2>&1
    "%ADB_PATH%" -s !DEVICE_ID! shell getprop ro.product.manufacturer > "%TEMP%\device_manufacturer.txt" 2>&1
) else (
    adb -s !DEVICE_ID! shell getprop ro.product.model > "%TEMP%\device_model.txt" 2>&1
    adb -s !DEVICE_ID! shell getprop ro.build.version.release > "%TEMP%\device_version.txt" 2>&1
    adb -s !DEVICE_ID! shell getprop ro.product.manufacturer > "%TEMP%\device_manufacturer.txt" 2>&1
)

set /p DEVICE_MODEL=< "%TEMP%\device_model.txt"
set /p DEVICE_VERSION=< "%TEMP%\device_version.txt"
set /p DEVICE_MANUFACTURER=< "%TEMP%\device_manufacturer.txt"

echo.
echo   Device Information:
echo   معلومات الجهاز:
echo   ============================================================
echo   Device ID: !DEVICE_ID!
echo   Manufacturer: !DEVICE_MANUFACTURER!
echo   Model: !DEVICE_MODEL!
echo   Android Version: !DEVICE_VERSION!
echo   ============================================================
echo.

call :log "Device info - Model: !DEVICE_MODEL!, Version: !DEVICE_VERSION!, Manufacturer: !DEVICE_MANUFACTURER!"

REM Optional: Show installed packages count (smoke test)
echo   Running smoke tests...
echo   جاري تشغيل اختبارات التحقق...
if defined ADB_PATH (
    "%ADB_PATH%" -s !DEVICE_ID! shell pm list packages | find /c "package:" > "%TEMP%\package_count.txt" 2>&1
) else (
    adb -s !DEVICE_ID! shell pm list packages | find /c "package:" > "%TEMP%\package_count.txt" 2>&1
)

set /p PACKAGE_COUNT=< "%TEMP%\package_count.txt"
echo   Installed packages: !PACKAGE_COUNT!
echo   الحزم المثبتة: !PACKAGE_COUNT!
call :log "Package count: !PACKAGE_COUNT!"

:check_flutter
REM ============================================================================
REM Step 6: Check Flutter Integration
REM ============================================================================
echo.
echo [Step 6/7] Checking Flutter integration...
echo   جاري التحقق من تكامل Flutter...

call :log "Checking Flutter..."

where flutter >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   OK - Flutter found
    call :log "Flutter found in PATH"
    
    REM Run flutter devices
    echo   Checking Flutter devices...
    echo   جاري التحقق من أجهزة Flutter...
    echo.
    flutter devices
    echo.
    call :log "Flutter devices listed"
    
    REM Check Android licenses
    echo   NOTE: If you see license errors, run:
    echo   ملاحظة: إذا رأيت أخطاء في الترخيص، قم بتشغيل:
    echo   flutter doctor --android-licenses
    echo.
    call :log "Flutter integration check completed"
) else (
    echo   WARNING - Flutter not found in PATH
    echo   تحذير - Flutter غير موجود
    echo.
    echo   To install Flutter:
    echo   لتثبيت Flutter:
    echo   1. Visit: https://docs.flutter.dev/get-started/install/windows
    echo   2. Download and extract Flutter SDK
    echo   3. Add Flutter bin directory to PATH
    echo   4. Run: flutter doctor
    echo.
    call :log "Flutter not found"
    set "FLUTTER_MISSING=1"
)

:summary
REM ============================================================================
REM Step 7: Final Summary and Next Steps
REM ============================================================================
echo.
echo [Step 7/7] Summary and Next Steps
echo   ============================================================
echo   SUMMARY
echo   الملخص
echo   ============================================================
echo.
if defined ADB_MISSING (
    echo   ADB: NOT FOUND
) else (
    echo   ADB: OK
)

if defined NO_DEVICE (
    echo   USB Device: NOT FOUND
    echo   (See troubleshooting steps above)
) else if defined DEVICE_ID (
    echo   USB Device: FOUND (!DEVICE_MODEL!)
    echo   Device ID: !DEVICE_ID!
) else (
    echo   USB Device: CHECK FAILED
)

if defined FLUTTER_MISSING (
    echo   Flutter: NOT FOUND
) else (
    echo   Flutter: OK
)

echo.
echo   Log file: %LOG_FILE%
echo   ملف السجل: %LOG_FILE%
echo.

if defined DEVICE_ID (
    echo   ============================================================
    echo   SUCCESS - USB Device is ready!
    echo   نجاح - جهاز USB جاهز!
    echo   ============================================================
    echo.
    echo   You can now run Flutter apps on your device:
    echo   يمكنك الآن تشغيل تطبيقات Flutter على جهازك:
    echo.
    echo   Option 1 - Run on specific device:
    echo   flutter run -d !DEVICE_ID!
    echo.
    echo   Option 2 - Let Flutter choose:
    echo   flutter run
    echo.
    echo   To re-run this test:
    echo   لإعادة تشغيل الاختبار:
    echo   %~f0
    echo.
    call :log "Script completed successfully - Device ready"
    exit /b 0
) else (
    echo   ============================================================
    echo   PARTIAL SUCCESS - Some steps need attention
    echo   نجاح جزئي - بعض الخطوات تحتاج إلى اهتمام
    echo   ============================================================
    echo.
    echo   Please follow the troubleshooting steps above.
    echo   يرجى اتباع خطوات استكشاف الأخطاء أعلاه.
    echo.
    call :log "Script completed with warnings"
    exit /b 0
)

REM ============================================================================
REM Helper Functions
REM ============================================================================

:log
REM Append to log file with timestamp
echo [%time%] %~1 >> "%LOG_FILE%" 2>&1
exit /b

