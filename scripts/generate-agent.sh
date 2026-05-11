#!/bin/bash
# Generate a new MemCore subagent from template
# Usage: bash scripts/generate-agent.sh [agent-name]
# Example: bash scripts/generate-agent.sh notification-coder

set -e

if [ -z "$1" ]; then
  echo "Usage: bash generate-agent.sh [agent-name]"
  echo "Example: bash generate-agent.sh notification-coder"
  exit 1
fi

NAME="$1"
FILE="core/agents/$NAME.md"

if [ -f "$FILE" ]; then
  echo "❌ Agent '$NAME' already exists at $FILE"
  exit 1
fi

cat > "$FILE" << EOF
---
name: $NAME
description: [description of what this agent does]
mode: subagent
permission:
  edit: deny
  read: allow
  glob: allow
  grep: allow
  bash: deny
---

# $NAME Agent

[Brief description of this agent's purpose]

## Workflow

1. **Read Context** - Load relevant docs/context/
2. **Check Past Lessons** - Run \`@memory, show lessons about [topic]\`
3. **Execute Task** - Perform the specialized task
4. **Decision Logging** - Log architectural choices via \`@decision-log\`
5. **Update Planner** - Mark task as \`[x]\` in planner.md

## Rules

- [Rule 1]
- [Rule 2]

## Guardrails

- **Scope Check**: If task is outside your domain → redirect to correct @agent.
- **Ask Before Modify**: If file exists, ask user before overwriting.

## Output Format

\`\`\`
**Task:** [task description]
**Files Modified:**
1. [path/to/file] - [description]
**Decision Logged**: DEC-YYYY-NNN (if applicable)
[x] TASK-ID completed
\`\`\`
EOF

echo "✅ Agent '$NAME' created at $FILE"
echo ""

# Register in routing table
if grep -q "Routing Table" core/agents/memcore.md 2>/dev/null; then
  echo "⚠️  Don't forget to add '$NAME' to the routing table in core/agents/memcore.md"
fi

echo "Next steps:"
echo "  1. Edit $FILE with agent-specific content"
echo "  2. Add '$NAME' to routing table in core/agents/memcore.md"
echo "  3. Register in VERSION.yaml core_agents list"
echo "  4. Run: bash scripts/validate.sh"
