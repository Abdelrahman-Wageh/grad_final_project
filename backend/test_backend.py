"""
Quick test script to check if backend can start.
"""
import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.dirname(__file__))

print("Testing backend imports...")

try:
    print("1. Importing FastAPI...")
    from fastapi import FastAPI
    print("   ✓ FastAPI OK")
except Exception as e:
    print(f"   ✗ FastAPI FAILED: {e}")
    sys.exit(1)

try:
    print("2. Importing app.config...")
    from app.config import settings
    print(f"   ✓ Config OK (DRY_RUN={settings.DRY_RUN})")
except Exception as e:
    print(f"   ✗ Config FAILED: {e}")
    sys.exit(1)

try:
    print("3. Importing app.models.schemas...")
    from app.models.schemas import HealthResponse
    print("   ✓ Schemas OK")
except Exception as e:
    print(f"   ✗ Schemas FAILED: {e}")
    sys.exit(1)

try:
    print("4. Importing app.services...")
    from app.services.stt_service import stt_service
    from app.services.nlu_service import nlu_service
    from app.services.tts_service import tts_service
    from app.services.cv_service import cv_service
    print("   ✓ Services OK")
except Exception as e:
    print(f"   ✗ Services FAILED: {e}")
    sys.exit(1)

try:
    print("5. Importing app.api_endpoints...")
    from app.api_endpoints import router
    print("   ✓ API Endpoints OK")
except Exception as e:
    print(f"   ✗ API Endpoints FAILED: {e}")
    sys.exit(1)

try:
    print("6. Importing app.main...")
    from app.main import app
    print("   ✓ Main App OK")
except Exception as e:
    print(f"   ✗ Main App FAILED: {e}")
    sys.exit(1)

print("\n✅ All imports successful! Backend should start.")
print(f"\nTo start the backend, run:")
print(f"  uvicorn app.main:app --reload --port 8000")
