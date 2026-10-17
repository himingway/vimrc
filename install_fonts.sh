#!/usr/bin/env bash
set -e

# Determine repository root
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FONTS_SRC="${REPO_DIR}/fonts"

# Target font directory: defaults to user-level fonts directory (~/.local/share/fonts)
TARGET_DIR="${1:-${XDG_DATA_HOME:-$HOME/.local/share}/fonts}"

if [ ! -d "$FONTS_SRC" ]; then
    echo "Error: Font source directory not found: $FONTS_SRC" >&2
    exit 1
fi

echo "=================================================="
echo "Installing coding fonts to: $TARGET_DIR"
echo "  - JetBrains Mono NL (No Ligatures, RTL/EDA recommended)"
echo "  - JetBrains Mono (Standard)"
echo "  - Hack"
echo "=================================================="

mkdir -p "$TARGET_DIR"

# Copy fonts preserving directory structure
cp -r "$FONTS_SRC"/* "$TARGET_DIR"/

echo "Fonts copied successfully."

# Update font cache if fontconfig is installed
if command -v fc-cache >/dev/null 2>&1; then
    echo "Updating font cache via fc-cache..."
    fc-cache -f "$TARGET_DIR"
    echo "Font cache updated successfully!"
else
    echo "Notice: fc-cache command not found. Fonts were copied, but you may need to restart your terminal/gVim."
fi

# Verify font detection
if command -v fc-list >/dev/null 2>&1; then
    echo ""
    echo "Installed fonts verified by fontconfig:"
    fc-list : family | grep -E "JetBrains Mono|Hack" | sort -u | sed 's/^/  ✓ /'
fi

echo ""
echo "All fonts installed successfully!"
