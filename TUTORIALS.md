# MemCore Tutorials

> **New here?** Start with [README.md](./README.md) for quick setup.
>
> **First clone:**
> ```bash
> git clone https://github.com/khairulariffinka/memcore.git
> cd memcore
> ```
>
> This page is for **detailed guides** when you want to learn more.

MemCore — memory intelligence layer with 5 focused skills.

---

## Table of Contents

### Getting Started
1. [Installation](#installation) — Setup MemCore in OpenCode
2. [Session Lifecycle](#session-lifecycle) — Start, work, save
3. [Basic Usage](#basic-usage) — First commands

### Skills
4. [Memory](#memory) — Patterns, knowledge, consolidation
5. [Reminders](#reminders) — Cross-session reminders
6. [Work](#work) — Plan execution + goals
7. [Improve](#improve) — Failures + self-improvement
8. [Compress](#compress) — Token compression

---

## Installation

### 1. Clone

```bash
git clone https://github.com/khairulariffinka/memcore.git
cd memcore
```

### 2. Load in OpenCode

```
"load install.md"
```

### 3. Activate

Press `TAB` until you see `memcore`.

---

## Session Lifecycle

### Start Session

1. MemCore loads configuration
2. Check reminders: `reminders list`
3. Load profile: `memory profile`

### During Session

Use any of the 5 skills as needed.

### End Session

When you say "bye", "done", "selesai", or "keluar":

1. Update behavioural profile: `memory observe`
2. Show due reminders: `reminders list`
3. Consolidate knowledge: `memory dream`

---

## Basic Usage

```bash
# Start
memory observe
reminders list

# Work
work start my-task
work goal set "tests passing" "npm test returns 0"

# Learn
improve log "auth bug" High --symptoms "..." --cause "..."

# Save tokens
compress full

# End
memory dream
```

---

## Memory

**Skill:** `memory`

Three functions: observe patterns, store knowledge, consolidate memory.

| Command | What |
|---------|------|
| `memory observe` | Detect user patterns |
| `memory profile` | Show behavioural profile |
| `memory save <category> <name> [content]` | Save knowledge |
| `memory search <keyword>` | Search entries |
| `memory list [category]` | List entries |
| `memory get <category> <name>` | Read entry |
| `memory delete <category> <name>` | Delete entry |
| `memory dream` | Consolidate → MEMORY.md |

### Categories

| Category | Use For |
|----------|---------|
| `architecture` | System design, patterns |
| `workflow` | Processes, automations |
| `database` | Schema, queries |
| `integration` | API contracts |

### Example

```
User: memory observe
AI:   ✓ Language: Malay, Peak: 10:00, Completion: 75%

User: memory save architecture jwt "Use JWT with refresh token"
AI:   Saved: architecture/jwt.md

User: memory dream
AI:   🌙 Consolidated 3 entries to MEMORY.md
```

---

## Reminders

**Skill:** `reminders`

Cross-session reminders with due dates.

| Command | What |
|---------|------|
| `reminders set <due> <message>` | Set reminder |
| `reminders list` | List pending |
| `reminders done <id>` | Mark complete |
| `reminders edit <id> <due> <message>` | Edit |
| `reminders clear` | Clear completed |

Due: `next-session`, `tomorrow`, `YYYY-MM-DD`

### Example

```
User: reminders set tomorrow "Review PR"
AI:   REM-001 — "Review PR" (due: tomorrow)

User: reminders list
AI:   ⚠️ REM-001 — "Review PR" (due: tomorrow)
```

---

## Work

**Skill:** `work`

Plan execution + goal-driven sessions.

| Command | What |
|---------|------|
| `work start <name>` | Start plan |
| `work next` | Next task |
| `work done [message]` | Complete task |
| `work status` | Progress |
| `work goal set <goal> [verification]` | Set goal |
| `work goal status` | Goal progress |
| `work goal check` | Verify completion |
| `work goal stop` | Mark complete |
| `work goal clear` | Clear goal |

### Example

```
User: work start refactor-auth
AI:   === Plan: refactor-auth ===
      Current: Update login controller

User: work done "Refactored login"
AI:   ✓ Done. Next: Add validation

User: work goal set "tests pass" "npm test returns 0"
AI:   🎯 Goal: tests pass

User: work goal check
AI:   🔍 Verifying... ✅ PASS

User: work goal stop
AI:   Session complete.
```

---

## Improve

**Skill:** `improve`

Learn from failures + scan codebase.

| Command | What |
|---------|------|
| `improve log <title> [severity] [--flags]` | Log failure |
| `improve edit <id> <section> <content>` | Update |
| `improve list` | List failures |
| `improve lessons` | Show lessons |
| `improve delete <id>` | Delete |
| `improve scan` | Scan codebase |
| `improve create <name> <desc>` | Generate skill |

Severity: `Critical`, `High`, `Medium`, `Low`

### Example

```
User: improve log "Migration failed" High \
      --symptoms "500 error" \
      --cause "Missing column" \
      --lesson "Verify locally"

AI:   Created: IMP-2026-06-18-001

User: improve lessons
AI:   ## Lesson: Verify migration locally

User: improve scan
AI:   Issues found: 3. Proposals saved.
```

---

## Compress

**Skill:** `compress`

Token compression — talk less, save more.

| Command | What |
|---------|------|
| `compress lite` | Professional, tight |
| `compress full` | Classic (default) |
| `compress ultra` | Maximum compression |
| `compress off` | Normal mode |
| `compress file <filepath>` | Compress memory file |

### Levels

| Level | What Change |
|-------|-------------|
| **lite** | No filler. Keep full sentences |
| **full** | Drop articles, fragments OK |
| **ultra** | Abbreviate prose words |

### Example

```
User: compress full
AI:   ✓ Full compress active.

User: How does useEffect work?
AI:   useEffect run side-effect after render. Dependency array control when run.

User: compress file AGENTS.md
AI:   Compressed: 2000 → 1080 tokens (46% saved)

User: compress off
AI:   ✓ Normal mode.
```

---

## Quick Reference

| Skill | Commands |
|-------|----------|
| `memory` | `observe`, `profile`, `save`, `search`, `list`, `get`, `delete`, `dream` |
| `reminders` | `set`, `list`, `done`, `edit`, `clear` |
| `work` | `start`, `next`, `done`, `status`, `goal set/status/check/stop/clear` |
| `improve` | `log`, `edit`, `list`, `lessons`, `delete`, `scan`, `create` |
| `compress` | `lite`, `full`, `ultra`, `off`, `file <filepath>` |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0.0 | 2026-06-18 | Simplified: 11 → 5 skills |
| 1.3.0 | 2026-06-18 | Added compress, compress-file |
| 1.2.0 | 2026-06-18 | Added dream, goal, checkpoint |
| 1.1.0 | 2026-06-18 | Added plan agent, permissions |
| 1.0.0 | 2026-05-12 | First stable release |

---

_Last updated: 2026-06-18_
