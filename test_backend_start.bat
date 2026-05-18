@echo off
REM Test Backend Startup
echo Testing backend startup...
cd backend
python -c "import app; print('✅ Backend module imports successfully!'); from app.main import app as fastapi_app; print('✅ FastAPI app created successfully!')"
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo   BACKEND IS READY TO START!
    echo ========================================
    echo.
    echo To start the backend server, run:
    echo   cd backend
    echo   python -m app.main
    echo.
) else (
    echo.
    echo ❌ Backend test failed!
    echo.
)
pause
