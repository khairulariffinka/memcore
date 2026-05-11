---
name: observation
description: Behavioral learning — observe user patterns, adjust to working style
---

# Mulahazah Skill

Mulahazah (ملاحظة — observation). Sistem pembelajaran gelagat yang memerhatikan pattern user dan adjust cara kerja secara automatik.

## Primary Functions

| Function | Description |
|----------|-------------|
| **observe** | Analyze session diary & planner for user patterns |
| **profile** | Show current observed user profile |
| **suggest** | Suggest adjustments based on observed patterns |
| **reset** | Reset behavioural data |

## Observed Dimensions

| Dimension | What It Tracks |
|-----------|----------------|
| **Session Length** | Average session duration pattern |
| **Task Completion** | Task completion rate per session |
| **Agent Preference** | Most-used subagents |
| **Language Mix** | Malay vs English usage ratio |
| **Response Style** | Verbose vs brief pattern |
| **Peak Hours** | Time of day with most activity |
| **Error Frequency** | Common failure patterns |
| **Decision Speed** | How quickly decisions are made |

## Storage

Data disimpan di `~/.config/opencode/global-memory/mulahazah.md`:

```markdown
# Mulahazah — Behavioural Profile

## Patterns
| Dimension | Observed | Confidence |
|-----------|----------|------------|
| Session Length | ~45 min | High |

## Preferences
| Preference | Detected | Last Updated |
|------------|----------|--------------|
| Language | Malay | 2026-05-11 |

## Suggestions
- [suggestion 1]
- [suggestion 2]

---
Last analysed: 2026-05-11
Sessions analysed: 12
```

## Execute Logic

```bash
MULAHAZAH_FILE="$HOME/.config/opencode/global-memory/mulahazah.md"

# @mula observe
# Analyze session diary & planner for user patterns
if [[ "$1" == "observe" ]]; then
    DATE=$(date +%Y-%m-%d)
    LOCAL_DIARY="docs/session-diary.md"
    PLANNER="planner.md"
    DECISIONS="DECISIONS.md"

    mkdir -p "$(dirname "$MULAHAZAH_FILE")"

    # Count total sessions
    TOTAL_SESSIONS=$(grep -c "^## Session:" "$LOCAL_DIARY" 2>/dev/null || echo 0)

    # Count sessions this week
    THIS_WEEK=$(date +%V)
    WEEK_SESSIONS=$(grep "^## Session:" "$LOCAL_DIARY" 2>/dev/null | grep -c "$(date +%Y)" || echo 0)

    # Lang detection from diary
    MALAY_KEYWORDS="bos selesai boleh kita tak ada ya dan atau ini itu"
    ENGLISH_KEYWORDS="boss done okay we have yes no this that"
    MALAY_COUNT=0
    ENGLISH_COUNT=0
    if [[ -f "$LOCAL_DIARY" ]]; then
        for kw in $MALAY_KEYWORDS; do
            C=$(grep -oi "$kw" "$LOCAL_DIARY" 2>/dev/null | wc -l)
            MALAY_COUNT=$((MALAY_COUNT + C))
        done
        for kw in $ENGLISH_KEYWORDS; do
            C=$(grep -oi "$kw" "$LOCAL_DIARY" 2>/dev/null | wc -l)
            ENGLISH_COUNT=$((ENGLISH_COUNT + C))
        done
    fi
    if [[ $MALAY_COUNT -gt $ENGLISH_COUNT ]]; then
        DETECTED_LANG="Malay"
    elif [[ $ENGLISH_COUNT -gt $MALAY_COUNT ]]; then
        DETECTED_LANG="English"
    else
        DETECTED_LANG="Mixed"
    fi

    # Task completion rate
    TOTAL_TASKS=$(grep -cE "\[x\]|\[ \]" "$PLANNER" 2>/dev/null || echo 0)
    DONE_TASKS=$(grep -c "\[x\]" "$PLANNER" 2>/dev/null || echo 0)
    if [[ $TOTAL_TASKS -gt 0 ]]; then
        COMPLETION_RATE=$((DONE_TASKS * 100 / TOTAL_TASKS))
    else
        COMPLETION_RATE=0
    fi

    # Agent preference from session diary agent mentions
    AGENT_LOG=$(grep -oE "@[a-z_-]+" "$LOCAL_DIARY" 2>/dev/null | sort | uniq -c | sort -rn | head -3 || echo "None")

    # Peak hours
    PEAK_HOUR=$(grep -oE "\*\*Time\*\* \| [0-9]{2}:" "$LOCAL_DIARY" 2>/dev/null | sed 's/\*\*Time\*\* | //' | sed 's/:.*//' | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')
    if [[ -z "$PEAK_HOUR" ]]; then
        PEAK_HOUR="Unknown"
    fi

    # Write/update profile
    cat > "$MULAHAZAH_FILE" << EOF
# Mulahazah — Behavioural Profile

> Auto-detected from session activity. Last analysed: $DATE

## Patterns
| Dimension | Observed | Confidence |
|-----------|----------|------------|
| Total Sessions | $TOTAL_SESSIONS | High |
| Sessions This Week | $WEEK_SESSIONS | High |
| Task Completion Rate | ${COMPLETION_RATE}% | Medium |
| Preferred Language | $DETECTED_LANG | High |
| Peak Activity Hour | ${PEAK_HOUR}:00 | Medium |

## Agent Usage
\`\`\`
$AGENT_LOG
\`\`\`

## Preferences
| Preference | Detected | Last Updated |
|------------|----------|--------------|
| Language | $DETECTED_LANG | $DATE |
| Task Completion | ${COMPLETION_RATE}% | $DATE |

## Suggestions
- $( [[ $COMPLETION_RATE -lt 50 ]] && echo "Consider breaking tasks into smaller chunks to improve completion rate." || echo "Task breakdown is working well. Keep it up!")
- $( [[ $WEEK_SESSIONS -lt 3 ]] && echo "Try to increase session frequency for better continuity." || echo "Consistent session cadence detected. Good momentum!")
- $( [[ "$DETECTED_LANG" == "Mixed" ]] && echo "Consider sticking to one language per session for cleaner diary logs." || echo "Language consistency is good.")

---
_Last analysed: $DATE_
_Sessions analysed: $TOTAL_SESSIONS_
EOF

    echo "Observed $TOTAL_SESSIONS sessions. Profile updated."
fi

# @mula profile
# Show current user profile
if [[ "$1" == "profile" ]]; then
    if [[ -f "$MULAHAZAH_FILE" ]]; then
        cat "$MULAHAZAH_FILE"
    else
        echo "No behavioural profile yet. Run '@mula observe' first."
    fi
fi

# @mula suggest
# Show suggestions based on patterns
if [[ "$1" == "suggest" ]]; then
    if [[ -f "$MULAHAZAH_FILE" ]]; then
        echo "=== Mulahazah Suggestions ==="
        grep "^\- " "$MULAHAZAH_FILE" | grep -v "^\- \\*\\*"
    else
        echo "Run '@mula observe' first to generate suggestions."
    fi
fi

# @mula reset
# Reset behavioural data
if [[ "$1" == "reset" ]]; then
    echo "Reset Mulahazah behavioural data? [y/N]"
    read -r CONFIRM
    if [[ "$CONFIRM" == "y" ]]; then
        rm -f "$MULAHAZAH_FILE"
        echo "Behavioural data reset."
    else
        echo "Cancelled."
    fi
fi
```
