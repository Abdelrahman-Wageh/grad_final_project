"""
FastAPI main application for Whispering Woods.
Provides STT→NLU→TTS/CV pipeline endpoints.
"""

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import logging
from datetime import datetime, timezone

from app.config import settings
from app.api_endpoints import router as api_router
from app.health_monitor import start_health_monitor, stop_health_monitor, get_health_status, get_detailed_status

# Configure logging
logging.basicConfig(
    level=getattr(logging, settings.LOG_LEVEL),
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Whispering Woods API",
    description="AI-powered educational adventure game backend",
    version="1.0.0",
    docs_url="/docs" if settings.DEBUG else None,
    redoc_url="/redoc" if settings.DEBUG else None,
)

# Startup event
@app.on_event("startup")
async def startup_event():
    """Start background services"""
    logger.info("Starting Whispering Woods API...")
    start_health_monitor()
    logger.info("Health monitor started")

# Shutdown event
@app.on_event("shutdown")
async def shutdown_event():
    """Stop background services"""
    logger.info("Shutting down Whispering Woods API...")
    stop_health_monitor()
    logger.info("Health monitor stopped")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.get_allowed_origins(),
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include API routes
app.include_router(api_router, prefix="/api")


@app.get("/")
async def root():
    """Root endpoint - health check."""
    return {
        "status": "healthy",
        "service": "Whispering Woods API",
        "version": "1.0.0",
        "dry_run": settings.DRY_RUN,
        "timestamp": datetime.now(timezone.utc).isoformat()
    }


@app.get("/health")
async def health_check():
    """Detailed health check endpoint."""
    health_status = {
        "status": "healthy",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "dry_run_mode": settings.DRY_RUN,
        "services": {
            "stt": "available" if settings.DRY_RUN else ("available" if settings.WHISPER_MODEL_PATH else "not_configured"),
            "nlu": "available",
            "tts": "available" if settings.DRY_RUN else ("available" if settings.TTS_MODEL_PATH else "not_configured"),
            "cv": "available" if settings.DRY_RUN else ("available" if settings.CV_MODEL_PATH else "not_configured"),
        }
    }
    return JSONResponse(content=health_status)


@app.get("/api/system-health")
async def system_health():
    """System health monitoring endpoint with detailed metrics."""
    return JSONResponse(content=get_detailed_status())


@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    """Global exception handler."""
    logger.error(f"Unhandled exception: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={
            "error": "Internal server error",
            "message": str(exc) if settings.DEBUG else "An error occurred"
        }
    )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app.main:app",
        host=settings.HOST,
        port=settings.PORT,
        reload=settings.DEBUG,
        log_level=settings.LOG_LEVEL.lower()
    )

