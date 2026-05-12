# Update MemCore

> **When user loads this file:** User wants to update MemCore to latest version.

```
"load update.md"
```

That's it!

---

## Options

| Option | Description |
|--------|-------------|
| (default) | Full update with backup |
| `--dry-run` | Preview only, no changes |

To use, append after command: `"load update.md --dry-run"`

---

## Changelog

### v0.2.0 (Current)
- **Refocus**: Stripped 12 overlapping skills, kept 7 unique memory skills
- Observation (Mulahazah) — `@observation observe/profile/suggest`
- Reminders — `@remind set/list/done/clear`
- Library system — `@library save/search/list/get`
- LRU projects — `@lru add/list/switch/remove/status`
- Forge — `@forge scan/create/propose/list`
- Work plan — `@plan start/next/done/status`
- Post-mortem — `@pm log/list/lessons`
- Reduced to 1 agent + 7 skills (memory intelligence layer)
- Identity: complement to CodeXen, not competitor

---

## Context

When this file is loaded, AI must know:
- User wants to update to latest version
- NOT just reading the file
- AI must execute update steps
- IMPORTANT: Skip copying opencode.json if already exists AND same (preserve user customizations)
- IMPORTANT: Skip copying global-memory if it already contains files

## AI Execution

When executing update, use conditional copy:

```bash
# Check for dry-run mode
DRY_RUN=false
if [[ "$*" == *"--dry-run"* ]]; then
  DRY_RUN=true
  echo "🔍 DRY-RUN MODE: No changes will be made"
  echo ""
fi

# Create backup before update (unless dry-run)
if [ "$DRY_RUN" = false ]; then
  BACKUP_DIR="$HOME/.config/opencode.backup-$(date +%Y-%m-%d-%H%M)"
  if [ -d ~/.config/opencode ]; then
    cp -r ~/.config/opencode "$BACKUP_DIR" && echo "✅ Backup created: $BACKUP_DIR"
  fi
fi

# Function to update or preview with conflict resolution
update_or_skip() {
  local source="$1"
  local dest="$2"
  local name="$3"

  if [ ! -f "$dest" ]; then
    [ "$DRY_RUN" = true ] && echo "[DRY-RUN] Would add: $name" || cp "$source" "$dest" && echo "Added: $name"
  elif ! diff -q "$source" "$dest" > /dev/null 2>&1; then
    # File exists and is different - ask user
    if [ "$DRY_RUN" = true ]; then
      echo "[DRY-RUN] Would update: $name (CONFLICT - user has custom version)"
      echo "         Run without --dry-run to resolve"
    else
      echo ""
      echo "⚠️  CONFLICT: $name differs from MemCore version"
      echo "    [1] Keep mine (custom) - skip update"
      echo "    [2] Use MemCore version - overwrite"
      echo "    [3] Show diff - see differences"
      read -p "Choice [1]: " choice
      case "$choice" in
        2)
          cp "$source" "$dest" && echo "Updated: $name"
          ;;
        3)
          echo "--- Your version ---"
          head -20 "$dest"
          echo "--- MemCore version ---"
          head -20 "$source"
          echo ""
          read -p "Choose [1=keep mine, 2=use memcore]: " choice2
          case "$choice2" in
            2) cp "$source" "$dest" && echo "Updated: $name" ;;
            *) echo "Keeping your version" ;;
          esac
          ;;
        *)
          echo "Keeping your version"
          ;;
      esac
    fi
  else
    echo "Skipping: $name (unchanged)"
  fi
}

echo ""
echo "=== Updating Agents ==="
mkdir -p ~/.config/opencode/agents

# Find user's primary agent (mode: primary)
primary_agent_file=$(ls ~/.config/opencode/agents/*.md 2>/dev/null | xargs -I{} grep -l "^mode: primary" {} 2>/dev/null | head -1)

if [ -n "$primary_agent_file" ]; then
  # User has primary agent - update content but preserve name and mode
  primary_agent_name=$(basename "$primary_agent_file" .md)
  echo "Found primary agent: $primary_agent_name"
  if diff -q core/agents/memcore.md "$primary_agent_file" > /dev/null 2>&1; then
    echo "Skipping: $primary_agent_name (unchanged)"
  else
    echo "⚠️  CONFLICT: $primary_agent_name differs from MemCore version"
    echo "    [1] Keep mine (custom) - skip update"
    echo "    [2] Use MemCore version - overwrite (preserves name & mode)"
    read -p "Choice [1]: " choice
    if [ "$choice" = "2" ]; then
      cp core/agents/memcore.md "$primary_agent_file"
      sed -i 's/^name: memcore$/name: '"$primary_agent_name"'/' "$primary_agent_file"
      sed -i 's/^mode: subagent/mode: primary/' "$primary_agent_file"
      echo "Updated: $primary_agent_name"
    else
      echo "Keeping your version"
    fi
  fi
else
  # No primary agent - create default
  echo "No primary agent found, creating memcore.md"
  update_or_skip "core/agents/memcore.md" "$HOME/.config/opencode/agents/memcore.md" "memcore"
fi

echo ""
echo "=== Updating Subagents ==="
for f in core/agents/*.md; do
  agent_name=$(basename "$f")
  dest=~/.config/opencode/agents/"$agent_name"
  update_or_skip "$f" "$dest" "$agent_name"
done

echo ""
echo "=== Updating Skills ==="
for f in core/skills/*/*.md; do
  skill_name=$(basename "$f")
  skill_dir=$(basename "$(dirname "$f")")
  dest=~/.config/opencode/skills/"$skill_dir"/"$skill_name"
  mkdir -p ~/.config/opencode/skills/"$skill_dir"
  update_or_skip "$f" "$dest" "$skill_dir"
done

echo ""
echo "=== Updating Config ==="
# opencode.json - merge to preserve user settings
if [ -f ~/.config/opencode/opencode.json ]; then
  if ! diff -q core/opencode.json ~/.config/opencode/opencode.json > /dev/null 2>&1; then
    # User has custom config - prompt with merge option
    if [ "$DRY_RUN" = true ]; then
      echo "[DRY-RUN] Would update: opencode.json (CONFLICT - user has custom config)"
    else
      echo ""
      echo "⚠️  CONFLICT: opencode.json differs from MemCore version"
      echo "    [1] Keep mine - skip, don't change (RECOMMENDED)"
      echo "    [2] Merge - add MemCore settings to mine"
      echo "    [3] Show diff - see before deciding"
      read -p "Choice [1]: " choice
      case "$choice" in
        2)
          # Merge JSON - MemCore adds new keys, keeps user values
          if command -v jq >/dev/null 2>&1; then
            jq -s '.[0] * .[1]' ~/.config/opencode/opencode.json core/opencode.json > ~/.config/opencode/opencode.json.tmp && \
            mv ~/.config/opencode/opencode.json.tmp ~/.config/opencode/opencode.json && \
            echo "Merged opencode.json (your settings kept + new MemCore settings added)"
          else
            # No jq - fallback to keeping user config
            echo "jq not found - keeping your config (install jq for merge)"
          fi
          ;;
        3)
          echo "--- Your config ---"
          cat ~/.config/opencode/opencode.json
          echo "--- MemCore config ---"
          cat core/opencode.json
          echo ""
          read -p "Choose [1=keep mine, 2=merge]: " choice2
          case "$choice2" in
            2)
              if command -v jq >/dev/null 2>&1; then
                jq -s '.[0] * .[1]' ~/.config/opencode/opencode.json core/opencode.json > ~/.config/opencode/opencode.json.tmp && \
                mv ~/.config/opencode/opencode.json.tmp ~/.config/opencode/opencode.json && \
                echo "Merged opencode.json"
              else
                echo "jq not found - keeping your config"
              fi
              ;;
            *) echo "Keeping your config" ;;
          esac
          ;;
        *)
          echo "Keeping your config"
          ;;
      esac
    fi
  else
    echo "Skipping opencode.json (unchanged)"
  fi
else
  [ "$DRY_RUN" = true ] && echo "[DRY-RUN] Would add: opencode.json" || cp core/opencode.json ~/.config/opencode/opencode.json && echo "Copied opencode.json"
fi

# global-memory
if [ -z "$(ls -A ~/.config/opencode/global-memory 2>/dev/null)" ]; then
  [ "$DRY_RUN" = true ] && echo "[DRY-RUN] Would init: global-memory" || cp -r templates/global-memory/* ~/.config/opencode/global-memory/ && echo "Initialized global-memory"
else
  echo "Skipping global-memory (already exists)"
fi

# validation script
echo ""
echo "=== Installing Validation Script ==="
mkdir -p ~/.config/opencode/scripts
update_or_skip "scripts/validate.sh" "$HOME/.config/opencode/scripts/validate.sh" "validate.sh"

echo ""
[ "$DRY_RUN" = true ] && echo "🔍 DRY-RUN complete. Run without --dry-run to apply." || echo "✅ Update complete!"
```

## What It Does

| Action | Description |
|--------|-----------|
| Update agents (compare first) | Copy 1 agent from `core/agents/` |
| Update skills (compare first) | Copy 7 skills from `core/skills/` |
| Update opencode.json (if different) | Preserve user customizations |
| Update memory templates (if empty) | Skip if exists |
| **Preserves user's custom agents/skills** | Unchanged |

---

## Quick Update

In OpenCode:

```
"load update.md"
```

---

## Version

Current: **0.2.0**

---

## Troubleshooting

If update doesn't work, run the install script:

```bash
bash install.sh
```

---

## Development Workflow

For contributors - NEVER push directly to main. ALWAYS ask before pushing. Use branches:

```bash
# Create a new branch
git checkout -b feature/your-feature

# Make changes and commit
git add -A
git commit -m "feat: your feature"

# Push and create PR
git push -u origin feature/your-feature
# Then create Pull Request on GitHub

# IMPORTANT: Ask before pushing to main
```