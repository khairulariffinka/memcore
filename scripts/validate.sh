#!/bin/bash
# MemCore Validation Script
# Run: bash scripts/validate.sh
# Checks: frontmatter, agent refs, permissions, overclaim terms, file integrity

PASS=0
FAIL=0

# Usage: bash validate.sh [--installed]
#   Default: validate memcore repo files (script's location)
#   --installed: validate ~/.config/opencode/ installed files

if [ "$1" = "--installed" ]; then
  ROOT="$HOME/.config/opencode"
  AGENTS_DIR="$ROOT/agents"
  SKILLS_DIR="$ROOT/skills"
  echo "🔍 Validating installed config: $ROOT"
elif [ "$1" = "--help" ]; then
  echo "Usage: bash validate.sh [--installed]"
  echo "  (no flag)  Validate memcore repo files"
  echo "  --installed Validate ~/.config/opencode/ installed files"
  echo "  --help     Show this help"
  exit 0
else
  ROOT=$(dirname "$(dirname "$(realpath "$0")")")
  AGENTS_DIR="$ROOT/core/agents"
  SKILLS_DIR="$ROOT/core/skills"
  echo "🔍 Validating repo: $ROOT"
fi

red()   { printf "\e[31m%s\e[0m\n" "$1"; }
green() { printf "\e[32m%s\e[0m\n" "$1"; }
yellow(){ printf "\e[33m%s\e[0m\n" "$1"; }

check() {
  local desc="$1"
  local result="$2"
  if [ "$result" = "pass" ]; then
    green "  ✅ $desc"
    PASS=$((PASS + 1))
  else
    red "  ❌ $desc"
    FAIL=$((FAIL + 1))
  fi
}

echo ""
yellow "=========================================="
yellow "  MemCore Validation"
yellow "=========================================="
echo ""

# ── 1. Agent count ──
echo "── Agent Count ──"
agent_count=$(ls "$AGENTS_DIR"/*.md 2>/dev/null | wc -l)
check "5 agent files (found: $agent_count)" "$([ "$agent_count" -eq 5 ] && echo "pass" || echo "fail")"

# ── 2. Skill count ──
echo "── Skill Count ──"
skill_count=$(ls "$SKILLS_DIR"/*/SKILL.md 2>/dev/null | wc -l)
check "19 skill files (found: $skill_count)" "$([ "$skill_count" -eq 19 ] && echo "pass" || echo "fail")"

# ── 3. YAML frontmatter ──
echo "── YAML Frontmatter ──"
for f in "$AGENTS_DIR"/*.md; do
  name=$(basename "$f")
  if head -1 "$f" | grep -q '^---$'; then
    : # has frontmatter
  else
    check "$name: missing --- frontmatter" "fail"
    continue
  fi
  if ! grep -q '^name: ' "$f"; then
    check "$name: missing name:" "fail"
    continue
  fi
  if ! grep -q '^description: ' "$f"; then
    check "$name: missing description:" "fail"
    continue
  fi
  if ! grep -q '^mode: ' "$f"; then
    check "$name: missing mode:" "fail"
    continue
  fi
  if ! grep -q '^permission:' "$f"; then
    check "$name: missing permission:" "fail"
    continue
  fi
done
check "All agents have valid YAML frontmatter" "pass"

# ── 4. Skill frontmatter ──
echo "── Skill Frontmatter ──"
for f in "$SKILLS_DIR"/*/SKILL.md; do
  name=$(basename "$(dirname "$f")")
  if head -1 "$f" 2>/dev/null | grep -q '^---$'; then
    : # has frontmatter
  else
    check "$name/SKILL.md: missing --- frontmatter" "fail"
  fi
done
check "All skills have valid YAML frontmatter" "pass"

# ── 5. Permission consistency ──
echo "── Permission Consistency ──"
# Read-only agents (bash: deny + no edit)
for agent in research; do
  f="$AGENTS_DIR/$agent.md"
  if [ -f "$f" ]; then
    if grep -q 'bash: deny' "$f" && ! grep -q 'edit: allow' "$f" 2>/dev/null; then
      : # ok
    else
      check "$agent: expected bash:deny + no edit" "fail"
    fi
  fi
done
# Spec writers (edit:allow + bash:deny)
for agent in decision-log planner; do
  f="$AGENTS_DIR/$agent.md"
  if [ -f "$f" ] && ! grep -q 'edit: allow' "$f"; then
    check "$agent: expected edit:allow (spec writer)" "fail"
  fi
done
# Full-access agents (edit:allow + bash:allow)
for agent in memcore memory; do
  f="$AGENTS_DIR/$agent.md"
  if [ -f "$f" ]; then
    if grep -q 'edit: allow' "$f" && grep -q 'bash: allow' "$f"; then
      : # ok
    else
      check "$agent: expected edit:allow + bash:allow (full access)" "fail"
    fi
  fi
done
check "Permission sets are consistent" "pass"

# ── 6. No swap/temp files ──
echo "── Temp / Swap Files ──"
swap_dir="$ROOT"
[ "$1" = "--installed" ] && swap_dir="$ROOT/agents"  # no core/ dir in installed
swaps=$(find "$swap_dir" -name '*.swp' -o -name '*.swo' -o -name '*~' -o -name '*.kate-swp' 2>/dev/null || true)
if [ -n "$swaps" ]; then
  check "Swap files found: $(echo "$swaps" | tr '\n' ' ')" "fail"
else
  check "No swap/temp files" "pass"
fi

# ── 7. Agent references ──
echo "── Agent @references ──"
# Build list of valid agent names
valid_agents=""
for f in "$AGENTS_DIR"/*.md; do
  agent_name=$(basename "$f" .md)
  valid_agents="$valid_agents $agent_name"
done

bad_refs=0
if [ "$1" = "--installed" ]; then
  ref_files="$AGENTS_DIR"/*.md
else
  ref_files="$AGENTS_DIR"/*.md "$SKILLS_DIR"/*/SKILL.md
fi
shopt -s nullglob
for f in $ref_files; do
  [ ! -f "$f" ] && continue
  refs=$(grep -on '@[a-z][a-z-]*' "$f" 2>/dev/null | grep -v '@param\|@returns\|@throws\|@click\|@mouse\|@key\|@media\|@import\|@apply\|@tailwind\|@layer\|@screen\|@font\|@starting' || true)
  while IFS=: read -r line ref; do
    [ -z "$ref" ] && continue
    agent_name="${ref#@}"
    case "$agent_name" in
      memcore|memory|planner|research|decision-log) ;;
      *) continue ;;
    esac
    if ! echo "$valid_agents" | grep -qw "$agent_name"; then
      bad_refs=$((bad_refs + 1))
    fi
  done <<< "$refs"
done
check "All @agent refs resolve to existing files (broken: $bad_refs)" "$([ "$bad_refs" -eq 0 ] && echo "pass" || echo "fail")"

# ── 8. Overclaim terms ──
echo "── Overclaim Terms ──"
if [ "$1" = "--installed" ]; then
  overclaims=$(grep -rn 'semantic search\|knowledge graph\|pattern recognition' "$ROOT/agents" "$ROOT/skills" --include='*.md' 2>/dev/null || true)
else
  overclaims=$(grep -rn 'semantic search\|knowledge graph\|pattern recognition' "$ROOT/core" --include='*.md' 2>/dev/null || true)
fi
if [ -z "$overclaims" ]; then
  check "No overclaim terms detected" "pass"
else
  check "Overclaim terms found: $(echo "$overclaims" | wc -l)" "fail"
fi

# ── 9. No TODO/FIXME in production files ──
echo "── TODO / FIXME Check ──"
if [ "$1" = "--installed" ]; then
  todos=$(grep -rn 'TODO\|FIXME' "$ROOT/agents" "$ROOT/skills" --include='*.md' 2>/dev/null | grep -v 'code examples\|```\|No.*TODO.*left\|No.*FIXME.*comment' || true)
else
  todos=$(grep -rn 'TODO\|FIXME' "$ROOT/core" --include='*.md' 2>/dev/null | grep -v 'code examples\|```\|No.*TODO.*left\|No.*FIXME.*comment' || true)
fi
if [ -z "$todos" ]; then
  check "No TODO/FIXME in production files" "pass"
else
  check "TODO/FIXME found (review needed)" "fail"
fi

# ── 10. Install/Update agent count (repo only) ──
if [ "$1" != "--installed" ]; then
  echo "── Install/Update File Counts ──"
  install_match=$(grep -c '5 agents\|5 subagents' "$ROOT/install.md" 2>/dev/null || true)
  update_match=$(grep -c '5 agents\|5 subagents' "$ROOT/update.md" 2>/dev/null || true)
  if [ "$install_match" -gt 0 ] && [ "$update_match" -gt 0 ]; then
    check "install/update.md reference correct agent count" "pass"
  else
    check "install/update.md agent count mismatch" "fail"
  fi
fi

# ── 11. Parallel group consistency (repo only) ──
if [ "$1" != "--installed" ]; then
  echo "── Parallel Group Consistency ──"
  parallel_planner=$(grep -c 'Parallel Group\|Parallel.*Group' "$ROOT/core/skills/planner/SKILL.md" 2>/dev/null || true)
  parallel_memcore=$(grep -c 'Parallel Group\|Parallel.*Group\|Parallel Execution' "$ROOT/core/agents/memcore.md" 2>/dev/null || true)
  if [ "$parallel_planner" -ge 3 ] && [ "$parallel_memcore" -ge 1 ]; then
    check "Parallel execution defined consistently across files" "pass"
  else
    check "Parallel execution references inconsistent" "fail"
  fi
fi

# ── 12. .gitignore scope (repo only) ──
if [ "$1" != "--installed" ]; then
  echo "── .gitignore Scope ──"
  if grep -q '^/docs/' "$ROOT/.gitignore" 2>/dev/null; then
    check ".gitignore uses root-scoped /docs/" "pass"
  else
    check ".gitignore docs/ not root-scoped" "fail"
  fi
fi

# ── Summary ──
echo ""
yellow "=========================================="
TOTAL=$((PASS + FAIL))
yellow "  Results: $PASS passed, $FAIL failed (${TOTAL} checks)"
yellow "=========================================="
echo ""

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
