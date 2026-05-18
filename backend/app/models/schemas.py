"""
Pydantic schemas for request/response validation.
Ensures type safety for API endpoints.
"""

from pydantic import BaseModel, Field
from typing import Optional, Dict, Any, List
from datetime import datetime, timezone


# Adventure Speech Request/Response
class GameState(BaseModel):
    """Current game state information."""
    state: str = Field(..., description="Current game state (e.g., 'FOREST_ADVENTURE', 'NUMBER_GATE_PUZZLE')")
    context: str = Field(..., description="Game context (e.g., 'introduction', 'puzzle_solving')")
    level: Optional[int] = Field(None, description="Current level number")
    state_data: Optional[Dict[str, Any]] = Field(default_factory=dict, description="Additional state data")


class AdventureSpeechRequest(BaseModel):
    """Request for adventure speech endpoint."""
    audio_base64: str = Field(..., description="Audio file encoded as base64")
    audio_format: str = Field(default="wav", description="Audio format (wav, mp3, m4a)")
    game_state: GameState = Field(..., description="Current game state and context")
    player_id: Optional[str] = Field(None, description="Player identifier for logging")
    character_type: Optional[str] = Field(None, description="Selected character type")


class ResponseMetadata(BaseModel):
    """Metadata about the AI response."""
    response_key: str = Field(..., description="Deterministic response key (e.g., 'NUMBER_HINT_1')")
    confidence: float = Field(..., ge=0.0, le=1.0, description="Confidence score")
    source: str = Field(..., description="Response source (e.g., 'nlu_rule', 'offline_placeholder')")
    transcribed_text: Optional[str] = Field(None, description="Transcribed child speech")
    detected_emotion: Optional[str] = Field(None, description="Detected emotion from child's speech")
    processing_time_ms: Optional[float] = Field(None, description="Processing time in milliseconds")


class AdventureSpeechResponse(BaseModel):
    """Response from adventure speech endpoint."""
    audio_base64: str = Field(..., description="Response audio encoded as base64")
    audio_format: str = Field(default="wav", description="Audio format")
    text_response: str = Field(..., description="Text version of the response (for debugging)")
    metadata: ResponseMetadata = Field(..., description="Response metadata")
    timestamp: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


# Drawing Request/Response
class DrawRequest(BaseModel):
    """Request for drawing recognition endpoint."""
    image_base64: str = Field(..., description="Drawing image encoded as base64 (PNG/JPEG)")
    challenge: str = Field(..., description="Drawing challenge (e.g., 'DRAW_CAT', 'DRAW_HOUSE')")
    game_state: Optional[GameState] = Field(None, description="Current game state")
    player_id: Optional[str] = Field(None, description="Player identifier")


class DrawResponse(BaseModel):
    """Response from drawing recognition endpoint."""
    prediction: str = Field(..., description="Predicted drawing label")
    confidence: float = Field(..., ge=0.0, le=1.0, description="Confidence score")
    is_correct: bool = Field(..., description="Whether prediction matches challenge")
    response_key: str = Field(..., description="Response key for NLU (e.g., 'DRAW_SUCCESS', 'DRAW_TRY_AGAIN')")
    text_response: str = Field(..., description="Text feedback")
    metadata: ResponseMetadata = Field(..., description="Processing metadata")
    timestamp: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


# Admin Request/Response
class AdminStatsRequest(BaseModel):
    """Request for admin statistics."""
    player_id: Optional[str] = Field(None, description="Specific player ID or None for all")
    date_from: Optional[datetime] = Field(None, description="Start date for stats")
    date_to: Optional[datetime] = Field(None, description="End date for stats")


class AdminStatsResponse(BaseModel):
    """Admin statistics response."""
    total_interactions: int
    total_players: int
    avg_session_duration_seconds: float
    most_active_game_state: str
    top_characters: List[Dict[str, Any]]
    error_rate: float
    timestamp: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


# Health Check
class HealthResponse(BaseModel):
    """Health check response."""
    status: str
    timestamp: datetime
    dry_run_mode: bool
    services: Dict[str, str]


# Audit Log
class AuditLogEntry(BaseModel):
    """Audit log entry structure."""
    timestamp: datetime
    action: str
    player_id: Optional[str]
    game_state: Optional[str]
    metadata: Dict[str, Any]
    ip_address: Optional[str] = None
    user_agent: Optional[str] = None

