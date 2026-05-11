---
name: save-diary
description: Auto-save session diary with structured format and enhanced metadata
---

# Save Diary Skill

Auto-save session diary dengan format better — enriched metadata, structured summaries, and smart categorisation.

## Primary Functions

| Function | Description |
|----------|-------------|
| **save** | Auto-save sesi dengan format better |
| **list** | Senarai session diary entries |
| **view** | View session diary tertentu |

## Better Format

Setiap session disimpan dalam format terstruktur:

```markdown
| Field | Description |
|-------|-------------|
| **Date** | Session date |
| **Duration** | Estimated session length |
| **Focus** | Main area of work |
| **Tasks** | What was done |
| **Decisions** | Key decisions made |
| **Files** | Files created/modified |
| **Next** | What to do next |
```

## Execute Logic

```bash
# @diary save [focus]
# Auto-save current session with better format
if [[ "$1" == "save" ]]; then
    DATE=$(date +%Y-%m-%d)
    TIME_NOW=$(date +%H:%M)
    MONTH=$(date +%Y-%m)
    PROJECT_NAME=$(basename "$PWD")
    FOCUS="${2:-General}"

    GLOBAL_DIR="$HOME/.config/opencode/global-memory"
    GLOBAL_RAM="$GLOBAL_DIR/current-session.md"
    GLOBAL_DIARY="$GLOBAL_DIR/work-diary/diary-$MONTH.md"
    LOCAL_DIARY="docs/session-diary.md"

    # Read RAM if exists
    RAM_CONTENT=""
    if [[ -f "$GLOBAL_RAM" ]]; then
        RAM_CONTENT=$(cat "$GLOBAL_RAM")
    fi

    # Count sessions today
    TODAY_COUNT=$(grep -c "## Session: $DATE" "$LOCAL_DIARY" 2>/dev/null || echo 0)
    SESSION_NUM=$((TODAY_COUNT + 1))

    # Detect tasks from planner.md
    COMPLETED_TASKS=$(grep -E "\[x\]" planner.md 2>/dev/null | head -5 || echo "None")
    PENDING_TASKS=$(grep -E "\[ \]" planner.md 2>/dev/null | head -5 || echo "None")

    # Detect decisions from DECISIONS.md
    RECENT_DECISIONS=$(grep "^| DEC-" DECISIONS.md 2>/dev/null | tail -3 || echo "None")

    # Detect changed files from git
    CHANGED_FILES=$(git diff --name-only 2>/dev/null | head -10 || echo "None")
    UNTRACKED_FILES=$(git ls-files --others --exclude-standard 2>/dev/null | head -10 || echo "None")

    mkdir -p docs

    # Save to local diary with better format
    cat >> "$LOCAL_DIARY" << EOF

## Session: $DATE (Session #$SESSION_NUM)

| Field | Detail |
|-------|--------|
| **Time** | $TIME_NOW |
| **Focus** | $FOCUS |
| **Project** | $PROJECT_NAME |

### Tasks Completed
$COMPLETED_TASKS

### Pending Tasks
$PENDING_TASKS

### Decisions
$RECENT_DECISIONS

### Files Changed
Modified: $CHANGED_FILES
New: $UNTRACKED_FILES

### Session Notes
$RAM_CONTENT

### Next Steps
- Review pending tasks in planner.md

---
EOF

    echo "Session #$SESSION_NUM saved with better format."

    # Sync to global diary
    mkdir -p "$GLOBAL_DIR/work-diary"
    if [[ ! -f "$GLOBAL_DIARY" ]]; then
        cat > "$GLOBAL_DIARY" << EOF
# Work Diary - $MONTH

Monthly session log with structured format.

---
EOF
    fi

    cat >> "$GLOBAL_DIARY" << EOF

### $DATE - Session #$SESSION_NUM
**Time:** $TIME_NOW
**Focus:** $FOCUS
**Project:** $PROJECT_NAME

**Tasks Completed:**
$COMPLETED_TASKS

**Files Changed:**
Modified: $CHANGED_FILES
New: $UNTRACKED_FILES

---
EOF

    # Clear RAM after save
    if [[ -f "$GLOBAL_RAM" ]]; then
        : > "$GLOBAL_RAM"
    fi

    echo "Memory saved (local + global)."
fi

# @diary list [limit]
if [[ "$1" == "list" ]]; then
    LIMIT="${2:-10}"
    if [[ -f "docs/session-diary.md" ]]; then
        echo "Recent sessions:"
        grep "^## Session:" docs/session-diary.md | tail -"$LIMIT"
    else
        echo "No diary entries yet."
    fi
fi

# @diary view <session-id>
if [[ "$1" == "view" ]]; then
    if [[ -z "$2" ]]; then
        echo "Usage: @diary view <session-id>"
        echo "Example: @diary view 1"
        exit 1
    fi
    if [[ -f "docs/session-diary.md" ]]; then
        awk "/Session.*#$2/,/^---/" docs/session-diary.md | head -40
    fi
fi
```
