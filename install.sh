#!/bin/bash

# Outcoin Electrum Wallet Installation Script
# Version: 1.0.1

set -e

echo "🚀 Installing Outcoin Electrum Wallet..."
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed."
    echo "Please install Python 3.8+ and try again."
    exit 1
fi

# Check Python version
PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
REQUIRED_VERSION="3.8"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    echo "❌ Python $REQUIRED_VERSION or higher is required. Found: $PYTHON_VERSION"
    exit 1
fi

echo "✅ Python $PYTHON_VERSION detected"

# Create virtual environment
echo "📦 Creating virtual environment..."
python3 -m venv outcoin-electrum-env
source outcoin-electrum-env/bin/activate

# Upgrade pip
echo "⬆️  Upgrading pip..."
pip install --upgrade pip

# Install PyQt6 first (required for GUI)
echo "🖥️  Installing PyQt6..."
pip install PyQt6

# Install Outcoin Electrum
echo "💰 Installing Outcoin Electrum..."
if [ -f "dist/outcoin-1.0.0-py3-none-any.whl" ]; then
    pip install dist/outcoin-1.0.0-py3-none-any.whl
elif [ -f "dist/outcoin-1.0.0.tar.gz" ]; then
    pip install dist/outcoin-1.0.0.tar.gz
else
    echo "📥 Downloading from GitHub..."
    pip install https://github.com/outcoin-chain/outcoin-core-electrum/releases/download/v1.0.1/outcoin-1.0.0-py3-none-any.whl
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "To run Outcoin Electrum:"
echo "1. Activate the environment: source outcoin-electrum-env/bin/activate"
echo "2. Run the wallet: ./run_electrum"
echo ""
echo "Or create a desktop shortcut using the provided .desktop file"
echo ""
echo "Happy trading with Outcoin! 💎" 