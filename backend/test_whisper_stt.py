"""
Quick test script for the fine-tuned Whisper STT service.
Tests the production STT service with a sample audio file.
"""

import sys
import os
from pathlib import Path

# Add backend to path
sys.path.insert(0, str(Path(__file__).parent))

from app.services.stt_service import stt_service
import time


def test_stt_service():
    """Test the STT service with sample audio."""
    print("=" * 60)
    print("Testing Fine-tuned Whisper STT Service")
    print("=" * 60)
    
    # Check model status
    print("\n1. Checking model status...")
    if stt_service.is_model_loaded():
        print("   ✅ Model loaded successfully!")
        info = stt_service.get_model_info()
        print(f"   Model: {info['model']}")
        print(f"   Device: {info['device']}")
        print(f"   Parameters: {info['parameters_millions']:.2f}M")
        print(f"   WER: {info['wer']}%")
    else:
        print("   ⚠️  Model not loaded - using placeholder mode")
        info = stt_service.get_model_info()
        print(f"   Mode: {info['mode']}")
    
    # Test with sample audio
    test_audio_path = r"E:\Projects\github\Graduation Project\Graduation-Project\dataset\clip_0977.wav"
    
    if not os.path.exists(test_audio_path):
        print(f"\n⚠️  Test audio not found: {test_audio_path}")
        print("   Skipping audio test")
        return
    
    print(f"\n2. Testing with audio file...")
    print(f"   File: {test_audio_path}")
    
    # Load audio
    with open(test_audio_path, 'rb') as f:
        audio_bytes = f.read()
    
    print(f"   Audio size: {len(audio_bytes) / 1024:.2f} KB")
    
    # Transcribe
    print("\n3. Transcribing...")
    start_time = time.time()
    result = stt_service.transcribe(audio_bytes)
    elapsed = time.time() - start_time
    
    # Display results
    print("\n" + "=" * 60)
    print("RESULTS")
    print("=" * 60)
    print(f"📝 Text: {result['text']}")
    print(f"📊 Confidence: {result['confidence']:.4f} ({result['confidence']*100:.2f}%)")
    print(f"🌍 Language: {result['language']}")
    print(f"🤖 Model: {result['model']}")
    print(f"⏱️  Time: {elapsed:.3f} seconds")
    
    # Performance metrics
    if result['model'] != 'placeholder':
        # Estimate audio duration (assuming 16kHz mono WAV with 44-byte header)
        audio_duration = (len(audio_bytes) - 44) / (16000 * 2)  # 2 bytes per sample
        rtf = audio_duration / elapsed
        print(f"⚡ Real-time factor: {rtf:.2f}x")
        
        if rtf > 1:
            print(f"   ✅ Processing faster than real-time!")
        else:
            print(f"   ⚠️  Processing slower than real-time")
    
    print("\n" + "=" * 60)
    print("✅ Test completed successfully!")
    print("=" * 60)


def test_placeholder_mode():
    """Test placeholder mode."""
    print("\n" + "=" * 60)
    print("Testing Placeholder Mode")
    print("=" * 60)
    
    # Create dummy audio
    dummy_audio = b'\x00' * 1000
    
    print("\nTranscribing with placeholder...")
    result = stt_service.transcribe(dummy_audio)
    
    print(f"📝 Text: {result['text']}")
    print(f"📊 Confidence: {result['confidence']:.2f}")
    print(f"🤖 Model: {result['model']}")
    
    print("\n✅ Placeholder mode working!")


if __name__ == "__main__":
    try:
        test_stt_service()
        
        # Test placeholder if model not loaded
        if not stt_service.is_model_loaded():
            test_placeholder_mode()
            
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
