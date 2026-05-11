#!/bin/bash
# Install script for MemCore

# Update agents
for f in core/agents/*.md; do
  agent_name=$(basename "$f")
  if [ -f "$HOME/.config/opencode/agents/$agent_name" ]; then
    if ! diff -q "$f" "$HOME/.config/opencode/agents/$agent_name" > /dev/null 2>&1; then
      cp "$f" "$HOME/.config/opencode/agents/$agent_name" && echo "Updated: $agent_name"
    else
      echo "Skipping: $agent_name (unchanged)"
    fi
  else
    cp "$f" "$HOME/.config/opencode/agents/" && echo "Added: $agent_name"
  fi
done

# Update skills
for f in core/skills/*/*.md; do
  skill_name=$(basename "$f")
  skill_dir=$(dirname "$f" | xargs basename)
  if [ -f "$HOME/.config/opencode/skills/$skill_dir/$skill_name" ]; then
    if ! diff -q "$f" "$HOME/.config/opencode/skills/$skill_dir/$skill_name" > /dev/null 2>&1; then
      cp "$f" "$HOME/.config/opencode/skills/$skill_dir/$skill_name" && echo "Updated: $skill_name"
    else
      echo "Skipping: $skill_name (unchanged)"
    fi
  else
    mkdir -p "$HOME/.config/opencode/skills/$skill_dir"
    cp "$f" "$HOME/.config/opencode/skills/$skill_dir/" && echo "Added: $skill_name"
  fi
done

# Update opencode.json
if [ -f "$HOME/.config/opencode/opencode.json" ]; then
  if ! diff -q core/opencode.json "$HOME/.config/opencode/opencode.json" > /dev/null 2>&1; then
    cp core/opencode.json "$HOME/.config/opencode/opencode.json" && echo "Updated opencode.json"
  else
    echo "Skipping opencode.json (unchanged)"
  fi
else
  cp core/opencode.json "$HOME/.config/opencode/opencode.json" && echo "Copied opencode.json"
fi

# Copy global-memory if empty
if [ -z "$(ls -A "$HOME/.config/opencode/global-memory" 2>/dev/null)" ]; then
  cp -r templates/global-memory/* "$HOME/.config/opencode/global-memory/" && echo "Copied global-memory templates"
else
  echo "Skipping global-memory (already exists)"
fi