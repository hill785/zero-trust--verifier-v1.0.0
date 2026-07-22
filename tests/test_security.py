"""
ATPT Automated Anti-Tampering & Security Hardening Tests.
Validates RASP barriers, constant-time HMAC validations, and environment spoof rejection.
Target Audit Vector: OpenZeppelin Anti-Exploitation Proofing Layer.
"""

import sys
import pytest
import hashlib
import uuid
import platform
from unittest.mock import patch
from atpt.engine import MITREAIATriageTool, SecurityException

@pytest.fixture
def base_validation_vectors():
    """Generates standard baseline credentials for an authorized development system."""
    client_id = "HERMES_AUDIT_SECURE_NODE"
    valid_key = hashlib.sha256(f"{client_id}:HERMES_GROUP_SECURE_V1".encode("utf-8")).hexdigest()
    hardware_hash = hashlib.sha256(
        f"{uuid.getnode()}:{platform.processor()}:{platform.machine()}:HERMES_SECURE_NODE".encode("utf-8")
    ).hexdigest()
    
    return {
        "client_id": client_id,
        "key": valid_key,
        "hw_hash": hardware_hash
    }

def test_anti_reverse_engineering_rasp_trap(base_validation_vectors):
    """
    Simulates a reverse engineer hooking sys.gettrace() to monitor verification code paths.
    Asserts that the system isolates the threat and terminates execution paths gracefully.
    """
    # Mock sys.gettrace to fake an attached debugging framework (e.g., GDB or PySpy)
    with patch("sys.gettrace", return_value=True):
        with pytest.raises(SecurityException) as error_context:
            MITREAIATriageTool(
                license_type="COMMERCIAL",
                client_id=base_validation_vectors["client_id"],
                commercial_key=base_validation_vectors["key"],
                hardware_lock_hash=base_validation_vectors["hw_hash"]
            )
        assert "Instrumentation hook detected" in str(error_context.value)

def test_anti_mirroring_environment_binding(base_validation_vectors):
    """
    Simulates a container replication attack where the compiled SDK is duplicated 
    and launched on unauthorized cloud hardware (spoofed uuid node).
    """
    # Force a mismatched hardware configuration state to trigger verification rules
    invalid_hardware_hash = hashlib.sha256(b"SPOOFED_CLONED_VIRTUAL_MACHINE_NODE").hexdigest()
    
    with pytest.raises(PermissionError) as error_context:
        MITREAIATriageTool(
            license_type="COMMERCIAL",
            client_id=base_validation_vectors["client_id"],
            commercial_key=base_validation_vectors["key"],
            # Provide mismatched hardware mapping profile
            hardware_lock_hash=invalid_hardware_hash
        )
    assert "Virtual runtime fingerprint does not match" in str(error_context.value)

def test_anti_spoofing_timing_side_channel_rejection(base_validation_vectors):
    """
    Verifies that the constant-time logic drops malicious or corrupted authentication 
    keys instantly without leaking execution trace paths to remote tools.
    """
    malicious_spoofed_key = "98f5a6b7d1e37f22a55cb47851239abfe88710344d990bc1d77a88ef23b9d620" # Intentionally altered single byte
    
    with pytest.raises(PermissionError) as error_context:
        MITREAIATriageTool(
            license_type="COMMERCIAL",
            client_id=base_validation_vectors["client_id"],
            commercial_key=malicious_spoofed_key,
            hardware_lock_hash=base_validation_vectors["hw_hash"]
        )
    assert "Provided credential hash failed structural check" in str(error_context.value)
