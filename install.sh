#!/usr/bin/env bash
# Claude Skills Installation Script
# Symlinks skills from the checked-out repository to ~/.claude/skills/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"

# Ensure target directory exists
if [ ! -d "$SKILLS_DIR" ]; then
    echo "Creating skills directory: $SKILLS_DIR"
    mkdir -p "$SKILLS_DIR"
fi

# Find all skill directories (any directory with a SKILL.md file)
SKILL_DIRS=()
while IFS= read -r -d '' dir; do
    SKILL_DIRS+=("$dir")
done < <(find "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 -type d -exec test -f "{}/SKILL.md" \; -print0)

echo ""
echo "Found ${#SKILL_DIRS[@]} skills to install:"
echo ""

INSTALLED=0
UPDATED=0
SKIPPED=0

for skill_dir in "${SKILL_DIRS[@]}"; do
    skill_name=$(basename "$skill_dir")
    source_path="$skill_dir"
    target_path="$SKILLS_DIR/$skill_name"

    # Check if already symlinked
    if [ -L "$target_path" ]; then
        link_target=$(readlink "$target_path")
        if [ "$link_target" = "$source_path" ]; then
            echo "  [SKIP] $skill_name - already linked"
            ((SKIPPED++))
            continue
        else
            echo "  [UPDATE] $skill_name - removing old link"
            rm -rf "$target_path"
        fi
    fi

    # Create symlink
    if ln -s "$source_path" "$target_path" 2>/dev/null; then
        echo "  [OK] $skill_name -> $target_path"
        ((INSTALLED++))
    else
        echo "  [ERROR] Failed to link $skill_name"
    fi
done

echo ""
echo "Installation summary:"
echo "  Installed: $INSTALLED"
echo "  Updated: $UPDATED"
echo "  Skipped: $SKIPPED"
echo ""
echo "Skills are now available in Claude Code!"
echo "Use '/oh-my-claudecode:help' to see available skills."
echo ""
