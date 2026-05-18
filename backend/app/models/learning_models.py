"""
Pydantic models for learning app features:
- Courses and Lessons
- Quiz and Questions
- Rewards and Badges
- Progress Tracking
- User Profile and Avatar
- Daily Challenges
- Learning Map
- Parent Dashboard
- Shop Items
"""

from pydantic import BaseModel, Field
from typing import Optional, Dict, Any, List
from datetime import datetime, timezone
from enum import Enum


# ==================== ENUMS ====================
class DifficultyLevel(str, Enum):
    """Difficulty levels for courses and quizzes."""
    EASY = "easy"
    MEDIUM = "medium"
    HARD = "hard"


class SubjectType(str, Enum):
    """Subject types available in the app."""
    MATH = "math"
    SCIENCE = "science"
    ENGLISH = "english"
    ARABIC = "arabic"
    ART_AND_CRAFT = "art_and_craft"
    LIFE_SKILLS = "life_skills"
    CODING = "coding"


class BadgeType(str, Enum):
    """Types of badges that can be earned."""
    FIRST_LESSON = "first_lesson"
    PERFECT_SCORE = "perfect_score"
    QUICK_THINKER = "quick_thinker"
    HELPER_HARD = "helper_hard"
    EXPLORER = "explorer"
    SUPER_LEARNER = "super_learner"


class ShopItemType(str, Enum):
    """Types of shop items."""
    AVATAR_CLOTHES = "avatar_clothes"
    AVATAR_ACCESSORIES = "avatar_accessories"
    AVATAR_SKIN = "avatar_skin"
    AVATAR_HAIR = "avatar_hair"
    AVATAR = "avatar"
    POWER_UP = "power_up"


class IslandType(str, Enum):
    """Types of islands in gamified learning map."""
    NUMBERS_WORLD = "numbers_world"
    MULTIPLICATION_FOREST = "multiplication_forest"
    DIVISION_CASTLE = "division_castle"
    ALPHABET_ISLAND = "alphabet_island"
    SCIENCE_LAB = "science_lab"
    CODING_GALAXY = "coding_galaxy"


# ==================== COURSE & LESSON ====================
class LessonCharacter(BaseModel):
    """Character information for a lesson."""
    character_id: str = Field(..., description="Unique character identifier")
    name: str = Field(..., description="Character name")
    avatar_url: str = Field(..., description="Character avatar image URL")
    personality: str = Field(..., description="Character personality/style")
    greeting: str = Field(..., description="Character greeting message")
    encouragement_phrases: List[str] = Field(
        default_factory=list,
        description="List of encouragement phrases the character can say"
    )


class LessonContent(BaseModel):
    """Content structure for a lesson."""
    title: str = Field(..., description="Lesson title")
    description: str = Field(..., description="Lesson description")
    learning_objectives: List[str] = Field(..., description="What the student will learn")
    content_sections: List[Dict[str, Any]] = Field(..., description="Main lesson content")
    character: LessonCharacter = Field(..., description="Character for this lesson")
    estimated_duration_minutes: int = Field(..., description="Estimated time to complete")
    interactive_elements: List[Dict[str, Any]] = Field(
        default_factory=list,
        description="Interactive components (animations, drawings, etc.)"
    )


class Lesson(BaseModel):
    """Lesson model."""
    lesson_id: str = Field(..., description="Unique lesson identifier")
    course_id: str = Field(..., description="Parent course ID")
    title: str = Field(..., description="Lesson title")
    order: int = Field(..., description="Order in course sequence")
    difficulty: DifficultyLevel = Field(..., description="Difficulty level")
    thumbnail_url: str = Field(..., description="Lesson thumbnail image")
    content: LessonContent = Field(..., description="Lesson content details")
    is_locked: bool = Field(default=False, description="Is lesson locked")
    unlock_requirement: Optional[str] = Field(None, description="Requirement to unlock")
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


class Course(BaseModel):
    """Course model."""
    course_id: str = Field(..., description="Unique course identifier")
    title: str = Field(..., description="Course title")
    description: str = Field(..., description="Course description")
    subject: SubjectType = Field(..., description="Subject category")
    difficulty: DifficultyLevel = Field(..., description="Overall difficulty")
    icon_url: str = Field(..., description="Course icon/thumbnail")
    color_code: str = Field(default="#6366F1", description="Color code for course")
    lessons: List[Lesson] = Field(default_factory=list, description="List of lessons")
    total_duration_minutes: int = Field(..., description="Total course duration")
    age_range: str = Field(..., description="Recommended age range")
    learning_outcomes: List[str] = Field(..., description="What students will learn")
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


# ==================== QUIZ & QUESTIONS ====================
class QuizOption(BaseModel):
    """A quiz question option/answer choice."""
    option_id: str = Field(..., description="Unique option identifier")
    text: str = Field(..., description="Option text")
    is_correct: bool = Field(..., description="Is this the correct answer")
    feedback: str = Field(..., description="Feedback if selected")
    image_url: Optional[str] = Field(None, description="Optional image for option")


class QuizQuestion(BaseModel):
    """A quiz question."""
    question_id: str = Field(..., description="Unique question identifier")
    quiz_id: str = Field(..., description="Parent quiz ID")
    order: int = Field(..., description="Question order in quiz")
    question_text: str = Field(..., description="The question text")
    question_image_url: Optional[str] = Field(None, description="Optional question image")
    question_type: str = Field(default="multiple_choice", description="Type: multiple_choice, true_false, fill_blank")
    options: List[QuizOption] = Field(..., description="Answer options")
    time_limit_seconds: Optional[int] = Field(None, description="Time limit for this question")
    difficulty: DifficultyLevel = Field(..., description="Question difficulty")
    hints: List[str] = Field(default_factory=list, description="Available hints")


class Quiz(BaseModel):
    """Quiz model."""
    quiz_id: str = Field(..., description="Unique quiz identifier")
    lesson_id: str = Field(..., description="Associated lesson ID")
    title: str = Field(..., description="Quiz title")
    description: str = Field(..., description="Quiz description")
    questions: List[QuizQuestion] = Field(..., description="List of questions")
    passing_score_percentage: int = Field(default=70, description="Passing score %")
    total_time_seconds: int = Field(..., description="Total quiz time")
    shuffle_questions: bool = Field(default=True, description="Randomize question order")
    show_score_immediately: bool = Field(default=True, description="Show score right after")
    retake_allowed: bool = Field(default=True, description="Can student retake quiz")
    max_retakes: Optional[int] = Field(None, description="Max retake attempts")


class QuizAttempt(BaseModel):
    """Record of a quiz attempt by a student."""
    attempt_id: str = Field(..., description="Unique attempt identifier")
    quiz_id: str = Field(..., description="Quiz ID")
    user_id: str = Field(..., description="User/Student ID")
    score_percentage: float = Field(..., description="Score as percentage")
    answers: Dict[str, str] = Field(..., description="Question ID -> Answer mapping")
    time_spent_seconds: int = Field(..., description="Time spent on quiz")
    passed: bool = Field(..., description="Did student pass")
    attempted_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


# ==================== REWARDS & BADGES ====================
class Badge(BaseModel):
    """Badge that can be earned."""
    badge_id: str = Field(..., description="Unique badge identifier")
    name: str = Field(..., description="Badge name")
    description: str = Field(..., description="Badge description")
    icon_url: str = Field(..., description="Badge icon image")
    badge_type: BadgeType = Field(..., description="Type of badge")
    requirement: str = Field(..., description="How to earn this badge")
    rarity: str = Field(default="common", description="Rarity: common, rare, epic, legendary")
    points_value: int = Field(default=10, description="Points earned for this badge")


class EarnedBadge(BaseModel):
    """Badge earned by a user."""
    earned_id: str = Field(..., description="Unique earned badge record ID")
    user_id: str = Field(..., description="User ID")
    badge_id: str = Field(..., description="Badge ID")
    badge: Badge = Field(..., description="Badge details")
    earned_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


class Reward(BaseModel):
    """Reward earned by completing activities."""
    reward_id: str = Field(..., description="Unique reward identifier")
    user_id: str = Field(..., description="User ID")
    title: str = Field(..., description="Reward title")
    coins_earned: int = Field(default=0, description="Coins earned")
    gems_earned: int = Field(default=0, description="Gems earned")
    points_earned: int = Field(default=0, description="Points earned")
    reason: str = Field(..., description="Why this reward was earned")
    earned_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


# ==================== PROGRESS TRACKING ====================
class LessonProgress(BaseModel):
    """Progress on a specific lesson."""
    lesson_id: str = Field(..., description="Lesson ID")
    completion_percentage: float = Field(default=0, description="Completion %")
    completed: bool = Field(default=False, description="Is lesson completed")
    quiz_score: Optional[float] = Field(None, description="Quiz score if completed")
    attempts: int = Field(default=0, description="Number of attempts")
    time_spent_seconds: int = Field(default=0, description="Time spent on lesson")
    started_at: Optional[datetime] = Field(None, description="When lesson was started")
    completed_at: Optional[datetime] = Field(None, description="When lesson was completed")


class CourseProgress(BaseModel):
    """Progress on a specific course."""
    course_id: str = Field(..., description="Course ID")
    lessons_completed: int = Field(default=0, description="Lessons completed")
    total_lessons: int = Field(..., description="Total lessons in course")
    completion_percentage: float = Field(default=0, description="Overall course completion %")
    average_score: float = Field(default=0, description="Average quiz score")
    total_time_minutes: int = Field(default=0, description="Total time spent")
    started_at: Optional[datetime] = Field(None, description="When course was started")
    completed_at: Optional[datetime] = Field(None, description="When course was completed")


class UserProgress(BaseModel):
    """Overall progress tracking for a user."""
    user_id: str = Field(..., description="User ID")
    total_lessons_completed: int = Field(default=0, description="Total lessons completed")
    total_courses_completed: int = Field(default=0, description="Total courses completed")
    total_study_time_minutes: int = Field(default=0, description="Total study time")
    current_streak_days: int = Field(default=0, description="Current learning streak")
    longest_streak_days: int = Field(default=0, description="Longest streak")
    total_points: int = Field(default=0, description="Total points earned")
    current_level: int = Field(default=1, description="Current level")
    badges_earned: int = Field(default=0, description="Total badges earned")
    course_progress: List[CourseProgress] = Field(default_factory=list, description="Course progress list")
    lesson_progress: List[LessonProgress] = Field(default_factory=list, description="Lesson progress list")
    last_activity_at: Optional[datetime] = Field(None, description="Last activity timestamp")


# ==================== USER PROFILE & AVATAR ====================
class AvatarCustomization(BaseModel):
    """User's avatar customization."""
    avatar_id: str = Field(..., description="Base avatar ID")
    outfit: str = Field(default="default", description="Outfit ID")
    accessories: List[str] = Field(default_factory=list, description="Accessory IDs")
    skin_tone: str = Field(default="medium", description="Skin tone")
    hair_style: str = Field(default="default", description="Hair style ID")
    hair_color: str = Field(default="brown", description="Hair color")
    facial_features: Dict[str, str] = Field(default_factory=dict, description="Facial features")


class UserProfile(BaseModel):
    """User/Student profile."""
    user_id: str = Field(..., description="Unique user identifier")
    name: str = Field(..., description="Student name")
    age: int = Field(..., description="Student age")
    avatar: AvatarCustomization = Field(..., description="Avatar customization")
    total_coins: int = Field(default=100, description="Total coins (soft currency)")
    total_gems: int = Field(default=0, description="Total gems (hard currency)")
    inventory: Dict[str, int] = Field(default_factory=dict, description="Item ID -> Quantity")
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    last_login_at: Optional[datetime] = Field(None, description="Last login time")
    daily_challenge_completed_today: bool = Field(default=False, description="Completed daily challenge today")
    offline_mode: bool = Field(default=False, description="Is using offline mode")


# ==================== DAILY CHALLENGE ====================
class DailyChallenge(BaseModel):
    """Daily challenge for a student."""
    challenge_id: str = Field(..., description="Unique challenge ID")
    user_id: str = Field(..., description="User ID")
    date: str = Field(..., description="Date of challenge (YYYY-MM-DD)")
    challenge_type: str = Field(..., description="Type: quiz, lesson, drawing, math")
    title: str = Field(..., description="Challenge title")
    description: str = Field(..., description="Challenge description")
    difficulty: DifficultyLevel = Field(..., description="Challenge difficulty")
    reward_coins: int = Field(default=50, description="Coins for completing")
    reward_gems: int = Field(default=5, description="Gems for completing")
    content: Dict[str, Any] = Field(..., description="Challenge content/questions")
    is_completed: bool = Field(default=False, description="Is challenge completed")
    completed_at: Optional[datetime] = Field(None, description="When completed")
    score: Optional[float] = Field(None, description="Score if applicable")
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


# ==================== LEARNING MAP ====================
class Island(BaseModel):
    """Island in the gamified learning map."""
    island_id: str = Field(..., description="Unique island identifier")
    island_type: IslandType = Field(..., description="Type of island")
    name: str = Field(..., description="Island name")
    description: str = Field(..., description="Island description")
    theme_image_url: str = Field(..., description="Island background image")
    level_number: int = Field(..., description="Which level/position this is")
    courses: List[str] = Field(default_factory=list, description="Course IDs on this island")
    is_unlocked: bool = Field(default=False, description="Is island unlocked")
    unlock_requirement: str = Field(..., description="Requirement to unlock")


class LearningMap(BaseModel):
    """Gamified learning map with islands."""
    map_id: str = Field(..., description="Unique map identifier")
    user_id: str = Field(..., description="User ID")
    islands: List[Island] = Field(..., description="List of islands")
    current_island: int = Field(default=0, description="Current island index")
    completed_islands: int = Field(default=0, description="Islands completed")
    total_islands: int = Field(..., description="Total islands available")


# ==================== PARENT DASHBOARD ====================
class DailyStudyStats(BaseModel):
    """Daily study statistics."""
    date: str = Field(..., description="Date (YYYY-MM-DD)")
    study_time_minutes: int = Field(default=0, description="Total study time")
    lessons_completed: int = Field(default=0, description="Lessons completed")
    quiz_score_average: float = Field(default=0, description="Average quiz score")
    badges_earned: int = Field(default=0, description="Badges earned")


class StudentDashboard(BaseModel):
    """Dashboard data for a student (shown to parents)."""
    student_id: str = Field(..., description="Student ID")
    student_name: str = Field(..., description="Student name")
    total_study_time_hours: int = Field(default=0, description="Total study hours")
    lessons_completed: int = Field(default=0, description="Lessons completed")
    courses_in_progress: int = Field(default=0, description="Active courses")
    average_score: float = Field(default=0, description="Average quiz score")
    current_streak: int = Field(default=0, description="Current learning streak")
    total_badges: int = Field(default=0, description="Total badges earned")
    daily_stats_7_days: List[DailyStudyStats] = Field(..., description="Last 7 days of stats")
    recent_lessons: List[Dict[str, Any]] = Field(default_factory=list, description="Recently completed lessons")
    learning_areas: Dict[str, float] = Field(..., description="Subject -> Progress %")


# ==================== SHOP ====================
class ShopItem(BaseModel):
    """Item available in the shop."""
    item_id: str = Field(..., description="Unique item identifier")
    name: str = Field(..., description="Item name")
    description: str = Field(..., description="Item description")
    item_type: ShopItemType = Field(..., description="Type of item")
    image_url: str = Field(..., description="Item image")
    price_coins: Optional[int] = Field(None, description="Price in coins")
    price_gems: Optional[int] = Field(None, description="Price in gems")
    rarity: str = Field(default="common", description="Item rarity")
    category: str = Field(..., description="Item category")
    is_limited: bool = Field(default=False, description="Is limited-time item")
    stock: Optional[int] = Field(None, description="Stock count if limited")


class UserInventory(BaseModel):
    """User's inventory of purchased items."""
    inventory_id: str = Field(..., description="Unique inventory record ID")
    user_id: str = Field(..., description="User ID")
    item_id: str = Field(..., description="Item ID")
    quantity: int = Field(default=1, description="Quantity owned")
    purchased_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


# ==================== API REQUEST/RESPONSE ====================
class CourseListResponse(BaseModel):
    """Response for listing courses."""
    courses: List[Course] = Field(..., description="List of courses")
    total_count: int = Field(..., description="Total number of courses")


class UserProgressResponse(BaseModel):
    """Response with user progress."""
    user_id: str = Field(..., description="User ID")
    progress: UserProgress = Field(..., description="Progress data")
    badges: List[EarnedBadge] = Field(..., description="Earned badges")
    rewards_today: List[Reward] = Field(..., description="Rewards earned today")


class QuizSubmissionRequest(BaseModel):
    """Request to submit quiz answers."""
    quiz_id: str = Field(..., description="Quiz ID")
    user_id: str = Field(..., description="User ID")
    answers: Dict[str, str] = Field(..., description="Question ID -> Answer mapping")
    time_spent_seconds: int = Field(..., description="Time spent on quiz")


class QuizSubmissionResponse(BaseModel):
    """Response after quiz submission."""
    attempt_id: str = Field(..., description="Attempt record ID")
    quiz_id: str = Field(..., description="Quiz ID")
    score_percentage: float = Field(..., description="Score percentage")
    passed: bool = Field(..., description="Did student pass")
    rewards_earned: Reward = Field(..., description="Rewards for completing")
    badges_earned: List[Badge] = Field(default_factory=list, description="Badges earned")
    detailed_feedback: Dict[str, str] = Field(default_factory=dict, description="Question-by-question feedback")
