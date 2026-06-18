# MemCore

![Version](https://img.shields.io/badge/version-1.2.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)

**Memory intelligence layer for [OpenCode CLI](https://opencode.ai)**

Behavioural observation, cross-session reminders, knowledge library, multi-project tracking, self-improvement forge, work plan execution, failure learning, memory consolidation, and goal-driven sessions — all in lightweight markdown + bash.

> Your AI never forgets.

---

## Get Started

```bash
git clone https://github.com/khairulariffinka/memcore.git
cd memcore
```

Then in OpenCode:
```
load install.md
```

Press `TAB` until you see `memcore`.

---

## What It Does

| Capability | How |
|------------|-----|
| **Observation** | Detects language preference, peak hours, agent usage, task completion rate |
| **Reminders** | Set reminders with due dates that persist across sessions |
| **Knowledge Library** | Save/search entries by category (architecture, workflow, database, integration) |
| **LRU Projects** | Track up to 10 active projects with auto-archival |
| **Forge** | Self-improvement — scan codebase, generate new skills (human-in-the-loop) |
| **Work Plan** | Plan-to-execution with per-task tracking |
| **Post-Mortem** | Failure logging with root cause, resolution, prevention |
| **Dream** | Memory consolidation — scan sessions, extract durable knowledge, promote to MEMORY.md |
| **Goal** | Goal-driven sessions with stop conditions and verification checklists |

---

## Architecture

```
memcore/
├── core/
│   ├── agents/
│   │   ├── memcore.md           # Primary orchestrator (mode: primary)
│   │   └── memcore-plan.md      # Read-only planning agent (mode: plan)
│   │
│   ├── skills/                  # 8 skill modules
│   │   ├── observation/         # Behavioural learning (Mulahazah)
│   │   ├── reminders/           # Cross-session reminders
│   │   ├── library-system/      # Knowledge library by category
│   │   ├── lru-projects/        # Multi-project LRU tracking
│   │   ├── forge/               # Self-improvement skill generator
│   │   ├── work-plan/           # Plan-to-execution tracking
│   │   ├── post-mortem/         # Failure learning log
│   │   ├── dream/               # Memory consolidation (MiMo-inspired)
│   │   └── goal/                # Goal-driven sessions with stop conditions
│   │
│   └── opencode.json            # Agent & skill permissions
│
├── docs/                        # Documentation
├── templates/                   # Global memory templates
│   ├── checkpoint.md            # 11-section session state snapshot
│   └── global-memory/
│       ├── current-session.md   # Active session context
│       ├── session-index.md     # Cross-session recall index
│       ├── knowledge-graph.md   # Cross-skill references
│       ├── user-profile.md      # User preferences
│       └── work-diary/          # Session logs
│
├── scripts/                     # Helper scripts
│   ├── budgeted-read.sh         # Token-aware file reading
│   └── validate.sh              # Validation script
│
├── install.md                   # Install instructions
└── update.md                    # Update instructions
```

---

## Agents

| Agent | Mode | Purpose |
|-------|------|---------|
| `memcore` | primary | Full access — edit, bash, skills |
| `memcore-plan` | plan | Read-only — explore, analyze, plan |

---

## Skills

| Skill | Purpose |
|-------|---------|
| `observation` | Detect user patterns, load behavioural profile |
| `reminders` | Set/list/done/edit/clear cross-session reminders |
| `library-system` | Save/search/list/get/delete knowledge by category |
| `lru-projects` | Add/list/switch/remove multi-project LRU tracking |
| `forge` | Scan/create/propose self-improvement skills |
| `work-plan` | Start/next/done/status work plan execution |
| `post-mortem` | Log/edit/list/learn from failures |
| `dream` | Consolidate session knowledge into durable MEMORY.md |
| `goal` | Goal-driven sessions with stop conditions |

---

## Requirements

- [OpenCode CLI](https://opencode.ai)
- bash 4+, standard Linux/macOS tools (`diff`, `grep`, `cp`, `sed`)
- Zero runtime dependencies — no npm, no Docker, no database

---

## License

MIT License

**Version**: 1.2.0
