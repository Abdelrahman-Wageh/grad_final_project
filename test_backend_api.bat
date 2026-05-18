@echo off
echo Testing Backend API...
echo.
echo Make sure the backend is running first!
echo.
timeout /t 3

curl http://127.0.0.1:8000/
echo.
echo.
echo Testing health endpoint...
curl http://127.0.0.1:8000/health
echo.
echo.
pause
