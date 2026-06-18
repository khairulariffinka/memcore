---
name: compress-file
description: >
  Compress natural language memory files (AGENTS.md, planner.md, DECISIONS.md, etc.)
  into terse format to save input tokens. Preserves code, URLs, file paths exactly.
  Compressed version overwrites original. Backup saved as FILE.original.md.
  Trigger: "compress file FILEPATH" or "compress memory file"
---

Rewrite memory files into terse format. Cut ~46% input tokens. Every session cheaper.

## How It Works

1. Read target file
2. Compress: drop filler, shorten prose, keep code/URLs/paths exact
3. Save backup as `FILE.original.md`
4. Overwrite with compressed version

## Usage

```
compress-file AGENTS.md
compress-file planner.md
compress-file DECISIONS.md
```

## Compression Rules

### DROP
- Articles (a/an/the) — except where grammar breaks
- Filler words (just, really, basically, actually, simply, very, quite)
- Hedging phrases (it seems like, I think that, probably, might be)
- Pleasantries (sure, of course, happy to help, great question)
- Redundant explanations (the purpose of this is to → this does)
- Self-references (we need to, let me, I'll)
- Decorative emoji

### KEEP (exact, byte-preserved)
- Code blocks
- URLs and file paths
- Technical terms (API names, CLI commands, database terms)
- Function names, variable names
- Error messages
- Git commands

### SHORTEN
- "in order to" → "to"
- "at this point in time" → "now"
- "due to the fact that" → "because"
- "a large number of" → "many"
- "has the ability to" → "can"
- "is able to" → "can"

## Example

**Before (156 tokens):**
```
# Session Rules

In order to maintain consistency across all sessions, we need to follow these rules.
At the beginning of each session, the AI should check the current-state.md file to
understand where we are in the project. Due to the fact that context is limited,
it's important to load only the most relevant files.
```

**After (89 tokens):**
```
# Session Rules

Maintain consistency across sessions. Each session start:
- Check current-state.md for project position
- Load only relevant files (context limited)
```

**Savings: 43%**

## When to Compress

- AGENTS.md — project rules, always loaded
- planner.md — task breakdown
- DECISIONS.md — design decisions
- Any file >500 tokens loaded every session
