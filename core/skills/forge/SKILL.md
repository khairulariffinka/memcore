---
name: forge
description: Self-improvement — detect patterns, generate new skills, evolve the system
---

# Forge Skill

AI-driven self-improvement. Scan codebase for repetitive patterns, generate new skills, and propose improvements. Human-in-the-loop — every creation needs confirmation.

## Primary Functions

| Function | Description |
|----------|-------------|
| **scan** | Scan codebase/skills for improvement patterns |
| **create** | Generate a new skill from template |
| **propose** | Propose improvements based on scan results |
| **list** | List forged skills and proposals |

## Execute Logic

```bash
FORGE_DIR="docs/forge"
PROPOSALS_FILE="$FORGE_DIR/proposals.md"

# @forge scan
# Analyse codebase for repetitive patterns and improvement opportunities
if [[ "$1" == "scan" ]]; then
    mkdir -p "$FORGE_DIR"
    DATE=$(date +%Y-%m-%d)

    echo "=== Forge Scan ==="
    echo "Date: $DATE"
    echo ""

    # Count existing skills and their size
    SKILL_COUNT=$(ls core/skills/*/SKILL.md 2>/dev/null | wc -l)
    echo "Existing skills: $SKILL_COUNT"

    # Look for patterns in skill implementations
    # Check if there are skills with similar function names
    echo ""
    echo "--- Pattern Analysis ---"

    # Check for skills that could be merged
    if [[ -f "core/skills/memory/SKILL.md" && -f "core/skills/save-diary/SKILL.md" ]]; then
        echo "Potential overlap: memory/save-diary both handle session saving"
    fi

    # Check for missing error handling
    for SKILL in core/skills/*/SKILL.md; do
        [[ -f "$SKILL" ]] || continue
        NAME=$(grep "^name:" "$SKILL" 2>/dev/null | sed 's/name: //')
        if ! grep -q "exit 1\|exit 0" "$SKILL" 2>/dev/null; then
            echo "⚠️  '$NAME' missing error handling"
        fi
    done

    # Count total function blocks
    TOTAL_FUNCTIONS=$(grep -c "^# @" core/skills/*/SKILL.md 2>/dev/null || echo 0)
    echo "Total skill functions: $TOTAL_FUNCTIONS"

    # Check for repetitive bash patterns
    VALIDATION_COUNT=$(grep -c 'if \[\[\s*"\$1"' core/skills/*/SKILL.md 2>/dev/null || echo 0)
    echo "Command dispatchers: $VALIDATION_COUNT"

    echo ""
    echo "--- Suggestions ---"
    echo "1. Review overlapping skills for potential merge"
    echo "2. Add error handling to skills missing it"
    echo "3. Standardise command patterns across skills"

    # Save scan results
    cat > "$FORGE_DIR/last-scan.md" << EOF
# Forge Scan Results

Date: $DATE
Skills: $SKILL_COUNT
Functions: $TOTAL_FUNCTIONS

## Findings
- $( [[ $SKILL_COUNT -gt 15 ]] && echo "High skill count — consider consolidation" || echo "Skill count is manageable" )
- $( [[ $TOTAL_FUNCTIONS -lt $SKILL_COUNT ]] && echo "Some skills may have no functions" || echo "Good function distribution" )

---
EOF
    echo ""
    echo "Scan saved to $FORGE_DIR/last-scan.md"
fi

# @forge create <skill-name> <description>
# Generate a new skill from template
if [[ "$1" == "create" ]]; then
    SKILL_NAME="$2"
    shift 2
    DESCRIPTION="$*"

    if [[ -z "$SKILL_NAME" || -z "$DESCRIPTION" ]]; then
        echo "Usage: @forge create <skill-name> <description>"
        echo "Example: @forge create api-tester Auto-test API endpoints"
        exit 1
    fi

    DATE=$(date +%Y-%m-%d)
    TARGET_DIR="core/skills/$SKILL_NAME"
    TARGET_FILE="$TARGET_DIR/SKILL.md"

    if [[ -f "$TARGET_FILE" ]]; then
        echo "Skill '$SKILL_NAME' already exists. Overwrite? [y/N]"
        read -r CONFIRM
        [[ "$CONFIRM" != "y" ]] && echo "Cancelled." && exit 0
    fi

    mkdir -p "$TARGET_DIR"

    cat > "$TARGET_FILE" << EOF
---
name: $SKILL_NAME
description: $DESCRIPTION
---

# ${SKILL_NAME^} Skill

$(echo "$DESCRIPTION" | sed 's/^/\U/')

## Primary Functions

| Function | Description |
|----------|-------------|
| **help** | Show available commands |

## Execute Logic

\`\`\`bash
# @${SKILL_NAME} help
if [[ "\$1" == "help" || -z "\$1" ]]; then
    echo "${SKILL_NAME^} Skill"
    echo "Usage: @${SKILL_NAME} <command>"
    echo ""
    echo "Commands:"
    echo "  help    Show this message"
fi
\`\`\`
EOF

    echo "✓ Skill forged: $TARGET_FILE"
    echo ""
    echo "Next steps:"
    echo "  1. Edit $TARGET_FILE to add functionality"
    echo "  2. Register in VERSION.yaml under core_skills"
    echo "  3. Add routing in core/agents/memcore.md"

    # Log this creation
    mkdir -p "$FORGE_DIR"
    echo "- $(date +%Y-%m-%d): Created skill '$SKILL_NAME' ($DESCRIPTION)" >> "$FORGE_DIR/changelog.md"
fi

# @forge propose
# Show improvement proposals
if [[ "$1" == "propose" ]]; then
    if [[ -f "$PROPOSALS_FILE" ]]; then
        cat "$PROPOSALS_FILE"
    else
        echo "No proposals yet. Run '@forge scan' first."
    fi
fi

# @forge list
# List forged skills
if [[ "$1" == "list" ]]; then
    echo "=== Forged Skills ==="
    if [[ -f "$FORGE_DIR/changelog.md" ]]; then
        cat "$FORGE_DIR/changelog.md"
    else
        echo "No skills forged yet."
    fi

    echo ""
    echo "=== All Skills ==="
    for SKILL in core/skills/*/SKILL.md; do
        [[ -f "$SKILL" ]] || continue
        NAME=$(grep "^name:" "$SKILL" 2>/dev/null | sed 's/name: //')
        DESC=$(grep "^description:" "$SKILL" 2>/dev/null | sed 's/description: //')
        echo "  $NAME — $DESC"
    done
fi
```
