@echo off
echo ========================================
echo Checking What's on GitHub vs Local
echo ========================================
echo.

cd /d "%~dp0"

echo === Folders in your LOCAL repo ===
dir /AD /B

echo.
echo === Checking Git status ===
git status

echo.
echo === Last commit on GitHub ===
git log origin/main -1 --oneline

echo.
echo === Your last LOCAL commit ===
git log -1 --oneline

echo.
echo === Comparing local vs remote ===
git diff --stat origin/main

echo.
echo ========================================
echo.
echo INSTRUCTIONS:
echo - If "git diff" shows differences = Not everything pushed
echo - If "git diff" is empty = Everything is pushed
echo - Check GitHub in browser to see what folders are there
echo.
pause
