@echo off
echo ========================================
echo Testing Backend Only
echo ========================================
echo.

cd backend
conda activate ai_env
python -m uvicorn app.main:app --host 127.0.0.1 --port 8000

pause
