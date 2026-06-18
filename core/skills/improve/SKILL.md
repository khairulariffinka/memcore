---
name: improve
description: >
  Self-improvement — learn from failures, scan codebase for patterns, generate skills.
  Two functions: post-mortem (failure learning), forge (codebase improvement).
---

Improvement layer. Two functions.

## Functions

| Command | What |
|---------|------|
| `improve log <title> [severity] [--flags]` | Log a failure |
| `improve edit <id> <section> <content>` | Update a section |
| `improve list` | List all post-mortems |
| `improve lessons` | Show lessons learned |
| `improve delete <id>` | Delete entry |
| `improve scan` | Scan codebase for improvement patterns |
| `improve create <name> <desc>` | Generate a new skill |

## Post-Mortem

Severity: `Critical`, `High`, `Medium` (default), `Low`
Sections: `symptoms`, `cause`, `resolution`, `lesson`, `prevention`

```
User: improve log "Migration failed" High \
      --symptoms "500 error" \
      --cause "Missing column" \
      --resolution "Added column" \
      --lesson "Verify locally" \
      --prevention "Add CI test"

AI:   Created: IMP-2026-06-18-001

User: improve lessons
AI:   ## Lesson: Verify migration locally
```

## Forge

```
User: improve scan
AI:   === Forge Scan ===
      Existing skills: 5
      Issues found: 3
      Proposals saved

User: improve create api-tester "Auto-test API"
AI:   ✓ Skill forged: core/skills/api-tester/SKILL.md
```
