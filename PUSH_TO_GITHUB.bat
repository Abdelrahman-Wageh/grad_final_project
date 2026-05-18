@echo off
REM ========================================
REM Quick GitHub Push Script
REM ========================================

echo ========================================
echo   GitHub Push - Smartino Project
echo ========================================
echo.

cd /d "E:\Projects\github\Graduation-Project"

echo [1/4] Adding changes...
git add .kiro/* backend/* tools/* deploy/* devtools/* docs/* Gradutaion/* Report/* imgs/* mobile_app/*
git add *.md *.bat

echo.
echo [2/4] Committing changes...
git commit -m "feat: Session 15 - All Hive errors fixed + comprehensive updates"

echo.
echo [3/4] Pushing to GitHub...
git push origin main

echo.
echo [4/4] Done!
echo.
echo Check: https://github.com/NourahanElhalawany/Graduation-Project
echo.
pause
