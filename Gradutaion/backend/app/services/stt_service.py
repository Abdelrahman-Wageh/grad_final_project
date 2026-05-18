"""
STT (Speech-to-Text) Service - Placeholder Mode Only
Works without any AI model dependencies
"""

import logging
from typing import Dict, Any
import random

from app.config import settings

logger = logging.getLogger(__name__)


class STTService:
    """
    Speech-to-Text service - Placeholder mode for DRY_RUN.
    Returns random Arabic phrases for testing.
    """
    
    def __init__(self):
        logger.info("STT service initialized in placeholder mode (no AI models)")
    
    def transcribe(self, audio_bytes: bytes) -> Dict[str, Any]:
        """
        Transcribe audio to text (placeholder mode).
        
        Args:
            audio_bytes: Raw audio data (ignored in placeholder mode)
            
        Returns:
            Dict with:
                - text: Random Arabic text
                - confidence: Confidence score
                - language: Language code ('ar')
                - model: Model identifier
        """
        logger.info("Using placeholder STT response")
        
        placeholder_texts = [
            "أهلاً وسهلاً",
            "مرحباً",
            "كيف حالك",
            "أنا بخير",
            "شكراً",
            "من فضلك",
            "نعم",
            "لا",
            "تمام",
            "ممتاز",
            "عايز ألعب",
            "عايز أتعلم",
            "ساعدني",
            "مش فاهم"
        ]
        
        return {
            "text": random.choice(placeholder_texts),
            "confidence": 0.85,
            "language": "ar",
            "model": "placeholder"
        }
    
    def is_model_loaded(self) -> bool:
        """Check if the model is successfully loaded."""
        return False
    
    def get_model_info(self) -> Dict[str, Any]:
        """Get information about the loaded model."""
        return {
            "status": "placeholder",
            "mode": "dry_run",
            "message": "No AI models loaded - using placeholder responses"
        }


# Global instance
stt_service = STTService()

