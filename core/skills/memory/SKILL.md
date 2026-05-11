---
name: memory
description: Managed project memory - handles modular context, decision syncing, and global diary management using the standard Work Diary format.
---

# Memory Skill

Manages persistent project context and global knowledge preservation.

## Primary Functions

| Function | Description |
|----------|-------------|
| **READ** | Selective loading of AGENTS.md, current-state.md, and specific module context. |
| **UPDATE** | Marking planner.md progress, syncing decisions. |
| **SAVE** | Local session diary + global work diary sync. |

---

## Execute Logic

```bash
# 1. READ CONTEXT (Modular Intelligence)
# Usage: @memory read [module]
if [[ "$1" == "read" ]]; then
    echo "[MEMORY LOADED]"
    [ -f "AGENTS.md" ] && cat AGENTS.md
    [ -f "docs/current-state.md" ] && cat docs/current-state.md
    if [[ -n "$2" && -f "docs/context/$2.md" ]]; then
        echo "--- Module: $2 ---"
        cat "docs/context/$2.md"
    fi
fi

# 2. MARK PROGRESS
# Usage: @memory complete TASK-ID
if [[ "$1" == "complete" ]]; then
    sed -i "s/\[ \] \*\*Task $2\*\*/\[x\] \*\*Task $2\*\*/g" planner.md
    sed -i "s/\[ \] $2/\[x\] $2/g" planner.md
    echo "✅ Task $2 marked complete in planner.md"
fi

# 3. AUTO-SAVE (Local + Global Sync)
# NOTE: Before calling @memory save, ensure current-session.md
# has been written by the orchestrator during the session.
# The orchestrator (memcore.md) must populate:
#   ~/.config/opencode/global-memory/current-session.md
if [[ "$1" == "save" ]]; then
    DATE=$(date +%Y-%m-%d)
    TIME_NOW=$(date +%H:%M)
    MONTH=$(date +%Y-%m)
    PROJECT_NAME=$(basename "$PWD")

    GLOBAL_DIR="$HOME/.config/opencode/global-memory"
    GLOBAL_RAM="$GLOBAL_DIR/current-session.md"
    GLOBAL_DIARY="$GLOBAL_DIR/work-diary/diary-$MONTH.md"
    ARCHIVE_DIR="$GLOBAL_DIR/work-diary/archive"

    # Step A: Update Local Project Diary
    mkdir -p docs
    cat >> docs/session-diary.md << EOF
## Session: $DATE $TIME_NOW
- Project: $PROJECT_NAME
- Status: Auto-saved via @memory skill
EOF

    # Step B: Initialize Global Diary if not exists
    if [ ! -f "$GLOBAL_DIARY" ]; then
        mkdir -p "$GLOBAL_DIR/work-diary"
        cat > "$GLOBAL_DIARY" << EOF
# Work Diary - $MONTH

Monthly session log - auto-archived when >1000 lines.

---
EOF
    fi

    # Step C: Append RAM to Diary, then clear RAM
    if [[ -f "$GLOBAL_RAM" ]]; then
        echo "### $DATE - Session Update" >> "$GLOBAL_DIARY"
        echo "**Time:** $TIME_NOW" >> "$GLOBAL_DIARY"
        echo "**Project:** $PROJECT_NAME" >> "$GLOBAL_DIARY"
        echo "" >> "$GLOBAL_DIARY"
        cat "$GLOBAL_RAM" >> "$GLOBAL_DIARY"
        echo "" >> "$GLOBAL_DIARY"
        echo "---" >> "$GLOBAL_DIARY"
        : > "$GLOBAL_RAM"  # Clear RAM after save
    else
        echo "⚠️  No current-session.md found. Session summary not saved globally."
    fi

    # Step D: Auto-Archive (>1000 lines)
    LINE_COUNT=$(wc -l < "$GLOBAL_DIARY" 2>/dev/null || echo 0)
    if [ "$LINE_COUNT" -gt 1000 ]; then
        mkdir -p "$ARCHIVE_DIR"
        mv "$GLOBAL_DIARY" "$ARCHIVE_DIR/diary-$MONTH-$(date +%s).md"
        echo "✅ Diary archived due to size (>1000 lines)."
    fi

    echo "✅ Memory saved (local + global)."
fi
```
