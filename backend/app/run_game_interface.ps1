# PowerShell Script to Run Game Interface
# Run this script after installing Flutter

Write-Host "🎮 Whispering Woods - Game Interface Launcher" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is installed
Write-Host "Checking Flutter installation..." -ForegroundColor Yellow
try {
    $flutterVersion = flutter --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Flutter is installed!" -ForegroundColor Green
        Write-Host $flutterVersion[0] -ForegroundColor Gray
    } else {
        throw "Flutter not found"
    }
} catch {
    Write-Host "❌ Flutter is NOT installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Flutter first:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor White
    Write-Host "2. Extract to C:\src\flutter" -ForegroundColor White
    Write-Host "3. Add C:\src\flutter\bin to PATH" -ForegroundColor White
    Write-Host "4. Restart terminal and run this script again" -ForegroundColor White
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Checking if backend is running..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://127.0.0.1:8000/docs" -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop
    Write-Host "✅ Backend is running!" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Backend is NOT running!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please start the backend in another terminal:" -ForegroundColor Yellow
    Write-Host "  cd backend\app" -ForegroundColor White
    Write-Host "  python main.py" -ForegroundColor White
    Write-Host ""
    $startBackend = Read-Host "Do you want to start it now? (y/n)"
    if ($startBackend -eq "y") {
        Write-Host "Starting backend..." -ForegroundColor Yellow
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot\..\backend\app'; python main.py"
        Write-Host "Waiting 5 seconds for backend to start..." -ForegroundColor Yellow
        Start-Sleep -Seconds 5
    }
}

Write-Host ""
Write-Host "Navigating to mobile app..." -ForegroundColor Yellow
$mobileAppPath = Join-Path $PSScriptRoot "..\mobile_app"
if (-not (Test-Path $mobileAppPath)) {
    Write-Host "❌ mobile_app directory not found!" -ForegroundColor Red
    Write-Host "Expected path: $mobileAppPath" -ForegroundColor Gray
    Read-Host "Press Enter to exit"
    exit 1
}

Set-Location $mobileAppPath
Write-Host "✅ In mobile_app directory" -ForegroundColor Green

Write-Host ""
Write-Host "Checking dependencies..." -ForegroundColor Yellow
if (-not (Test-Path "pubspec.lock")) {
    Write-Host "Installing dependencies (this may take a few minutes)..." -ForegroundColor Yellow
    flutter pub get
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install dependencies!" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
} else {
    Write-Host "✅ Dependencies already installed" -ForegroundColor Green
}

Write-Host ""
Write-Host "Checking available devices..." -ForegroundColor Yellow
flutter devices

Write-Host ""
Write-Host "🚀 Starting game interface..." -ForegroundColor Cyan
Write-Host "This will open in Chrome browser..." -ForegroundColor Gray
Write-Host ""
Write-Host "Press Ctrl+C to stop the app" -ForegroundColor Yellow
Write-Host ""

# Run Flutter
flutter run -d chrome


