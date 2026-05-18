"""
FastAPI endpoints for Whispering Woods.
Implements STT→NLU→TTS pipeline and drawing recognition.
"""

import base64
import time
import logging
from fastapi import APIRouter, HTTPException, Depends, Header, Request
from fastapi.responses import JSONResponse
from datetime import datetime, timezone
import json

from app.config import settings
from app.models.schemas import (
    AdventureSpeechRequest, AdventureSpeechResponse,
    DrawRequest, DrawResponse,
    AdminStatsRequest, AdminStatsResponse,
    ResponseMetadata, HealthResponse
)
from app.services.stt_service import stt_service
from app.services.nlu_service import nlu_service
from app.services.tts_service import tts_service
from app.services.cv_service import cv_service
from app.audit_logging.audit_logger import audit_logger

logger = logging.getLogger(__name__)
router = APIRouter()


def verify_admin_api_key(x_admin_api_key: str = Header(None)):
    """Verify admin API key for protected endpoints."""
    if not settings.ADMIN_API_KEY:
        raise HTTPException(status_code=503, detail="Admin API not configured")
    if x_admin_api_key != settings.ADMIN_API_KEY:
        raise HTTPException(status_code=401, detail="Invalid admin API key")
    return True


@router.post("/adventure_speech", response_model=AdventureSpeechResponse)
async def adventure_speech(request: AdventureSpeechRequest, http_request: Request):
    """
    Main pipeline endpoint: STT → NLU → TTS.
    
    Accepts:
    - Audio file (base64 encoded)
    - Game state and context
    - Character type
    
    Returns:
    - Audio response (base64 encoded)
    - Response metadata
    """
    start_time = time.time()
    
    try:
        # Decode audio
        try:
            audio_bytes = base64.b64decode(request.audio_base64)
        except Exception as e:
            raise HTTPException(status_code=400, detail=f"Invalid audio encoding: {e}")
        
        # Log action
        audit_logger.log_action(
            action="adventure_speech_request",
            player_id=request.player_id,
            game_state=request.game_state.state,
            metadata={
                "context": request.game_state.context,
                "character_type": request.character_type,
                "audio_size_bytes": len(audio_bytes)
            },
            ip_address=http_request.client.host if http_request.client else None
        )
        
        # Step 1: STT (Speech-to-Text)
        stt_start = time.time()
        stt_result = stt_service.transcribe(audio_bytes)
        stt_time = (time.time() - stt_start) * 1000
        
        transcribed_text = stt_result.get("text", "")
        logger.info(f"STT result: {transcribed_text}")
        
        # Step 2: NLU (Natural Language Understanding)
        nlu_start = time.time()
        nlu_result = nlu_service.process(
            text=transcribed_text,
            game_state=request.game_state.state,
            game_context=request.game_state.context,
            state_data=request.game_state.state_data or {}
        )
        nlu_time = (time.time() - nlu_start) * 1000
        
        response_key = nlu_result.get("response_key", "FALLBACK")
        response_text = nlu_result.get("response_text", "حاول تاني!")
        detected_emotion = nlu_result.get("emotion", "neutral")
        
        logger.info(f"NLU result: {response_key} -> {response_text[:50]}...")
        
        # Step 3: TTS (Text-to-Speech)
        tts_start = time.time()
        tts_result = tts_service.synthesize(
            text=response_text,
            character_type=request.character_type
        )
        tts_time = (time.time() - tts_start) * 1000
        
        audio_bytes_response = tts_result.get("audio_bytes", b"")
        audio_base64_response = base64.b64encode(audio_bytes_response).decode('utf-8')
        
        total_time = (time.time() - start_time) * 1000
        
        # Build response
        metadata = ResponseMetadata(
            response_key=response_key,
            confidence=nlu_result.get("confidence", 0.9),
            source="nlu_rule" if not settings.DRY_RUN else "placeholder",
            transcribed_text=transcribed_text,
            detected_emotion=detected_emotion,
            processing_time_ms=total_time
        )
        
        response = AdventureSpeechResponse(
            audio_base64=audio_base64_response,
            audio_format=tts_result.get("format", "wav"),
            text_response=response_text,
            metadata=metadata
        )
        
        # Log success
        audit_logger.log_action(
            action="adventure_speech_success",
            player_id=request.player_id,
            game_state=request.game_state.state,
            metadata={
                "response_key": response_key,
                "processing_time_ms": total_time,
                "stt_time_ms": stt_time,
                "nlu_time_ms": nlu_time,
                "tts_time_ms": tts_time
            }
        )
        
        return response
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Adventure speech error: {e}", exc_info=True)
        audit_logger.log_action(
            action="adventure_speech_error",
            player_id=request.player_id if 'request' in locals() else None,
            metadata={"error": str(e)}
        )
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")


@router.post("/draw", response_model=DrawResponse)
async def draw_recognition(request: DrawRequest, http_request: Request):
    """
    Drawing recognition endpoint.
    
    Accepts:
    - Drawing image (base64 encoded PNG/JPEG)
    - Challenge (what should be drawn)
    
    Returns:
    - Prediction and correctness
    - NLU response for feedback
    """
    start_time = time.time()
    
    try:
        # Decode image
        try:
            image_bytes = base64.b64decode(request.image_base64)
        except Exception as e:
            raise HTTPException(status_code=400, detail=f"Invalid image encoding: {e}")
        
        # Log action
        audit_logger.log_action(
            action="draw_recognition_request",
            player_id=request.player_id,
            game_state=request.game_state.state if request.game_state else None,
            metadata={
                "challenge": request.challenge,
                "image_size_bytes": len(image_bytes)
            },
            ip_address=http_request.client.host if http_request.client else None
        )
        
        # CV: Recognize drawing
        cv_start = time.time()
        cv_result = cv_service.recognize_drawing(image_bytes, request.challenge)
        cv_time = (time.time() - cv_start) * 1000
        
        prediction = cv_result.get("prediction", "unknown")
        confidence = cv_result.get("confidence", 0.0)
        is_correct = cv_result.get("is_correct", False)
        
        logger.info(f"CV result: {prediction} (confidence: {confidence:.2f}, correct: {is_correct})")
        
        # Get NLU response based on result
        if is_correct:
            response_key = "DRAW_SUCCESS"
            response_text = "ممتاز! رسمت ذلك بشكل رائع! برافو!"
        else:
            response_key = "DRAW_TRY_AGAIN"
            response_text = f"رسمت {prediction}، لكن التحدي كان رسم {request.challenge.replace('DRAW_', '')}. حاول مرة أخرى!"
        
        total_time = (time.time() - start_time) * 1000
        
        metadata = ResponseMetadata(
            response_key=response_key,
            confidence=confidence,
            source="cv_classifier" if not settings.DRY_RUN else "placeholder",
            processing_time_ms=total_time
        )
        
        response = DrawResponse(
            prediction=prediction,
            confidence=confidence,
            is_correct=is_correct,
            response_key=response_key,
            text_response=response_text,
            metadata=metadata
        )
        
        # Log success
        audit_logger.log_action(
            action="draw_recognition_success",
            player_id=request.player_id,
            metadata={
                "prediction": prediction,
                "challenge": request.challenge,
                "is_correct": is_correct,
                "confidence": confidence
            }
        )
        
        return response
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Draw recognition error: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")


@router.get("/health", response_model=HealthResponse)
async def health_check():
    """Health check endpoint."""
    return HealthResponse(
        status="healthy",
        timestamp=datetime.now(timezone.utc),
        dry_run_mode=settings.DRY_RUN,
        services={
            "stt": "available",
            "nlu": "available",
            "tts": "available",
            "cv": "available"
        }
    )


@router.post("/admin/stats", response_model=AdminStatsResponse)
async def admin_stats(request: AdminStatsRequest, _: bool = Depends(verify_admin_api_key)):
    """Admin statistics endpoint (protected by API key)."""
    try:
        # Read from audit log
        stats = audit_logger.get_stats(
            player_id=request.player_id,
            date_from=request.date_from,
            date_to=request.date_to
        )
        
        return AdminStatsResponse(**stats)
    except Exception as e:
        logger.error(f"Admin stats error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/admin/audit_log")
async def admin_audit_log(
    limit: int = 100,
    player_id: str = None,
    _: bool = Depends(verify_admin_api_key)
):
    """Get audit log entries (protected)."""
    try:
        logs = audit_logger.get_recent_logs(limit=limit, player_id=player_id)
        return {"logs": logs}
    except Exception as e:
        logger.error(f"Audit log error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/billing/webhook")
async def billing_webhook(request: Request):
    """
    Stripe webhook endpoint for billing events.
    Placeholder implementation - verify webhook signature in production.
    """
    try:
        payload = await request.body()
        signature = request.headers.get("stripe-signature")
        
        # Log webhook
        audit_logger.log_action(
            action="billing_webhook_received",
            metadata={
                "signature": signature,
                "payload_size": len(payload)
            }
        )
        
        # In production, verify Stripe signature here
        # For now, just log it
        logger.info(f"Billing webhook received: {len(payload)} bytes")
        
        return {"status": "received"}
        
    except Exception as e:
        logger.error(f"Webhook error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

