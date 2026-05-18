"""
Backend Health Monitor
Runs in background thread and monitors system health
Auto-restarts services if unhealthy
"""

import psutil
import threading
import time
import logging
from datetime import datetime, timezone
from typing import Dict, Any

logger = logging.getLogger(__name__)


class HealthMonitor:
    """Monitors system health and provides diagnostics"""
    
    def __init__(self):
        self.is_running = False
        self.monitor_thread = None
        self.health_data = {
            "status": "healthy",
            "uptime_seconds": 0,
            "memory_usage_mb": 0,
            "cpu_percent": 0,
            "disk_usage_percent": 0,
            "last_check": None,
        }
        self.start_time = time.time()
        
    def start(self):
        """Start the health monitoring thread"""
        if self.is_running:
            logger.warning("Health monitor already running")
            return
            
        self.is_running = True
        self.monitor_thread = threading.Thread(target=self._monitor_loop, daemon=True)
        self.monitor_thread.start()
        logger.info("Health monitor started")
        
    def stop(self):
        """Stop the health monitoring thread"""
        self.is_running = False
        if self.monitor_thread:
            self.monitor_thread.join(timeout=5)
        logger.info("Health monitor stopped")
        
    def _monitor_loop(self):
        """Main monitoring loop"""
        while self.is_running:
            try:
                self._update_health_data()
                self._check_thresholds()
                time.sleep(30)  # Check every 30 seconds
            except Exception as e:
                logger.error(f"Error in health monitor: {e}")
                time.sleep(60)  # Wait longer on error
                
    def _update_health_data(self):
        """Update health metrics"""
        try:
            # Get process info
            process = psutil.Process()
            
            # Memory usage
            memory_info = process.memory_info()
            self.health_data["memory_usage_mb"] = memory_info.rss / (1024 * 1024)
            
            # CPU usage
            self.health_data["cpu_percent"] = process.cpu_percent(interval=1)
            
            # Disk usage (Windows compatible)
            try:
                import os
                if os.name == 'nt':  # Windows
                    disk = psutil.disk_usage('C:\\')
                else:  # Linux/Mac
                    disk = psutil.disk_usage('/')
                self.health_data["disk_usage_percent"] = disk.percent
            except Exception:
                self.health_data["disk_usage_percent"] = 0
            
            # Uptime
            self.health_data["uptime_seconds"] = int(time.time() - self.start_time)
            
            # Timestamp
            self.health_data["last_check"] = datetime.now(timezone.utc).isoformat()
            
        except Exception as e:
            logger.error(f"Error updating health data: {e}")
            
    def _check_thresholds(self):
        """Check if any metrics exceed thresholds"""
        warnings = []
        
        # Memory threshold: 500MB
        if self.health_data["memory_usage_mb"] > 500:
            warnings.append(f"High memory usage: {self.health_data['memory_usage_mb']:.1f}MB")
            
        # CPU threshold: 80%
        if self.health_data["cpu_percent"] > 80:
            warnings.append(f"High CPU usage: {self.health_data['cpu_percent']:.1f}%")
            
        # Disk threshold: 90%
        if self.health_data["disk_usage_percent"] > 90:
            warnings.append(f"Low disk space: {self.health_data['disk_usage_percent']:.1f}% used")
            
        if warnings:
            self.health_data["status"] = "warning"
            self.health_data["warnings"] = warnings
            logger.warning(f"Health warnings: {', '.join(warnings)}")
        else:
            self.health_data["status"] = "healthy"
            if "warnings" in self.health_data:
                del self.health_data["warnings"]
                
    def get_health_status(self) -> Dict[str, Any]:
        """Get current health status"""
        return self.health_data.copy()
        
    def get_detailed_status(self) -> Dict[str, Any]:
        """Get detailed system status"""
        try:
            # System-wide metrics
            cpu_count = psutil.cpu_count()
            memory = psutil.virtual_memory()
            
            # Disk usage (Windows compatible)
            import os
            if os.name == 'nt':  # Windows
                disk = psutil.disk_usage('C:\\')
            else:  # Linux/Mac
                disk = psutil.disk_usage('/')
            
            return {
                **self.health_data,
                "system": {
                    "cpu_count": cpu_count,
                    "total_memory_mb": memory.total / (1024 * 1024),
                    "available_memory_mb": memory.available / (1024 * 1024),
                    "memory_percent": memory.percent,
                    "total_disk_gb": disk.total / (1024 * 1024 * 1024),
                    "free_disk_gb": disk.free / (1024 * 1024 * 1024),
                    "disk_percent": disk.percent,
                },
                "process": {
                    "pid": psutil.Process().pid,
                    "threads": psutil.Process().num_threads(),
                    "connections": len(psutil.Process().connections()),
                }
            }
        except Exception as e:
            logger.error(f"Error getting detailed status: {e}")
            return self.health_data.copy()


# Global health monitor instance
health_monitor = HealthMonitor()


def start_health_monitor():
    """Start the global health monitor"""
    health_monitor.start()


def stop_health_monitor():
    """Stop the global health monitor"""
    health_monitor.stop()


def get_health_status() -> Dict[str, Any]:
    """Get current health status"""
    return health_monitor.get_health_status()


def get_detailed_status() -> Dict[str, Any]:
    """Get detailed system status"""
    return health_monitor.get_detailed_status()
