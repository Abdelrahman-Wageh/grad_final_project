"""
Integration test for full pipeline (STT→NLU→TTS).
Tests placeholder mode end-to-end.
"""

import pytest
from fastapi.testclient import TestClient
import base64
import io
import wave
import numpy as np

from app.main import app

client = TestClient(app)


def create_test_audio(duration_seconds=1):
    """Create test audio (silence)."""
    audio_buffer = io.BytesIO()
    sample_rate = 16000
    frames = int(sample_rate * duration_seconds)
    
    with wave.open(audio_buffer, 'wb') as wav:
        wav.setnchannels(1)
        wav.setsampwidth(2)
        wav.setframerate(sample_rate)
        silence = np.zeros(frames, dtype=np.int16)
        wav.writeframes(silence.tobytes())
    
    return base64.b64encode(audio_buffer.getvalue()).decode('utf-8')


def test_full_pipeline():
    """Test complete STT→NLU→TTS pipeline."""
    audio_base64 = create_test_audio()
    
    request_data = {
        "audio_base64": audio_base64,
        "audio_format": "wav",
        "game_state": {
            "state": "FOREST_ADVENTURE",
            "context": "introduction",
            "level": 1,
            "state_data": {}
        },
        "player_id": "test_integration",
        "character_type": "bird"
    }
    
    response = client.post("/api/adventure_speech", json=request_data)
    
    assert response.status_code == 200
    data = response.json()
    
    # Verify response structure
    assert "audio_base64" in data
    assert "text_response" in data
    assert "metadata" in data
    
    # Verify metadata
    metadata = data["metadata"]
    assert "response_key" in metadata
    assert "confidence" in metadata
    assert "processing_time_ms" in metadata
    
    # Verify audio is returned (even if placeholder silence)
    assert len(data["audio_base64"]) > 0
    
    # Verify processing time is reasonable (< 5 seconds for placeholder)
    assert metadata["processing_time_ms"] < 5000


def test_pipeline_with_different_game_states():
    """Test pipeline with different game states."""
    audio_base64 = create_test_audio()
    
    game_states = [
        {"state": "FOREST_ADVENTURE", "context": "introduction"},
        {"state": "NUMBER_GATE_PUZZLE", "context": "puzzle_solving"},
        {"state": "COLOR_LEARNING", "context": "learning_activity"},
    ]
    
    for game_state in game_states:
        request_data = {
            "audio_base64": audio_base64,
            "audio_format": "wav",
            "game_state": {
                **game_state,
                "level": 1,
                "state_data": {}
            },
            "player_id": "test_player",
            "character_type": "bird"
        }
        
        response = client.post("/api/adventure_speech", json=request_data)
        assert response.status_code == 200
        assert "text_response" in response.json()

