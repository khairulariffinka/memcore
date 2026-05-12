# MemCore

![Version](https://img.shields.io/badge/version-0.2.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)

**Memory intelligence layer for [OpenCode CLI](https://opencode.ai)**

Behavioural observation, cross-session reminders, knowledge library, multi-project tracking, self-improvement forge, work plan execution, and failure learning — all in lightweight markdown + bash.

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

---

## Architecture

```
memcore/
├── core/
│   ├── agents/
│   │   └── memcore.md        # Primary orchestrator
│   │
│   └── skills/               # 7 skill modules
│       ├── observation/      # Behavioural learning (Mulahazah)
│       ├── reminders/        # Cross-session reminders
│       ├── library-system/   # Knowledge library by category
│       ├── lru-projects/     # Multi-project LRU tracking
│       ├── forge/            # Self-improvement skill generator
│       ├── work-plan/        # Plan-to-execution tracking
│       └── post-mortem/      # Failure learning log
│
├── docs/                     # Documentation
├── templates/                # Global memory templates
├── scripts/                  # Helper scripts
├── install.md                # Install instructions
└── update.md                 # Update instructions
```

---

## Commands

| Subagent | Purpose |
|----------|---------|
| `@observation` / `@observe` | Detect user patterns, load behavioural profile |
| `@reminders` / `@remind` | Set/list/done/clear cross-session reminders |
| `@library` / `@library-system` | Save/search/list knowledge entries by category |
| `@lru` | Add/list/switch multi-project LRU tracking |
| `@forge` | Scan/create/propose self-improvement skills |
| `@plan` | Start/next/done/status work plan execution |
| `@pm` / `@post-mortem` | Log/list/learn from failures |

---

## Requirements

- [OpenCode CLI](https://opencode.ai)
- bash 4+, standard Linux/macOS tools (`diff`, `grep`, `cp`, `sed`)
- Zero runtime dependencies — no npm, no Docker, no database

---

## License

MIT License

**Version**: 0.2.0
