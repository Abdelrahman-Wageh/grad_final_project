@echo off
REM ============================================================================
REM Android Emulator Test Script - Whispering Woods Development Tools
REM Checks Android SDK tools, installs if missing, lists AVDs, and starts emulator
REM Idempotent: skips install if tools already present
REM ============================================================================

REM Set UTF-8 console encoding for proper character display
chcp 65001 >nul 2>&1

REM ============================================================================
REM Configuration
REM ============================================================================
set "BOOT_TIMEOUT_SECONDS=300"
set "BOOT_CHECK_INTERVAL=5"
set "ANDROID_SDK_PATH=%LOCALAPPDATA%\Android\Sdk"

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
call :log "Android Emulator Test Script Started"
call :log "Time: %date% %time%"
call :log "=========================================="

REM ============================================================================
REM Banner
REM ============================================================================
echo.
echo ============================================================
echo   Android Emulator Test - Whispering Woods Dev Tools
echo   Android SDK tools check and emulator startup
echo   تحقق من أدوات Android SDK وبدء المحاكي
echo ============================================================
echo.

REM ============================================================================
REM Step 1: Check winget availability
REM ============================================================================
echo [Step 1/8] Checking winget availability...
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
REM Step 2: Check ADB (Android Debug Bridge)
REM ============================================================================
echo [Step 2/8] Checking ADB (Android Debug Bridge)...
echo   جاري التحقق من ADB...

call :log "Checking ADB..."

where adb >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   OK - ADB found in PATH
    call :log "ADB found in PATH"
    set "ADB_FOUND=1"
    goto :check_emulator
)

REM Check Android SDK path
if exist "%ANDROID_SDK_PATH%\platform-tools\adb.exe" (
    echo   OK - ADB found in Android SDK
    call :log "ADB found in Android SDK"
    set "ADB_PATH=%ANDROID_SDK_PATH%\platform-tools\adb.exe"
    set "PATH=%PATH%;%ANDROID_SDK_PATH%\platform-tools"
    set "ADB_FOUND=1"
    goto :check_emulator
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
            goto :check_emulator
        )
        
        REM Check common install location
        if exist "%ANDROID_SDK_PATH%\platform-tools\adb.exe" (
            set "PATH=%PATH%;%ANDROID_SDK_PATH%\platform-tools"
            set "ADB_FOUND=1"
            echo   OK - ADB found after installation
            goto :check_emulator
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
goto :check_emulator

:check_emulator
REM ============================================================================
REM Step 3: Check Emulator
REM ============================================================================
echo.
echo [Step 3/8] Checking Android Emulator...
echo   جاري التحقق من محاكي Android...

call :log "Checking emulator..."

where emulator >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   OK - Emulator found in PATH
    call :log "Emulator found in PATH"
    set "EMULATOR_FOUND=1"
    goto :check_avdmanager
)

REM Check Android SDK path
if exist "%ANDROID_SDK_PATH%\emulator\emulator.exe" (
    echo   OK - Emulator found in Android SDK
    call :log "Emulator found in Android SDK"
    set "EMULATOR_PATH=%ANDROID_SDK_PATH%\emulator\emulator.exe"
    set "PATH=%PATH%;%ANDROID_SDK_PATH%\emulator"
    set "EMULATOR_FOUND=1"
    goto :check_avdmanager
)

REM Emulator not found - attempt installation
echo   Emulator not found - Android Studio required...
echo   المحاكي غير موجود - يتطلب Android Studio...

if "%HAVE_WINGET%"=="1" (
    echo   Installing Android Studio via winget (this may open installer GUI)...
    echo   جاري تثبيت Android Studio (قد يفتح نافذة التثبيت)...
    echo   WARNING: This may require manual interaction!
    echo   تحذير: قد يتطلب تفاعلاً يدوياً!
    call :log "Installing Android Studio..."
    
    winget install --id=Google.AndroidStudio -e --accept-package-agreements --accept-source-agreements >nul 2>&1
    
    if %ERRORLEVEL% EQU 0 (
        echo   Installation initiated - waiting...
        call :log "Android Studio installation initiated"
        timeout /t 5 /nobreak >nul 2>&1
        
        REM Check if emulator is now available
        if exist "%ANDROID_SDK_PATH%\emulator\emulator.exe" (
            set "PATH=%PATH%;%ANDROID_SDK_PATH%\emulator"
            set "EMULATOR_FOUND=1"
            echo   OK - Emulator found after installation
            goto :check_avdmanager
        ) else (
            echo   NOTE: Android Studio installation may take time.
            echo   After installation completes, you may need to:
            echo   1. Open Android Studio
            echo   2. Complete the setup wizard
            echo   3. Install Android SDK components
            echo   4. Re-run this script
            call :log "Android Studio installation in progress"
        )
    )
)

REM Emulator still not found
if not defined EMULATOR_FOUND (
    echo.
    echo   ============================================================
    echo   WARNING - Emulator not found
    echo   تحذير - المحاكي غير موجود
    echo   ============================================================
    echo.
    echo   Please install Android Studio manually:
    echo   يرجى تثبيت Android Studio يدوياً:
    echo   1. Visit: https://developer.android.com/studio
    echo   2. Download and install Android Studio
    echo   3. Complete the setup wizard
    echo   4. Re-run this script
    echo.
    call :log "Emulator not found"
    set "EMULATOR_MISSING=1"
)

:check_avdmanager
REM ============================================================================
REM Step 4: Check AVD Manager
REM ============================================================================
echo.
echo [Step 4/8] Checking AVD Manager...
echo   جاري التحقق من AVD Manager...

call :log "Checking avdmanager..."

where avdmanager >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   OK - AVD Manager found
    call :log "AVD Manager found in PATH"
    set "AVDMANAGER_FOUND=1"
    goto :list_avds
)

REM Check Android SDK path
if exist "%ANDROID_SDK_PATH%\cmdline-tools\latest\bin\avdmanager.bat" (
    echo   OK - AVD Manager found in Android SDK
    call :log "AVD Manager found in Android SDK"
    set "AVDMANAGER_PATH=%ANDROID_SDK_PATH%\cmdline-tools\latest\bin\avdmanager.bat"
    set "AVDMANAGER_FOUND=1"
    goto :list_avds
)

if exist "%ANDROID_SDK_PATH%\tools\bin\avdmanager.bat" (
    echo   OK - AVD Manager found (legacy location)
    call :log "AVD Manager found in legacy location"
    set "AVDMANAGER_PATH=%ANDROID_SDK_PATH%\tools\bin\avdmanager.bat"
    set "AVDMANAGER_FOUND=1"
    goto :list_avds
)

echo   WARNING - AVD Manager not found (will try to list AVDs anyway)
echo   تحذير - AVD Manager غير موجود
call :log "AVD Manager not found"
set "AVDMANAGER_MISSING=1"

:list_avds
REM ============================================================================
REM Step 5: List Available AVDs
REM ============================================================================
echo.
echo [Step 5/8] Listing available AVDs...
echo   جاري عرض المحاكيات المتاحة...

call :log "Listing AVDs..."

REM Try to list AVDs using emulator command
if defined EMULATOR_PATH (
    "%EMULATOR_PATH%" -list-avds > "%TEMP%\avd_list.txt" 2>&1
) else (
    emulator -list-avds > "%TEMP%\avd_list.txt" 2>&1
)

if %ERRORLEVEL% EQU 0 (
    call :log "AVD list command executed successfully"
    
    REM Check if file has content
    for %%F in ("%TEMP%\avd_list.txt") do set "AVD_FILE_SIZE=%%~zF"
    
    if !AVD_FILE_SIZE! GTR 0 (
        echo   Available AVDs:
        echo   المحاكيات المتاحة:
        type "%TEMP%\avd_list.txt"
        call :log "AVDs listed successfully"
        
        REM Read first AVD name
        set "FIRST_AVD="
        for /f "usebackq delims=" %%A in ("%TEMP%\avd_list.txt") do (
            if not defined FIRST_AVD (
                set "FIRST_AVD=%%A"
                goto :avd_found
            )
        )
        
        :avd_found
        if defined FIRST_AVD (
            echo   Using first AVD: !FIRST_AVD!
            call :log "Selected AVD: !FIRST_AVD!"
            goto :start_emulator
        )
    )
)

REM No AVDs found
echo   WARNING - No AVDs found
echo   تحذير - لا توجد محاكيات
echo.
echo   ============================================================
echo   NO AVD FOUND
echo   لا توجد محاكيات متاحة
echo   ============================================================
echo.
echo   You need to create an AVD (Android Virtual Device):
echo   تحتاج إلى إنشاء محاكي Android:
echo.
echo   Option 1 - Using Android Studio:
echo   1. Open Android Studio
echo   2. Tools ^> AVD Manager
echo   3. Create Virtual Device
echo   4. Select a device (e.g., Pixel 4)
echo   5. Select a system image (e.g., API 31)
echo   6. Finish setup
echo.
echo   Option 2 - Using Command Line (if avdmanager is available):
echo   avdmanager create avd -n whisper_avd -k "system-images;android-31;google_apis;x86_64"
echo.
echo   After creating an AVD, re-run this script.
echo   بعد إنشاء محاكي، أعد تشغيل هذا السكريبت.
echo.
call :log "No AVDs found"
set "NO_AVD=1"
goto :summary

:start_emulator
REM ============================================================================
REM Step 6: Start Emulator
REM ============================================================================
echo.
echo [Step 6/8] Starting emulator...
echo   جاري بدء المحاكي...

call :log "Starting emulator: !FIRST_AVD!"

REM Check if emulator is already running
if defined ADB_PATH (
    "%ADB_PATH%" devices > "%TEMP%\adb_devices.txt" 2>&1
) else (
    adb devices > "%TEMP%\adb_devices.txt" 2>&1
)

findstr /C:"emulator" "%TEMP%\adb_devices.txt" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   NOTE - An emulator may already be running
    echo   ملاحظة - قد يكون المحاكي يعمل بالفعل
    call :log "Emulator may already be running"
)

REM Start emulator in background
echo   Launching emulator: !FIRST_AVD!
echo   جاري تشغيل المحاكي...

if defined EMULATOR_PATH (
    start "" "%EMULATOR_PATH%" -avd !FIRST_AVD! -netdelay none -netspeed full >nul 2>&1
) else (
    start "" emulator -avd !FIRST_AVD! -netdelay none -netspeed full >nul 2>&1
)

call :log "Emulator start command executed"

REM Wait a moment for emulator to begin starting
echo   Waiting for emulator to boot (this may take %BOOT_TIMEOUT_SECONDS% seconds)...
echo   جاري انتظار بدء المحاكي (قد يستغرق %BOOT_TIMEOUT_SECONDS% ثانية)...
timeout /t 10 /nobreak >nul 2>&1

REM ============================================================================
REM Step 7: Wait for Boot
REM ============================================================================
echo.
echo [Step 7/8] Waiting for emulator to boot...
echo   جاري انتظار اكتمال بدء المحاكي...

set "BOOT_COMPLETE=0"
set "ELAPSED_TIME=0"

:boot_loop
REM Check boot status
if defined ADB_PATH (
    "%ADB_PATH%" shell getprop sys.boot_completed > "%TEMP%\boot_status.txt" 2>&1
) else (
    adb shell getprop sys.boot_completed > "%TEMP%\boot_status.txt" 2>&1
)

findstr /C:"1" "%TEMP%\boot_status.txt" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set "BOOT_COMPLETE=1"
    echo   OK - Emulator booted successfully!
    echo   OK - اكتمل بدء المحاكي بنجاح!
    call :log "Emulator boot completed"
    goto :verify_device
)

REM Check timeout
set /a ELAPSED_TIME+=!BOOT_CHECK_INTERVAL!
if !ELAPSED_TIME! GEQ %BOOT_TIMEOUT_SECONDS% (
    echo   TIMEOUT - Emulator did not boot within %BOOT_TIMEOUT_SECONDS% seconds
    echo   انتهى الوقت - لم يكتمل بدء المحاكي خلال %BOOT_TIMEOUT_SECONDS% ثانية
    call :log "Boot timeout exceeded"
    goto :boot_timeout
)

REM Show progress
echo   Still booting... (!ELAPSED_TIME!/%BOOT_TIMEOUT_SECONDS% seconds)
echo   ما زال يبدأ... (!ELAPSED_TIME!/%BOOT_TIMEOUT_SECONDS% ثانية)
timeout /t %BOOT_CHECK_INTERVAL% /nobreak >nul 2>&1
goto :boot_loop

:boot_timeout
echo.
echo   ============================================================
echo   BOOT TIMEOUT
echo   انتهى وقت الانتظار
echo   ============================================================
echo.
echo   The emulator may still be starting. Check manually:
echo   قد يكون المحاكي ما زال يبدأ. تحقق يدوياً:
echo   adb devices
echo.
echo   Or try:
echo   أو جرب:
echo   1. Close and restart the emulator
echo   2. Try a different AVD
echo   3. Increase BOOT_TIMEOUT_SECONDS in the script
echo.
call :log "Boot timeout"
set "BOOT_TIMEOUT=1"
goto :summary

:verify_device
REM ============================================================================
REM Step 8: Verify Device Info
REM ============================================================================
echo.
echo [Step 8/8] Verifying device information...
echo   جاري التحقق من معلومات الجهاز...

REM Get device model
if defined ADB_PATH (
    "%ADB_PATH%" shell getprop ro.product.model > "%TEMP%\device_model.txt" 2>&1
    "%ADB_PATH%" shell getprop ro.build.version.release > "%TEMP%\device_version.txt" 2>&1
) else (
    adb shell getprop ro.product.model > "%TEMP%\device_model.txt" 2>&1
    adb shell getprop ro.build.version.release > "%TEMP%\device_version.txt" 2>&1
)

set /p DEVICE_MODEL=< "%TEMP%\device_model.txt"
set /p DEVICE_VERSION=< "%TEMP%\device_version.txt"

echo   Device Model: !DEVICE_MODEL!
echo   Android Version: !DEVICE_VERSION!
call :log "Device verified - Model: !DEVICE_MODEL!, Version: !DEVICE_VERSION!"

REM List all devices
echo.
echo   All connected devices:
echo   جميع الأجهزة المتصلة:
if defined ADB_PATH (
    "%ADB_PATH%" devices
) else (
    adb devices
)

:summary
REM ============================================================================
REM Final Summary
REM ============================================================================
echo.
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

if defined EMULATOR_MISSING (
    echo   Emulator: NOT FOUND
) else (
    echo   Emulator: OK
)

if defined NO_AVD (
    echo   AVD: NOT FOUND (create one in Android Studio)
) else if defined BOOT_COMPLETE (
    echo   AVD: RUNNING (!FIRST_AVD!)
) else if defined BOOT_TIMEOUT (
    echo   AVD: TIMEOUT (may still be booting)
) else (
    echo   AVD: FOUND (!FIRST_AVD!)
)

echo.
echo   Log file: %LOG_FILE%
echo   ملف السجل: %LOG_FILE%
echo.

if defined BOOT_COMPLETE (
    echo   ============================================================
    echo   SUCCESS - Emulator is ready!
    echo   نجاح - المحاكي جاهز!
    echo   ============================================================
    echo.
    echo   You can now run Flutter apps on the emulator:
    echo   يمكنك الآن تشغيل تطبيقات Flutter على المحاكي:
    echo   flutter run
    echo.
    call :log "Script completed successfully - Emulator ready"
    exit /b 0
) else (
    echo   ============================================================
    echo   PARTIAL SUCCESS - Some steps need attention
    echo   نجاح جزئي - بعض الخطوات تحتاج إلى اهتمام
    echo   ============================================================
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

