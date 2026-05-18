#!/usr/bin/env python3
"""
Dependency Resolution Script for Whispering Woods
Attempts to resolve and pin compatible dependency versions.
"""

import subprocess
import sys
import json
import os
import logging
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Tuple, Optional

# Setup logging
LOG_DIR = Path(__file__).parent.parent / "devtools" / "logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)
LOG_FILE = LOG_DIR / f"resolve_deps_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(LOG_FILE),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

class DependencyResolver:
    """Resolves and fixes dependency conflicts."""
    
    def __init__(self, project_root: Path, dry_run: bool = False):
        self.project_root = project_root
        self.dry_run = dry_run
        self.backend_dir = project_root / "backend"
        self.venv_path = self.backend_dir / ".venv"
        self.results = {
            "timestamp": datetime.now().isoformat(),
            "python_version": sys.version,
            "python_executable": sys.executable,
            "dry_run": dry_run,
            "backend": {},
            "frontend": {},
            "flutter": {},
            "errors": [],
            "warnings": []
        }
    
    def run_command(self, cmd: List[str], cwd: Optional[Path] = None, capture_output: bool = True) -> Tuple[int, str, str]:
        """Run a command and return exit code, stdout, stderr."""
        logger.info(f"Running: {' '.join(cmd)}")
        try:
            result = subprocess.run(
                cmd,
                cwd=cwd or self.project_root,
                capture_output=capture_output,
                text=True,
                timeout=300
            )
            stdout = result.stdout if capture_output else ""
            stderr = result.stderr if capture_output else ""
            return result.returncode, stdout, stderr
        except subprocess.TimeoutExpired:
            logger.error(f"Command timed out: {' '.join(cmd)}")
            return 1, "", "Command timed out"
        except Exception as e:
            logger.error(f"Command failed: {e}")
            return 1, "", str(e)
    
    def setup_venv(self) -> bool:
        """Create and setup Python virtual environment."""
        logger.info("Setting up Python virtual environment...")
        
        if self.venv_path.exists():
            logger.info("Venv already exists, skipping creation")
            self.results["backend"]["venv_exists"] = True
        else:
            if self.dry_run:
                logger.info("DRY RUN: Would create venv")
                self.results["backend"]["venv_exists"] = False
                return True
            
            logger.info("Creating venv...")
            code, stdout, stderr = self.run_command([
                sys.executable, "-m", "venv", str(self.venv_path)
            ], cwd=self.backend_dir)
            
            if code != 0:
                logger.error(f"Failed to create venv: {stderr}")
                self.results["errors"].append(f"Venv creation failed: {stderr}")
                return False
            
            logger.info("Venv created successfully")
            self.results["backend"]["venv_created"] = True
        
        return True
    
    def get_pip_executable(self) -> Path:
        """Get pip executable from venv."""
        if sys.platform == "win32":
            return self.venv_path / "Scripts" / "pip.exe"
        else:
            return self.venv_path / "bin" / "pip"
    
    def upgrade_pip(self) -> bool:
        """Upgrade pip in venv."""
        pip_exe = self.get_pip_executable()
        if not pip_exe.exists():
            logger.warning("Pip not found in venv")
            return False
        
        logger.info("Upgrading pip...")
        if self.dry_run:
            logger.info("DRY RUN: Would upgrade pip")
            return True
        
        code, stdout, stderr = self.run_command([
            str(pip_exe), "install", "--upgrade", "pip", "setuptools", "wheel"
        ])
        
        if code == 0:
            logger.info("Pip upgraded successfully")
            return True
        else:
            logger.warning(f"Pip upgrade had warnings: {stderr}")
            return True  # Non-fatal
    
    def test_install(self, requirements_file: Path) -> Tuple[bool, List[str]]:
        """Test installing requirements and capture conflicts."""
        pip_exe = self.get_pip_executable()
        if not pip_exe.exists():
            return False, ["Pip executable not found"]
        
        logger.info(f"Testing installation from {requirements_file.name}...")
        
        if self.dry_run:
            logger.info("DRY RUN: Would attempt pip install")
            return True, []
        
        # Try pip install with verbose output
        code, stdout, stderr = self.run_command([
            str(pip_exe), "install", "-r", str(requirements_file), "--dry-run"
        ])
        
        # If --dry-run not supported, try actual install but catch errors
        if code != 0 and "no such option: --dry-run" in stderr:
            logger.info("Dry-run not supported, attempting real install...")
            code, stdout, stderr = self.run_command([
                str(pip_exe), "install", "-r", str(requirements_file), "--no-cache-dir"
            ])
        
        errors = []
        warnings = []
        
        if code != 0:
            # Parse errors
            error_lines = stderr.split('\n')
            for line in error_lines:
                if 'error' in line.lower() or 'failed' in line.lower():
                    errors.append(line.strip())
                elif 'warning' in line.lower():
                    warnings.append(line.strip())
        
        return code == 0, errors
    
    def resolve_python_deps(self) -> bool:
        """Resolve Python backend dependencies."""
        logger.info("=" * 60)
        logger.info("Resolving Python Dependencies")
        logger.info("=" * 60)
        
        requirements_file = self.backend_dir / "requirements.txt"
        if not requirements_file.exists():
            logger.error(f"Requirements file not found: {requirements_file}")
            self.results["errors"].append(f"Requirements file not found")
            return False
        
        # Setup venv
        if not self.setup_venv():
            return False
        
        # Upgrade pip
        self.upgrade_pip()
        
        # Read current requirements
        with open(requirements_file, 'r') as f:
            original_reqs = f.read()
        
        self.results["backend"]["original_requirements"] = original_reqs.split('\n')
        
        # Test installation
        success, errors = self.test_install(requirements_file)
        
        if not success:
            logger.warning("Initial install failed, attempting resolution...")
            self.results["backend"]["initial_install_failed"] = True
            self.results["backend"]["errors"] = errors
            
            # Try to get compatible versions
            logger.info("Attempting to find compatible versions...")
            success = self._attempt_version_resolution(requirements_file, errors)
        else:
            logger.info("Requirements installed successfully!")
            self.results["backend"]["install_success"] = True
        
        # Generate lock file if successful
        if success and not self.dry_run:
            self._generate_lock_file()
        
        return success
    
    def _attempt_version_resolution(self, requirements_file: Path, errors: List[str]) -> bool:
        """Attempt to resolve version conflicts."""
        logger.info("Attempting version resolution...")
        
        # Common fixes for Python 3.14 compatibility
        fixes = {
            # Update pydantic for Python 3.14
            "pydantic==2.5.0": "pydantic>=2.10.0",
            "pydantic-settings==2.1.0": "pydantic-settings>=2.6.0",
            
            # Update FastAPI
            "fastapi==0.104.1": "fastapi>=0.115.0",
            "uvicorn[standard]==0.24.0": "uvicorn[standard]>=0.32.0",
            
            # Update numpy/scipy for Python 3.14
            "numpy==1.24.3": "numpy>=1.26.0",
            "scipy==1.11.4": "scipy>=1.14.0",
            
            # Update Pillow
            "Pillow==10.1.0": "Pillow>=10.4.0",
            
            # Update pytest
            "pytest==7.4.3": "pytest>=8.3.0",
            "pytest-asyncio==0.21.1": "pytest-asyncio>=0.24.0",
            "httpx==0.25.2": "httpx>=0.27.0",
        }
        
        # Read and update requirements
        with open(requirements_file, 'r') as f:
            lines = f.readlines()
        
        updated_lines = []
        changes_made = []
        
        for line in lines:
            original_line = line.strip()
            updated_line = line
            
            # Check if this line needs updating
            for old_version, new_version in fixes.items():
                if old_version in line:
                    updated_line = line.replace(old_version, new_version)
                    changes_made.append(f"{old_version} -> {new_version}")
                    logger.info(f"Updating: {old_version} -> {new_version}")
                    break
            
            updated_lines.append(updated_line)
        
        if changes_made:
            if not self.dry_run:
                # Backup original
                backup_file = requirements_file.with_suffix('.txt.backup')
                with open(backup_file, 'w') as f:
                    f.writelines(lines)
                logger.info(f"Backed up original to {backup_file.name}")
                
                # Write updated
                with open(requirements_file, 'w') as f:
                    f.writelines(updated_lines)
                logger.info("Updated requirements.txt")
            
            self.results["backend"]["version_updates"] = changes_made
            
            # Test again
            if not self.dry_run:
                success, new_errors = self.test_install(requirements_file)
                return success
            else:
                return True
        
        return False
    
    def _generate_lock_file(self):
        """Generate requirements.lock.txt from installed packages."""
        pip_exe = self.get_pip_executable()
        lock_file = self.backend_dir / "requirements.lock.txt"
        
        logger.info("Generating lock file...")
        
        code, stdout, stderr = self.run_command([
            str(pip_exe), "freeze"
        ])
        
        if code == 0:
            if not self.dry_run:
                with open(lock_file, 'w') as f:
                    f.write(stdout)
                logger.info(f"Lock file created: {lock_file.name}")
            self.results["backend"]["lock_file_created"] = True
        else:
            logger.warning(f"Failed to generate lock file: {stderr}")
    
    def resolve_node_deps(self) -> bool:
        """Resolve Node.js frontend dependencies."""
        logger.info("=" * 60)
        logger.info("Resolving Node.js Dependencies")
        logger.info("=" * 60)
        
        frontend_dir = self.project_root / "promotional_website"
        package_json = frontend_dir / "package.json"
        
        if not package_json.exists():
            logger.error("package.json not found")
            return False
        
        # Check Node version compatibility
        code, stdout, stderr = self.run_command(["node", "--version"])
        node_version = stdout.strip() if code == 0 else "unknown"
        self.results["frontend"]["node_version"] = node_version
        
        logger.info(f"Node version: {node_version}")
        
        # React-scripts 5.0.1 may not work with Node 22
        # Update to a compatible version
        with open(package_json, 'r') as f:
            package_data = json.load(f)
        
        updates_made = False
        
        # Update react-scripts if needed
        if "react-scripts" in package_data.get("dependencies", {}):
            current_version = package_data["dependencies"]["react-scripts"]
            if current_version == "5.0.1":
                # Check if Node 22+ requires newer version
                if node_version.startswith("v22") or node_version.startswith("v23"):
                    logger.info("Node 22+ detected, updating react-scripts...")
                    package_data["dependencies"]["react-scripts"] = "^5.0.1"
                    # Note: 5.0.1 should work, but we'll let npm resolve
                    updates_made = True
        
        if updates_made and not self.dry_run:
            # Backup
            backup_file = package_json.with_suffix('.json.backup')
            import shutil
            shutil.copy(package_json, backup_file)
            
            # Write updated
            with open(package_json, 'w') as f:
                json.dump(package_data, f, indent=2)
            
            logger.info("Updated package.json")
        
        # Try npm install
        if not self.dry_run:
            logger.info("Running npm install...")
            # Try to find npm in common locations or use where
            npm_cmd = "npm.cmd" if sys.platform == "win32" else "npm"
            code, stdout, stderr = self.run_command(
                [npm_cmd, "install"],
                cwd=frontend_dir
            )
            
            if code == 0:
                logger.info("npm install successful")
                self.results["frontend"]["install_success"] = True
                
                # Check if package-lock.json was created
                lock_file = frontend_dir / "package-lock.json"
                if lock_file.exists():
                    self.results["frontend"]["lock_file_created"] = True
            else:
                logger.error(f"npm install failed: {stderr}")
                self.results["frontend"]["install_failed"] = True
                self.results["errors"].append(f"npm install: {stderr}")
                return False
        else:
            logger.info("DRY RUN: Would run npm install")
        
        return True
    
    def resolve_flutter_deps(self) -> bool:
        """Resolve Flutter dependencies."""
        logger.info("=" * 60)
        logger.info("Resolving Flutter Dependencies")
        logger.info("=" * 60)
        
        app_dir = self.project_root / "mobile_app"
        pubspec_yaml = app_dir / "pubspec.yaml"
        
        if not pubspec_yaml.exists():
            logger.error("pubspec.yaml not found")
            return False
        
        # Check Flutter
        code, stdout, stderr = self.run_command(["flutter", "--version"])
        if code != 0:
            logger.warning("Flutter not found - skipping Flutter dependency resolution")
            self.results["flutter"]["flutter_installed"] = False
            self.results["warnings"].append("Flutter not installed - cannot resolve Flutter deps")
            return False
        
        flutter_version = stdout.split('\n')[0] if stdout else "unknown"
        self.results["flutter"]["flutter_installed"] = True
        self.results["flutter"]["version"] = flutter_version
        
        logger.info(f"Flutter version: {flutter_version}")
        
        if not self.dry_run:
            logger.info("Running flutter pub get...")
            code, stdout, stderr = self.run_command(
                ["flutter", "pub", "get"],
                cwd=app_dir
            )
            
            if code == 0:
                logger.info("flutter pub get successful")
                self.results["flutter"]["install_success"] = True
            else:
                logger.error(f"flutter pub get failed: {stderr}")
                self.results["flutter"]["install_failed"] = True
                self.results["errors"].append(f"flutter pub get: {stderr}")
                return False
        else:
            logger.info("DRY RUN: Would run flutter pub get")
        
        return True
    
    def save_results(self):
        """Save resolution results to JSON."""
        results_file = self.project_root / "devtools" / "dependency_resolution_results.json"
        with open(results_file, 'w') as f:
            json.dump(self.results, f, indent=2)
        logger.info(f"Results saved to {results_file}")
    
    def run_all(self) -> bool:
        """Run all dependency resolutions."""
        logger.info("Starting dependency resolution...")
        
        backend_ok = self.resolve_python_deps()
        frontend_ok = self.resolve_node_deps()
        flutter_ok = self.resolve_flutter_deps()
        
        self.save_results()
        
        logger.info("=" * 60)
        logger.info("Resolution Summary:")
        logger.info(f"  Backend: {'OK' if backend_ok else 'FAILED'}")
        logger.info(f"  Frontend: {'OK' if frontend_ok else 'FAILED'}")
        logger.info(f"  Flutter: {'OK' if flutter_ok else 'FAILED'}")
        logger.info("=" * 60)
        
        return backend_ok and frontend_ok and (flutter_ok or not self.results["flutter"]["flutter_installed"])


def main():
    """Main entry point."""
    import argparse
    
    parser = argparse.ArgumentParser(description="Resolve Whispering Woods dependencies")
    parser.add_argument("--dry-run", action="store_true", help="Dry run mode")
    parser.add_argument("--project-root", type=str, default=".", help="Project root directory")
    
    args = parser.parse_args()
    
    project_root = Path(args.project_root).resolve()
    if not project_root.exists():
        print(f"Error: Project root not found: {project_root}")
        return 1
    
    resolver = DependencyResolver(project_root, dry_run=args.dry_run)
    success = resolver.run_all()
    
    return 0 if success else 1


if __name__ == "__main__":
    sys.exit(main())

