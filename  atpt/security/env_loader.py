"""
ATPT Secure Configuration & Secret Isolation Layer.
Prevents credential leaking by enforcing runtime environment parsing.
"""

import os
from typing import Dict, Optional

class EnvironmentConfig:
    @staticmethod
    def load_secure_credentials() -> Dict[str, str]:
        """
        Dynamically extracts sensitive credentials straight from process memory space.
        Throws a LookupError if corporate licensing parameters are absent.
        """
        # Parse host process variables safely
        client_id: Optional[str] = os.environ.get("HERMES_CLIENT_ID")
        commercial_key: Optional[str] = os.environ.get("HERMES_COMMERCIAL_KEY")
        hardware_hash: Optional[str] = os.environ.get("HERMES_HARDWARE_HASH")
        
        # OpenZeppelin Audit Gate Requirement: Explicit fail-fast on missing secrets
        if not client_id or not commercial_key or not hardware_hash:
            raise LookupError(
                "❌ CRITICAL SYSTEM ERROR: Missing required Hermes corporate licensing environment variables. "
                "Ensure HERMES_CLIENT_ID, HERMES_COMMERCIAL_KEY, and HERMES_HARDWARE_HASH are properly "
                "injected into the target machine runtime configuration."
            )
            
        return {
            "client_id": client_id,
            "commercial_key": commercial_key,
            "hardware_lock_hash": hardware_hash
        }
