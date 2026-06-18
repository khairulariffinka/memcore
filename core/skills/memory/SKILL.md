---
name: memory
description: >
  Memory system — observe user patterns, store knowledge, consolidate session memory.
  Three functions: observe (detect patterns), save/search (knowledge library), dream (consolidate).
---

Memory layer. Three functions in one skill.

## Functions

| Command | What |
|---------|------|
| `memory observe` | Detect user patterns (language, peak hours, completion rate) |
| `memory profile` | Show behavioural profile |
| `memory save <category> <name> [content]` | Save knowledge entry |
| `memory search <keyword>` | Search entries by keyword |
| `memory list [category]` | List entries |
| `memory get <category> <name>` | Read specific entry |
| `memory delete <category> <name>` | Delete entry |
| `memory dream` | Consolidate session knowledge → MEMORY.md |
| `memory dream list` | Show consolidated knowledge |

## Categories (for save/search)

| Category | Use For |
|----------|---------|
| `architecture` | System design, patterns, tech decisions |
| `workflow` | Processes, pipelines, automations |
| `database` | Schema, queries, migrations |
| `integration` | API contracts, third-party services |

## Observed Dimensions

| Dimension | What It Tracks |
|-----------|----------------|
| Language | Malay vs English usage |
| Peak Hours | Time of day with most activity |
| Completion Rate | Task completion rate |
| Agent Preference | Most-used subagents |
| Error Frequency | Common failure patterns |

## Storage

- Patterns: `~/.config/opencode/global-memory/mulahazah.md`
- Knowledge: `docs/library/<category>/<name>.md`
- Consolidated: `~/.config/opencode/global-memory/MEMORY.md`

## Example

```
# Detect patterns
User: memory observe
AI:   Observing sessions... ✓ Language: Malay, Peak: 10:00

# Save knowledge
User: memory save architecture jwt "Use JWT with refresh token"
AI:   Entry saved: architecture/jwt.md

# Search
User: memory search jwt
AI:   architecture/jwt — JWT with refresh token

# Consolidate
User: memory dream
AI:   🌙 Consolidated 3 entries to MEMORY.md
```
