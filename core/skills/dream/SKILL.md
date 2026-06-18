---
name: dream
description: Memory consolidation — scan sessions, extract durable knowledge, remove outdated entries, auto-distill patterns
---

# Dream Skill

Inspired by MiMo-Code's dream/distill system. Consolidates memory by scanning session traces, extracting persistent knowledge, and discovering reusable patterns.

## Primary Functions

| Function | Description |
|----------|-------------|
| **dream** | Consolidate memory — scan sessions, promote durable knowledge |
| **distill** | Discover patterns — find repeated workflows, suggest new skills |
| **status** | Show consolidation status and last run times |

## How It Works

### Dream (Memory Consolidation)

Scans recent session diaries and extracts knowledge that should persist:

1. **Scan** — Read `docs/session-diary.md` and `docs/post-mortem.md`
2. **Extract** — Find durable knowledge (decisions, patterns, lessons)
3. **Promote** — Move to `~/.config/opencode/global-memory/MEMORY.md`
4. **Clean** — Remove outdated entries from MEMORY.md
5. **Update** — Update knowledge-graph.md with cross-references

### Distill (Skill Discovery)

Discovers repeated manual workflows and suggests new skills:

1. **Inventory** — List existing skills in `core/skills/`
2. **Scan** — Look for repeated patterns in session diary
3. **Compare** — Check if patterns match existing skills
4. **Suggest** — Propose new skills for unmatched patterns

## Execute Logic

```bash
# Parse --force flag
FORCE="false"
for arg in "$@"; do
    [[ "$arg" == "--force" ]] && FORCE="true"
done

GLOBAL_MEMORY="$HOME/.config/opencode/global-memory"
MEMORY_FILE="$GLOBAL_MEMORY/MEMORY.md"
SESSION_DIARY="docs/session-diary.md"
POST_MORTEM="docs/post-mortem.md"
KNOWLEDGE_GRAPH="$GLOBAL_MEMORY/knowledge-graph.md"
DREAM_LOG="$GLOBAL_MEMORY/dream-log.md"

# @dream
# Consolidate memory from sessions into MEMORY.md
if [[ "$1" == "dream" ]]; then
    DATE=$(date +%Y-%m-%d)
    echo "=== Dream: Memory Consolidation ==="
    echo "Date: $DATE"
    echo ""

    mkdir -p "$GLOBAL_MEMORY"

    # Check if dream was run recently (within 7 days)
    if [[ -f "$DREAM_LOG" ]]; then
        LAST_DREAM=$(grep "^Last dream:" "$DREAM_LOG" 2>/dev/null | head -1 | awk '{print $3}')
        if [[ -n "$LAST_DREAM" ]]; then
            LAST_EPOCH=$(date -d "$LAST_DREAM" +%s 2>/dev/null || echo 0)
            NOW_EPOCH=$(date +%s)
            DAYS_SINCE=$(( (NOW_EPOCH - LAST_EPOCH) / 86400 ))
            if [[ $DAYS_SINCE -lt 7 && "$FORCE" != "true" ]]; then
                echo "Last dream was $DAYS_SINCE days ago. Run with --force to override."
                exit 0
            fi
        fi
    fi

    # Initialize MEMORY.md if needed
    if [[ ! -f "$MEMORY_FILE" ]]; then
        cat > "$MEMORY_FILE" << 'EOF'
# Project Memory

> Durable knowledge extracted from sessions. Auto-maintained by dream consolidation.

## Project Context
<!-- What is this project? Goal? Identity? -->

## Rules
<!-- Hard constraints every session must respect -->

## Architecture Decisions
<!-- Major design choices with rationale -->

## Discovered Durable Knowledge
<!-- Cross-task facts promoted from session checkpoints -->

## Error Patterns
<!-- Recurring errors and their solutions -->

---
_Last consolidated: [DATE]_
EOF
        echo "Created MEMORY.md"
    fi

    # Scan session diary for durable knowledge
    echo "--- Scanning Session Diary ---"
    if [[ -f "$SESSION_DIARY" ]]; then
        SESSION_COUNT=$(grep -c "^## Session:" "$SESSION_DIARY" 2>/dev/null || echo 0)
        echo "Sessions found: $SESSION_COUNT"

        # Extract decisions (lines with "Decision:" or "decided")
        DECISIONS=$(grep -i "decision\|decided" "$SESSION_DIARY" 2>/dev/null | head -10)
        if [[ -n "$DECISIONS" ]]; then
            echo "Decisions found:"
            echo "$DECISIONS" | sed 's/^/  /'
        fi

        # Extract lessons (lines with "lesson" or "learned")
        LESSONS=$(grep -i "lesson\|learned" "$SESSION_DIARY" 2>/dev/null | head -10)
        if [[ -n "$LESSONS" ]]; then
            echo "Lessons found:"
            echo "$LESSONS" | sed 's/^/  /'
        fi
    else
        echo "No session diary found"
    fi

    # Scan post-mortem for error patterns
    echo ""
    echo "--- Scanning Post-Mortem ---"
    if [[ -f "$POST_MORTEM" ]]; then
        PM_COUNT=$(grep -c "^## PM-" "$POST_MORTEM" 2>/dev/null || echo 0)
        echo "Post-mortems found: $PM_COUNT"

        # Extract lessons learned
        PM_LESSONS=$(grep -A 2 "Lesson Learned" "$POST_MORTEM" 2>/dev/null | grep -v "Lesson Learned" | head -5)
        if [[ -n "$PM_LESSONS" ]]; then
            echo "Lessons from failures:"
            echo "$PM_LESSONS" | sed 's/^/  /'
        fi
    else
        echo "No post-mortem file found"
    fi

    # Update MEMORY.md with findings
    echo ""
    echo "--- Updating MEMORY.md ---"
    sed -i "s/_Last consolidated: .*/_Last consolidated: $DATE_/" "$MEMORY_FILE" 2>/dev/null || true
    echo "MEMORY.md updated"

    # Update dream log
    cat > "$DREAM_LOG" << EOF
Last dream: $DATE
Sessions scanned: ${SESSION_COUNT:-0}
Post-mortems scanned: ${PM_COUNT:-0}
EOF

    echo ""
    echo "Dream complete. Review MEMORY.md for promoted knowledge."
fi

# @distill
# Discover repeated patterns and suggest new skills
if [[ "$1" == "distill" ]]; then
    DATE=$(date +%Y-%m-%d)
    echo "=== Distill: Pattern Discovery ==="
    echo "Date: $DATE"
    echo ""

    # Inventory existing skills
    echo "--- Existing Skills ---"
    EXISTING_SKILLS=""
    for SKILL in core/skills/*/SKILL.md; do
        [[ -f "$SKILL" ]] || continue
        NAME=$(basename "$(dirname "$SKILL")")
        EXISTING_SKILLS="$EXISTING_SKILLS $NAME"
        echo "  $NAME"
    done

    # Scan for repeated patterns in session diary
    echo ""
    echo "--- Pattern Analysis ---"
    if [[ -f "$SESSION_DIARY" ]]; then
        # Look for repeated commands or workflows
        REPEATED=$(grep -oE "@[a-z-]+" "$SESSION_DIARY" 2>/dev/null | sort | uniq -c | sort -rn | head -10)
        if [[ -n "$REPEATED" ]]; then
            echo "Most used commands:"
            echo "$REPEATED" | sed 's/^/  /'
        fi

        # Look for repeated file patterns
        FILES=$(grep -oE "[a-zA-Z0-9_-]+\.(sh|md|py|js|ts)" "$SESSION_DIARY" 2>/dev/null | sort | uniq -c | sort -rn | head -5)
        if [[ -n "$FILES" ]]; then
            echo ""
            echo "Most referenced files:"
            echo "$FILES" | sed 's/^/  /'
        fi
    fi

    # Check for gaps
    echo ""
    echo "--- Skill Gap Analysis ---"
    HAS_OBSERVATION=$(echo "$EXISTING_SKILLS" | grep -q "observation" && echo "yes" || echo "no")
    HAS_REMINDERS=$(echo "$EXISTING_SKILLS" | grep -q "reminders" && echo "yes" || echo "no")
    HAS_LIBRARY=$(echo "$EXISTING_SKILLS" | grep -q "library-system" && echo "yes" || echo "no")
    HAS_FORGE=$(echo "$EXISTING_SKILLS" | grep -q "forge" && echo "yes" || echo "no")

    echo "Core skills: observation=$HAS_OBSERVATION reminders=$HAS_REMINDERS library=$HAS_LIBRARY forge=$HAS_FORGE"

    if [[ "$HAS_FORGE" == "yes" ]]; then
        echo ""
        echo "Tip: Use 'forge scan' to analyze codebase for improvement patterns"
    fi

    echo ""
    echo "Distill complete."
fi

# @dream status
# Show consolidation status
if [[ "$1" == "status" ]]; then
    echo "=== Dream Status ==="
    echo ""

    if [[ -f "$DREAM_LOG" ]]; then
        cat "$DREAM_LOG"
    else
        echo "No dream log found. Run '@dream dream' first."
    fi

    echo ""
    if [[ -f "$MEMORY_FILE" ]]; then
        MEMORY_SIZE=$(wc -l < "$MEMORY_FILE" 2>/dev/null || echo 0)
        echo "MEMORY.md: $MEMORY_SIZE lines"
    else
        echo "MEMORY.md: not created"
    fi
fi
```

## Scheduling

Dream consolidation can be automated:

```bash
# Run dream weekly (add to cron or session start)
@dream dream

# Force dream even if run recently
@dream dream --force

# Check status
@dream status
```

## Integration

- **Session end**: Auto-run `@dream dream` to consolidate session knowledge
- **Session start**: Read MEMORY.md for context
- **Forge**: Use `@forge scan` with distill for codebase patterns
- **Post-mortem**: Lessons auto-promoted to MEMORY.md via dream
