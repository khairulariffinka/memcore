#!/bin/bash
cd "$(dirname "$0")/.."

echo "=== Updating MemCore ==="
echo ""

echo "=== Agents ==="
for f in core/agents/*.md; do
  agent_name=$(basename "$f")
  if [ -f ~/.config/opencode/agents/"$agent_name" ]; then
    if ! diff -q "$f" ~/.config/opencode/agents/"$agent_name" > /dev/null 2>&1; then
      cp "$f" ~/.config/opencode/agents/"$agent_name" && echo "Updated: $agent_name"
    else
      echo "Skipping: $agent_name (unchanged)"
    fi
  else
    cp "$f" ~/.config/opencode/agents/ && echo "Added: $agent_name"
  fi
done

echo ""
echo "=== Skills ==="
for f in core/skills/*/*.md; do
  skill_name=$(basename "$f")
  skill_dir=$(dirname "$f" | xargs basename)
  if [ -f ~/.config/opencode/skills/"$skill_dir"/"$skill_name" ]; then
    if ! diff -q "$f" ~/.config/opencode/skills/"$skill_dir"/"$skill_name" > /dev/null 2>&1; then
      cp "$f" ~/.config/opencode/skills/"$skill_dir"/"$skill_name" && echo "Updated: $skill_name"
    else
      echo "Skipping: $skill_name (unchanged)"
    fi
  else
    mkdir -p ~/.config/opencode/skills/"$skill_dir"
    cp "$f" ~/.config/opencode/skills/"$skill_dir"/ && echo "Added: $skill_name"
  fi
done

echo ""
echo "=== global-memory ==="
[ -z "$(ls -A ~/.config/opencode/global-memory 2>/dev/null)" ] && cp -r templates/global-memory/* ~/.config/opencode/global-memory/ || echo "Skipping global-memory (already exists)"

echo ""
echo "=== Done ==="