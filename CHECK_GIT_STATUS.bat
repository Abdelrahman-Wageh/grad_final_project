@echo off
echo ========================================
echo Git Status Check
echo ========================================
echo.

cd /d "%~dp0"

echo Current branch:
git branch

echo.
echo Recent commits:
git log --oneline -5

echo.
echo Files changed (not committed):
git status --short

echo.
echo Remote repository:
git remote -v

echo.
echo ========================================
pause
