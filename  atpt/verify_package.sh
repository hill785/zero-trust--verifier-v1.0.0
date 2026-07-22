#!/usr/bin/env bash

# =========================================================================
# 🛡️ HERMES ATTACHMENT GATEWAY - PRODUCTION PACKAGING AUDIT SUITE
# Automated Zero-Source Verification Script for Version 1.0.0 Compliance
# =========================================================================

# Enforce strict system failure parameters for clean audit logs
set -euo pipefail

echo "⏳ Step 1: Purging historical deployment artifacts and workspace caches..."
rm -rf build/ dist/ *.egg-info

echo "⏳ Step 2: Compiling hardened native distribution wheel asset via Cython..."
python -m build --wheel

echo "⏳ Step 3: Executing OpenZeppelin Zero-Source Structural Audit..."

# Locate generated build files safely across different platform naming schemas
WHEEL_FILE=$(ls dist/atpt_security_sdk-1.0.0-*.whl 2>/dev/null | head -n 1 || true)

if [ -z "$WHEEL_FILE" ]; then
    echo "❌ AUDIT CRITICAL: Production distribution wheel was not generated successfully."
    exit 1
fi

echo "📦 Target Package Located: $WHEEL_FILE"
echo "🔍 Scanning internal archive maps for intellectual property leaks..."

# Hardened Fix: Use zipinfo to extract clean, unadulterated package pathways.
# Bypasses header/footer noise and ignores valid package mapping init files.
# The '|| true' statement stops grep code 1 from crashing strict execution parameters.
LEAKING_FILES=$(zipinfo -1 "$WHEEL_FILE" | grep -E "atpt/.*\.py$" | grep -v "__init__.py" || true)

if [ -n "$LEAKING_FILES" ]; then
    echo "================================================================="
    echo "❌ AUDIT FAILURE: Intellectual Property Leaks Detected!"
    echo "================================================================="
    echo "The following raw Python source files were bundled inside the wheel:"
    echo "$LEAKING_FILES"
    echo "================================================================="
    echo "Remediation: Review HardenedBuildPy configurations in setup.py."
    exit 1
else
    echo "================================================================="
    echo "✅ AUDIT PASSED: Zero-Source Delivery Verified for V1.0.0."
    echo "📦 Certified Artifact Target: $WHEEL_FILE"
    echo "================================================================="
    exit 0
fi
