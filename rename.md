# Rename Protocol

> **When user loads this file:** User wants to rename their primary agent.

AI-assisted protocol to rename the primary agent from "memcore" to a custom name.

**Works for:** OpenCode

## Context

When this file is loaded, AI must know:
- User wants to rename agent MemCore
- Current name: `memcore`
- AI must ask user what to rename to

## Usage

```
User: "Load rename.md"
AI: "What would you like to rename 'memcore' to?"
User: "nova"
AI: [Execute rename steps]
```

## Rename Steps

Execute these steps when user provides their chosen name:

### Step 1: Validate Name

```
Rules for valid name:
- Lowercase letters and numbers only
- Hyphens allowed between words
- No spaces, underscores, or special characters
- Must be 1-64 characters
- Cannot start or end with hyphen

Valid examples: nova, my-agent, code-helper-123
Invalid examples: My Agent, nova_v2, agent!
```

If invalid, ask user for a different name.

### Step 2: Find Current Primary Agent

```
Find user's primary agent (mode: primary):

primary_agent=$(ls ~/.config/opencode/agents/*.md | xargs grep -l "^mode: primary" | head -1)
agent_name=$(basename "$primary_agent" .md)
```

Example output:
- If renamed: nova.md (mode: primary) → current name: nova
- Default: memcore.md (mode: primary) → current name: memcore

### Step 3: Rename Agent File

```
# Rename file
mv ~/.config/opencode/agents/{current-name}.md ~/.config/opencode/agents/{new-name}.md
```

### Step 4: Update Agent File Content

Edit the renamed agent file:

```bash
# Update name in content
sed -i 's/^name: .*/name: {new-name}/' ~/.config/opencode/agents/{new-name}.md

# Ensure mode stays as primary
sed -i 's/^mode: .*/mode: primary/' ~/.config/opencode/agents/{new-name}.md
```

### Step 5: Verify Rename

```
Check that all files are correctly renamed:

~/.config/opencode/
├── agents/
│   └── {new-name}.md         ← Renamed ✓
└── skills/
    └── (skills are unchanged) ← No memcore folder
```

### Step 6: Complete

```
✅ Rename Complete!

Old name: memcore
New name: {new-name}

Files updated:
- agents/{new-name}.md

Test your renamed agent:
Say: "{new-name}, hello!"
```

## Example Session

```
User: Load rename.md

AI: I'll help you rename your agent.
    (Detecting current name from mode: primary...)
    Current name: nova

User: alex

AI: Validating name... ✓
    Renaming nova → alex...

    1. Renaming agent file... ✓
    2. Updating agent content... ✓

    ✅ Rename Complete!
    Your agent is now "alex"

    Test it: "alex, hello!"
```

## Reverting

To revert to the default name:

```
User: Load rename.md
AI: What name?
User: memcore
AI: [Reverts to default]
```

## Important Notes

- **ONLY edit files in ~/.config/opencode/** - NEVER edit source files in project folder
- Detects primary agent by searching for `mode: primary` in agent files
- Core subagents (memory, planner, coder, etc.) are NOT renamed
- The rename ONLY affects:
  - ~/.config/opencode/agents/{current-name}.md → {new-name}.md
- Skills are referenced directly from core/skills/ - no separate folder
- Original source files in the project folder remain unchanged
- Update (load update.md) will update your custom agent directly
