"""
Structured audit logging for actions.log.
Append-only JSON logging for safety and analytics.
"""

import json
import logging
import os
from datetime import datetime, timezone
from typing import Dict, Any, Optional, List
from pathlib import Path

from app.config import settings

logger = logging.getLogger(__name__)


class AuditLogger:
    """Structured audit logger writing to actions.log."""
    
    def __init__(self):
        self.log_file = Path(settings.get_actions_log_file())
        self.log_file.parent.mkdir(parents=True, exist_ok=True)
    
    def log_action(
        self,
        action: str,
        player_id: Optional[str] = None,
        game_state: Optional[str] = None,
        metadata: Optional[Dict[str, Any]] = None,
        ip_address: Optional[str] = None,
        user_agent: Optional[str] = None
    ):
        """
        Log an action to actions.log.
        
        Args:
            action: Action name (e.g., 'adventure_speech_request')
            player_id: Player identifier
            game_state: Current game state
            metadata: Additional metadata dict
            ip_address: Client IP
            user_agent: User agent string
        """
        log_entry = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "action": action,
            "player_id": player_id,
            "game_state": game_state,
            "metadata": metadata or {},
            "ip_address": ip_address,
            "user_agent": user_agent
        }
        
        # Append to log file (append-only for safety)
        try:
            with open(self.log_file, 'a', encoding='utf-8') as f:
                f.write(json.dumps(log_entry, ensure_ascii=False) + '\n')
        except Exception as e:
            logger.error(f"Failed to write audit log: {e}")
    
    def get_recent_logs(
        self,
        limit: int = 100,
        player_id: Optional[str] = None
    ) -> List[Dict[str, Any]]:
        """
        Get recent log entries.
        
        Args:
            limit: Maximum number of entries
            player_id: Filter by player ID
            
        Returns:
            List of log entries
        """
        logs = []
        if not self.log_file.exists():
            return logs
        
        try:
            with open(self.log_file, 'r', encoding='utf-8') as f:
                lines = f.readlines()
                
            # Read from end (most recent first)
            for line in reversed(lines[-limit:]):
                try:
                    entry = json.loads(line.strip())
                    if player_id is None or entry.get("player_id") == player_id:
                        logs.append(entry)
                        if len(logs) >= limit:
                            break
                except json.JSONDecodeError:
                    continue
                    
        except Exception as e:
            logger.error(f"Failed to read audit log: {e}")
        
        return logs
    
    def get_stats(
        self,
        player_id: Optional[str] = None,
        date_from: Optional[datetime] = None,
        date_to: Optional[datetime] = None
    ) -> Dict[str, Any]:
        """
        Get statistics from audit logs.
        
        Args:
            player_id: Filter by player ID
            date_from: Start date
            date_to: End date
            
        Returns:
            Statistics dictionary
        """
        logs = []
        if not self.log_file.exists():
            return self._empty_stats()
        
        try:
            with open(self.log_file, 'r', encoding='utf-8') as f:
                for line in f:
                    try:
                        entry = json.loads(line.strip())
                        entry_time = datetime.fromisoformat(entry.get("timestamp", ""))
                        
                        # Apply filters
                        if player_id and entry.get("player_id") != player_id:
                            continue
                        if date_from and entry_time < date_from:
                            continue
                        if date_to and entry_time > date_to:
                            continue
                        
                        logs.append(entry)
                    except (json.JSONDecodeError, ValueError):
                        continue
        except Exception as e:
            logger.error(f"Failed to read stats: {e}")
            return self._empty_stats()
        
        # Calculate stats
        total_interactions = len([l for l in logs if l.get("action") in [
            "adventure_speech_request", "draw_recognition_request"
        ]])
        
        unique_players = len(set(l.get("player_id") for l in logs if l.get("player_id")))
        
        # Count game states
        game_states = {}
        for log in logs:
            state = log.get("game_state")
            if state:
                game_states[state] = game_states.get(state, 0) + 1
        
        most_active = max(game_states.items(), key=lambda x: x[1])[0] if game_states else "none"
        
        # Count errors
        errors = len([l for l in logs if "error" in l.get("action", "").lower()])
        error_rate = errors / total_interactions if total_interactions > 0 else 0.0
        
        # Estimate session duration (simplified)
        if logs:
            first_time = datetime.fromisoformat(logs[0]["timestamp"])
            last_time = datetime.fromisoformat(logs[-1]["timestamp"])
            avg_duration = (last_time - first_time).total_seconds() / max(unique_players, 1)
        else:
            avg_duration = 0.0
        
        return {
            "total_interactions": total_interactions,
            "total_players": unique_players,
            "avg_session_duration_seconds": avg_duration,
            "most_active_game_state": most_active,
            "top_characters": [],  # Could be calculated from metadata
            "error_rate": error_rate
        }
    
    def _empty_stats(self) -> Dict[str, Any]:
        """Return empty stats structure."""
        return {
            "total_interactions": 0,
            "total_players": 0,
            "avg_session_duration_seconds": 0.0,
            "most_active_game_state": "none",
            "top_characters": [],
            "error_rate": 0.0
        }


# Global instance
audit_logger = AuditLogger()
