---
name: work-plan
description: Plan-to-execution tracking — breakdown, assign, execute, commit per task
---

# Work Plan Skill

Execute task plans with per-task tracking and optional auto-commit. Integrates with planner.md, session diary, and git.

## Primary Functions

| Function | Description |
|----------|-------------|
| **start** | Start working on a plan/task |
| **next** | Show next pending task |
| **done** | Mark current task done, commit if git |
| **status** | Show plan progress |

## Execute Logic

```bash
PLAN_DIR="docs/plans"
CURRENT_TASK_FILE="$PLAN_DIR/.current"

# @plan start <plan-name|plan-file>
# Load a plan file and begin execution
if [[ "$1" == "start" ]]; then
    NAME="$2"
    PLAN_FILE="$PLAN_DIR/$NAME.md"

    if [[ ! -f "$PLAN_FILE" ]]; then
        # Search for plan in planner.md
        if [[ -f "planner.md" ]]; then
            TASKS=$(grep -nE "^- \[ \]" planner.md | head -10)
            if [[ -n "$TASKS" ]]; then
                mkdir -p "$PLAN_DIR"
                cat > "$PLAN_FILE" << EOF
# Plan: $NAME

Started: $(date +%Y-%m-%d)
Source: planner.md

## Tasks
$(echo "$TASKS" | sed 's/^[0-9]*:- //')

---
EOF
                echo "Plan created from planner.md tasks: $PLAN_FILE"
            else
                echo "No pending tasks found in planner.md."
                exit 0
            fi
        else
            echo "Plan file not found: $PLAN_FILE"
            echo "Create one at docs/plans/<name>.md"
            exit 1
        fi
    fi

    mkdir -p "$PLAN_DIR"
    # Find first pending task
    FIRST=$(grep -n "^- \[ \]" "$PLAN_FILE" | head -1)
    if [[ -z "$FIRST" ]]; then
        echo "Plan '$NAME' has no pending tasks."
        rm -f "$CURRENT_TASK_FILE"
        exit 0
    fi

    LINE=$(echo "$FIRST" | cut -d: -f1)
    TASK=$(echo "$FIRST" | sed 's/^[0-9]*:- \[ \] //')
    echo "$PLAN_FILE:$LINE" > "$CURRENT_TASK_FILE"

    echo "=== Plan: $NAME ==="
    echo "Current task (line $LINE): $TASK"
    echo ""
    grep -n "^- \[" "$PLAN_FILE"
fi

# @plan next
# Show next pending task
if [[ "$1" == "next" ]]; then
    if [[ ! -f "$CURRENT_TASK_FILE" ]]; then
        echo "No active plan. Use '@plan start <name>' first."
        exit 0
    fi

    read -r PLAN_LINE < "$CURRENT_TASK_FILE"
    PLAN_FILE="${PLAN_LINE%:*}"
    CURRENT_LINE="${PLAN_LINE##*:}"

    # Find next pending after current
    NEXT=$(sed -n "$CURRENT_LINE,\$p" "$PLAN_FILE" 2>/dev/null | grep -n "^- \[ \]" | head -1)
    if [[ -z "$NEXT" ]]; then
        # Search from beginning
        NEXT=$(grep -n "^- \[ \]" "$PLAN_FILE" | head -1)
    fi

    if [[ -z "$NEXT" ]]; then
        echo "No pending tasks. All done!"
        rm -f "$CURRENT_TASK_FILE"
    else
        LINE=$(echo "$NEXT" | cut -d: -f1)
        TASK=$(echo "$NEXT" | sed 's/^[0-9]*:- \[ \] //')
        echo "$PLAN_FILE:$LINE" > "$CURRENT_TASK_FILE"
        echo "Next task: $TASK"
    fi
fi

# @plan done [commit-message]
# Mark current task done, commit with message
if [[ "$1" == "done" ]]; then
    shift
    COMMIT_MSG="$*"

    if [[ ! -f "$CURRENT_TASK_FILE" ]]; then
        echo "No active task. Use '@plan start <name>' first."
        exit 0
    fi

    read -r PLAN_LINE < "$CURRENT_TASK_FILE"
    PLAN_FILE="${PLAN_LINE%:*}"
    CURRENT_LINE="${PLAN_LINE##*:}"

    # Mark task as done
    TASK_TEXT=$(sed -n "${CURRENT_LINE}p" "$PLAN_FILE" 2>/dev/null)
    if [[ -z "$TASK_TEXT" ]]; then
        echo "Task not found at line $CURRENT_LINE."
        rm -f "$CURRENT_TASK_FILE"
        exit 1
    fi

    sed -i "${CURRENT_LINE}s/\[ \]/[x]/" "$PLAN_FILE"
    TASK_DESC=$(echo "$TASK_TEXT" | sed 's/^- \[ \] //')

    echo "✓ Task done: $TASK_DESC"

    # Also update planner.md if sourced from it
    if grep -q "Source: planner.md" "$PLAN_FILE" 2>/dev/null; then
        # Try to match and update planner.md
        ESCAPED=$(echo "$TASK_DESC" | sed 's/[]\/$*.^[]/\\&/g')
        if [[ -f "planner.md" ]]; then
            sed -i "s/^- \[ \] $ESCAPED/- [x] $ESCAPED/" planner.md 2>/dev/null
        fi
    fi

    # Auto-commit if git repo and message provided
    if git rev-parse --git-dir > /dev/null 2>&1 && [[ -n "$COMMIT_MSG" ]]; then
        git add -A
        git commit -m "$TASK_DESC: $COMMIT_MSG"
        echo "Committed: $TASK_DESC"
    elif git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Task done. Use 'git add -A && git commit -m \"$TASK_DESC\"' to commit."
    fi

    # Advance to next task
    CURRENT_DIR=$(dirname "$CURRENT_TASK_FILE")
    mkdir -p "$CURRENT_DIR"
    NEXT=$(sed -n "$CURRENT_LINE,\$p" "$PLAN_FILE" 2>/dev/null | grep -n "^- \[ \]" | head -1)
    if [[ -z "$NEXT" ]]; then
        NEXT=$(grep -n "^- \[ \]" "$PLAN_FILE" | head -1)
    fi

    if [[ -n "$NEXT" ]]; then
        LINE=$(echo "$NEXT" | cut -d: -f1)
        echo "$PLAN_FILE:$LINE" > "$CURRENT_TASK_FILE"
        NEXT_TASK=$(echo "$NEXT" | sed 's/^[0-9]*:- \[ \] //')
        echo "Next up: $NEXT_TASK"
    else
        echo "✓ All tasks complete in plan!"
        rm -f "$CURRENT_TASK_FILE"
    fi
fi

# @plan status
# Show plan progress
if [[ "$1" == "status" ]]; then
    echo "=== Work Plan Status ==="

    if [[ -f "$CURRENT_TASK_FILE" ]]; then
        read -r PLAN_LINE < "$CURRENT_TASK_FILE"
        PLAN_FILE="${PLAN_LINE%:*}"
        echo "Active plan: $(basename "$PLAN_FILE" .md)"

        TOTAL=$(grep -c "^- \[\]\|^- \[ \]" "$PLAN_FILE" 2>/dev/null || echo 0)
        DONE=$(grep -c "^- \[x\]" "$PLAN_FILE" 2>/dev/null || echo 0)
        TOTAL=$((TOTAL + DONE))

        if [[ $TOTAL -gt 0 ]]; then
            PCT=$((DONE * 100 / TOTAL))
            echo "Progress: $DONE/$TOTAL ($PCT%)"
        fi
    fi

    # Check planner.md tasks too
    if [[ -f "planner.md" ]]; then
        P=$(grep -cE "^- \[ \]" planner.md 2>/dev/null || echo 0)
        D=$(grep -c "^- \[x\]" planner.md 2>/dev/null || echo 0)
        T=$((P + D))
        if [[ $T -gt 0 ]]; then
            echo "Planner: $D/$T done ($((D * 100 / T))%)"
        fi
    fi
fi
```
