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

Comprehensive guide to using all 5 core agents and 19 skills in MemCore.

---

## Table of Contents

### Getting Started
1. [Primary Agent](#primary-agent) — How to use the main agent
2. [Session Lifecycle](#session-lifecycle) — Start, work, save

### Skills & Agents
3. [Planner](#planner) — Task breakdown & estimation
4. [Memory](#memory) — Context, diary, recall
5. [Research](#research) — Codebase analysis
6. [Decision Log](#decision-log) — Design decisions
7. [Save Diary](#save-diary) — Structured session diary
8. [Library System](#library-system) — Knowledge library
9. [Observation](#observation) — Behavioural learning
10. [Reminders](#reminders) — Cross-session reminders
11. [Memory Consolidation](#memory-consolidation) — Compression & audit
12. [Work Plan](#work-plan) — Plan execution tracking
13. [Auto-Commit](#auto-commit) — Git commits
14. [LRU Projects](#lru-projects) — Multi-project tracking

---

## Primary Agent

The **Primary Agent** (`memcore`) is your main orchestrator. It routes tasks to the right agent or skill, manages session lifecycle, and coordinates workflows.

### How to Activate

Press `TAB` until you see `memcore`, then give your task:

```
@memory, save session
@planner, break down auth feature
@research, analyze codebase
```

### Session Start

When a session starts, MemCore automatically:

1. Reads project context (VERSION.yaml)
2. Loads global memory (user profile, past sessions)
3. Checks pending reminders
4. Shows memory health status
5. Loads behavioural profile

---

## Session Lifecycle

### Start
```
opencode
→ Auto-brief: shows active tasks, pending reminders, memory health
```

### Work
```
@planner, create plan for feature X
@research, find existing patterns
@decision-log, log architecture choice
@plan start feature-x      → Begin execution
@plan done "implemented"   → Mark task complete
@commit save "feat: x"     → Commit changes
@library save architecture decision-log "Why we chose X"
```

### End
When you say `bye`, `done`, `selesai`, or `keluar`:

1. `@diary save <focus>` — Save structured diary
2. `@observation observe` — Update behavioural profile
3. `@remind list` — Check pending reminders
4. `@commit save <summary>` — Commit if changes exist
5. `@lru add` — Update project tracking

---

## Planner

### What It Does

The `planner` creates hierarchical task breakdowns with risk assessment, dependency tracking, and effort estimation.

**Features:**
| Feature | Description |
|---------|-------------|
| **Hierarchical Planning** | Milestones → Epics → Stories → Tasks |
| **Risk Assessment** | Risk level, impact, mitigation |
| **Dependency Tracking** | Task dependencies and blockers |
| **Effort Estimation** | Time estimates based on complexity |
| **Parallel Grouping** | Identify tasks that can run simultaneously |

### Usage

```
@planner, create a plan for building an e-commerce checkout
```

```
@planner, break down the user authentication feature into tasks
```

### Example Output

```
# Project Plan: User Authentication

## Overview
- Goal: Implement complete user auth system
- Total Tasks: 8
- Parallel Groups: 2

## Milestones
### Milestone 1: Foundation
- [ ] Task AUTH-001: Create User model
- [ ] Task AUTH-002: Create database migration

### Milestone 2: Authentication
- [ ] Task AUTH-003: Create registration API
- [ ] Task AUTH-004: Create login API

## Parallel Groups
### Group 1 (Can start immediately)
- AUTH-001, AUTH-002

### Group 2 (Depends on Group 1)
- AUTH-003, AUTH-004
```

---

## Memory

### What It Does

The `memory` agent maintains context across sessions — keyword search, decision tracking, file relationship maps, and cross-project context.

**Features:**
| Feature | Description |
|---------|-------------|
| **Keyword Search** | Search by tags, keywords, file names |
| **Decision Tracking** | Log why decisions were made |
| **Cross-Project Context** | Reuse patterns from other projects |
| **Pattern Documentation** | Document recurring implementation patterns |
| **Session Briefing** | Auto-brief on session start |

### Usage

```
@memory, what decisions were made about authentication?
```

```
@memory, show me similar implementations of payment integration
```

### Example Output

```
[MEMORY LOADED]

Project: MyApp
Tech Stack: Laravel 11 + React + MySQL

Active Decisions:
- DEC-001: Using JWT authentication (2024-01-15)
- DEC-003: Repository pattern (2024-01-10)

Relevant Patterns:
- API Resource Pattern (used 8 times)
- Repository Pattern (active)

Similar Past Work:
- Session 2024-01-15: User authentication
```

### Memory Consolidation

Compress old sessions to save tokens:

```
@consolidate compress light     # 30-50% savings
@consolidate compress medium    # 50-70% savings
@consolidate compress full      # 70-80% savings
```

### Echo Recall

Search past sessions by keyword:

```
@memory, search JWT
@memory, search PostgreSQL
@memory, recent
```

---

## Research

### What It Does

The `research` agent analyzes the codebase to understand existing patterns, tech stack, and context.

**Research Areas:**
| Area | Details |
|------|---------|
| **Tech Stack** | Framework, language, database, API style |
| **Project Structure** | Directory layout, key files |
| **Existing Patterns** | Code organisation, conventions |
| **Similar Implementations** | Find reusable components |

### Usage

```
@research, analyze the current project structure
```

```
@research, find how authentication is implemented
```

### Example Output

```
# Research: New Feature Implementation

## Tech Stack Detected
- Framework: Express.js
- Language: TypeScript
- Database: PostgreSQL
- API: REST

## Relevant Files
| File | Purpose |
|------|---------|
| src/models/User.ts | User model |
| src/routes/auth.ts | Auth routes |

## Existing Patterns
- Validation: express-validator
- Auth: JWT with refresh tokens

## Recommendations
- Use existing JWT pattern from auth module
```

---

## Decision Log

### What It Does

The `decision-log` agent tracks design decisions with full context and rationale.

**Purpose:**
- Capture design decisions during development
- Document context and constraints
- Record options considered and trade-offs
- Link related decisions

### Usage

```
@decision-log, log the decision to use PostgreSQL over MongoDB
```

```
@decision-log, record the JWT vs Session authentication decision
```

### Example Format

```
## Decision: DEC-2026-001

**Date:** 2026-03-11
**Context:** Need authentication for API-first app

### Options Considered
| Option | Pros | Cons |
|--------|------|------|
| JWT | Scalable, stateless | Harder to revoke |
| Sessions | Easy to revoke | Not scalable |

### Decision
**Chosen:** JWT with refresh tokens

### Rationale
- API-first architecture
- Mobile app integration planned
```

---

## Save Diary

### What It Does

Saves structured session diaries with tasks, decisions, files, and git context.

### Usage

```
@diary save "implemented auth"     → Auto-save with focus
@diary list                         → Show recent sessions
@diary view 1                       → View session #1
```

### Auto-Detected on Save

- **Tasks completed/pending** — from planner.md
- **Decisions made** — from DECISIONS.md
- **Files changed** — from git diff
- **Session notes** — from global RAM

---

## Library System

### What It Does

Knowledge repository organised by categories — save and recall information.

### Categories

| Category | Description |
|----------|-------------|
| **architecture** | System design, patterns, tech decisions |
| **workflow** | Processes, pipelines, automations |
| **database** | Schema, queries, migrations |
| **integration** | API contracts, third-party services |

### Usage

```
@library save architecture api-design "We chose REST over GraphQL because..."
@library search JWT
@library list architecture
@library get architecture api-design
```

---

## Observation

### What It Does

Behavioural learning — tracks your patterns and adjusts to your working style.

### Observed Dimensions

| Dimension | What It Tracks |
|-----------|----------------|
| **Session Length** | Average session duration |
| **Task Completion** | Completion rate per session |
| **Language Mix** | Malay vs English usage ratio |
| **Peak Hours** | Time of day with most activity |
| **Agent Usage** | Most-used subagents |

### Usage

```
@observation observe     → Analyse session diary for patterns
@observation profile     → Show current behavioural profile
@observation suggest     → Show suggestions based on patterns
```

---

## Reminders

### What It Does

Cross-session reminders with due dates that persist until completed.

### Usage

```
@remind set next-session "Check deployment config"
@remind set tomorrow "Review PR #42"
@remind set 2026-06-01 "Renew SSL certificate"
@remind list
@remind done REM-001
@remind clear
```

---

## Memory Consolidation

### What It Does

Advanced memory management — compress session history, patch planner tasks, and run full memory audit.

### Usage

```
@consolidate compress light      → Summarise sessions older than 10
@consolidate compress medium     → Keep only last 5 sessions
@consolidate compress full       → Keep only last 2 + decisions
@consolidate patch               → Sync planner consistency
@consolidate analyze             → Full memory audit
@consolidate status              → Quick memory health check
```

---

## Work Plan

### What It Does

Plan-to-execution tracking with per-task auto-commit.

### Usage

```
@plan start feature-auth     → Load/create plan, start first task
@plan next                   → Show next pending task
@plan done "implemented"     → Mark current task done, auto-commit
@plan status                 → Show plan progress
```

### Example

```
User: @plan start feature-auth

MemCore:
=== Plan: feature-auth ===
Current task: Create User model with migration

 1. Create User model with migration
 2. Implement registration API
 3. Implement login API
 4. Add JWT middleware
 5. Write tests

User: (implements the model)
User: @plan done "created User model"

MemCore:
✓ Task done: Create User model with migration
✓ Committed: "feat: create User model with migration"
Next up: Implement registration API
```

---

## Auto-Commit

### What It Does

Structured git commits with session context — auto-stage, auto-generate message.

### Usage

```
@commit save "implemented auth"      → Stage all + commit with message
@commit save                          → Commit with date-based message
@commit status                        → Show git status with diary context
@commit log 5                         → Show last 5 commits
```

---

## LRU Projects

### What It Does

Multi-project tracking with LRU eviction — 10 active slots, auto-archival.

### Usage

```
@lru add memcore               → Register current directory
@lru list                       → Show active + archived projects
@lru switch other-project       → Switch to another tracked project
@lru remove old-project         → Remove from tracking
@lru status                     → Show project activity summary
```

---

## Summary Table

| # | Agent / Skill | Category | Purpose |
|---|--------------|----------|---------|
| 1 | memcore | Primary | Task orchestration, session lifecycle |
| 2 | planner | Agent | Task breakdown, planning |
| 3 | research | Agent | Codebase analysis |
| 4 | memory | Agent | Context, search, diary, recall |
| 5 | decision-log | Agent | Design decisions |
| 6 | @save-diary / @diary | Skill | Structured session diary |
| 7 | @library-system / @library | Skill | Knowledge library |
| 8 | @observation | Skill | Behavioural learning |
| 9 | @reminders | Skill | Cross-session reminders |
| 10 | @consolidate | Skill | Memory compression & audit |
| 11 | @plan | Skill | Work plan execution |
| 12 | @commit | Skill | Git commits with context |
| 13 | @lru | Skill | Multi-project tracking |
| 14 | @forge | Skill | Self-improvement skill generation |
| 15 | @pm | Skill | Post-mortem failure logging |
| 16 | @init-project | Skill | Project scaffolding |
| 17 | @setup-profile | Skill | User profile wizard |

---

## Quick Reference

### Start a session
```
@memory, what's my current status?
@remind list
```

### Plan and execute
```
@planner, break down feature X
@plan start feature-x
@plan done "implemented task"
@plan status
```

### Save knowledge
```
@diary save "what I did"
@library save architecture x "notes"
@decision-log, log the choice
```

### End session
```
bye / done / selesai / keluar
→ diary saved → observation updated → reminders checked → project tracked
```

---

## Common Workflows

### Daily Session
```
1. Start opencode
2. @remind list          → Check pending reminders
3. @consolidate status   → Quick memory health check
4. Work on tasks
5. @diary save <focus>   → Save before ending
6. bye                   → Auto-save, commit, track
```

### Research → Plan → Execute
```
1. @research, analyze codebase
2. @planner, create implementation plan
3. @plan start <name>
4. @plan done "message" (repeat for each task)
5. @commit save "summary"
```

### Log a Decision
```
1. @decision-log, log the decision
2. @library save architecture decision-name "details"
3. @diary save "logged decision about X"
```

---

*For more details, see agent documentation in `core/agents/*.md` and skill documentation in `core/skills/*/SKILL.md`*
