#!/bin/sh
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# Backup existing .vimrc if present
if [ -f "$HOME/.vimrc" ]; then
    BACKUP="$HOME/.vimrc.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$HOME/.vimrc" "$BACKUP"
    echo "Backed up existing ~/.vimrc to $BACKUP"
fi

cp "${REPO_DIR}/vimrcs/basic.vim" "$HOME/.vimrc"
echo "Installed the Basic Vim configuration successfully! Enjoy :-)"
