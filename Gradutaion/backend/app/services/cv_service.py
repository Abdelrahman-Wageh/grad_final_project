"""
CV (Computer Vision) Service for drawing recognition.
Uses Quick, Draw! trained model when available.
"""

import base64
import io
import logging
from typing import Dict, Any
import os
import tempfile

from app.config import settings

logger = logging.getLogger(__name__)


class CVService:
    """Computer Vision service for drawing recognition."""
    
    def __init__(self):
        self._real_service = None
        self._categories = [
            'cat', 'dog', 'bird', 'fish', 'house', 'tree', 
            'sun', 'car', 'flower', 'apple', 'circle', 'square'
        ]
        self._initialize_real_service()
    
    def _initialize_real_service(self):
        """Initialize real CV service if available."""
        if not settings.DRY_RUN and settings.CV_MODEL_PATH:
            try:
                import sys
                sys.path.append(os.path.join(os.path.dirname(__file__), '../../ai_backend'))
                from services.drawing_service import DrawingService
                self._real_service = DrawingService()
                logger.info("Real CV service initialized")
            except Exception as e:
                logger.warning(f"Failed to initialize real CV service: {e}. Using placeholder.")
        else:
            logger.info("CV service in DRY_RUN/placeholder mode")
    
    def recognize_drawing(
        self, 
        image_bytes: bytes, 
        challenge: str
    ) -> Dict[str, Any]:
        """
        Recognize drawing and compare with challenge.
        
        Args:
            image_bytes: Drawing image bytes (PNG/JPEG)
            challenge: Expected drawing (e.g., 'DRAW_CAT')
            
        Returns:
            Dict with 'prediction', 'confidence', 'is_correct'
        """
        if self._real_service and not settings.DRY_RUN:
            try:
                # Save to temp file
                with tempfile.NamedTemporaryFile(suffix='.png', delete=False) as tmp:
                    tmp.write(image_bytes)
                    tmp_path = tmp.name
                
                # Extract challenge label (e.g., 'DRAW_CAT' -> 'cat')
                challenge_label = challenge.replace('DRAW_', '').lower()
                
                result = self._real_service.analyze_drawing(tmp_path, challenge_label)
                os.unlink(tmp_path)
                
                return {
                    "prediction": result.get("prediction", "unknown"),
                    "confidence": result.get("confidence", 0.0),
                    "is_correct": result.get("is_correct", False)
                }
            except Exception as e:
                logger.error(f"Real CV failed: {e}. Falling back to placeholder.")
        
        # Placeholder: Random prediction for demo
        logger.info("Using placeholder CV response")
        import random
        
        # Extract challenge (e.g., 'DRAW_CAT' -> 'cat')
        challenge_clean = challenge.replace('DRAW_', '').lower()
        
        # 70% chance of correct prediction in placeholder mode
        if random.random() < 0.7:
            prediction = challenge_clean
            is_correct = True
            confidence = random.uniform(0.75, 0.95)
        else:
            # Random wrong prediction
            prediction = random.choice([c for c in self._categories if c != challenge_clean])
            is_correct = False
            confidence = random.uniform(0.5, 0.7)
        
        return {
            "prediction": prediction,
            "confidence": confidence,
            "is_correct": is_correct
        }


# Global instance
cv_service = CVService()

