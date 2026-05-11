# Install MemCore

> **When user loads this file:** User wants to install/copy MemCore files to their system.

```
"load install.md"
```

That's it!

---

## Options

| Option | Description |
|--------|-------------|
| (default) | Install with backup |
| `--dry-run` | Preview only, no changes |

---

## Changelog

### v0.1.0 (Current)

---

## Context

When this file is loaded, AI must know:
- User wants to install/copy files to ~/.config/opencode/
- NOT just reading the file
- AI must execute install steps
- IMPORTANT: Skip copying opencode.json if already exists
- IMPORTANT: Skip copying global-memory if it already contains files

## AI Execution

When executing install, use conditional copy:

```bash
# Check for dry-run mode
DRY_RUN=false
if [[ "$*" == *"--dry-run"* ]]; then
  DRY_RUN=true
  echo "🔍 DRY-RUN MODE: No changes will be made"
  echo ""
fi

# Create backup before install (unless dry-run)
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
echo "=== Installing Agents ==="
mkdir -p ~/.config/opencode/agents

# Check if primary agent exists
primary_agent_file=$(ls ~/.config/opencode/agents/*.md 2>/dev/null | xargs -I{} grep -l "^mode: primary" {} 2>/dev/null | head -1)

if [ -z "$primary_agent_file" ]; then
  # First install - prompt for agent name
  echo ""
  echo "🎉 First time setup!"
  echo "What would you like to name your primary agent?"
  echo "Press Enter for default: memcore"
  read -p "Agent name: " agent_name
  [ -z "$agent_name" ] && agent_name="memcore"
  
  # Validate name (lowercase, numbers, hyphens only)
  if [[ ! "$agent_name" =~ ^[a-z0-9-]+$ ]] || [[ "$agent_name" =~ ^- || "$agent_name" =~ -$ ]]; then
    echo "Invalid name. Using default: memcore"
    agent_name="memcore"
  fi
  
  # Create agent with user's chosen name
  echo "Creating agent: $agent_name"
  cp core/agents/memcore.md ~/.config/opencode/agents/"$agent_name.md"
  
  # Set as primary agent
  sed -i 's/^name: memcore$/name: '"$agent_name"'/' ~/.config/opencode/agents/"$agent_name.md"
  sed -i 's/^mode: .*/mode: primary/' ~/.config/opencode/agents/"$agent_name.md"
  
  echo "✅ Primary agent '$agent_name' created!"
else
  echo "Primary agent already exists - skipping first-time setup"
fi

echo ""
echo "=== Updating Agents ==="
for f in core/agents/*.md; do
  agent_name=$(basename "$f")
  dest=~/.config/opencode/agents/"$agent_name"
  update_or_skip "$f" "$dest" "$agent_name"
done

echo ""
echo "=== Installing Skills ==="
for f in core/skills/*/*.md; do
  skill_name=$(basename "$f")
  skill_dir=$(basename "$(dirname "$f")")
  dest=~/.config/opencode/skills/"$skill_dir"/"$skill_name"
  mkdir -p ~/.config/opencode/skills/"$skill_dir"
  update_or_skip "$f" "$dest" "$skill_dir"
done

echo ""
echo "=== Installing Config ==="
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
[ "$DRY_RUN" = true ] && echo "🔍 DRY-RUN complete. Run without --dry-run to apply." || echo "✅ Install complete!"
```

## What It Does

| Action | Location |
|--------|---------|
| Updates 5 agents (compare first) | `~/.config/opencode/agents/` |
| Updates 19 skills (compare first) | `~/.config/opencode/skills/` |
| Copies opencode.json (if different) | `~/.config/opencode/opencode.json` |
| Creates memory templates (if empty) | `~/.config/opencode/global-memory/` |
| Copies validation script | `~/.config/opencode/scripts/validate.sh` |
| **Preserves user's custom agents/skills** | Unchanged |

---

## Quick Start

```bash
git clone https://github.com/khairulariffinka/memcore.git
cd memcore
opencode
```

Then in OpenCode:

```
"load install.md"
```

---

## After Install

1. Restart OpenCode
2. Say: `memcore, hello!`

---

## Troubleshooting

If something goes wrong, manually run:

```bash
mkdir -p ~/.config/opencode/agents ~/.config/opencode/skills ~/.config/opencode/global-memory
bash install.sh
```

## Development

To push changes, use a separate branch and create a PR. ALWAYS ask before pushing to main:

```bash
git checkout -b feature/your-feature
git add -A
git commit -m "your message"
git push -u origin feature/your-feature
```

Then create a Pull Request on GitHub.