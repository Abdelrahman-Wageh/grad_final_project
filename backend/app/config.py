"""
Configuration module for Whispering Woods backend.
Supports DRY_RUN mode for safe Day-1 operation.
"""

import os
from typing import Optional, List
from pydantic import field_validator
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""
    
    # Server
    HOST: str = "0.0.0.0"  # Use "0.0.0.0" to allow connections from other devices on network
    PORT: int = 8000
    DEBUG: bool = True
    
    # API Keys & Security
    ADMIN_API_KEY: Optional[str] = None
    SECRET_KEY: str = "dev-secret-key-change-in-production"
    
    # DRY_RUN Mode (Safe Day-1 Operation)
    DRY_RUN: bool = True
    
    # Model Paths
    WHISPER_MODEL_PATH: str = r"E:\Projects\Models\Whisper\whisper-small-egyptian-arabic"
    TTS_MODEL_PATH: Optional[str] = None
    CV_MODEL_PATH: Optional[str] = None
    
    # LLM Configuration (Qwen with GGUF/llama.cpp for 6GB VRAM)
    QWEN_MODEL_PATH: str = r"E:\Projects\Models\LLMs\Qwen\Qwen3-4B-ggfu"  # GGUF quantized model
    QWEN_MODEL_FILE: str = "Qwen3-4B-Instruct-2507-Q5_K_M.gguf"  # Q5_K_M quantized (~2.7GB)
    QWEN_LORA_PATH: Optional[str] = r"E:\Projects\Models\LLMs\Qwen\Qwen3-4B"  # LoRA adapter (optional)
    USE_LLM_GENERATOR: bool = False  # Toggle: False = NLU, True = Qwen LLM
    LLM_TEMPERATURE: float = 0.8  # High creativity for kids
    LLM_MAX_TOKENS: int = 150
    
    # Memory Optimization (6GB VRAM) - Q5_K_M uses ~3.5GB
    GPU_LAYERS: int = 35  # Offload layers to GPU (adjust based on VRAM)
    CONTEXT_LENGTH: int = 2048  # Reduced context for memory efficiency
    BATCH_SIZE: int = 512  # Batch size for inference
    THREADS: int = 4  # CPU threads for non-GPU layers
    
    # Game Context
    GAME_CHAPTERS: List[str] = ["colors", "animals", "numbers"]  # Available game chapters
    
    # Whisper Optimization
    WHISPER_DEVICE: str = "cuda"  # Use GPU
    WHISPER_COMPUTE_TYPE: str = "int8"  # 8-bit quantization for Whisper (~1GB VRAM)
    WHISPER_BATCH_SIZE: int = 16  # Batch size for Whisper
    
    # Audio Settings
    AUDIO_SAMPLE_RATE: int = 22050
    AUDIO_CHANNELS: int = 1
    MAX_AUDIO_SIZE_MB: int = 16
    
    # Logging
    LOG_LEVEL: str = "INFO"
    LOG_DIR: Optional[str] = None
    ACTIONS_LOG_FILE: Optional[str] = None
    
    # Database (if needed for admin)
    DATABASE_URL: Optional[str] = None
    
    # Billing (Stripe)
    STRIPE_SECRET_KEY: Optional[str] = None
    STRIPE_WEBHOOK_SECRET: Optional[str] = None
    
    # CORS - will be parsed from string
    ALLOWED_ORIGINS: str = "http://localhost:3000,http://localhost:8080,http://localhost:8000,http://localhost:5173"
    
    model_config = {
        "env_file": ".env",
        "case_sensitive": True,
    }
    
    def get_allowed_origins(self) -> List[str]:
        """Parse ALLOWED_ORIGINS string into list."""
        if isinstance(self.ALLOWED_ORIGINS, list):
            return self.ALLOWED_ORIGINS
        return [origin.strip() for origin in self.ALLOWED_ORIGINS.split(",") if origin.strip()]
    
    def get_log_dir(self) -> str:
        """Get log directory path."""
        if self.LOG_DIR:
            return self.LOG_DIR
        default_log_dir = os.path.join(os.path.dirname(__file__), "..", "logs")
        return os.path.abspath(default_log_dir)
    
    def get_actions_log_file(self) -> str:
        """Get actions log file path."""
        if self.ACTIONS_LOG_FILE:
            return self.ACTIONS_LOG_FILE
        return os.path.join(self.get_log_dir(), "actions.log")


# Global settings instance
settings = Settings()

# Ensure log directory exists
os.makedirs(settings.get_log_dir(), exist_ok=True)

