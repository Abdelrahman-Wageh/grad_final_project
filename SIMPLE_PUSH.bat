@echo off
echo ========================================
echo Simple GitHub Push - Smartino Project
echo ========================================
echo.

cd /d "%~dp0"

echo [1/3] Adding all changes...
git add .

echo.
echo [2/3] Creating commit...
git commit -m "Session 15-16: All Hive errors fixed + context transfer"

echo.
echo [3/3] Pushing to GitHub...
echo NOTE: A browser window may open for authentication
echo.
git push origin main

echo.
echo ========================================
echo Push complete!
echo ========================================
pause
