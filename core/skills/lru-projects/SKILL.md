---
name: lru-projects
description: Multi-project tracking with LRU eviction — 10 active slots, auto-archival
---

# LRU Projects Skill

Smart multi-project management. Track up to 10 active projects with least-recently-used eviction. Archived projects are remembered but not loaded.

## Primary Functions

| Function | Description |
|----------|-------------|
| **add** | Register current directory as a tracked project |
| **list** | List tracked projects (active + archived) |
| **switch** | Switch to another tracked project |
| **remove** | Remove a project from tracking |
| **status** | Show project activity summary |

## Storage

Projects tracked in `~/.config/opencode/global-memory/projects.md`:

```markdown
# Tracked Projects

## Active (max 10)
| Rank | Project | Last Active | Sessions | Path |
|------|---------|-------------|----------|------|

## Archived
| Project | Last Active | Sessions | Path |
|---------|-------------|----------|------|
```

## Execute Logic

```bash
PROJECTS_FILE="$HOME/.config/opencode/global-memory/projects.md"
MAX_ACTIVE=10

# @lru add [name]
# Register current directory as a tracked project
if [[ "$1" == "add" ]]; then
    NAME="${2:-$(basename "$PWD")}"
    PATH_VAL="$PWD"
    DATE=$(date +%Y-%m-%d)

    # Count sessions from diary
    SESSION_COUNT=0
    if [[ -f "docs/session-diary.md" ]]; then
        SESSION_COUNT=$(grep -c "^## Session:" docs/session-diary.md 2>/dev/null || echo 0)
    fi

    mkdir -p "$(dirname "$PROJECTS_FILE")"

    if [[ ! -f "$PROJECTS_FILE" ]]; then
        cat > "$PROJECTS_FILE" << EOF
# Tracked Projects

## Active (max $MAX_ACTIVE)
| Rank | Project | Last Active | Sessions | Path |
|------|---------|-------------|----------|------|

## Archived
| Project | Last Active | Sessions | Path |
|---------|-------------|----------|------|

---
EOF
    fi

    # Check if already tracked
    if grep -q "| $NAME |" "$PROJECTS_FILE" 2>/dev/null; then
        # Update it — move to top of active
        echo "Project '$NAME' already tracked. Updating..."
        # Remove old entry
        grep -v "| $NAME |" "$PROJECTS_FILE" > "${PROJECTS_FILE}.tmp"
        mv "${PROJECTS_FILE}.tmp" "$PROJECTS_FILE"
    fi

    # Count current active
    ACTIVE_COUNT=$(grep -c "^| [0-9]" "$PROJECTS_FILE" 2>/dev/null || echo 0)

    if [[ $ACTIVE_COUNT -ge $MAX_ACTIVE ]]; then
        # Evict least recently used (last in active list)
        echo "Active slot limit reached ($MAX_ACTIVE). Archiving oldest..."
        OLDEST=$(grep "^| [0-9]" "$PROJECTS_FILE" | head -1)
        # Move to archived
        OLD_NAME=$(echo "$OLDEST" | awk -F'|' '{print $3}' | xargs)
        OLD_DATE=$(echo "$OLDEST" | awk -F'|' '{print $4}' | xargs)
        OLD_SESS=$(echo "$OLDEST" | awk -F'|' '{print $5}' | xargs)
        OLD_PATH=$(echo "$OLDEST" | awk -F'|' '{print $6}' | xargs)
        sed -i "/^| [0-9].*| $OLD_NAME |/d" "$PROJECTS_FILE"
        sed -i "/^## Archived/a| $OLD_NAME | $OLD_DATE | $OLD_SESS | $OLD_PATH |" "$PROJECTS_FILE"
        echo "Archived: $OLD_NAME"
    fi

    # Add as active (at position 1, shift others)
    # Find the current top rank
    sed -i 's/^| \([0-9]\)/| \x27$\x27/' "$PROJECTS_FILE" 2>/dev/null || true
    # Simple approach: insert at top of active section
    sed -i "/^## Active/a| 1 | $NAME | $DATE | $SESSION_COUNT | $PATH_VAL |" "$PROJECTS_FILE"

    # Renumber active entries
    awk '
    /^## Active/ { active=1; print; next }
    /^## Archived/ { active=0; print; next }
    active && /^| [0-9]/ { rank++; sub(/\| [0-9]+ \|/, "| " rank " |"); print; next }
    { print }
    ' "$PROJECTS_FILE" > "${PROJECTS_FILE}.tmp" && mv "${PROJECTS_FILE}.tmp" "$PROJECTS_FILE"

    echo "Project added: $NAME (active: 1)"
fi

# @lru list
# List tracked projects
if [[ "$1" == "list" ]]; then
    if [[ ! -f "$PROJECTS_FILE" ]]; then
        echo "No tracked projects."
        exit 0
    fi

    echo "=== Active Projects ==="
    grep "^| [0-9]" "$PROJECTS_FILE" 2>/dev/null | while read -r LINE; do
        echo "  $LINE"
    done

    echo ""
    echo "=== Archived Projects ==="
    IN_ARCHIVE=0
    while read -r LINE; do
        if echo "$LINE" | grep -q "^## Archived"; then
            IN_ARCHIVE=1
            continue
        fi
        if [[ $IN_ARCHIVE -eq 1 ]] && echo "$LINE" | grep -q "^|"; then
            echo "  $LINE"
        fi
        if echo "$LINE" | grep -q "^---"; then
            break
        fi
    done < "$PROJECTS_FILE"
fi

# @lru switch <name>
# Switch to another tracked project
if [[ "$1" == "switch" ]]; then
    NAME="$2"

    if [[ -z "$NAME" ]]; then
        echo "Usage: @lru switch <project-name>"
        echo "Use '@lru list' to see available projects"
        exit 1
    fi

    if [[ ! -f "$PROJECTS_FILE" ]]; then
        echo "No tracked projects."
        exit 0
    fi

    # Find project path
    PROJECT_LINE=$(grep "| $NAME |" "$PROJECTS_FILE" 2>/dev/null)
    if [[ -z "$PROJECT_LINE" ]]; then
        echo "Project '$NAME' not found."
        exit 1
    fi

    PROJECT_PATH=$(echo "$PROJECT_LINE" | awk -F'|' '{print $6}' | xargs)
    if [[ ! -d "$PROJECT_PATH" ]]; then
        echo "Project path not found: $PROJECT_PATH"
        exit 1
    fi

    # Update last active time
    DATE=$(date +%Y-%m-%d)
    sed -i "s/| $NAME | [0-9-]* | [0-9]* | $PROJECT_PATH |/| $NAME | $DATE | ... | $PROJECT_PATH |/" "$PROJECTS_FILE"

    # Move to top of active list
    grep -v "| $NAME |" "$PROJECTS_FILE" > "${PROJECTS_FILE}.tmp"
    mv "${PROJECTS_FILE}.tmp" "$PROJECTS_FILE"
    sed -i "/^## Active/a| 0 | $NAME | $DATE | ... | $PROJECT_PATH |" "$PROJECTS_FILE"

    echo "Switched to: $NAME ($PROJECT_PATH)"
    echo "Run 'cd $PROJECT_PATH' to navigate."
fi

# @lru remove <name>
# Remove a project from tracking
if [[ "$1" == "remove" ]]; then
    NAME="$2"
    if [[ -z "$NAME" ]]; then
        echo "Usage: @lru remove <project-name>"
        exit 1
    fi

    if [[ ! -f "$PROJECTS_FILE" ]]; then
        echo "No tracked projects."
        exit 0
    fi

    if grep -q "| $NAME |" "$PROJECTS_FILE" 2>/dev/null; then
        grep -v "| $NAME |" "$PROJECTS_FILE" > "${PROJECTS_FILE}.tmp"
        mv "${PROJECTS_FILE}.tmp" "$PROJECTS_FILE"
        echo "Project removed: $NAME"
    else
        echo "Project '$NAME' not found."
    fi
fi

# @lru status
# Show project activity summary
if [[ "$1" == "status" ]]; then
    if [[ ! -f "$PROJECTS_FILE" ]]; then
        echo "No tracked projects."
        exit 0
    fi

    ACTIVE=$(grep -c "^| [0-9]" "$PROJECTS_FILE" 2>/dev/null || echo 0)
    ARCHIVED=$(sed -n '/^## Archived/,/^---/p' "$PROJECTS_FILE" 2>/dev/null | grep -c "^|" || echo 0)

    echo "=== LRU Projects ==="
    echo "Active: $ACTIVE/$MAX_ACTIVE"
    echo "Archived: $ARCHIVED"

    if [[ $ACTIVE -ge $MAX_ACTIVE ]]; then
        echo "⚠️  Active limit reached. Next add will archive oldest."
    fi

    CURRENT_PROJECT=$(basename "$PWD")
    if grep -q "| $CURRENT_PROJECT |" "$PROJECTS_FILE" 2>/dev/null; then
        echo "Current: $CURRENT_PROJECT (tracked)"
    else
        echo "Current: $CURRENT_PROJECT (not tracked — use '@lru add')"
    fi
fi
```
