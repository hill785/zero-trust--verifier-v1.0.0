# =========================================================================
# 🛡️ HERMES ATTACHMENT GATEWAY - WORKSPACE AUTOMATION CORE (V1.0.0)
# Orchestration Engine for Zero-Source Compilation and Audit Verification
# =========================================================================

.PHONY: help venv install build test verify clean git-sync

# Default target executes help layout overview
help:
	@echo "================================================================="
	@echo "💼 HERMES WORKSPACE CORE - AUTOMATION MATRIX"
	@echo "================================================================="
	@echo "make venv       - Initialize an isolated local Python virtual environment"
	@echo "make install    - Provision pinned compiler and testing dependencies"
	@echo "make build      - Execute native Cython machine code binary compilation"
	@echo "make test       - Execute asynchronous bot swarm stress test suite"
	@echo "make verify     - Run automated zero-source compliance check script"
	@echo "make clean      - Clean compilation remnants, cache folders, and build noise"
	@echo "make git-sync   - Automatically stage and freeze current V1.0.0 milestones"
	@echo "================================================================="

# Step 1: Initialize local runtime tracking isolation folder
venv:
	@echo "⏳ Initializing isolated development workspace..."
	python3 -m venv venv
	@echo "✅ Environment created. Activate using: 'source venv/bin/activate'"

# Step 2: Install production-proven stable dependencies
install:
	@echo "⏳ Upgrading pip package index tools..."
	python -m pip install --upgrade pip
	@echo "⏳ Provisioning pinned compiler and validation libraries..."
	pip install -r requirements.txt
	@echo "✅ Hardened toolchains provisioned successfully."

# Step 3: Run native compilation across package targets
build:
	@echo "⏳ Executing inline native Cython binary compilation..."
	python setup.py build_ext --inplace
	@echo "✅ Platform extensions successfully generated (.so/.pyd)."

# Step 4: Execute multi-threaded asynchronous bot swarm stress tests
test:
	@echo "⏳ Initiating 100-thread async bot swarm stress test suite..."
	cd tests && pytest -v -s test_swarm.py test_security.py
	@echo "✅ Core stress matrix evaluation passed."

# Step 5: Run strict zero-source package inspection script
verify:
	@echo "⏳ Triggering OpenZeppelin zero-source packaging check..."
	chmod +x verify_package.sh
	./verify_package.sh

# Step 6: Wipe out all temporary build structures, binaries, and logging caches
clean:
	@echo "⏳ Purging packaging debris and transient filesystem noise..."
	rm -rf build/ dist/ *.egg-info .pytest_cache/ .asyncio_cache/
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.so" -delete
	find . -type f -name "*.pyd" -delete
	# Hardened Fix: Safely strips transient compiled C generation artifacts without touching core python engines
	find . -type f -name "*.c" -delete
	@echo "✅ Workspace cleaned to virgin pristine state."

# Step 7: Automated configuration control checkpoint freezing
git-sync:
	@echo "⏳ Freezing current workspace updates into tracking ledger..."
	git add Makefile
	git commit -m "fix: patch Makefile clean target logic to ensure cross-platform audit compliance"
	@echo "✅ Version 1.0.0 milestones successfully committed."
