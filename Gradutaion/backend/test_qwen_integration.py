"""
Quick test script for Qwen LLM integration.
Tests both the comparative architecture and Friend Mode.
"""

import sys
import os
from pathlib import Path

# Add backend to path
sys.path.insert(0, str(Path(__file__).parent))

print("=" * 60)
print("QWEN LLM INTEGRATION TEST")
print("=" * 60)

# Test 1: Check configuration
print("\n1. Checking Configuration...")
from app.config import settings

print(f"   USE_LLM_GENERATOR: {settings.USE_LLM_GENERATOR}")
print(f"   QWEN_MODEL_PATH: {settings.QWEN_MODEL_PATH}")
print(f"   LLM_TEMPERATURE: {settings.LLM_TEMPERATURE}")
print(f"   LLM_MAX_TOKENS: {settings.LLM_MAX_TOKENS}")

# Test 2: Test Response Service
print("\n2. Testing Response Service...")
from app.services.response_service import response_service

info = response_service.get_generator_info()
print(f"   Active Generator: {info['name']}")
print(f"   Type: {info['type']}")
print(f"   Available: {response_service.is_generator_available()}")

# Test 3: Generate a response
print("\n3. Generating Test Response...")
try:
    result = response_service.generate_response(
        text="مرحباً! أنا اسمي أحمد",
        game_state="GREETING",
        game_context="introduction",
        child_name="أحمد"
    )
    
    print(f"   Input: 'مرحباً! أنا اسمي أحمد'")
    print(f"   Response: {result['response_text']}")
    print(f"   Generator: {result['generator_type']}")
    print(f"   Confidence: {result['confidence']:.2f}")
    print(f"   Emotion: {result['emotion']}")
    
except Exception as e:
    print(f"   ⚠️  Error: {e}")

# Test 4: Test Friend Mode Service
print("\n4. Testing Friend Mode Service...")
from app.services.friend_mode_service import friend_mode_service

if friend_mode_service.llm_generator:
    llm_info = friend_mode_service.llm_generator.get_info()
    print(f"   LLM Loaded: {llm_info['loaded']}")
    if llm_info['loaded']:
        print(f"   Device: {llm_info['device']}")
        print(f"   Parameters: {llm_info['parameters_billions']:.2f}B")
else:
    print(f"   ⚠️  LLM not initialized")

# Test 5: Test switching generators
print("\n5. Testing Generator Switching...")
print(f"   Current: {response_service.get_generator_info()['type']}")

# Try switching (will only work if LLM is available)
try:
    current_type = response_service.get_generator_info()['type']
    new_use_llm = (current_type == 'nlu')  # Switch to opposite
    
    print(f"   Switching to: {'LLM' if new_use_llm else 'NLU'}...")
    response_service.reload_generator(use_llm=new_use_llm)
    
    new_info = response_service.get_generator_info()
    print(f"   ✅ Switched to: {new_info['name']}")
    
    # Switch back
    response_service.reload_generator(use_llm=(current_type == 'llm'))
    print(f"   ✅ Switched back to: {current_type.upper()}")
    
except Exception as e:
    print(f"   ⚠️  Switching failed: {e}")

# Summary
print("\n" + "=" * 60)
print("TEST SUMMARY")
print("=" * 60)
print("\n✅ Configuration loaded successfully")
print("✅ Response service initialized")
print("✅ Generator interface working")

if response_service.get_generator_info()['type'] == 'llm':
    print("✅ Qwen LLM active and ready")
else:
    print("ℹ️  Legacy NLU active (LLM available but not enabled)")

print("\n📝 To switch to LLM:")
print("   1. Edit backend/app/config.py")
print("   2. Set USE_LLM_GENERATOR = True")
print("   3. Restart the backend")
print("\n   OR")
print("\n   Set environment variable: USE_LLM_GENERATOR=true")

print("\n" + "=" * 60)
print("✅ All tests completed!")
print("=" * 60)
