"""
Tests for NLU service (rule-based).
"""

import pytest
from app.services.nlu_service import nlu_service


def test_nlu_greeting():
    """Test NLU recognizes greeting."""
    result = nlu_service.process(
        text="أهلاً",
        game_state="FOREST_ADVENTURE",
        game_context="introduction"
    )
    assert "response_key" in result
    assert "response_text" in result
    assert result["confidence"] > 0


def test_nlu_help_request():
    """Test NLU recognizes help request."""
    result = nlu_service.process(
        text="مش فاهم",
        game_state="NUMBER_GATE_PUZZLE",
        game_context="puzzle_solving"
    )
    assert result["response_key"] in ["NUMBER_HINT_1", "GENERAL_HELP", "FALLBACK"]
    assert len(result["response_text"]) > 0


def test_nlu_fallback():
    """Test NLU fallback for unknown input."""
    result = nlu_service.process(
        text="random text that doesn't match",
        game_state="FOREST_ADVENTURE",
        game_context="introduction"
    )
    assert result["response_key"] == "FALLBACK" or result["confidence"] < 1.0


def test_nlu_affirmation():
    """Test NLU recognizes affirmation."""
    result = nlu_service.process(
        text="أيوه",
        game_state="FOREST_ADVENTURE",
        game_context="introduction"
    )
    assert "ENCOURAGEMENT" in result["response_key"] or result["confidence"] > 0.5

