"""
NLU (Natural Language Understanding) Service - Rule-Based State Machine.
Deterministic, no generative LLMs. Uses YAML/JSON rules.
"""

import yaml
import json
import logging
from typing import Dict, Any, Optional
import os

from app.config import settings

logger = logging.getLogger(__name__)


class NLUService:
    """Rule-based NLU service - deterministic responses."""
    
    def __init__(self):
        self.rules = {}
        self._load_rules()
        # Also try to use existing service as fallback
        self._existing_service = None
        self._initialize_existing_service()
    
    def _initialize_existing_service(self):
        """Try to use existing NLU service as adapter."""
        try:
            import sys
            sys.path.append(os.path.join(os.path.dirname(__file__), '../../ai_backend'))
            from services.advanced_nlu_service import AdvancedNLUService
            self._existing_service = AdvancedNLUService()
            logger.info("Existing NLU service initialized as adapter")
        except Exception as e:
            logger.debug(f"Could not load existing NLU service: {e}")
    
    def _load_rules(self):
        """Load NLU rules from YAML/JSON file."""
        rules_file = os.path.join(os.path.dirname(__file__), "..", "..", "app", "services", "nlu_rules.yaml")
        
        # Create default rules if file doesn't exist
        if not os.path.exists(rules_file):
            default_rules = self._get_default_rules()
            self._save_default_rules(rules_file, default_rules)
            self.rules = default_rules
        else:
            try:
                with open(rules_file, 'r', encoding='utf-8') as f:
                    self.rules = yaml.safe_load(f) or {}
            except Exception as e:
                logger.error(f"Failed to load rules: {e}. Using defaults.")
                self.rules = self._get_default_rules()
    
    def _get_default_rules(self) -> Dict[str, Any]:
        """Default NLU rules with Egyptian Arabic patterns."""
        return {
            "patterns": {
                "greeting": {
                    "triggers": ["أهلاً", "مرحباً", "سلام", "إزيك"],
                    "responses": {
                        "default": "WELCOME_GREETING"
                    }
                },
                "help_request": {
                    "triggers": ["مش فاهم", "مش عارف", "ساعد", "مساعدة", "عايز مساعدة"],
                    "responses": {
                        "NUMBER_GATE_PUZZLE": "NUMBER_HINT_1",
                        "FOREST_ADVENTURE": "FOREST_HINT_1",
                        "default": "GENERAL_HELP"
                    }
                },
                "confusion": {
                    "triggers": ["مش عارف", "إيه ده", "مش فاهم إيه"],
                    "responses": {
                        "default": "CLARIFICATION"
                    }
                },
                "affirmation": {
                    "triggers": ["أيوه", "تمام", "صح", "ماشي"],
                    "responses": {
                        "default": "ENCOURAGEMENT"
                    }
                }
            },
            "responses": {
                "WELCOME_GREETING": "أهلاً وسهلاً! أنا صديقك في رحلة الغابة السحرية!",
                "NUMBER_HINT_1": "بص كويس جنب الشلال يا بطل! الأرقام موجودة هناك!",
                "FOREST_HINT_1": "انظر بين الأشجار! هناك شيء مميز ينتظرك!",
                "GENERAL_HELP": "لا تقلق! أنا هنا لمساعدتك. قولي محتاج إيه؟",
                "CLARIFICATION": "حبيبي، إيه اللي مش واضح؟ قولي عايز أعرف إيه؟",
                "ENCOURAGEMENT": "ممتاز! أنت بطل! كمل كده!"
            },
            "fallback": "عذراً، لم أفهم. ممكن تقول تاني؟"
        }
    
    def _save_default_rules(self, filepath: str, rules: Dict[str, Any]):
        """Save default rules to file."""
        try:
            os.makedirs(os.path.dirname(filepath), exist_ok=True)
            with open(filepath, 'w', encoding='utf-8') as f:
                yaml.dump(rules, f, allow_unicode=True, default_flow_style=False)
        except Exception as e:
            logger.warning(f"Could not save default rules: {e}")
    
    def process(
        self, 
        text: str, 
        game_state: str, 
        game_context: str,
        state_data: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        """
        Process text and return response key and text.
        
        Args:
            text: Transcribed text
            game_state: Current game state
            game_context: Current game context
            state_data: Additional state data
            
        Returns:
            Dict with 'response_key', 'response_text', 'confidence', 'emotion'
        """
        # Try existing service first if available
        if self._existing_service:
            try:
                result = self._existing_service.process(
                    text=text,
                    game_state=game_state,
                    game_context=game_context,
                    state_data=state_data or {}
                )
                return {
                    "response_key": f"NLU_{game_state}_{game_context}",
                    "response_text": result.get("response", ""),
                    "confidence": result.get("confidence", 0.9),
                    "emotion": result.get("emotion", "neutral")
                }
            except Exception as e:
                logger.debug(f"Existing service failed: {e}")
        
        # Use rule-based matching
        text_lower = text.lower()
        
        # Match patterns
        for pattern_name, pattern_config in self.rules.get("patterns", {}).items():
            triggers = pattern_config.get("triggers", [])
            if any(trigger in text_lower for trigger in triggers):
                # Found match - get response for this game state
                responses = pattern_config.get("responses", {})
                response_key = responses.get(game_state) or responses.get("default", "GENERAL_RESPONSE")
                
                # Get response text
                response_texts = self.rules.get("responses", {})
                response_text = response_texts.get(response_key, self.rules.get("fallback", "حاول تاني!"))
                
                return {
                    "response_key": response_key,
                    "response_text": response_text,
                    "confidence": 0.9,
                    "emotion": "neutral"
                }
        
        # No match - use fallback
        fallback = self.rules.get("fallback", "حاول تاني!")
        return {
            "response_key": "FALLBACK",
            "response_text": fallback,
            "confidence": 0.5,
            "emotion": "neutral"
        }


# Global instance
nlu_service = NLUService()

