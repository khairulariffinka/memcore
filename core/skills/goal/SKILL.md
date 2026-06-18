---
name: goal
description: Goal-driven sessions — set stop conditions, track completion, prevent premature stops
---

# Goal Skill

Inspired by MiMo-Code's goal/stop condition system. Sets a stopping condition for sessions and verifies completion before allowing the agent to stop.

## Primary Functions

| Function | Description |
|----------|-------------|
| **set** | Set a goal/stop condition for the session |
| **check** | Check if current goal is satisfied |
| **clear** | Clear the current goal |
| **status** | Show current goal and progress |

## How It Works

### Goal Setting

When you set a goal, it's stored in `~/.config/opencode/global-memory/goal.md`. The agent must verify the goal is satisfied before stopping.

### Goal Verification

Before the agent stops, it must:
1. Read the current goal
2. Check if the condition is met
3. If not met, continue working
4. If met, report completion

### Preventing Premature Stops

The goal system prevents "optimistic stops" where the agent claims success without verification. The agent must provide evidence that the goal is met.

## Execute Logic

```bash
GLOBAL_MEMORY="$HOME/.config/opencode/global-memory"
GOAL_FILE="$GLOBAL_MEMORY/goal.md"

# @goal set <condition>
# Set a goal/stop condition for the session
if [[ "$1" == "set" ]]; then
    shift
    CONDITION="$*"

    if [[ -z "$CONDITION" ]]; then
        echo "Usage: @goal set <condition>"
        echo "Example: @goal set all tests passing"
        echo "Example: @goal set user can login successfully"
        exit 1
    fi

    DATE=$(date +%Y-%m-%d)
    TIME=$(date +%H:%M)

    mkdir -p "$GLOBAL_MEMORY"

    cat > "$GOAL_FILE" << EOF
# Session Goal

> Set: $DATE $TIME
> Status: ACTIVE

## Condition
$CONDITION

## Verification Checklist
<!-- Agent must check each item before claiming success -->
- [ ] Condition understood
- [ ] Evidence gathered
- [ ] Condition verified met

## Evidence
<!-- Agent provides evidence here -->
_No evidence yet_

## History
| Date | Action | Result |
|------|--------|--------|
| $DATE | Goal set | Active |
EOF

    echo "Goal set: $CONDITION"
    echo ""
    echo "Agent must verify this condition is met before stopping."
    echo "Use '@goal check' to verify completion."
fi

# @goal check
# Check if current goal is satisfied
if [[ "$1" == "check" ]]; then
    if [[ ! -f "$GOAL_FILE" ]]; then
        echo "No active goal. Use '@goal set <condition>' to set one."
        exit 0
    fi

    echo "=== Goal Check ==="
    echo ""

    # Read current goal
    CONDITION=$(sed -n '/^## Condition$/,/^## Verification/p' "$GOAL_FILE" | grep -v "^##" | head -1)
    STATUS=$(grep "^> Status:" "$GOAL_FILE" | head -1 | awk '{print $3}')

    echo "Condition: $CONDITION"
    echo "Status: $STATUS"
    echo ""

    if [[ "$STATUS" == "MET" ]]; then
        echo "✅ Goal already completed."
        exit 0
    fi

    echo "Verification checklist:"
    sed -n '/^## Verification Checklist$/,/^## Evidence/p' "$GOAL_FILE" | grep "^- \[" | sed 's/^/  /'

    echo ""
    echo "To mark as met:"
    echo "  sed -i 's/> Status: ACTIVE/> Status: MET/' $GOAL_FILE"
    echo ""
    echo "To provide evidence:"
    echo "  sed -i '/^## Evidence$/,/^## History/c\\## Evidence\\n证据内容\\n\\n## History' $GOAL_FILE"
fi

# @goal clear
# Clear the current goal
if [[ "$1" == "clear" ]]; then
    if [[ -f "$GOAL_FILE" ]]; then
        if [[ "$FORCE" == "true" ]]; then
            rm -f "$GOAL_FILE"
            echo "Goal cleared."
        else
            echo "Clear current goal? [y/N]"
            read -r CONFIRM
            if [[ "$CONFIRM" == "y" ]]; then
                rm -f "$GOAL_FILE"
                echo "Goal cleared."
            else
                echo "Cancelled."
            fi
        fi
    else
        echo "No active goal."
    fi
fi

# @goal status
# Show current goal and progress
if [[ "$1" == "status" ]]; then
    if [[ ! -f "$GOAL_FILE" ]]; then
        echo "No active goal."
        exit 0
    fi

    echo "=== Goal Status ==="
    echo ""

    # Read goal details
    SET_DATE=$(grep "^> Set:" "$GOAL_FILE" | head -1 | awk '{print $2, $3}')
    STATUS=$(grep "^> Status:" "$GOAL_FILE" | head -1 | awk '{print $3}')
    CONDITION=$(sed -n '/^## Condition$/,/^## Verification/p' "$GOAL_FILE" | grep -v "^##" | head -1)

    echo "Set: $SET_DATE"
    echo "Status: $STATUS"
    echo "Condition: $CONDITION"
    echo ""

    # Count completed items
    TOTAL=$(grep -c "^- \[" "$GOAL_FILE" 2>/dev/null || echo 0)
    DONE=$(grep -c "^- \[x\]" "$GOAL_FILE" 2>/dev/null || echo 0)

    if [[ $TOTAL -gt 0 ]]; then
        PCT=$((DONE * 100 / TOTAL))
        FILLED=$((PCT / 5))
        EMPTY=$((20 - FILLED))
        BAR=$(printf '%*s' "$FILLED" '' | tr ' ' '█')
        BAR="$BAR$(printf '%*s' "$EMPTY" '' | tr ' ' '░')"
        echo "Progress: [$BAR] $DONE/$TOTAL ($PCT%)"
    fi
fi
```

## Usage Examples

```bash
# Set a goal
@goal set all tests passing
@goal set user can login with email and password
@goal set API returns 200 for /health endpoint

# Check progress
@goal check

# See status
@goal status

# Clear goal
@goal clear
```

## Integration

- **Session end**: Agent must `@goal check` before stopping
- **Work plan**: Goals align with plan tasks
- **Post-mortem**: Failed goals create post-mortem entries
- **Observation**: Goal completion rate tracked in behavioral profile
