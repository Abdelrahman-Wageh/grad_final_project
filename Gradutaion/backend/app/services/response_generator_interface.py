"""
Response Generator Interface - Abstraction Layer
Allows switching between Legacy NLU and Fine-tuned Qwen LLM
"""

from abc import ABC, abstractmethod
from typing import Dict, Any, Optional
import logging

logger = logging.getLogger(__name__)


class ResponseGeneratorInterface(ABC):
    """
    Abstract interface for response generation.
    Implementations: Legacy NLU (rule-based) and Qwen LLM (generative)
    """
    
    @abstractmethod
    def generate_response(
        self,
        text: str,
        game_state: str,
        game_context: str,
        state_data: Optional[Dict[str, Any]] = None,
        child_name: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Generate a response based on input text and game state.
        
        Args:
            text: User input text (from STT)
            game_state: Current game state identifier
            game_context: Current game context
            state_data: Additional state information
            child_name: Child's name for personalization
            
        Returns:
            Dict with:
                - response_text: Generated response text
                - response_key: Response identifier (for NLU)
                - confidence: Confidence score (0.0 to 1.0)
                - emotion: Detected/suggested emotion
                - generator_type: 'nlu' or 'llm'
        """
        pass
    
    @abstractmethod
    def is_available(self) -> bool:
        """Check if the generator is available and ready."""
        pass
    
    @abstractmethod
    def get_info(self) -> Dict[str, Any]:
        """Get information about the generator."""
        pass


class LegacyNLUGenerator(ResponseGeneratorInterface):
    """Legacy rule-based NLU generator."""
    
    def __init__(self):
        from app.services.nlu_service import nlu_service
        self.nlu_service = nlu_service
        logger.info("✅ Legacy NLU Generator initialized")
    
    def generate_response(
        self,
        text: str,
        game_state: str,
        game_context: str,
        state_data: Optional[Dict[str, Any]] = None,
        child_name: Optional[str] = None
    ) -> Dict[str, Any]:
        """Generate response using rule-based NLU."""
        result = self.nlu_service.process(
            text=text,
            game_state=game_state,
            game_context=game_context,
            state_data=state_data
        )
        
        # Personalize with child's name if provided
        response_text = result.get("response_text", "")
        if child_name and "{name}" in response_text:
            response_text = response_text.replace("{name}", child_name)
        
        return {
            "response_text": response_text,
            "response_key": result.get("response_key", "UNKNOWN"),
            "confidence": result.get("confidence", 0.9),
            "emotion": result.get("emotion", "neutral"),
            "generator_type": "nlu"
        }
    
    def is_available(self) -> bool:
        """NLU is always available (rule-based)."""
        return True
    
    def get_info(self) -> Dict[str, Any]:
        """Get NLU generator information."""
        return {
            "type": "nlu",
            "name": "Legacy Rule-Based NLU",
            "description": "Deterministic rule-based response system",
            "always_available": True
        }


class QwenLLMGenerator(ResponseGeneratorInterface):
    """Qwen LLM generator - Placeholder mode (no AI models)."""
    
    def __init__(
        self,
        model_path: str = r"E:\Projects\Models\LLMs\Qwen\Qwen3-4B-GGUF",
        model_file: str = "qwen2.5-3b-instruct-q4_k_m.gguf"
    ):
        from app.config import settings
        self.model_path = settings.QWEN_MODEL_PATH
        self.model_file = settings.QWEN_MODEL_FILE
        self.model = None
        self._model_loaded = False
        logger.info("Qwen LLM Generator initialized in placeholder mode (no AI models)")
    
    def generate_response(
        self,
        text: str,
        game_state: str,
        game_context: str,
        state_data: Optional[Dict[str, Any]] = None,
        child_name: Optional[str] = None
    ) -> Dict[str, Any]:
        """Generate response (placeholder mode - no AI)."""
        import random
        
        # Placeholder responses
        responses = [
            "رائع! أنت بطل! 🌟",
            "ممتاز! استمر كده! 💪",
            "برافو! أنا فخور بيك! 🎉",
            "عظيم! يلا نكمل! 🚀",
            "تمام! أنت شاطر جداً! ⭐"
        ]
        
        response = random.choice(responses)
        
        return {
            "response_text": response,
            "response_key": f"LLM_{game_state}_{game_context}",
            "confidence": 0.85,
            "emotion": "happy",
            "generator_type": "llm_placeholder"
        }
    
    def _build_system_prompt(
        self,
        game_state: str,
        game_context: str,
        child_name: Optional[str] = None
    ) -> str:
        """Build system prompt for kid-safe, encouraging companion."""
        name_part = f" اسمه {child_name}" if child_name else ""
        
        return f"""أنت صديق مرح ومشجع للأطفال{name_part}. أنت تتحدث مع طفل مصري عمره بين 4-8 سنوات.

قواعد مهمة:
1. استخدم لغة بسيطة وواضحة مناسبة للأطفال
2. كن مشجعاً ومحفزاً دائماً - لا تستخدم كلمات سلبية
3. استخدم العامية المصرية بشكل طبيعي
4. كن مرحاً واستخدم الإيموجي أحياناً
5. اجعل الردود قصيرة (2-3 جمل فقط)
6. ركز على التشجيع والمساعدة
7. لا تتحدث عن مواضيع غير مناسبة للأطفال

السياق الحالي: {game_context}
حالة اللعبة: {game_state}

تذكر: أنت صديق الطفل المفضل في رحلة التعلم!"""
    
    def _apply_safety_filter(self, text: str) -> str:
        """Apply safety filter to ensure kid-safe content."""
        # List of inappropriate words/phrases (add more as needed)
        inappropriate_words = [
            # Add any words you want to filter
        ]
        
        text_lower = text.lower()
        for word in inappropriate_words:
            if word in text_lower:
                logger.warning(f"Safety filter triggered for word: {word}")
                return "دعنا نتحدث عن شيء آخر! ما رأيك نكمل اللعبة؟ 🎮"
        
        return text
    
    def _detect_emotion(self, text: str) -> str:
        """Simple emotion detection from text."""
        text_lower = text.lower()
        
        if any(word in text_lower for word in ["رائع", "ممتاز", "برافو", "عظيم", "😊", "🎉"]):
            return "happy"
        elif any(word in text_lower for word in ["حزين", "😢", "للأسف"]):
            return "sad"
        elif any(word in text_lower for word in ["مش فاهم", "صعب", "🤔"]):
            return "confused"
        else:
            return "neutral"
    
    def is_available(self) -> bool:
        """Check if Qwen model is loaded and ready."""
        return self._model_loaded
    
    def get_info(self) -> Dict[str, Any]:
        """Get Qwen generator information."""
        return {
            "type": "llm",
            "name": "Qwen LLM (Placeholder Mode)",
            "description": "No AI models - using placeholder responses",
            "loaded": False,
            "mode": "placeholder"
        }


# Factory function to create the appropriate generator
def create_response_generator(use_llm: bool = False) -> ResponseGeneratorInterface:
    """
    Factory function to create response generator.
    
    Args:
        use_llm: If True, use Qwen LLM. If False, use Legacy NLU.
        
    Returns:
        ResponseGeneratorInterface implementation
    """
    if use_llm:
        generator = QwenLLMGenerator()
        if generator.is_available():
            logger.info("✅ Using Qwen LLM Generator")
            return generator
        else:
            logger.warning("⚠️ Qwen LLM not available, falling back to Legacy NLU")
            return LegacyNLUGenerator()
    else:
        logger.info("✅ Using Legacy NLU Generator")
        return LegacyNLUGenerator()
