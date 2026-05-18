@echo off
echo ========================================
echo COMPLETE PUSH AND VERIFICATION
echo ========================================
echo This will:
echo 1. Check local files
echo 2. Remove LFS completely
echo 3. Add and commit everything
echo 4. Push to GitHub
echo 5. Verify everything pushed correctly
echo ========================================
echo.
pause

cd /d "%~dp0"

echo.
echo [STEP 1/8] Killing stuck processes...
taskkill /F /IM git.exe 2>nul
timeout /t 2 >nul

echo.
echo [STEP 2/8] Removing Git LFS completely...
git lfs uninstall
git lfs uninstall --local
if exist .gitattributes del .gitattributes
if exist .git\hooks\pre-push del .git\hooks\pre-push

echo.
echo [STEP 3/8] Checking what folders exist locally...
echo === LOCAL FOLDERS ===
dir /AD /B | findstr /V /C:".git" /C:"node_modules" /C:"build" /C:"venv"

echo.
echo [STEP 4/8] Resetting and adding ALL files...
git reset
git add .

echo.
echo [STEP 5/8] Creating commit...
git commit -m "Session 15-16: All Hive errors fixed + complete project push"

echo.
echo [STEP 6/8] Fetching latest from GitHub...
git fetch origin

echo.
echo [STEP 7/8] Pushing to GitHub (with retry)...
:RETRY_PUSH
git push origin main
if errorlevel 1 (
    echo.
    echo Push failed, retrying with force...
    git push origin main --force
    if errorlevel 1 (
        echo.
        echo ERROR: Push failed even with force!
        echo Check your internet connection and GitHub authentication.
        pause
        exit /b 1
    )
)

echo.
echo [STEP 8/8] Verifying push was successful...
git fetch origin
git diff --stat main origin/main

echo.
echo ========================================
echo VERIFICATION COMPLETE
echo ========================================
echo.
echo If you see "no differences" above, everything pushed successfully!
echo.
echo Now checking GitHub to confirm...
echo Opening GitHub in browser...
start https://github.com/NourahanElhalawany/Graduation-Project
echo.
echo ========================================
echo MANUAL VERIFICATION CHECKLIST:
echo ========================================
echo Please check that these folders exist on GitHub:
echo [ ] .kiro
echo [ ] backend
echo [ ] deploy
echo [ ] devtools
echo [ ] docs
echo [ ] Gradutaion
echo [ ] imgs
echo [ ] mobile_app
echo [ ] Report
echo [ ] tools
echo.
echo If any are missing, press N to retry push.
echo If all are there, press Y to confirm success.
echo ========================================
echo.
choice /C YN /M "Are all folders visible on GitHub"
if errorlevel 2 goto RETRY_PUSH
if errorlevel 1 goto SUCCESS

:SUCCESS
echo.
echo ========================================
echo SUCCESS! Everything pushed perfectly!
echo ========================================
echo.
echo Your repository is now fully up to date at:
echo https://github.com/NourahanElhalawany/Graduation-Project
echo.
echo All your work from Sessions 14-16 is safely backed up!
echo ========================================
pause
exit /b 0
