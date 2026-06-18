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

MemCore — memory intelligence layer with 9 focused skills.

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
11. [Dream](#dream) — Memory consolidation
12. [Goal](#goal) — Goal-driven sessions

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
observation observe
```

---

## Session Lifecycle

### Start Session

When you start a session, the following happens:

1. MemCore loads its configuration
2. You can check pending reminders: `reminders list`
3. You can load behavioural profile: `observation profile`

### During Session

Use any of the 9 skills as needed.

### End Session

When you say "bye", "done", "selesai", or "keluar":

1. Behavioural profile updates via `observation observe`
2. Pending reminders shown via `reminders list`
3. Project tracking updates via `lru-projects add`
4. Session knowledge consolidated via `dream`
5. Session summary saved

---

## Basic Usage

### First Session

```bash
# Observe your patterns
observation observe

# Set a reminder
reminders set tomorrow "Review PR"

# Save knowledge
library-system save architecture api-design "RESTful API design patterns"

# Track this project
lru-projects add
```

---

## Observation

**Skill:** `observation`

Tracks your behavioural patterns across sessions:

| Command | Description |
|---------|-------------|
| `observation observe` | Analyse session diary & planner for user patterns |
| `observation profile` | Show current observed user profile |
| `observation suggest` | Suggest adjustments based on observed patterns |
| `observation reset` | Reset behavioural data |

### What It Tracks

| Dimension | What It Detects |
|-----------|----------------|
| Language | Malay vs English usage ratio |
| Peak Hours | Time of day with most activity |
| Completion Rate | How often tasks are completed |
| Agent Preference | Most-used subagents |
| Session Length | Average session duration |
| Error Frequency | Common failure patterns |

### Example

```
User: observation observe
AI:   Observing 12 sessions...
      ✓ Language: Malay (preferred)
      ✓ Peak hours: 10:00
      ✓ Completion rate: 75%
      ✓ Profile updated.
```

---

## Reminders

**Skill:** `reminders`

Cross-session reminders with due dates and persistence.

| Command | Description |
|---------|-------------|
| `reminders set <due> <message>` | Set a new reminder |
| `reminders list` | Show all pending reminders |
| `reminders done <id>` | Mark reminder complete |
| `reminders edit <id> <due> <message>` | Edit an existing reminder |
| `reminders clear` | Clear all completed reminders |

Due options: `next-session`, `tomorrow`, `YYYY-MM-DD`

### Example

```
User: reminders set next-session "Check deployment status"
AI:   Reminder set: REM-001 — "Check deployment status" (due: next-session)

--- Next session ---
User: reminders list
AI:   ⚠️ Due reminders:
      REM-001 — "Check deployment status" (due: next-session)

User: reminders edit REM-001 tomorrow "Updated deployment check"
AI:   Reminder REM-001 updated: "Updated deployment check" (due: tomorrow)
```

---

## Library System

**Skill:** `library-system`

Organised knowledge library with categorised entries.

| Command | Description |
|---------|-------------|
| `library-system save <category> <name> [content]` | Save a knowledge entry |
| `library-system search <keyword>` | Search entries by keyword |
| `library-system list [category]` | List entries (by category or all) |
| `library-system get <category> <name>` | Read a specific entry |
| `library-system delete <category> <name>` | Delete an entry |

### Categories

| Category | Use For |
|----------|---------|
| **architecture** | System design, patterns, tech decisions |
| **workflow** | Processes, pipelines, automations |
| **database** | Schema, queries, migrations |
| **integration** | API contracts, third-party services |

### Example

```
User: library-system save architecture repository-pattern "Repository pattern with Laravel:
      - Interface + Implementation
      - Dependency injection via constructor
      - Unit test with mocks"

AI:   Entry saved: LIB-2026-001 → docs/library/architecture/repository-pattern.md

User: library-system search repository
AI:   LIB-2026-001 — Repository Pattern (architecture)

User: library-system delete architecture repository-pattern
AI:   Deleted: architecture/repository-pattern
```

---

## LRU Projects

**Skill:** `lru-projects`

Multi-project management with LRU eviction — 10 active slots, auto-archival.

| Command | Description |
|---------|-------------|
| `lru-projects add [name]` | Register current project |
| `lru-projects list` | List all tracked projects (active + archived) |
| `lru-projects switch <name>` | Switch to another project |
| `lru-projects remove <name>` | Remove a project |
| `lru-projects status` | Show project activity summary |

### Example

```
User: lru-projects add
AI:   Project added: memcore (active: 1/10)

User: lru-projects list
AI:   === Active Projects ===
      1 | memcore | 2026-05-12 | 5 sessions
      === Archived ===
      old-project | 2026-04-01 | 12 sessions

User: lru-projects switch memcore
AI:   Switched to: memcore (/path/to/memcore)
```

---

## Forge

**Skill:** `forge`

Self-improvement system — scan codebase, detect patterns, generate new skills.

| Command | Description |
|---------|-------------|
| `forge scan` | Analyse codebase for improvement patterns |
| `forge create <name> <desc>` | Generate a new skill from template |
| `forge propose` | Show improvement proposals |
| `forge list` | List all forged skills |

### Example

```
User: forge scan
AI:   === Forge Scan ===
      Date: 2026-06-18
      Existing skills: 9

      --- Code Complexity ---
      Total lines: 1247

      --- Duplicate Patterns ---
      Skills using $1 dispatch: 9/9
      Missing validation: 2
      Missing --force: 3

      --- Summary ---
      Issues found: 5
      Proposals saved to docs/forge/proposals.md

User: forge create api-tester "Auto-test API endpoints"
AI:   ✓ Skill forged: core/skills/api-tester/SKILL.md
      Template includes:
        - --force flag support
        - Input validation
        - Error handling
        - Usage messages
```

---

## Work Plan

**Skill:** `work-plan`

Plan-to-execution tracking with per-task progress, integrated with git.

| Command | Description |
|---------|-------------|
| `work-plan start <name>` | Start working on a plan |
| `work-plan next` | Show next pending task |
| `work-plan done [message]` | Mark task done (optional git commit) |
| `work-plan status` | Show plan progress |

### Example

```
User: work-plan start refactor-auth
AI:   === Plan: refactor-auth ===
      Current task (line 3): Update login controller

User: work-plan done "Refactored login controller"
AI:   ✓ Task done: Update login controller
      Committed: Update login controller
      Next up: Add input validation

User: work-plan status
AI:   === Work Plan Status ===
      Active plan: refactor-auth
      Progress: [████░░░░░░░░░░░░░░░░] 2/5 (40%)
```

---

## Post-Mortem

**Skill:** `post-mortem`

Failure learning log — record errors, root causes, and prevention.

| Command | Description |
|---------|-------------|
| `post-mortem log <title> [severity] [--symptoms "..."] [--cause "..."] [--resolution "..."] [--lesson "..."] [--prevention "..."]` | Log a new failure |
| `post-mortem edit <id> <section> <content>` | Update a section |
| `post-mortem list` | List all post-mortems |
| `post-mortem lessons` | Show lessons learned |
| `post-mortem delete <id>` | Delete a post-mortem |

Severity: `Critical`, `High`, `Medium` (default), `Low`
Sections: `symptoms`, `cause`, `resolution`, `lesson`, `prevention`

### Example

```
User: post-mortem log "Migration failed after deploy" High \
      --symptoms "500 error on user table" \
      --cause "Missing column in migration" \
      --resolution "Added missing column" \
      --lesson "Always verify migration locally" \
      --prevention "Add migration test to CI"

AI:   Post-mortem created: PM-2026-06-18-001

User: post-mortem edit PM-2026-06-18-001 cause "Migration script missing 'avatar' column"
AI:   Updated PM-2026-06-18-001.cause

User: post-mortem lessons
AI:   ## PM-2026-06-18-001: Migration failed after deploy
      ### Lesson Learned
      Always verify migration locally
```

---

## Dream

**Skill:** `dream`

Memory consolidation — scan sessions, extract durable knowledge, promote to MEMORY.md.

| Command | Description |
|---------|-------------|
| `dream dream` | Run consolidation process |
| `dream list` | Show consolidated knowledge |
| `dream search <keyword>` | Search MEMORY.md entries |

### How It Works

1. Scans session-diary.md for completed sessions
2. Extracts durable knowledge (decisions, patterns, corrections)
3. Deduplicates against existing MEMORY.md entries
4. Promotes new knowledge with metadata
5. Discovers cross-session patterns

### Example

```
User: dream dream
AI:   🌙 Dream consolidation...
      Sessions scanned: 5
      Durable knowledge: 3 entries
      ✅ Promoted to MEMORY.md:
         - Auth pattern: Use JWT with refresh token
         - User prefers Malay for casual conversation
         - Never deploy on Friday afternoon
      📊 Patterns discovered: 1
         - Peak productivity 10:00-12:00
```

---

## Goal

**Skill:** `goal`

Goal-driven sessions with stop conditions — prevents premature stops.

| Command | Description |
|---------|-------------|
| `goal set <goal> [verification]` | Set session goal |
| `goal status` | Show goal and progress |
| `goal check` | Verify if goal met (run verifiers) |
| `goal stop` | Mark goal as complete |
| `goal clear` | Clear goal without completing |

### Why Use Goals?

Without goals, agents may stop prematurely when they think they're done. Goals enforce verification.

### Example

```
User: goal set "All tests passing" "npm test returns 0"
AI:   🎯 Goal set: All tests passing
      Verification: npm test returns 0

# ... work happens ...

User: goal check
AI:   🔍 Verifying: npm test returns 0
      ❌ FAIL: 3 tests failing
      📋 Remaining:
         - Test 1: auth.test.js
         - Test 2: user.test.js

# ... more work ...

User: goal check
AI:   🔍 Verifying: npm test returns 0
      ✅ PASS: All tests green
      🎉 Goal achieved!

User: goal stop
AI:   Session complete: All tests passing
```

---

## Quick Reference

### All Commands

| Skill | Command | Description |
|-------|---------|-------------|
| `observation` | `observe` | Analyse patterns |
| | `profile` | Show behavioural profile |
| | `suggest` | Get improvement suggestions |
| | `reset` | Reset behavioural data |
| `reminders` | `set <due> <msg>` | Set reminder |
| | `list` | List pending reminders |
| | `done <id>` | Mark complete |
| | `edit <id> <due> <msg>` | Edit reminder |
| | `clear` | Clear completed |
| `library-system` | `save <cat> <name> <content>` | Save knowledge |
| | `search <keyword>` | Search entries |
| | `list [category]` | List entries |
| | `get <cat> <name>` | Read entry |
| | `delete <cat> <name>` | Delete entry |
| `lru-projects` | `add [name]` | Track project |
| | `list` | Show projects |
| | `switch <name>` | Change project |
| | `remove <name>` | Remove project |
| | `status` | Project summary |
| `forge` | `scan` | Analyse patterns |
| | `create <name> <desc>` | Generate skill |
| | `propose` | Show proposals |
| | `list` | List forged skills |
| `work-plan` | `start <name>` | Begin plan |
| | `next` | Next task |
| | `done [msg]` | Complete task |
| | `status` | Progress report |
| `post-mortem` | `log <title> [sev] [--flags]` | Log failure |
| | `edit <id> <section> <content>` | Update section |
| | `list` | List failures |
| | `lessons` | Show lessons |
| | `delete <id>` | Delete entry |
| `dream` | `dream` | Consolidate memory |
| | `list` | Show consolidated knowledge |
| | `search <keyword>` | Search MEMORY.md |
| `goal` | `set <goal> [verification]` | Set goal |
| | `status` | Show progress |
| | `check` | Verify completion |
| | `stop` | Mark complete |
| | `clear` | Clear goal |

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

### Quick Workflow

```bash
# Start
observation profile
reminders list

# Work
Build your app with OpenCode

# Save
library-system save architecture login-flow "Login flow using JWT"
post-mortem log "login bug — missing validation" Medium

# Consolidate
dream dream

# End session
lru-projects add
```

### Use Goals for Complex Tasks

For tasks with clear completion criteria:

```bash
# Set goal with verification
goal set "API endpoint works" "curl -s localhost:8080/health returns 200"

# Work until verified
# ... code code code ...

# Check
goal check
# ✅ PASS → goal stop
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.2.0 | 2026-06-18 | Added dream skill, goal skill, budgeted-read, checkpoint template, context reconstruction |
| 1.1.0 | 2026-06-18 | Added plan agent, permission system, session index, knowledge graph, new commands |
| 1.0.0 | 2026-05-12 | First stable release. Memory intelligence layer — 7 skills, fully standalone. |
| 0.1.0 | - | Initial release with 19 skills |

---

_Last updated: 2026-06-18_
