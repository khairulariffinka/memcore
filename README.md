# MemCore

![Version](https://img.shields.io/badge/version-0.1.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)

**Memory-focused AI agent system for [OpenCode CLI](https://opencode.ai)**

Persistent memory, session diary, behaviour observation, reminders, knowledge library, and task orchestration — all in zero-dependency Markdown + bash.

---

## Get Started

```
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
| **Session diary** | Structured diary with tasks, decisions, files — auto-saved on exit |
| **Knowledge library** | Save/search entries by category (architecture, workflow, database, integration) |
| **Behaviour observation** | Detects language preference, peak hours, agent usage, task completion rate |
| **Cross-session reminders** | Set reminders with due dates that persist across sessions |
| **Memory consolidation** | Compress diary, patch planner, full memory audit |
| **Work plan execution** | Track plan-to-execution with per-task auto-commit |
| **Multi-project LRU** | Track up to 10 active projects with auto-archival |
| **Self-improvement forge** | Scan codebase for patterns, generate new skills (human-in-the-loop) |
| **Echo recall** | Search past sessions by keyword |
| **Session briefing** | Auto-brief on session start — active tasks, pending reminders, memory health |
| **Post-mortem** | Failure logging with root cause, resolution, prevention |

---

## Architecture

```
memcore/
├── core/
│   ├── agents/               # 5 active agents
│   │   ├── memcore.md        # Primary orchestrator
│   │   ├── memory.md         # Session persistence & recall
│   │   ├── planner.md        # Task breakdown & estimation
│   │   ├── research.md       # Codebase analysis
│   │   └── decision-log.md   # Architecture decision tracking
│   │

│   └── skills/               # 19 skill modules
│       ├── auto-commit/      # Structured git commits
│       ├── decision-log/     # Decision tracking
│       ├── echo-recall/      # Memory search
│       ├── forge/            # Self-improvement
│       ├── init-project/     # Project scaffolding
│       ├── library-system/   # Knowledge library
│       ├── lru-projects/     # Multi-project tracking
│       ├── memory/           # Core memory logic
│       ├── memory-consolidation/ # Compression & patch
│       ├── observation/      # Behavioural learning
│       ├── orchestration/    # Self-healing, parallel execution
│       ├── planner/          # Task planning logic
│       ├── post-mortem/      # Failure logging
│       ├── reminders/        # Cross-session reminders
│       ├── research/         # Pattern analysis
│       ├── save-diary/       # Structured session diary
│       ├── session-briefing/ # Start-up brief
│       ├── setup-profile/    # User profile
│       └── work-plan/        # Plan execution tracking
│
├── docs/                     # Architecture, spec chain
├── templates/                # Global memory templates
├── scripts/                  # validate.sh
├── install.md                # Install instructions
└── update.md                 # Update instructions
```

---

## Commands

| Subagent | Purpose |
|----------|---------|
| `@planner` | Task breakdown, estimation, parallel group validation |
| `@research` | Codebase analysis, pattern matching |
| `@memory` | Session save, context load, echo recall, session briefing |
| `@decision-log` | Log architecture decisions with rationale |
| `@library-system` / `@library` | Save/search/list knowledge entries |
| `@save-diary` / `@diary` | Structured session diary with auto-detect |
| `@observation` | Observe user patterns and suggest adjustments |
| `@reminders` | Set/list/done/clear cross-session reminders |
| `@consolidate` | Compress diary, patch planner, memory audit |
| `@plan` | Start/next/done/status for work plan execution |
| `@forge` | Scan/create/propose self-improvement skills |
| `@commit` | Stage all + structured git commit |
| `@lru` | Multi-project LRU tracking |
| `@pm` | Post-mortem failure logging |

---

## Docs

- [Tutorials](TUTORIALS.md)
- [Architecture](docs/ARCHITECTURE.md)

---

## Installation

1. Clone or download this repository
2. In OpenCode: `load install.md`
3. Restart OpenCode, press TAB to select `memcore`

---

## Requirements

- [OpenCode CLI](https://opencode.ai)
- bash 4+, standard Linux/macOS tools (`diff`, `grep`, `cp`, `sed`)
- Zero runtime dependencies — no npm, no Docker, no database

---

## License

MIT License

**Version**: 0.1.0
