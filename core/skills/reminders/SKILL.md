---
name: reminders
description: Cross-session reminders system with persistence
---

# Reminders Skill

Cross-session reminders — set, view, and complete reminders that persist across sessions.

## Primary Functions

| Function | Description |
|----------|-------------|
| **set** | Set reminder baru |
| **list** | List all pending reminders |
| **done** | Tandakan reminder selesai |
| **edit** | Edit reminder sedia ada |
| **clear** | Clear all completed reminders |

## Storage

Reminders disimpan di `docs/reminders.md`:

```markdown
# Reminders

| ID | Date Set | Due | Task | Status |
|----|----------|-----|------|--------|
| REM-001 | 2026-05-11 | next-session | Check deployment config | Pending |

---

_Last updated: 2026-05-11_
```

## Execute Logic

```bash
REMINDER_FILE="docs/reminders.md"

# @remind set <due> <message>
if [[ "$1" == "set" ]]; then
    DUE="$2"
    shift 2
    MESSAGE="$*"

    if [[ -z "$DUE" || -z "$MESSAGE" ]]; then
        echo "Usage: @remind set <due> <message>"
        echo "Due options: next-session, tomorrow, YYYY-MM-DD"
        exit 1
    fi

    # Validate due format
    if [[ "$DUE" != "next-session" && "$DUE" != "tomorrow" && ! "$DUE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "Error: Invalid due format. Use: next-session, tomorrow, or YYYY-MM-DD"
        exit 1
    fi

    # Validate message — no pipe characters (breaks markdown table)
    if echo "$MESSAGE" | grep -q '|'; then
        echo "Error: Message cannot contain '|' character."
        exit 1
    fi

    DATE=$(date +%Y-%m-%d)

    # Generate ID
    if [[ -f "$REMINDER_FILE" ]]; then
        LAST_ID=$(grep -oP "REM-\K\d+" "$REMINDER_FILE" 2>/dev/null | sort -n | tail -1)
        NEXT_ID=$((LAST_ID + 1))
    else
        NEXT_ID=1
    fi
    ID=$(printf "REM-%03d" $NEXT_ID)

    mkdir -p docs

    # Initialize file if needed
    if [[ ! -f "$REMINDER_FILE" ]]; then
        cat > "$REMINDER_FILE" << EOF
# Reminders

| ID | Date Set | Due | Task | Status |
|----|----------|-----|------|--------|
EOF
    fi

    # Append reminder
    sed -i "/^---/i | $ID | $DATE | $DUE | $MESSAGE | Pending |" "$REMINDER_FILE" 2>/dev/null || \
    cat >> "$REMINDER_FILE" << EOF
| $ID | $DATE | $DUE | $MESSAGE | Pending |
EOF

    # Ensure footer exists
    if ! grep -q "^_Last updated:" "$REMINDER_FILE" 2>/dev/null; then
        echo "" >> "$REMINDER_FILE"
        echo "---" >> "$REMINDER_FILE"
        echo "_Last updated: $DATE_" >> "$REMINDER_FILE"
    else
        sed -i "s/_Last updated: .*/_Last updated: $DATE_/" "$REMINDER_FILE"
    fi

    echo "Reminder set: $ID — \"$MESSAGE\" (due: $DUE)"
fi

# @remind list
if [[ "$1" == "list" ]]; then
    if [[ ! -f "$REMINDER_FILE" ]]; then
        echo "No reminders."
        exit 0
    fi

    PENDING=$(grep "| Pending |" "$REMINDER_FILE" 2>/dev/null)
    if [[ -z "$PENDING" ]]; then
        echo "No pending reminders."
    else
        echo "=== Pending Reminders ==="
        echo "$PENDING" | while read -r LINE; do
            echo "  $LINE"
        done
    fi

    # Check for due reminders
    TODAY=$(date +%Y-%m-%d)
    DUE_TODAY=$(echo "$PENDING" | grep "$TODAY\|next-session")
    if [[ -n "$DUE_TODAY" ]]; then
        echo ""
        echo "⚠️  Due reminders:"
        echo "$DUE_TODAY"
    fi
fi

# @remind done <id>
if [[ "$1" == "done" ]]; then
    ID="$2"
    if [[ -z "$ID" ]]; then
        echo "Usage: @remind done <id>"
        echo "Example: @remind done REM-001"
        exit 1
    fi

    if [[ ! -f "$REMINDER_FILE" ]]; then
        echo "No reminders."
        exit 0
    fi

    # Mark as done
    sed -i "s/| $ID |.*Pending |/| $ID | ... | Done |/" "$REMINDER_FILE"

    DATE=$(date +%Y-%m-%d)
    sed -i "s/_Last updated: .*/_Last updated: $DATE_/" "$REMINDER_FILE"

    echo "Reminder $ID marked as done."
fi

# @remind edit <id> <due> <message>
if [[ "$1" == "edit" ]]; then
    ID="$2"
    DUE="$3"
    shift 3
    MESSAGE="$*"

    if [[ -z "$ID" || -z "$DUE" || -z "$MESSAGE" ]]; then
        echo "Usage: @remind edit <id> <due> <message>"
        echo "Example: @remind edit REM-001 tomorrow Buy groceries"
        exit 1
    fi

    if [[ ! -f "$REMINDER_FILE" ]]; then
        echo "No reminders."
        exit 0
    fi

    if ! grep -q "| $ID |" "$REMINDER_FILE" 2>/dev/null; then
        echo "Reminder '$ID' not found."
        exit 1
    fi

    # Validate due format
    if [[ "$DUE" != "next-session" && "$DUE" != "tomorrow" && ! "$DUE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "Error: Invalid due format. Use: next-session, tomorrow, or YYYY-MM-DD"
        exit 1
    fi

    # Validate message
    if echo "$MESSAGE" | grep -q '|'; then
        echo "Error: Message cannot contain '|' character."
        exit 1
    fi

    DATE=$(date +%Y-%m-%d)
    # Replace the line matching this ID
    sed -i "s/| $ID |.*| Pending |/| $ID | $DATE | $DUE | $MESSAGE | Pending |/" "$REMINDER_FILE"
    sed -i "s/_Last updated: .*/_Last updated: $DATE_/" "$REMINDER_FILE"

    echo "Reminder $ID updated: \"$message\" (due: $DUE)"
fi

# @remind clear
if [[ "$1" == "clear" ]]; then
    if [[ ! -f "$REMINDER_FILE" ]]; then
        echo "No reminders."
        exit 0
    fi

    # Remove done rows
    sed -i "/| Done |/d" "$REMINDER_FILE"

    DATE=$(date +%Y-%m-%d)
    sed -i "s/_Last updated: .*/_Last updated: $DATE_/" "$REMINDER_FILE"

    echo "Completed reminders cleared."
fi
```
