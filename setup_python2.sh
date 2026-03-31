#!/bin/bash
# NVMain-PIM Python 2 Environment Setup
# Run this script to set up the build environment for NVMain-PIM with Python 2

set -e

# Add ~/.local/bin to PATH for pip-installed packages
export PATH="$HOME/.local/bin:$PATH"

echo "=== NVMain-PIM Python 2 Environment Setup ==="

# Step 1: Check Python 2
if ! command -v python2 &> /dev/null; then
    echo "ERROR: Python 2 is not found. Please install python2.7."
    exit 1
fi
echo "[OK] Python 2 found: $(python2 --version 2>&1)"

# Step 2: Install pip for Python 2 (if not present)
if ! python2 -m pip --version &> /dev/null 2>&1; then
    echo "Installing pip for Python 2..."
    curl -sS https://bootstrap.pypa.io/pip/2.7/get-pip.py -o /tmp/get-pip.py
    python2 /tmp/get-pip.py --user
    echo "[OK] pip installed for Python 2"
else
    echo "[OK] pip for Python 2 already installed"
fi

# Step 3: Install SCons 2.x for Python 2 (compatible with NVMain)
echo "Installing SCons 2.x for Python 2..."
python2 -m pip install --user "scons>=2.0,<3.0" -q
echo "[OK] SCons 2.x installed"

# Step 4: Clean any previous build artifacts (from Python 3 SCons)
echo "Cleaning previous build artifacts..."
rm -rf build .sconsign.dblite .scons_* 2>/dev/null || true

# Step 5: Build NVMain
echo "Building NVMain..."
python2 ~/.local/bin/scons --build-type=fast

echo ""
echo "=== Setup Complete ==="
echo "Build output: nvmain.fast"
echo ""
echo "To run a simulation:"
echo "  ./nvmain.fast CONFIG_FILE TRACE_FILE [Cycles [PARAM=value ...]]"
echo ""
echo "Example configs are in: Config/"
echo ""
echo "For future builds, use:"
echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
echo "  python2 ~/.local/bin/scons --build-type=fast"
echo ""
echo "Note: Always use 'python2 ~/.local/bin/scons' - the system 'scons' may use Python 3"
echo "      and cause pickle protocol errors. Remove .sconsign.dblite if you switch Python versions."
