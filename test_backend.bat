@echo off
echo Testing backend startup...
cd backend
conda activate ai_env
cd app
python main.py
pause
