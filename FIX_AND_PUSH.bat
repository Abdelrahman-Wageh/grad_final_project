@echo off
echo ========================================================
echo   NUCLEAR OPTION: FIX GIT LFS GHOSTS & FORCE UPLOAD
echo ========================================================
echo.
echo This script will:
echo 1. Delete the corrupted .git folder (Resetting history)
echo 2. Re-initialize Git from scratch
echo 3. Add all your current files as STANDARD files (No LFS)
echo 4. Force push to your repository
echo.
echo YOUR CODE FILES WILL BE SAFE. ONLY GIT HISTORY IS RESET.
echo.
pause

cd /d "%~dp0"

echo.
echo [1/6] Removing corrupted Git tracking...
rmdir /s /q .git

echo.
echo [2/6] Re-initializing Git...
git init
git branch -M main

echo.
echo [3/6] Configuring User (Just in case)...
git config user.name "NourahanElhalawany"
git config user.email "nourahan.elhalawany@ejust.edu.eg"

echo.
echo [4/6] Adding files (This might take a minute)...
:: We disable LFS specifically for this add
set GIT_LFS_SKIP_SMUDGE=1
git lfs uninstall 2>nul
git add .

echo.
echo [5/6] Committing clean version...
git commit -m "Full Project Upload: Fixed LFS synchronization issues"

echo.
echo [6/6] Connecting and Force Pushing to GitHub...
git remote add origin https://github.com/NourahanElhalawany/Graduation-Project.git
git push -u origin main --force

echo.
echo ========================================================
echo                   PROCESS COMPLETE
echo ========================================================
echo If you see "Branch 'main' set up to track remote branch",
echo YOU ARE DONE!
echo.
pause
