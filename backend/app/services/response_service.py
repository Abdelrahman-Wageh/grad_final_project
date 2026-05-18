"""
Unified Response Service
Uses the configured generator (NLU or LLM) based on settings
"""

import logging
from typing import Dict, Any, Optional
from app.config import settings
from app.services.response_generator_interface import create_response_generator

logger = logging.getLogger(__name__)


class ResponseService:
    """
    Unified response service that switches between NLU and LLM.
    
    Configuration:
        Set USE_LLM_GENERATOR in config.py or .env file:
        - False: Use Legacy NLU (rule-based)
        - True: Use Qwen LLM (generative)
    """
    
    def __init__(self):
        self.generator = None
        self._initialize_generator()
    
    def _initialize_generator(self):
        """Initialize the configured generator."""
        use_llm = settings.USE_LLM_GENERATOR
        
        logger.info(f"Initializing Response Service with USE_LLM_GENERATOR={use_llm}")
        
        self.generator = create_response_generator(use_llm=use_llm)
        
        info = self.generator.get_info()
        logger.info(f"✅ Active Generator: {info['name']}")
        logger.info(f"   Type: {info['type']}")
        logger.info(f"   Description: {info['description']}")
    
    def generate_response(
        self,
        text: str,
        game_state: str = "GENERAL",
        game_context: str = "default",
        state_data: Optional[Dict[str, Any]] = None,
        child_name: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Generate response using the configured generator.
        
        Args:
            text: User input text (from STT)
            game_state: Current game state
            game_context: Current game context
            state_data: Additional state data
            child_name: Child's name for personalization
            
        Returns:
            Dict with response_text, confidence, emotion, etc.
        """
        try:
            result = self.generator.generate_response(
                text=text,
                game_state=game_state,
                game_context=game_context,
                state_data=state_data,
                child_name=child_name
            )
            
            logger.info(f"Generated response using {result['generator_type']}: {result['response_text'][:50]}...")
            return result
            
        except Exception as e:
            logger.error(f"Response generation failed: {e}")
            import traceback
            logger.debug(traceback.format_exc())
            
            # Fallback response
            return {
                "response_text": "عذراً، حدث خطأ. دعنا نحاول مرة أخرى!",
                "response_key": "ERROR_FALLBACK",
                "confidence": 0.5,
                "emotion": "neutral",
                "generator_type": "fallback"
            }
    
    def get_generator_info(self) -> Dict[str, Any]:
        """Get information about the active generator."""
        return self.generator.get_info()
    
    def is_generator_available(self) -> bool:
        """Check if the generator is available."""
        return self.generator.is_available()
    
    def reload_generator(self, use_llm: Optional[bool] = None):
        """
        Reload generator (useful for switching without restart).
        
        Args:
            use_llm: If provided, override the config setting
        """
        if use_llm is not None:
            logger.info(f"Reloading generator with use_llm={use_llm}")
            self.generator = create_response_generator(use_llm=use_llm)
        else:
            logger.info("Reloading generator with current config")
            self._initialize_generator()
        
        info = self.generator.get_info()
        logger.info(f"✅ Generator reloaded: {info['name']}")


# Global instance
response_service = ResponseService()
