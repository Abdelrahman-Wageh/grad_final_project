#!/usr/bin/env python3
"""
Backend Self-Check Script
Validates all endpoints are working correctly.
Exits with non-zero code if any endpoint fails.
"""

import sys
import os
import base64
import time
from pathlib import Path

# Add backend to path
backend_dir = Path(__file__).parent.parent
sys.path.insert(0, str(backend_dir))

try:
    import httpx
except ImportError:
    print("ERROR: httpx not installed. Install with: pip install httpx")
    sys.exit(1)

# Configuration
BASE_URL = os.getenv("API_BASE_URL", "http://localhost:8000")
TIMEOUT = 10.0

# Colors for output (optional)
GREEN = "\033[92m"
RED = "\033[91m"
YELLOW = "\033[93m"
RESET = "\033[0m"

def print_status(message, status="INFO"):
    """Print status message with color."""
    if status == "OK":
        print(f"{GREEN}✓{RESET} {message}")
    elif status == "FAIL":
        print(f"{RED}✗{RESET} {message}")
    elif status == "WARN":
        print(f"{YELLOW}⚠{RESET} {message}")
    else:
        print(f"  {message}")

def test_endpoint(method, path, description, **kwargs):
    """Test an endpoint and return success status."""
    url = f"{BASE_URL}{path}"
    try:
        if method == "GET":
            response = httpx.get(url, timeout=TIMEOUT, **kwargs)
        elif method == "POST":
            response = httpx.post(url, timeout=TIMEOUT, **kwargs)
        else:
            print_status(f"Unknown method: {method}", "FAIL")
            return False
        
        if response.status_code == 200:
            print_status(f"{description}: OK (HTTP {response.status_code})", "OK")
            return True
        else:
            print_status(
                f"{description}: FAILED (HTTP {response.status_code}) - {response.text[:100]}",
                "FAIL"
            )
            return False
    except httpx.ConnectError:
        print_status(f"{description}: FAILED (Cannot connect to {BASE_URL})", "FAIL")
        print_status("  Make sure the backend server is running:", "INFO")
        print_status("  cd backend && uvicorn app.main:app --reload", "INFO")
        return False
    except Exception as e:
        print_status(f"{description}: FAILED ({str(e)})", "FAIL")
        return False

def create_test_audio():
    """Create minimal test audio (silence WAV)."""
    import wave
    import io
    import numpy as np
    
    # Create 1 second of silence
    sample_rate = 16000
    duration = 1.0
    frames = int(sample_rate * duration)
    
    buffer = io.BytesIO()
    with wave.open(buffer, 'wb') as wav:
        wav.setnchannels(1)
        wav.setsampwidth(2)  # 16-bit
        wav.setframerate(sample_rate)
        silence = np.zeros(frames, dtype=np.int16)
        wav.writeframes(silence.tobytes())
    
    return base64.b64encode(buffer.getvalue()).decode('utf-8')

def create_test_image():
    """Create minimal test image (1x1 pixel PNG)."""
    from PIL import Image
    import io
    
    img = Image.new('RGB', (64, 64), color='white')
    buffer = io.BytesIO()
    img.save(buffer, format='PNG')
    return base64.b64encode(buffer.getvalue()).decode('utf-8')

def main():
    """Run all endpoint tests."""
    print("\n" + "="*60)
    print("Whispering Woods Backend Self-Check")
    print("="*60)
    print(f"Testing API at: {BASE_URL}\n")
    
    results = []
    
    # Test 1: Root endpoint
    print("1. Testing root endpoint...")
    results.append(test_endpoint("GET", "/", "Root endpoint"))
    
    # Test 2: Health endpoint
    print("\n2. Testing health endpoint...")
    results.append(test_endpoint("GET", "/health", "Health check"))
    
    # Test 3: API health endpoint
    print("\n3. Testing API health endpoint...")
    results.append(test_endpoint("GET", "/api/health", "API health check"))
    
    # Test 4: Adventure speech endpoint (placeholder)
    print("\n4. Testing adventure speech endpoint...")
    test_audio = create_test_audio()
    adventure_speech_payload = {
        "audio_base64": test_audio,
        "audio_format": "wav",
        "game_state": {
            "state": "FOREST_ADVENTURE",
            "context": "introduction",
            "level": 1,
            "state_data": {}
        },
        "player_id": "test_self_check",
        "character_type": "bird"
    }
    results.append(test_endpoint(
        "POST",
        "/api/adventure_speech",
        "Adventure speech pipeline",
        json=adventure_speech_payload
    ))
    
    # Test 5: Draw recognition endpoint (placeholder)
    print("\n5. Testing draw recognition endpoint...")
    test_image = create_test_image()
    draw_payload = {
        "image_base64": test_image,
        "challenge": "DRAW_CAT",
        "game_state": {
            "state": "DRAWING_GAME",
            "context": "challenge",
            "level": 1,
            "state_data": {}
        },
        "player_id": "test_self_check"
    }
    results.append(test_endpoint(
        "POST",
        "/api/draw",
        "Draw recognition",
        json=draw_payload
    ))
    
    # Summary
    print("\n" + "="*60)
    passed = sum(results)
    total = len(results)
    print(f"Results: {passed}/{total} tests passed")
    
    if passed == total:
        print_status("All tests passed! Backend is healthy.", "OK")
        return 0
    else:
        print_status(f"{total - passed} test(s) failed. Check the errors above.", "FAIL")
        return 1

if __name__ == "__main__":
    sys.exit(main())

