#!/bin/bash
set -e

echo "=== openvla-so101 Setup ==="
echo ""

# Detect OS
OS="$(uname)"
echo "Detected OS: $OS"

# Check Python
if ! command -v python3 &> /dev/null; then
    echo "ERROR: python3 not found. Install Python 3.10+ first."
    exit 1
fi
PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
echo "Python: $PYTHON_VERSION"

# Init submodules
echo ""
echo "1/4 Initializing submodules..."
git submodule update --init --recursive

# Create venv (inside so-101/ to match existing setup)
echo ""
echo "2/4 Setting up virtual environment..."
VENV_DIR="venv"
if [ -d "$VENV_DIR" ]; then
    echo "     $VENV_DIR already exists, skipping."
else
    python3 -m venv "$VENV_DIR"
    echo "     Created $VENV_DIR"
fi
source "$VENV_DIR/bin/activate"

# Install LeRobot with appropriate extras
echo ""
echo "3/4 Installing LeRobot..."
if [[ "$OS" == "Darwin" ]]; then
    echo "     macOS detected — installing [feetech,pi] extras"
    pip install -e "so-101/lerobot/.[feetech,pi]"
elif [[ "$OS" == "Linux" ]]; then
    echo "     Linux detected — installing [pi] extras"
    pip install -e "so-101/lerobot/.[pi]"
    # Check for CUDA
    if python3 -c "import torch; assert torch.cuda.is_available()" 2>/dev/null; then
        echo "     CUDA available ✓"
    else
        echo "     WARNING: CUDA not available — training will not work"
    fi
else
    echo "     Unknown OS — installing base [pi] extras"
    pip install -e "so-101/lerobot/.[pi]"
fi

# Verify
echo ""
echo "4/4 Verifying installation..."
python3 -c "import lerobot; print(f'  LeRobot {lerobot.__version__} OK')"
python3 -c "from lerobot.policies.pi0_fast import PI0FastPolicy; print('  Pi0-FAST OK')"

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Activate with:  source venv/bin/activate"
echo ""
echo "Next steps:"
echo "  Mac:   lerobot-find-port  (find robot ports)"
echo "  GPU:   lerobot-train ...  (train Pi0-FAST)"
