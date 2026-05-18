@echo off
echo ========================================
echo FINAL FIX: Remove LFS and Push
echo ========================================
echo.

cd /d "%~dp0"

echo Step 1: Killing any stuck processes...
taskkill /F /IM git.exe 2>nul
timeout /t 2 >nul

echo.
echo Step 2: Completely removing LFS...
git lfs uninstall
git lfs uninstall --local

echo.
echo Step 3: Removing LFS tracking file...
if exist .gitattributes (
    del .gitattributes
    echo Deleted .gitattributes
)

echo.
echo Step 4: Unstaging everything...
git reset

echo.
echo Step 5: Adding all files (without LFS)...
git add .

echo.
echo Step 6: Creating commit...
git commit -m "Session 15-16: All Hive errors fixed (no LFS)"

echo.
echo Step 7: Force pushing to GitHub...
git push origin main --force

echo.
echo ========================================
echo Done! Check above for success/errors.
echo ========================================
pause
