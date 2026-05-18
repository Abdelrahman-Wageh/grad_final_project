"""
TTS (Text-to-Speech) Service - Placeholder Mode Only
Works without any AI model dependencies
"""

import io
import logging
import wave
from typing import Dict, Any, Optional

from app.config import settings

logger = logging.getLogger(__name__)


class TTSService:
    """Text-to-Speech service - Placeholder mode for DRY_RUN."""
    
    def __init__(self):
        logger.info("TTS service initialized in placeholder mode (no AI models)")
    
    def synthesize(
        self, 
        text: str, 
        voice_id: Optional[str] = None,
        character_type: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Synthesize text to speech (placeholder mode).
        
        Args:
            text: Text to synthesize
            voice_id: Voice identifier (optional, ignored)
            character_type: Character type (optional, ignored)
            
        Returns:
            Dict with 'audio_bytes', 'format', 'duration_ms'
        """
        logger.info(f"Using placeholder TTS for text: {text[:50]}...")
        
        # Generate 2 seconds of silence (placeholder audio)
        sample_rate = settings.AUDIO_SAMPLE_RATE
        duration_samples = int(sample_rate * 2)  # 2 seconds
        
        # Create silence as bytes (16-bit PCM)
        silence = bytes([0, 0] * duration_samples)
        
        # Create WAV in memory
        wav_buffer = io.BytesIO()
        with wave.open(wav_buffer, 'wb') as wav_file:
            wav_file.setnchannels(settings.AUDIO_CHANNELS)
            wav_file.setsampwidth(2)  # 16-bit
            wav_file.setframerate(sample_rate)
            wav_file.writeframes(silence)
        
        return {
            "audio_bytes": wav_buffer.getvalue(),
            "format": "wav",
            "duration_ms": 2000,
            "placeholder_note": f"Text to speak: {text}"
        }


# Global instance
tts_service = TTSService()

