# ========================================
# GitHub Push Script with Progress Bar
# ========================================
# This script pushes all changes from specified folders to GitHub
# Repository: https://github.com/NourahanElhalawany/Graduation-Project

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  GitHub Push Script - Smartino Project" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Set location to project root
Set-Location "E:\Projects\github\Graduation-Project"

# Folders to push
$folders = @(
    ".kiro",
    "backend",
    "tools",
    "deploy",
    "devtools",
    "docs",
    "Gradutaion",
    "Report",
    "imgs",
    "mobile_app"
)

Write-Host "Project Root: " -NoNewline
Write-Host "E:\Projects\github\Graduation-Project" -ForegroundColor Green
Write-Host "Repository: " -NoNewline
Write-Host "https://github.com/NourahanElhalawany/Graduation-Project" -ForegroundColor Green
Write-Host ""

# Function to show progress
function Show-Progress {
    param(
        [int]$Current,
        [int]$Total,
        [string]$Activity
    )
    $percent = [math]::Round(($Current / $Total) * 100)
    Write-Progress -Activity $Activity -Status "$percent% Complete" -PercentComplete $percent
}

# Step 1: Check Git status
Write-Host "[1/5] Checking Git status..." -ForegroundColor Yellow
Show-Progress -Current 1 -Total 5 -Activity "Preparing Git Push"
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Host "✓ Changes detected" -ForegroundColor Green
} else {
    Write-Host "⚠ No changes to commit" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}
Write-Host ""

# Step 2: Add all changes from specified folders
Write-Host "[2/5] Adding changes from folders..." -ForegroundColor Yellow
Show-Progress -Current 2 -Total 5 -Activity "Adding Files to Git"

$totalFolders = $folders.Count
$currentFolder = 0

foreach ($folder in $folders) {
    $currentFolder++
    $folderPercent = [math]::Round(($currentFolder / $totalFolders) * 100)
    Write-Host "  [$currentFolder/$totalFolders] Adding: $folder" -NoNewline
    
    if (Test-Path $folder) {
        git add "$folder/*" 2>$null
        Write-Host " ✓" -ForegroundColor Green
    } else {
        Write-Host " ⚠ (not found)" -ForegroundColor Yellow
    }
}

# Also add root level markdown files
Write-Host "  [+] Adding root level files..." -NoNewline
git add "*.md" 2>$null
git add "*.bat" 2>$null
Write-Host " ✓" -ForegroundColor Green
Write-Host ""

# Step 3: Show what will be committed
Write-Host "[3/5] Files staged for commit:" -ForegroundColor Yellow
Show-Progress -Current 3 -Total 5 -Activity "Reviewing Changes"
$stagedFiles = git diff --cached --name-only
$fileCount = ($stagedFiles | Measure-Object).Count
Write-Host "  Total files: " -NoNewline
Write-Host "$fileCount" -ForegroundColor Cyan
Write-Host ""

# Show first 20 files
$displayFiles = $stagedFiles | Select-Object -First 20
foreach ($file in $displayFiles) {
    Write-Host "    • $file" -ForegroundColor Gray
}
if ($fileCount -gt 20) {
    Write-Host "    ... and $($fileCount - 20) more files" -ForegroundColor Gray
}
Write-Host ""

# Step 4: Commit changes
Write-Host "[4/5] Committing changes..." -ForegroundColor Yellow
Show-Progress -Current 4 -Total 5 -Activity "Committing Changes"

$commitMessage = "feat: Session 15 - All Hive errors fixed + comprehensive updates

- Fixed all Hive initialization errors
- Added explicit type parameters to adapters
- Fixed DevSettings TypeId conflict (8 -> 11)
- Fixed syntax errors in placeholder_asset_generator
- Improved error handling in StorageService
- Updated documentation in .kiro/specs
- Added Session 15 fix reports
- Production ready status achieved

Folders updated: .kiro, backend, tools, deploy, devtools, docs, Gradutaion, Report, imgs, mobile_app"

git commit -m "$commitMessage"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Commit successful" -ForegroundColor Green
} else {
    Write-Host "✗ Commit failed" -ForegroundColor Red
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}
Write-Host ""

# Step 5: Push to GitHub
Write-Host "[5/5] Pushing to GitHub..." -ForegroundColor Yellow
Show-Progress -Current 5 -Total 5 -Activity "Pushing to Remote"
Write-Host ""
Write-Host "  Repository: https://github.com/NourahanElhalawany/Graduation-Project" -ForegroundColor Cyan
Write-Host "  Branch: main" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Pushing..." -NoNewline

# Push with progress
git push origin main 2>&1 | ForEach-Object {
    if ($_ -match "Writing objects:\s+(\d+)%") {
        $percent = $matches[1]
        Write-Progress -Activity "Pushing to GitHub" -Status "$percent% Complete" -PercentComplete $percent
    }
    Write-Host "." -NoNewline -ForegroundColor Green
}

Write-Host ""
Write-Host ""

if ($LASTEXITCODE -eq 0) {
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  ✓ SUCCESS! Push completed" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your changes have been pushed to:" -ForegroundColor White
    Write-Host "https://github.com/NourahanElhalawany/Graduation-Project" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Folders pushed:" -ForegroundColor White
    foreach ($folder in $folders) {
        Write-Host "  ✓ $folder" -ForegroundColor Green
    }
} else {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "  ✗ PUSH FAILED" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "  1. Check your internet connection" -ForegroundColor White
    Write-Host "  2. Verify GitHub credentials" -ForegroundColor White
    Write-Host "  3. Ensure you have push access to the repository" -ForegroundColor White
    Write-Host "  4. Try: git push origin main --force (if needed)" -ForegroundColor White
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
