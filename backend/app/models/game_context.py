"""
Game Context Models
Defines the game state that Smartino needs to be aware of
"""

from enum import Enum
from typing import Optional, List, Dict
from pydantic import BaseModel, Field


class GameChapter(str, Enum):
    """Game chapters/worlds"""
    COLORS = "colors"
    ANIMALS = "animals"
    NUMBERS = "numbers"


class GameContext(BaseModel):
    """
    Current game state context for AI responses.
    
    This tells Smartino:
    - Where the child is in the game
    - What they're learning
    - What task they're working on
    """
    
    chapter: GameChapter = Field(
        ...,
        description="Current game chapter (colors, animals, numbers)"
    )
    
    level: int = Field(
        default=1,
        ge=1,
        le=10,
        description="Current level within the chapter"
    )
    
    current_task: str = Field(
        ...,
        description="What the child is currently trying to do",
        examples=["ابحث عن اللون الأحمر", "اطعم القطة", "عد من 1 إلى 5"]
    )
    
    child_name: str = Field(
        default="أحمد",
        description="Child's name for personalization"
    )
    
    child_age: int = Field(
        default=6,
        ge=4,
        le=8,
        description="Child's age (4-8 years)"
    )
    
    score: int = Field(
        default=0,
        ge=0,
        description="Current score/points"
    )
    
    recent_actions: List[str] = Field(
        default_factory=list,
        description="Recent actions the child took (for context)"
    )
    
    class Config:
        json_schema_extra = {
            "example": {
                "chapter": "colors",
                "level": 1,
                "current_task": "ابحث عن اللون الأحمر في المدينة",
                "child_name": "أحمد",
                "child_age": 6,
                "score": 10,
                "recent_actions": ["found_blue", "tried_red"]
            }
        }


# Game world definitions
GAME_WORLDS: Dict[GameChapter, Dict] = {
    GameChapter.COLORS: {
        "name": "مدينة الألوان المفقودة",
        "emoji": "🎨",
        "concepts": ["أحمر", "أزرق", "أخضر", "أصفر", "برتقالي", "بنفسجي"],
        "description": "مدينة سحرية فقدت ألوانها، ساعد سمارتينو في إعادة الألوان!"
    },
    GameChapter.ANIMALS: {
        "name": "حديقة الحيوانات الناطقة",
        "emoji": "🦁",
        "concepts": ["قطة", "كلب", "عصفور", "سمكة", "أرنب", "فيل"],
        "description": "حديقة مليئة بالحيوانات الودودة التي تحب اللعب!"
    },
    GameChapter.NUMBERS: {
        "name": "قلعة الأرقام السحرية",
        "emoji": "🔢",
        "concepts": ["واحد", "اتنين", "تلاتة", "أربعة", "خمسة", "ستة", "سبعة", "تمانية", "تسعة", "عشرة"],
        "description": "قلعة سحرية حيث الأرقام تحمي الكنوز!"
    }
}


def build_game_system_prompt(game_context: GameContext) -> str:
    """
    Build game-aware system prompt based on current game state.
    
    Args:
        game_context: Current game state
        
    Returns:
        System prompt string for Qwen LLM
    """
    world = GAME_WORLDS[game_context.chapter]
    
    prompt = f"""أنت سمارتينو 🌟، الصديق الذكي والمرح للأطفال في لعبة تعليمية.

═══════════════════════════════════════════════════════════
معلومات عنك:
═══════════════════════════════════════════════════════════
- الاسم: سمارتينو
- الدور: صديق ومرشد في رحلة التعلم
- الشخصية: مرح، مشجع، صبور، محب للألعاب
- اللغة: العامية المصرية الطبيعية

═══════════════════════════════════════════════════════════
الوضع الحالي في اللعبة:
═══════════════════════════════════════════════════════════
- العالم: {world['emoji']} {world['name']}
- الوصف: {world['description']}
- المستوى: {game_context.level}
- المهمة الحالية: {game_context.current_task}
- النقاط: {game_context.score}

- اسم الطفل: {game_context.child_name}
- عمر الطفل: {game_context.child_age} سنوات

═══════════════════════════════════════════════════════════
المفاهيم التي نتعلمها:
═══════════════════════════════════════════════════════════
{', '.join(world['concepts'])}

═══════════════════════════════════════════════════════════
قواعد صارمة (يجب الالتزام بها):
═══════════════════════════════════════════════════════════
1. استخدم العامية المصرية بشكل طبيعي (مش، عايز، يلا، برافو)
2. الردود قصيرة جداً: 2-3 جمل فقط (مهم جداً!)
3. لا تستخدم كلمات سلبية أو محبطة أبداً
4. استخدم الإيموجي بشكل معتدل (1-2 في الرد)
5. كن مرحاً وخفيف الظل
6. إذا أخطأ الطفل، شجعه: "مش مشكلة! حاول تاني!"
7. احتفل بكل نجاح: "برافو عليك! جامد أوي!"
8. ركز على المهمة الحالية في اللعبة
9. اربط إجاباتك بعالم اللعبة الحالي

═══════════════════════════════════════════════════════════
أسلوب الحديث (أمثلة):
═══════════════════════════════════════════════════════════
- "يلا بينا نلاقي اللون الأحمر! 🎨"
- "برافو عليك يا {game_context.child_name}! جامد أوي! 🌟"
- "مش مشكلة، حاول تاني! أنا واثق فيك! 💪"
- "واو! عرفت الإجابة! أنت شاطر جداً! 🎉"

═══════════════════════════════════════════════════════════
تذكر:
═══════════════════════════════════════════════════════════
- أنت داخل اللعبة، مش خارجها
- أنت شخصية حقيقية في عالم {world['name']}
- ساعد {game_context.child_name} في المهمة: {game_context.current_task}
- كن صديقاً حقيقياً، ليس معلماً صارماً
- الردود القصيرة أفضل للأطفال!
"""
    
    return prompt
