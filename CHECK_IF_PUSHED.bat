@echo off
echo ========================================
echo Checking Git Status
echo ========================================
echo.

cd /d "%~dp0"

echo Killing any stuck git processes...
taskkill /F /IM git.exe 2>nul
timeout /t 2 >nul

echo.
echo === Current Branch ===
git branch

echo.
echo === Last 3 Commits ===
git log --oneline -3

echo.
echo === Files Not Yet Committed ===
git status --short

echo.
echo === Checking Remote Status ===
git fetch origin
git status

echo.
echo ========================================
echo.
echo INSTRUCTIONS:
echo - If you see "Your branch is up to date" = Already pushed!
echo - If you see "Your branch is ahead" = Need to push
echo - If you see uncommitted files = Need to commit first
echo.
pause
