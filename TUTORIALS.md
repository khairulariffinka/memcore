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

MemCore — memory intelligence layer with 7 focused skills.

---

## Table of Contents

### Getting Started
1. [Installation](#installation) — Setup MemCore in OpenCode
2. [Session Lifecycle](#session-lifecycle) — Start, work, save
3. [Basic Usage](#basic-usage) — First commands

### Skills
4. [Observation](#observation) — Behavioural learning (Mulahazah)
5. [Reminders](#reminders) — Cross-session reminders
6. [Library System](#library-system) — Knowledge library
7. [LRU Projects](#lru-projects) — Multi-project tracking
8. [Forge](#forge) — Self-improvement skill generator
9. [Work Plan](#work-plan) — Plan execution tracking
10. [Post-Mortem](#post-mortem) — Failure learning

---

## Installation

### 1. Clone

```bash
git clone https://github.com/khairulariffinka/memcore.git
cd memcore
```

### 2. Load in OpenCode

In OpenCode, load the install file:

```
"load install.md"
```

### 3. Activate

Press `TAB` until you see `memcore`, then start using it:

```
@observation observe
```

---

## Session Lifecycle

### Start Session

When you start a session, the following happens:

1. MemCore loads its configuration
2. You can check pending reminders: `@reminders list`
3. You can load behavioural profile: `@observation profile`

### During Session

Use any of the 7 skills as needed.

### End Session

When you say "bye", "done", "selesai", or "keluar":

1. Behavioural profile updates via `@observation observe`
2. Pending reminders shown via `@reminders list`
3. Project tracking updates via `@lru add`
4. Session summary saved

---

## Basic Usage

### First Session

```bash
# Observe your patterns
@observation observe

# Set a reminder
@remind set tomorrow "Review PR"

# Save knowledge
@library save architecture api-design "RESTful API design patterns"

# Track this project
@lru add
```

---

## Observation

**Subagent:** `@observation` / `@observe`

Tracks your behavioural patterns across sessions:

| Command | Description |
|---------|-------------|
| `@observation observe` | Analyse session diary & planner for user patterns |
| `@observation profile` | Show current observed user profile |
| `@observation suggest` | Suggest adjustments based on observed patterns |
| `@observation reset` | Reset behavioural data |

### What It Tracks

| Dimension | What It Detects |
|-----------|----------------|
| Language | Malay vs English usage ratio |
| Peak Hours | Time of day with most activity |
| Completion Rate | How often tasks are completed |
| Agent Preference | Most-used subagents |
| Session Length | Average session duration |

### Example

```
User: @observation observe
AI:   Observing 12 sessions...
      ✓ Language: Malay (preferred)
      ✓ Peak hours: 10:00
      ✓ Completion rate: 75%
      ✓ Profile updated.
```

---

## Reminders

**Subagent:** `@reminders` / `@remind`

Cross-session reminders with due dates and persistence.

| Command | Description |
|---------|-------------|
| `@remind set <due> <message>` | Set a new reminder |
| `@remind list` | Show all pending reminders |
| `@remind done <id>` | Mark reminder complete |
| `@remind clear` | Clear all completed reminders |

Due options: `next-session`, `tomorrow`, `YYYY-MM-DD`

### Example

```
User: @remind set next-session "Check deployment status"
AI:   Reminder set: REM-001 — "Check deployment status" (due: next-session)

--- Next session ---
User: @remind list
AI:   ⚠️ Due reminders:
      REM-001 — "Check deployment status" (due: next-session)
```

---

## Library System

**Subagent:** `@library` / `@library-system`

Organised knowledge library with categorised entries.

| Command | Description |
|---------|-------------|
| `@library save <category> <name> [content]` | Save a knowledge entry |
| `@library search <keyword>` | Search entries by keyword |
| `@library list [category]` | List entries (by category or all) |
| `@library get <category> <name>` | Read a specific entry |

### Categories

| Category | Use For |
|----------|---------|
| **architecture** | System design, patterns, tech decisions |
| **workflow** | Processes, pipelines, automations |
| **database** | Schema, queries, migrations |
| **integration** | API contracts, third-party services |

### Example

```
User: @library save architecture repository-pattern "Repository pattern with Laravel:
      - Interface + Implementation
      - Dependency injection via constructor
      - Unit test with mocks"

AI:   Entry saved: LIB-2026-001 → docs/library/architecture/repository-pattern.md

User: @library search repository
AI:   LIB-2026-001 — Repository Pattern (architecture)
```

---

## LRU Projects

**Subagent:** `@lru`

Multi-project management with LRU eviction — 10 active slots, auto-archival.

| Command | Description |
|---------|-------------|
| `@lru add [name]` | Register current project |
| `@lru list` | List all tracked projects (active + archived) |
| `@lru switch <name>` | Switch to another project |
| `@lru remove <name>` | Remove a project |
| `@lru status` | Show project activity summary |

### Example

```
User: @lru add
AI:   Project added: memcore (active: 1/10)

User: @lru list
AI:   === Active Projects ===
      1 | memcore | 2026-05-12 | 5 sessions
      === Archived ===
      old-project | 2026-04-01 | 12 sessions
```

---

## Forge

**Subagent:** `@forge`

Self-improvement system — scan codebase, detect patterns, generate new skills.

| Command | Description |
|---------|-------------|
| `@forge scan` | Analyse codebase for improvement patterns |
| `@forge create <name> <desc>` | Generate a new skill from template |
| `@forge propose` | Show improvement proposals |
| `@forge list` | List all forged skills |

### Example

```
User: @forge scan
AI:   === Forge Scan ===
      Existing skills: 7
      Pattern analysis complete

      Suggestions:
      1. Review overlapping functionality
      2. Add error handling improvements

User: @forge create api-tester "Auto-test API endpoints"
AI:   ✓ Skill forged: core/skills/api-tester/SKILL.md
```

---

## Work Plan

**Subagent:** `@plan`

Plan-to-execution tracking with per-task progress, integrated with git.

| Command | Description |
|---------|-------------|
| `@plan start <name>` | Start working on a plan |
| `@plan next` | Show next pending task |
| `@plan done [message]` | Mark task done (optional git commit) |
| `@plan status` | Show plan progress |

### Example

```
User: @plan start refactor-auth
AI:   === Plan: refactor-auth ===
      Current task: Update login controller

User: @plan done "Refactored login controller"
AI:   ✓ Task done: Update login controller
      Next up: Add input validation
```

---

## Post-Mortem

**Subagent:** `@pm` / `@post-mortem`

Failure learning log — record errors, root causes, and prevention.

| Command | Description |
|---------|-------------|
| `@pm log <title> [severity]` | Log a new failure |
| `@pm list` | List all post-mortems |
| `@pm lessons` | Show lessons learned |

Severity: `Critical`, `High`, `Medium` (default), `Low`

### Example

```
User: @pm log "Migration failed after deploy" High
AI:   Post-mortem created: PM-2026-05-12-001

      Please edit docs/post-mortem.md to add:
      - Symptoms: What went wrong
      - Root Cause: Why it happened
      - Resolution: How it was fixed
      - Prevention: How to avoid next time
```

---

## Quick Reference

### All Commands

| Subagent | Command | Description |
|----------|---------|-------------|
| `@observation` | `observe` | Analyse patterns |
| | `profile` | Show behavioural profile |
| | `suggest` | Get improvement suggestions |
| `@reminders` | `set <due> <msg>` | Set reminder |
| | `list` | List pending reminders |
| | `done <id>` | Mark complete |
| | `clear` | Clear completed |
| `@library` | `save <cat> <name>` | Save knowledge |
| | `search <keyword>` | Search entries |
| | `list [category]` | List entries |
| | `get <cat> <name>` | Read entry |
| `@lru` | `add [name]` | Track project |
| | `list` | Show projects |
| | `switch <name>` | Change project |
| | `remove <name>` | Remove project |
| | `status` | Project summary |
| `@forge` | `scan` | Analyse patterns |
| | `create <name> <desc>` | Generate skill |
| | `propose` | Show proposals |
| | `list` | List forged skills |
| `@plan` | `start <name>` | Begin plan |
| | `next` | Next task |
| | `done [msg]` | Complete task |
| | `status` | Progress report |
| `@pm` | `log <title> [sev]` | Log failure |
| | `list` | List failures |
| | `lessons` | Show lessons |

---

## Tips & Best Practices

### Memory Compound Effect

The more you use MemCore, the smarter it gets:

```
Session 1:  Set up observation, create library entry
Session 5:  Observation detects your patterns
Session 10: Library has 20+ entries, forge has improvements
Session 20: Compound intelligence — everything connected
```

### Use with CodeXen

MemCore complements CodeXen perfectly:

```
CodeXen: Build feature, review code, audit, security
MemCore: Track patterns, save knowledge, set reminders,
         learn from failures, manage projects
```

### Quick Workflow

```bash
# Start
@observation profile
@reminders list

# Work
"Build user login"  (via OpenCode or CodeXen)

# Save
@library save architecture login-flow "Login flow using JWT"
@pm log "login bug — missing validation" Medium

# End session
@lru add
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 0.2.0 | 2026-05-12 | Stripped 12 overlapping skills. 7 unique memory skills only. Memory intelligence layer. |
| 0.1.0 | - | Initial release with 19 skills (overlap with CodeXen) |

---

_Last updated: 2026-05-12_
