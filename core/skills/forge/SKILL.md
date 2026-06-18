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

# Parse --force flag
FORCE="false"
for arg in "$@"; do
    [[ "$arg" == "--force" ]] && FORCE="true"
done

# @forge scan
# Analyse codebase for repetitive patterns and improvement opportunities
if [[ "$1" == "scan" ]]; then
    mkdir -p "$FORGE_DIR"
    DATE=$(date +%Y-%m-%d)

    echo "=== Forge Scan ==="
    echo "Date: $DATE"
    echo ""

    # ── 1. Skill Inventory ──
    SKILL_COUNT=$(ls core/skills/*/SKILL.md 2>/dev/null | wc -l)
    echo "Existing skills: $SKILL_COUNT"

    # ── 2. Code Complexity Analysis ──
    echo ""
    echo "--- Code Complexity ---"
    TOTAL_LINES=0
    for SKILL in core/skills/*/SKILL.md; do
        [[ -f "$SKILL" ]] || continue
        LINES=$(wc -l < "$SKILL")
        TOTAL_LINES=$((TOTAL_LINES + LINES))
        NAME=$(basename "$(dirname "$SKILL")")
        if [[ $LINES -gt 200 ]]; then
            echo "  ⚠️  $NAME: $LINES lines (consider splitting)"
        fi
    done
    echo "Total lines across all skills: $TOTAL_LINES"

    # ── 3. Duplicate Pattern Detection ──
    echo ""
    echo "--- Duplicate Patterns ---"

    # Find common bash patterns repeated across skills
    DISPATCH_PATTERN='if \[\[ "\$1" =='
    DISPATCH_COUNT=$(grep -rl "$DISPATCH_PATTERN" core/skills/*/SKILL.md 2>/dev/null | wc -l)
    echo "Skills using \$1 dispatch: $DISPATCH_COUNT/$SKILL_COUNT"

    # Find skills missing input validation
    MISSING_VALIDATION=0
    for SKILL in core/skills/*/SKILL.md; do
        [[ -f "$SKILL" ]] || continue
        NAME=$(basename "$(dirname "$SKILL")")
        if ! grep -q 'if \[\[ -z "\$' "$SKILL" 2>/dev/null; then
            echo "  ⚠️  $NAME: missing input validation"
            MISSING_VALIDATION=$((MISSING_VALIDATION + 1))
        fi
    done

    # Find skills missing --force flag
    MISSING_FORCE=0
    for SKILL in core/skills/*/SKILL.md; do
        [[ -f "$SKILL" ]] || continue
        NAME=$(basename "$(dirname "$SKILL")")
        if ! grep -q 'FORCE' "$SKILL" 2>/dev/null; then
            echo "  ⚠️  $NAME: missing --force flag support"
            MISSING_FORCE=$((MISSING_FORCE + 1))
        fi
    done

    # Find skills with read -r (potential hang)
    HANG_RISK=0
    for SKILL in core/skills/*/SKILL.md; do
        [[ -f "$SKILL" ]] || continue
        NAME=$(basename "$(dirname "$SKILL")")
        READ_COUNT=$(grep -c 'read -r' "$SKILL" 2>/dev/null || echo 0)
        FORCE_COUNT=$(grep -c 'FORCE' "$SKILL" 2>/dev/null || echo 0)
        if [[ $READ_COUNT -gt 0 && $FORCE_COUNT -eq 0 ]]; then
            echo "  🔴 $NAME: read -r without --force guard (hang risk)"
            HANG_RISK=$((HANG_RISK + 1))
        fi
    done

    # ── 4. Error Handling Analysis ──
    echo ""
    echo "--- Error Handling ---"
    for SKILL in core/skills/*/SKILL.md; do
        [[ -f "$SKILL" ]] || continue
        NAME=$(basename "$(dirname "$SKILL")")
        HAS_EXIT=$(grep -c 'exit [01]' "$SKILL" 2>/dev/null || echo 0)
        HAS_USAGE=$(grep -ci 'usage:' "$SKILL" 2>/dev/null || echo 0)
        if [[ $HAS_EXIT -eq 0 ]]; then
            echo "  ⚠️  $NAME: no exit codes defined"
        fi
        if [[ $HAS_USAGE -eq 0 ]]; then
            echo "  ⚠️  $NAME: no usage messages"
        fi
    done

    # ── 5. Naming Convention Check ──
    echo ""
    echo "--- Naming Conventions ---"
    for SKILL in core/skills/*/SKILL.md; do
        [[ -f "$SKILL" ]] || continue
        NAME=$(basename "$(dirname "$SKILL")")
        # Check frontmatter
        if ! head -5 "$SKILL" | grep -q '^name:'; then
            echo "  ⚠️  $NAME: missing name in frontmatter"
        fi
        if ! head -5 "$SKILL" | grep -q '^description:'; then
            echo "  ⚠️  $NAME: missing description in frontmatter"
        fi
        # Check function docs
        FUNC_COUNT=$(grep -c "^# @" "$SKILL" 2>/dev/null || echo 0)
        DOC_COUNT=$(grep -c '^\*\*' "$SKILL" 2>/dev/null || echo 0)
        if [[ $FUNC_COUNT -gt 0 && $DOC_COUNT -eq 0 ]]; then
            echo "  ⚠️  $NAME: has $FUNC_COUNT functions but no documentation table"
        fi
    done

    # ── 6. Dependency Analysis ──
    echo ""
    echo "--- Dependencies ---"
    # Check which skills depend on external files
    for SKILL in core/skills/*/SKILL.md; do
        [[ -f "$SKILL" ]] || continue
        NAME=$(basename "$(dirname "$SKILL")")
        REFS=$(grep -oE 'docs/[a-z-]+\.md' "$SKILL" 2>/dev/null | sort -u)
        if [[ -n "$REFS" ]]; then
            echo "  $NAME depends on: $REFS"
        fi
    done

    # ── 7. Summary & Proposals ──
    echo ""
    echo "--- Summary ---"
    echo "Issues found: $((MISSING_VALIDATION + MISSING_FORCE + HANG_RISK))"

    # Generate proposals
    mkdir -p "$FORGE_DIR"
    cat > "$PROPOSALS_FILE" << EOF
# Forge Proposals

Generated: $DATE

## High Priority
EOF

    if [[ $HANG_RISK -gt 0 ]]; then
        echo "- Fix $HANG_RISK skill(s) with read -r without --force guard" >> "$PROPOSALS_FILE"
    fi
    if [[ $MISSING_VALIDATION -gt 0 ]]; then
        echo "- Add input validation to $MISSING_VALIDATION skill(s)" >> "$PROPOSALS_FILE"
    fi
    if [[ $MISSING_FORCE -gt 0 ]]; then
        echo "- Add --force flag to $MISSING_FORCE skill(s)" >> "$PROPOSALS_FILE"
    fi

    cat >> "$PROPOSALS_FILE" << EOF

## Low Priority
- Standardise error handling across all skills
- Add documentation tables to undocumented skills
- Review skills with high line count for potential splitting

---
_Scan complete. Review proposals with: @forge propose_
EOF

    # Save scan results
    cat > "$FORGE_DIR/last-scan.md" << EOF
# Forge Scan Results

Date: $DATE
Skills: $SKILL_COUNT
Total Lines: $TOTAL_LINES

## Findings
- Skills with \$1 dispatch: $DISPATCH_COUNT
- Missing validation: $MISSING_VALIDATION
- Missing --force: $MISSING_FORCE
- Hang risk (read without --force): $HANG_RISK

## Proposals Generated
See $PROPOSALS_FILE
EOF

    echo ""
    echo "Scan saved to $FORGE_DIR/last-scan.md"
    echo "Proposals saved to $PROPOSALS_FILE"
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
        if [[ "$FORCE" != "true" ]]; then
            echo "Skill '$SKILL_NAME' already exists. Overwrite? [y/N]"
            read -r CONFIRM
            [[ "$CONFIRM" != "y" ]] && echo "Cancelled." && exit 0
        fi
    fi

    mkdir -p "$TARGET_DIR"

    cat > "$TARGET_FILE" << EOF
---
name: $SKILL_NAME
description: $DESCRIPTION
---

# ${SKILL_NAME^} Skill

$(echo "$DESCRIPTION" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')

## Primary Functions

| Function | Description |
|----------|-------------|
| **help** | Show available commands |
| **run** | Execute main logic |

## Execute Logic

\`\`\`bash
# Parse --force flag
FORCE="false"
for arg in "\$@"; do
    [[ "\$arg" == "--force" ]] && FORCE="true"
done

# @${SKILL_NAME} help
if [[ "\$1" == "help" || -z "\$1" ]]; then
    echo "${SKILL_NAME^} Skill"
    echo "Usage: @${SKILL_NAME} <command>"
    echo ""
    echo "Commands:"
    echo "  help    Show this message"
    echo "  run     Execute main logic"
    echo ""
    echo "Options:"
    echo "  --force Skip confirmation prompts"
    exit 0
fi

# @${SKILL_NAME} run [args]
if [[ "\$1" == "run" ]]; then
    shift
    ARGS="\$*"

    # Input validation
    if [[ -z "\$ARGS" ]]; then
        echo "Error: Missing required arguments."
        echo "Usage: @${SKILL_NAME} run <input>"
        exit 1
    fi

    # Validate input (no pipe characters)
    if echo "\$ARGS" | grep -q '|'; then
        echo "Error: Input cannot contain '|' character."
        exit 1
    fi

    # Confirmation for destructive operations
    if [[ "\$FORCE" != "true" ]]; then
        echo "Execute with input: \$ARGS? [y/N]"
        read -r CONFIRM
        [[ "\$CONFIRM" != "y" ]] && echo "Cancelled." && exit 0
    fi

    # Add your logic here
    echo "Running ${SKILL_NAME^} with: \$ARGS"
    echo "✅ Done"
    exit 0
fi

echo "Unknown command: \$1"
echo "Use '@${SKILL_NAME} help' for usage."
exit 1
\`\`\`

## Notes

- Add your logic in the \`run\` command block
- Use \`--force\` flag for non-interactive execution
- Always validate inputs before processing
- Return exit 0 on success, exit 1 on failure
EOF

    echo "✓ Skill forged: $TARGET_FILE"
    echo ""
    echo "Template includes:"
    echo "  - --force flag support"
    echo "  - Input validation"
    echo "  - Error handling"
    echo "  - Usage messages"
    echo ""
    echo "Next steps:"
    echo "  1. Edit $TARGET_FILE — add logic in the 'run' block"
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
