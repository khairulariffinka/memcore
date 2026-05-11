---
name: auto-commit
description: Structured git commits with session context — auto-stage, message templates
---

# Auto-Commit Skill

Intelligent git commit system. Auto-stages changes, generates structured commit messages from session context, diary, and plan.

## Primary Functions

| Function | Description |
|----------|-------------|
| **save** | Stage all + commit with auto-generated message |
| **status** | Show working tree status with context |
| **log** | Show recent commits with diary cross-ref |

## Execute Logic

```bash
# @commit save [message]
# Stage all changes and commit with structured message
if [[ "$1" == "save" ]]; then
    shift
    USER_MSG="$*"

    # Ensure we're in a git repo
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Not a git repository."
        exit 1
    fi

    # Check for changes
    if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
        :
    else
        echo "Nothing to commit."
        exit 0
    fi

    DATE=$(date +%Y-%m-%d)
    TIME_NOW=$(date +%H:%M)

    # Gather context for commit message
    DIFF_STATS=$(git diff --stat 2>/dev/null | tail -1)
    CHANGED_FILES=$(git diff --name-only 2>/dev/null | head -5)
    NEW_FILES=$(git ls-files --others --exclude-standard 2>/dev/null | head -5)

    # Detect type of changes
    FEAT=""
    FIX=""
    REFACTOR=""
    DOCS=""
    for FILE in $CHANGED_FILES $NEW_FILES; do
        case "$FILE" in
            *.md|*.mdx) DOCS="$DOCS $FILE" ;;
            *test*|*spec*) ;;
            *) FEAT="$FEAT $FILE" ;;
        esac
    done

    # Build commit message
    COMMIT_MSG=""
    if [[ -n "$USER_MSG" ]]; then
        COMMIT_MSG="$USER_MSG"
    else
        COMMIT_MSG="update: $(date +%Y-%m-%d) session changes"
    fi

    # Add structured body
    COMMIT_BODY=""
    if [[ -n "$CHANGED_FILES" ]]; then
        COMMIT_BODY="Modified:
$(echo "$CHANGED_FILES" | sed 's/^/  - /')"
    fi
    if [[ -n "$NEW_FILES" ]]; then
        COMMIT_BODY="$COMMIT_BODY
New:
$(echo "$NEW_FILES" | sed 's/^/  - /')"
    fi

    # Check for active plan context
    if [[ -f "docs/plans/.current" ]]; then
        read -r PLAN_REF < "docs/plans/.current"
        PLAN_NAME=$(basename "$(echo "$PLAN_REF" | cut -d: -f1)" .md)
        COMMIT_BODY="$COMMIT_BODY
Plan: $PLAN_NAME"
    fi

    # Stage everything
    git add -A

    # Commit with structured message
    if [[ -n "$COMMIT_BODY" ]]; then
        git commit -m "$COMMIT_MSG" -m "$COMMIT_BODY"
    else
        git commit -m "$COMMIT_MSG"
    fi

    echo "Committed: $COMMIT_MSG"
fi

# @commit status
# Show status with diary context
if [[ "$1" == "status" ]]; then
    DATE=$(date +%Y-%m-%d)

    echo "=== Git Status ==="
    git status --short 2>/dev/null || echo "(no changes)"

    # Show today's diary context
    if [[ -f "docs/session-diary.md" ]]; then
        TODAY_SESSION=$(grep -c "## Session: $DATE" docs/session-diary.md 2>/dev/null || echo 0)
        echo ""
        echo "Session diary: $TODAY_SESSION entries today"
    fi

    # Show commit count today
    TODAY_COMMITS=$(git log --oneline --after="$DATE 00:00" 2>/dev/null | wc -l)
    echo "Commits today: $TODAY_COMMITS"

    # Reminder to commit
    if git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null && [[ -z "$(git ls-files --others --exclude-standard)" ]]; then
        echo "Working tree clean."
    else
        echo "Uncommitted changes. Use '@commit save <message>'"
    fi
fi

# @commit log [limit]
# Show recent commits
if [[ "$1" == "log" ]]; then
    LIMIT="${2:-5}"
    echo "=== Recent Commits ==="
    git log --oneline -"$LIMIT" 2>/dev/null || echo "(no commits)"
fi
```
