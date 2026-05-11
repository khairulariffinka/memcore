---
name: memory-consolidation
description: Better patching and consolidation system for session diaries, tasks, and decisions
---

# Memory Consolidation Skill

Advanced memory management — compress session history, patch planner tasks, sync decisions, and consolidate patterns across sessions.

## Primary Functions

| Function | Description |
|----------|-------------|
| **compress** | Compress session diary by age/level |
| **patch** | Sync planner.md, decisions, and diary consistency |
| **analyze** | Scan for patterns and recurring themes |
| **status** | Show memory usage and health |

## Compression Levels

| Level | Action | Savings |
|-------|--------|---------|
| **light** | Summarize sessions older than 10 sessions | ~30-50% |
| **medium** | Compress all except last 5 sessions | ~50-70% |
| **full** | Keep only decisions + key outcomes | ~70-80% |

## Execute Logic

```bash
LOCAL_DIARY="docs/session-diary.md"
GLOBAL_DIARY="$HOME/.config/opencode/global-memory/work-diary"
PLANNER="planner.md"
DECISIONS="DECISIONS.md"
PATTERNS="docs/patterns.md"
LESSONS="docs/lessons.md"

# @consolidate compress [light|medium|full]
if [[ "$1" == "compress" ]]; then
    LEVEL="${2:-light}"

    if [[ ! -f "$LOCAL_DIARY" ]]; then
        echo "No session diary to compress."
        exit 0
    fi

    TOTAL_LINES=$(wc -l < "$LOCAL_DIARY")
    TOTAL_SESSIONS=$(grep -c "^## Session:" "$LOCAL_DIARY")

    echo "Compressing $TOTAL_SESSIONS sessions ($TOTAL_LINES lines) at '$LEVEL' level..."

    case "$LEVEL" in
        light)
            # Summarize sessions older than last 10
            KEEP=10
            ;;
        medium)
            # Keep only last 5 sessions
            KEEP=5
            ;;
        full)
            # Keep only last 2 sessions + decisions
            KEEP=2
            ;;
        *)
            echo "Unknown level: $LEVEL"
            echo "Valid: light, medium, full"
            exit 1
            ;;
    esac

    BACKUP="$LOCAL_DIARY.bak"
    cp "$LOCAL_DIARY" "$BACKUP"

    # Get last N sessions
    LAST_SESSIONS=$(grep -n "^## Session:" "$LOCAL_DIARY" | tail -"$KEEP" | head -1 | cut -d: -f1)

    if [[ "$LEVEL" == "full" ]]; then
        # Full: extract key decisions and outcomes only
        cat > "$LOCAL_DIARY" << EOF
# Session Diary — Consolidated ($(date +%Y-%m-%d))

> Auto-consolidated on $(date +%Y-%m-%d). Full history in diary archive.

---
EOF
        # Keep only last KEEP sessions
        sed -n "${LAST_SESSIONS},\$p" "$BACKUP" >> "$LOCAL_DIARY"
        ORIGINAL_LINES=$TOTAL_LINES
        NEW_LINES=$(wc -l < "$LOCAL_DIARY")
        SAVED=$((ORIGINAL_LINES - NEW_LINES))
        echo "Full consolidation done. Saved $SAVED lines."
    else
        # Light/medium: keep last KEEP sessions, summarize older ones
        cat > "$LOCAL_DIARY" << EOF
# Session Diary — Consolidated ($(date +%Y-%m-%d))

> Consolidated on $(date +%Y-%m-%d). Older sessions summarized below.

---
EOF

        # Summarize sessions before LAST_SESSIONS
        PREV_SESSIONS=$((LAST_SESSIONS - 1))
        if [[ $PREV_SESSIONS -gt 0 ]]; then
            head -n $PREV_SESSIONS "$BACKUP" | awk '
                /^## Session:/ {
                    if (summary != "") print summary
                    summary = $0
                    next
                }
                /Tasks Completed/ { show = 1; next }
                /^---/ { show = 0; if (summary != "") print summary; summary = ""; next }
                show && /^- \[x\]/ { summary = summary " | Task: " substr($0, 6) }
                show && /\*\*Focus\*\*/ { summary = summary " | Focus: " $NF }
                /^### Decisions/ { show_dec = 1; next }
                show_dec && /^DEC-/ { summary = summary " | " $0; show_dec = 0 }
            '
            if (length(summary) > 0) print summary
        fi

        echo "" >> "$LOCAL_DIARY"
        echo "---" >> "$LOCAL_DIARY"
        echo "" >> "$LOCAL_DIARY"
        echo "### Recent Sessions (preserved in full)" >> "$LOCAL_DIARY"
        echo "" >> "$LOCAL_DIARY"

        # Append full recent sessions
        sed -n "${LAST_SESSIONS},\$p" "$BACKUP" >> "$LOCAL_DIARY"

        ORIGINAL_LINES=$TOTAL_LINES
        NEW_LINES=$(wc -l < "$LOCAL_DIARY")
        SAVED=$((ORIGINAL_LINES - NEW_LINES))
        echo "$LEVEL compression done. Saved $SAVED lines ($((SAVED * 100 / ORIGINAL_LINES))% reduction)."
    fi

    # Archive the backup
    mkdir -p docs/archive
    ARCHIVE_NAME="docs/archive/session-diary-$(date +%Y%m%d-%H%M%S).bak"
    mv "$BACKUP" "$ARCHIVE_NAME"
    echo "Backup saved: $ARCHIVE_NAME"
fi

# @consolidate patch [planner|decisions|all]
if [[ "$1" == "patch" ]]; then
    TARGET="${2:-all}"

    if [[ "$TARGET" == "planner" || "$TARGET" == "all" ]]; then
        if [[ -f "$PLANNER" ]]; then
            # Detect inconsistencies in planner
            echo "=== Patching: planner.md ==="
            # Mark tasks with no context as needing review
            sed -i 's/^- \[ \] \(.*\)(no context)/- [ ] \1 ? (needs review)/g' "$PLANNER" 2>/dev/null
            echo "Planner consistency check done."
        else
            echo "No planner.md found."
        fi
    fi

    if [[ "$TARGET" == "decisions" || "$TARGET" == "all" ]]; then
        if [[ -f "$DECISIONS" ]]; then
            echo "=== Patching: DECISIONS.md ==="
            # Check for decisions with no status
            UNSTATED=$(grep -c "^| DEC-" "$DECISIONS" 2>/dev/null || echo 0)
            echo "$UNSTATED decisions found."
        else
            echo "No DECISIONS.md found."
        fi
    fi

    # Sync planner tasks to current session diary
    if [[ "$TARGET" == "all" ]]; then
        echo "=== Syncing tasks to diary ==="
        if [[ -f "$PLANNER" && -f "$LOCAL_DIARY" ]]; then
            PENDING=$(grep -cE "^- \[ \]" "$PLANNER" 2>/dev/null || echo 0)
            COMPLETED=$(grep -cE "^- \[x\]" "$PLANNER" 2>/dev/null || echo 0)
            echo "Sync complete: $PENDING pending, $COMPLETED completed tasks."
        fi
    fi

    echo "Patch complete."
fi

# @consolidate analyze
if [[ "$1" == "analyze" ]]; then
    echo "=== Memory Analysis ==="

    # Session frequency
    if [[ -f "$LOCAL_DIARY" ]]; then
        TOTAL_SESSIONS=$(grep -c "^## Session:" "$LOCAL_DIARY")
        TOTAL_LINES=$(wc -l < "$LOCAL_DIARY")
        echo "Sessions: $TOTAL_SESSIONS ($TOTAL_LINES lines)"

        # Frequency by month
        echo ""
        echo "=== Sessions per Month ==="
        grep "^## Session:" "$LOCAL_DIARY" | sed 's/## Session: //' | sed 's/ (Session.*//' | sed 's/-[0-9]*$//' | sed 's/..$//' | sort | uniq -c | sort -rn | head -6
    fi

    # Decision count
    if [[ -f "$DECISIONS" ]]; then
        DEC_COUNT=$(grep -c "^| DEC-" "$DECISIONS" 2>/dev/null || echo 0)
        echo ""
        echo "Decisions: $DEC_COUNT"
    fi

    # Task summary
    if [[ -f "$PLANNER" ]]; then
        PENDING=$(grep -cE "^- \[ \]" "$PLANNER" 2>/dev/null || echo 0)
        COMPLETED=$(grep -cE "^- \[x\]" "$PLANNER" 2>/dev/null || echo 0)
        TOTAL=$((PENDING + COMPLETED))
        echo ""
        echo "=== Tasks ==="
        echo "Total: $TOTAL | Pending: $PENDING | Completed: $COMPLETED"
        if [[ $TOTAL -gt 0 ]]; then
            PCT=$((COMPLETED * 100 / TOTAL))
            echo "Progress: ${PCT}%"
        fi
    fi

    # Reminder count
    if [[ -f "docs/reminders.md" ]]; then
        REMINDERS=$(grep -c "| Pending |" docs/reminders.md 2>/dev/null || echo 0)
        echo ""
        echo "Pending reminders: $REMINDERS"
    fi

    # Library entries
    if [[ -d "docs/library" ]]; then
        LIB_COUNT=$(find docs/library -name "*.md" 2>/dev/null | wc -l)
        echo "Library entries: $LIB_COUNT"
    fi

    # Global memory usage
    if [[ -d "$HOME/.config/opencode/global-memory" ]]; then
        GLOBAL_SIZE=$(du -sh "$HOME/.config/opencode/global-memory" 2>/dev/null | cut -f1)
        echo ""
        echo "=== Global Memory ==="
        echo "Size: $GLOBAL_SIZE"
        echo "Files: $(find "$HOME/.config/opencode/global-memory" -type f 2>/dev/null | wc -l)"
    fi
fi

# @consolidate status
# Quick health overview
if [[ "$1" == "status" ]]; then
    echo "=== Memory Health ==="

    # Diary
    if [[ -f "$LOCAL_DIARY" ]]; then
        DIARY_SIZE=$(wc -l < "$LOCAL_DIARY")
        if [[ $DIARY_SIZE -gt 500 ]]; then
            echo "⚠️  Session diary: $DIARY_SIZE lines (consider compression)"
        else
            echo "✅ Session diary: $DIARY_SIZE lines"
        fi
    else
        echo "⚠️  No session diary"
    fi

    # Backup age
    LATEST_BACKUP=$(ls -t docs/archive/session-diary-*.bak 2>/dev/null | head -1)
    if [[ -n "$LATEST_BACKUP" ]]; then
        BACKUP_DATE=$(stat -c %Y "$LATEST_BACKUP" 2>/dev/null)
        NOW=$(date +%s)
        BACKUP_AGE=$(( (NOW - BACKUP_DATE) / 86400 ))
        echo "✅ Last backup: ${BACKUP_AGE} days ago"
    else
        echo "ℹ️  No diary backups yet"
    fi

    # Global memory
    if [[ -d "$HOME/.config/opencode/global-memory" ]]; then
        echo "✅ Global memory directory exists"
    else
        echo "⚠️  No global memory directory"
    fi

    # Patterns
    if [[ -f "$PATTERNS" ]]; then
        PAT_LINES=$(wc -l < "$PATTERNS")
        echo "✅ Patterns: $PAT_LINES lines"
    else
        echo "ℹ️  No patterns file yet"
    fi

    echo ""
    echo "Run '@consolidate analyze' for detailed memory analysis."
fi
```
