# Environment Detection Script for Whispering Woods
# Collects system information and writes to detect_env.json

param(
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Continue"
$OutputPath = Join-Path $PSScriptRoot "detect_env.json"
$LogPath = Join-Path $PSScriptRoot "logs\detect_env_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# Ensure logs directory exists
$LogDir = Split-Path $LogPath
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

function Write-Log {
    param($Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$Timestamp - $Message" | Out-File -FilePath $LogPath -Append
    Write-Host $Message
}

function Get-CommandVersion {
    param($CommandName)
    try {
        $version = & $CommandName --version 2>&1 | Select-Object -First 1
        return $version.ToString().Trim()
    } catch {
        return $null
    }
}

Write-Log "=========================================="
Write-Log "Environment Detection Started"
Write-Log "=========================================="

$envInfo = @{
    timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    os = @{
        name = $PSVersionTable.OS
        version = [System.Environment]::OSVersion.Version.ToString()
        platform = $PSVersionTable.Platform
        architecture = if ([System.Environment]::Is64BitOperatingSystem) { "x64" } else { "x86" }
    }
    powershell = @{
        version = $PSVersionTable.PSVersion.ToString()
        edition = $PSVersionTable.PSEdition
    }
    python = @{}
    node = @{}
    npm = @{}
    flutter = @{}
    dart = @{}
    java = @{}
    docker = @{}
    winget = @{}
    git = @{}
}

# Detect Python
Write-Log "Detecting Python..."
$pythonExe = Get-Command python -ErrorAction SilentlyContinue
if ($pythonExe) {
    $envInfo.python.path = $pythonExe.Source
    $envInfo.python.version = Get-CommandVersion "python"
    
    # Check for venv
    if (Test-Path "backend\.venv") {
        $envInfo.python.has_venv = $true
        $envInfo.python.venv_path = Resolve-Path "backend\.venv"
    }
    
    # Check pip
    $pipVersion = Get-CommandVersion "pip"
    if ($pipVersion) {
        $envInfo.python.pip_version = $pipVersion
        
        # Get Python version details
        $pythonVersionOutput = python --version 2>&1
        if ($pythonVersionOutput -match "Python (\d+\.\d+\.\d+)") {
            $envInfo.python.full_version = $matches[1]
            $envInfo.python.major_minor = ($matches[1] -split '\.')[0..1] -join '.'
        }
    }
} else {
    $envInfo.python.installed = $false
    Write-Log "WARNING: Python not found"
}

# Detect Node.js
Write-Log "Detecting Node.js..."
$nodeExe = Get-Command node -ErrorAction SilentlyContinue
if ($nodeExe) {
    $envInfo.node.path = $nodeExe.Source
    $envInfo.node.version = Get-CommandVersion "node"
    
    # Detect npm
    $npmExe = Get-Command npm -ErrorAction SilentlyContinue
    if ($npmExe) {
        $envInfo.npm.path = $npmExe.Source
        $envInfo.npm.version = Get-CommandVersion "npm"
    }
} else {
    $envInfo.node.installed = $false
    Write-Log "WARNING: Node.js not found"
}

# Detect Flutter
Write-Log "Detecting Flutter..."
$flutterExe = Get-Command flutter -ErrorAction SilentlyContinue
if ($flutterExe) {
    $envInfo.flutter.path = $flutterExe.Source
    $flutterVersion = flutter --version 2>&1
    if ($flutterVersion -match "Flutter (\S+)") {
        $envInfo.flutter.version = $matches[1]
    }
    
    # Detect Dart
    $dartVersion = Get-CommandVersion "dart"
    if ($dartVersion) {
        $envInfo.dart.version = $dartVersion
    }
} else {
    $envInfo.flutter.installed = $false
    Write-Log "WARNING: Flutter not found"
}

# Detect Java
Write-Log "Detecting Java..."
$javaExe = Get-Command java -ErrorAction SilentlyContinue
if ($javaExe) {
    $envInfo.java.path = $javaExe.Source
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    $envInfo.java.version = $javaVersion.ToString().Trim()
} else {
    $envInfo.java.installed = $false
    Write-Log "WARNING: Java not found"
}

# Detect Docker
Write-Log "Detecting Docker..."
$dockerExe = Get-Command docker -ErrorAction SilentlyContinue
if ($dockerExe) {
    $envInfo.docker.path = $dockerExe.Source
    $envInfo.docker.version = Get-CommandVersion "docker"
    
    # Check Docker architecture
    try {
        $dockerInfo = docker info --format '{{.Architecture}}' 2>&1
        if ($dockerInfo) {
            $envInfo.docker.architecture = $dockerInfo.ToString().Trim()
        }
    } catch {
        Write-Log "Could not detect Docker architecture"
    }
} else {
    $envInfo.docker.installed = $false
    Write-Log "WARNING: Docker not found"
}

# Detect winget
Write-Log "Detecting winget..."
$wingetExe = Get-Command winget -ErrorAction SilentlyContinue
if ($wingetExe) {
    $envInfo.winget.path = $wingetExe.Source
    $envInfo.winget.version = Get-CommandVersion "winget"
} else {
    $envInfo.winget.installed = $false
    Write-Log "WARNING: winget not found"
}

# Detect Git
Write-Log "Detecting Git..."
$gitExe = Get-Command git -ErrorAction SilentlyContinue
if ($gitExe) {
    $envInfo.git.path = $gitExe.Source
    $envInfo.git.version = Get-CommandVersion "git"
} else {
    $envInfo.git.installed = $false
    Write-Log "WARNING: Git not found"
}

# Check Android SDK
Write-Log "Detecting Android SDK..."
$androidSdkPath = $env:ANDROID_HOME
if (-not $androidSdkPath) {
    $androidSdkPath = $env:ANDROID_SDK_ROOT
}
if (-not $androidSdkPath) {
    $defaultPath = "$env:LOCALAPPDATA\Android\Sdk"
    if (Test-Path $defaultPath) {
        $androidSdkPath = $defaultPath
    }
}

if ($androidSdkPath) {
    $envInfo.android_sdk = @{
        path = $androidSdkPath
        detected = $true
    }
    
    # Check for adb
    $adbPath = Join-Path $androidSdkPath "platform-tools\adb.exe"
    if (Test-Path $adbPath) {
        $envInfo.android_sdk.has_adb = $true
    }
} else {
    $envInfo.android_sdk = @{
        detected = $false
    }
    Write-Log "WARNING: Android SDK not found"
}

# Check project structure
Write-Log "Checking project structure..."
$projectPaths = @{
    backend = Test-Path "backend"
    frontend = Test-Path "promotional_website"
    mobile_app = Test-Path "mobile_app"
    devtools = Test-Path "devtools"
}

$envInfo.project_structure = $projectPaths

# Check requirement files
Write-Log "Checking requirement files..."
$requirementFiles = @{
    backend_requirements = Test-Path "backend\requirements.txt"
    package_json = Test-Path "promotional_website\package.json"
    pubspec_yaml = Test-Path "mobile_app\pubspec.yaml"
    package_lock = Test-Path "promotional_website\package-lock.json"
    pubspec_lock = Test-Path "mobile_app\pubspec.lock"
}

$envInfo.requirement_files = $requirementFiles

# Save to JSON
Write-Log "Writing environment info to $OutputPath"
$json = $envInfo | ConvertTo-Json -Depth 10
if (-not $DryRun) {
    $json | Out-File -FilePath $OutputPath -Encoding UTF8
    Write-Log "Environment detection complete. Results saved to $OutputPath"
} else {
    Write-Log "DRY RUN - Would write to $OutputPath"
    Write-Log $json
}

Write-Log "=========================================="
Write-Log "Detection Summary:"
Write-Log "  Python: $($envInfo.python.version)"
Write-Log "  Node: $($envInfo.node.version)"
Write-Log "  Flutter: $($envInfo.flutter.version)"
Write-Log "  Docker: $($envInfo.docker.version)"
Write-Log "=========================================="

return $envInfo

