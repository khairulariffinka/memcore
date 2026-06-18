# MemCore

![Version](https://img.shields.io/badge/version-2.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)

**Memory intelligence layer for [OpenCode CLI](https://opencode.ai)**

5 skills. Memory, reminders, work, improve, compress. Your AI never forgets. And talks less.

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

| Skill | What It Does |
|-------|-------------|
| **memory** | Observe user patterns, store knowledge, consolidate session memory |
| **reminders** | Cross-session reminders with due dates |
| **work** | Execute plans, track progress, set goals with stop conditions |
| **improve** | Learn from failures, scan codebase for patterns |
| **compress** | Cut ~75% output tokens, compress memory files ~46% |

---

## Architecture

```
memcore/
├── core/
│   ├── agents/
│   │   ├── memcore.md           # Primary (mode: primary)
│   │   └── memcore-plan.md      # Read-only (mode: plan)
│   │
│   ├── skills/                  # 5 skills
│   │   ├── memory/              # Patterns + knowledge + consolidation
│   │   ├── reminders/           # Cross-session reminders
│   │   ├── work/                # Plan execution + goals
│   │   ├── improve/             # Failures + self-improvement
│   │   └── compress/            # Token compression
│   │
│   └── opencode.json            # Agent & skill permissions
│
├── templates/                   # Global memory templates
├── scripts/                     # Helper scripts
├── install.md                   # Install instructions
└── update.md                    # Update instructions
```

---

## Skills

| Skill | Commands |
|-------|----------|
| `memory` | `observe`, `profile`, `save`, `search`, `list`, `get`, `delete`, `dream` |
| `reminders` | `set`, `list`, `done`, `edit`, `clear` |
| `work` | `start`, `next`, `done`, `status`, `goal set/status/check/stop/clear` |
| `improve` | `log`, `edit`, `list`, `lessons`, `delete`, `scan`, `create` |
| `compress` | `lite`, `full`, `ultra`, `off`, `file <filepath>` |

---

## Requirements

- [OpenCode CLI](https://opencode.ai)
- bash 4+, standard Linux/macOS tools
- Zero runtime dependencies

---

## License

MIT License

**Version**: 2.0.0
