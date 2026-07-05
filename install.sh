#!/bin/bash
# install.sh
# VIBE-Claude-Plugin standard plugin installer for macOS/Linux

set -e

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGINS_ROOT="$HOME/.claude/plugins"
TARGET_DIR="$PLUGINS_ROOT/vibe-claude-plugin"

echo -e "\033[0;36mInstalling VIBE-Claude-Plugin as a Claude Code plugin...\033[0m"

mkdir -p "$PLUGINS_ROOT"

if [ -d "$TARGET_DIR" ]; then
  rm -rf "$TARGET_DIR"
  echo -e "\033[0;33mRemoved existing plugin directory: $TARGET_DIR\033[0m"
fi

mkdir -p "$TARGET_DIR"

for item in ".claude-plugin" "commands" "skills" "scripts" "README.md" "LICENSE" "AI_DEVELOPMENT_DOC.md" "使用手册.md"; do
  if [ -e "$PLUGIN_DIR/$item" ]; then
    cp -r "$PLUGIN_DIR/$item" "$TARGET_DIR/"
  fi
done

echo -e "\033[0;32mInstallation completed successfully!\033[0m"
echo -e "\033[0;32mPlugin path: $TARGET_DIR\033[0m"
echo -e "\033[0;33mPlease restart Claude Code, then run /plugins to verify or use /vibe directly.\033[0m"
