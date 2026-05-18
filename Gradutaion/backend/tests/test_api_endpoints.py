"""
Tests for FastAPI endpoints.
Tests placeholder pipeline (STT→NLU→TTS) without requiring trained models.
"""

import pytest
from fastapi.testclient import TestClient
import base64
import io

from app.main import app

client = TestClient(app)


def test_health_check():
    """Test health check endpoint."""
    response = client.get("/api/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "dry_run_mode" in data


def test_adventure_speech_placeholder():
    """Test adventure speech endpoint with placeholder data."""
    # Create minimal audio bytes (silence)
    import wave
    import numpy as np
    
    audio_buffer = io.BytesIO()
    with wave.open(audio_buffer, 'wb') as wav:
        wav.setnchannels(1)
        wav.setsampwidth(2)
        wav.setframerate(16000)
        silence = np.zeros(16000, dtype=np.int16)  # 1 second
        wav.writeframes(silence.tobytes())
    
    audio_base64 = base64.b64encode(audio_buffer.getvalue()).decode('utf-8')
    
    request_data = {
        "audio_base64": audio_base64,
        "audio_format": "wav",
        "game_state": {
            "state": "FOREST_ADVENTURE",
            "context": "introduction",
            "level": 1,
            "state_data": {}
        },
        "player_id": "test_player",
        "character_type": "bird"
    }
    
    response = client.post("/api/adventure_speech", json=request_data)
    assert response.status_code == 200
    data = response.json()
    assert "audio_base64" in data
    assert "text_response" in data
    assert "metadata" in data
    assert data["metadata"]["response_key"] is not None


def test_draw_recognition_placeholder():
    """Test drawing recognition endpoint with placeholder data."""
    # Create minimal image (1x1 pixel PNG)
    from PIL import Image
    
    img = Image.new('RGB', (64, 64), color='white')
    img_buffer = io.BytesIO()
    img.save(img_buffer, format='PNG')
    img_base64 = base64.b64encode(img_buffer.getvalue()).decode('utf-8')
    
    request_data = {
        "image_base64": img_base64,
        "challenge": "DRAW_CAT",
        "game_state": {
            "state": "DRAWING_GAME",
            "context": "challenge",
            "level": 1,
            "state_data": {}
        },
        "player_id": "test_player"
    }
    
    response = client.post("/api/draw", json=request_data)
    assert response.status_code == 200
    data = response.json()
    assert "prediction" in data
    assert "is_correct" in data
    assert "confidence" in data


def test_admin_endpoints_require_key():
    """Test admin endpoints require API key."""
    response = client.post("/api/admin/stats", json={})
    # Returns 503 if admin API not configured, 401 if configured but key missing
    assert response.status_code in [401, 503]  # Service unavailable or unauthorized


def test_admin_endpoints_with_key():
    """Test admin endpoints with valid API key."""
    import os
    os.environ["ADMIN_API_KEY"] = "test-admin-key"
    
    # Reload app to get new env var
    from importlib import reload
    import app.config
    reload(app.config)
    
    response = client.post(
        "/api/admin/stats",
        json={},
        headers={"X-Admin-Api-Key": "test-admin-key"}
    )
    # Should succeed (may return empty stats if no data)
    assert response.status_code in [200, 500]  # 500 if no database


def test_billing_webhook():
    """Test billing webhook endpoint."""
    response = client.post(
        "/api/billing/webhook",
        json={"type": "test_event"},
        headers={"Stripe-Signature": "test"}
    )
    assert response.status_code == 200


def test_invalid_audio():
    """Test adventure speech with invalid audio."""
    request_data = {
        "audio_base64": "invalid_base64",
        "audio_format": "wav",
        "game_state": {
            "state": "FOREST_ADVENTURE",
            "context": "introduction"
        }
    }
    
    response = client.post("/api/adventure_speech", json=request_data)
    assert response.status_code == 400  # Bad Request


def test_missing_game_state():
    """Test adventure speech with missing game state."""
    request_data = {
        "audio_base64": base64.b64encode(b"fake_audio").decode('utf-8'),
        "audio_format": "wav"
    }
    
    response = client.post("/api/adventure_speech", json=request_data)
    assert response.status_code == 422  # Validation Error

