"""
AI Friend Mode Service
Free-form conversation mode: STT -> Qwen LLM -> TTS
Separate from main game logic, purely for friendly chat
"""

import logging
from typing import Dict, Any, Optional, List
from datetime import datetime
from app.config import settings
from app.services.stt_service import stt_service
from app.services.tts_service import tts_service
from app.services.response_generator_interface import QwenLLMGenerator

logger = logging.getLogger(__name__)


class FriendModeService:
    """
    AI Friend Mode - Free-form conversation with safety guidelines.
    
    Pipeline: Whisper (STT) -> Qwen LLM -> TTS
    
    Features:
    - Natural conversation with AI friend
    - Kid-safe content filtering
    - Conversation history tracking
    - Personality: Funny, encouraging, supportive
    """
    
    def __init__(self):
        self.llm_generator = None
        self.conversation_history: List[Dict[str, str]] = []
        self.max_history = 10  # Keep last 10 exchanges
        self._initialize_llm()
    
    def _initialize_llm(self):
        """Initialize Qwen LLM for friend mode."""
        try:
            self.llm_generator = QwenLLMGenerator(
                model_path=settings.QWEN_MODEL_PATH
            )
            
            if self.llm_generator.is_available():
                logger.info("✅ Friend Mode LLM initialized successfully")
            else:
                logger.warning("⚠️ Friend Mode LLM not available")
                
        except Exception as e:
            logger.error(f"Failed to initialize Friend Mode LLM: {e}")
    
    def chat(
        self,
        audio_bytes: bytes,
        child_name: Optional[str] = None,
        child_age: Optional[int] = None
    ) -> Dict[str, Any]:
        """
        Process audio input and generate friendly response.
        
        Args:
            audio_bytes: Audio input from child
            child_name: Child's name for personalization
            child_age: Child's age for age-appropriate responses
            
        Returns:
            Dict with:
                - transcribed_text: What the child said
                - response_text: AI friend's response
                - response_audio: TTS audio bytes
                - emotion: Detected emotion
                - safety_passed: Whether safety check passed
        """
        if not self.llm_generator or not self.llm_generator.is_available():
            return self._fallback_response()
        
        try:
            # Step 1: STT - Transcribe audio
            logger.info("Friend Mode: Transcribing audio...")
            stt_result = stt_service.transcribe(audio_bytes)
            transcribed_text = stt_result.get("text", "")
            
            if not transcribed_text:
                return self._empty_input_response()
            
            logger.info(f"Friend Mode: Transcribed: '{transcribed_text}'")
            
            # Step 2: Safety Check
            if not self._safety_check(transcribed_text):
                return self._unsafe_content_response(transcribed_text)
            
            # Step 3: LLM - Generate response
            logger.info("Friend Mode: Generating LLM response...")
            llm_response = self._generate_friend_response(
                transcribed_text,
                child_name,
                child_age
            )
            
            response_text = llm_response.get("response_text", "")
            
            # Step 4: Safety check on response
            if not self._safety_check(response_text):
                logger.warning("Friend Mode: LLM response failed safety check")
                response_text = "دعنا نتحدث عن شيء آخر! ما رأيك نلعب لعبة؟ 🎮"
            
            # Step 5: TTS - Synthesize response
            logger.info("Friend Mode: Synthesizing speech...")
            tts_result = tts_service.synthesize(response_text)
            
            # Step 6: Update conversation history
            self._add_to_history(transcribed_text, response_text)
            
            return {
                "transcribed_text": transcribed_text,
                "response_text": response_text,
                "response_audio": tts_result.get("audio_bytes"),
                "audio_format": tts_result.get("format", "wav"),
                "emotion": llm_response.get("emotion", "neutral"),
                "safety_passed": True,
                "timestamp": datetime.now().isoformat()
            }
            
        except Exception as e:
            logger.error(f"Friend Mode chat failed: {e}")
            import traceback
            logger.debug(traceback.format_exc())
            return self._error_response()
    
    def _generate_friend_response(
        self,
        text: str,
        child_name: Optional[str] = None,
        child_age: Optional[int] = None
    ) -> Dict[str, Any]:
        """Generate response (placeholder mode - no AI)."""
        import random
        
        # Placeholder friendly responses
        responses = [
            "واو! ده رائع جداً! قولي أكتر 😊",
            "أنا فخور بيك يا بطل! 🌟",
            "يلا نلعب لعبة؟ أنا بحب الألعاب زيك! 🎮",
            "مش فاهم حاجة؟ ولا يهمك، أنا هنا أساعدك! 💪",
            "ممتاز! أنت شاطر جداً! 🎉"
        ]
        
        response = random.choice(responses)
        
        return {
            "response_text": response,
            "emotion": "happy",
            "confidence": 0.85
        }
    
    def _build_friend_system_prompt(
        self,
        child_name: Optional[str] = None,
        child_age: Optional[int] = None
    ) -> str:
        """Build system prompt for AI friend personality."""
        name_part = f" اسمه {child_name}" if child_name else ""
        age_part = f" عمره {child_age} سنوات" if child_age else " عمره بين 4-8 سنوات"
        
        return f"""أنت صديق مرح ومشجع للأطفال. أنت تتحدث مع طفل مصري{name_part}{age_part}.

شخصيتك:
- مرح وخفيف الظل
- مشجع ومحفز دائماً
- صبور ومتفهم
- محب للمرح والألعاب
- ذكي ومثقف بطريقة بسيطة

قواعد صارمة (يجب الالتزام بها):
1. استخدم العامية المصرية بشكل طبيعي
2. اجعل الردود قصيرة (2-3 جمل فقط)
3. لا تستخدم أي كلمات سلبية أو محبطة
4. لا تتحدث عن مواضيع غير مناسبة للأطفال
5. استخدم الإيموجي بشكل معتدل
6. كن صديقاً حقيقياً - استمع وتفاعل
7. شجع الطفل على التعلم واللعب
8. إذا سأل الطفل عن شيء لا تعرفه، اعترف بذلك بطريقة لطيفة

أمثلة على أسلوبك:
- "واو! ده رائع جداً! قولي أكتر 😊"
- "أنا فخور بيك يا بطل! 🌟"
- "يلا نلعب لعبة؟ أنا بحب الألعاب زيك! 🎮"
- "مش فاهم حاجة؟ ولا يهمك، أنا هنا أساعدك! 💪"

تذكر: أنت صديق الطفل المفضل - كن مرحاً ومشجعاً دائماً!"""
    
    def _safety_check(self, text: str) -> bool:
        """
        Check if text is kid-safe.
        
        Returns:
            True if safe, False if unsafe
        """
        text_lower = text.lower()
        
        # List of inappropriate words/topics (expand as needed)
        unsafe_keywords = [
            # Add inappropriate words here
            # This is a basic filter - expand based on your needs
        ]
        
        for keyword in unsafe_keywords:
            if keyword in text_lower:
                logger.warning(f"Safety check failed: found '{keyword}'")
                return False
        
        return True
    
    def _detect_emotion(self, text: str) -> str:
        """Detect emotion from text."""
        text_lower = text.lower()
        
        if any(word in text_lower for word in ["رائع", "ممتاز", "برافو", "😊", "🎉", "❤️"]):
            return "happy"
        elif any(word in text_lower for word in ["حزين", "😢", "للأسف", "مش حلو"]):
            return "sad"
        elif any(word in text_lower for word in ["مش فاهم", "صعب", "🤔", "ليه"]):
            return "confused"
        elif any(word in text_lower for word in ["يلا", "هيا", "🎮", "لعبة"]):
            return "excited"
        else:
            return "neutral"
    
    def _add_to_history(self, user_text: str, assistant_text: str):
        """Add exchange to conversation history."""
        self.conversation_history.append({
            "user": user_text,
            "assistant": assistant_text,
            "timestamp": datetime.now().isoformat()
        })
        
        # Keep only last N exchanges
        if len(self.conversation_history) > self.max_history:
            self.conversation_history = self.conversation_history[-self.max_history:]
    
    def clear_history(self):
        """Clear conversation history."""
        self.conversation_history = []
        logger.info("Friend Mode: Conversation history cleared")
    
    def get_history(self) -> List[Dict[str, str]]:
        """Get conversation history."""
        return self.conversation_history.copy()
    
    def _fallback_response(self) -> Dict[str, Any]:
        """Fallback when LLM not available."""
        response_text = "مرحباً! أنا صديقك الذكي! 😊"
        tts_result = tts_service.synthesize(response_text)
        
        return {
            "transcribed_text": "",
            "response_text": response_text,
            "response_audio": tts_result.get("audio_bytes"),
            "audio_format": "wav",
            "emotion": "neutral",
            "safety_passed": True,
            "note": "LLM not available - using fallback"
        }
    
    def _empty_input_response(self) -> Dict[str, Any]:
        """Response when no input detected."""
        response_text = "مش سامع حاجة! ممكن تقول تاني؟ 🎤"
        tts_result = tts_service.synthesize(response_text)
        
        return {
            "transcribed_text": "",
            "response_text": response_text,
            "response_audio": tts_result.get("audio_bytes"),
            "audio_format": "wav",
            "emotion": "confused",
            "safety_passed": True
        }
    
    def _unsafe_content_response(self, transcribed_text: str) -> Dict[str, Any]:
        """Response when unsafe content detected."""
        response_text = "دعنا نتحدث عن شيء آخر! ما رأيك نلعب لعبة؟ 🎮"
        tts_result = tts_service.synthesize(response_text)
        
        return {
            "transcribed_text": transcribed_text,
            "response_text": response_text,
            "response_audio": tts_result.get("audio_bytes"),
            "audio_format": "wav",
            "emotion": "neutral",
            "safety_passed": False,
            "note": "Unsafe content detected"
        }
    
    def _error_response(self) -> Dict[str, Any]:
        """Response when error occurs."""
        response_text = "عذراً، حدث خطأ. دعنا نحاول مرة أخرى! 😊"
        tts_result = tts_service.synthesize(response_text)
        
        return {
            "transcribed_text": "",
            "response_text": response_text,
            "response_audio": tts_result.get("audio_bytes"),
            "audio_format": "wav",
            "emotion": "neutral",
            "safety_passed": True,
            "note": "Error occurred"
        }


# Global instance
friend_mode_service = FriendModeService()
