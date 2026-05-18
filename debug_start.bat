@echo off
echo ========================================================
echo   FIXING CONNECTION TIMEOUT & PUSHING
echo ========================================================

cd /d "%~dp0"

echo.
echo [1/3] Increasing Git Buffer Size to 500MB...
git config --global http.postBuffer 524288000

echo.
echo [2/3] Extending Network Timeouts...
git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 999999
git config --global sendpack.sideband false

echo.
echo [3/3] Pushing to GitHub (Attempting again)...
echo       Please wait. Do not close this window.
git push origin main --force

echo.
echo ========================================================
echo PROCESS COMPLETE.
echo Check the message above. If no "fatal" error, you are good.
echo ========================================================
pause
