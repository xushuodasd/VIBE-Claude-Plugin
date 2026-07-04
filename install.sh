#!/bin/bash
# install.sh
# VIBE-Claude-Plugin Installation Script for macOS/Linux

set -e

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$PLUGIN_DIR/skills"
TARGET_DIR="$HOME/.claude/skills"

echo -e "\033[0;36mInstalling VIBE-Claude-Plugin...\033[0m"

# Create target directory if it doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
    echo -e "\033[0;32mCreated directory: $TARGET_DIR\033[0m"
fi

# Copy skills
echo -e "\033[0;36mCopying skills from $SKILLS_DIR to $TARGET_DIR\033[0m"
cp -r "$SKILLS_DIR/"* "$TARGET_DIR/"

echo -e "\033[0;32mInstallation completed successfully!\033[0m"
echo -e "\033[0;33mYou can now use the VIBE skills in Claude Code.\033[0m"
echo -e "\033[0;33mRestart Claude Code to apply the changes.\033[0m"
