# Changelog

## [1.3.0] - 2026-06-18

### Added
- **compress skill** — Token compression: cut ~75% output tokens (lite/full/ultra modes)
- **compress-file skill** — Memory file compression: rewrite files to terse format (~46% savings)

### Changed
- **memcore.md** — Added compress skills to routing table
- **README.md** — Updated to v1.3.0 with compress skills
- **TUTORIALS.md** — Added compress and compress-file tutorials
- **VERSION.yaml** — Updated to v1.3.0 with new skills

## [1.2.0] - 2026-06-18

### Added
- **dream skill** — Memory consolidation: scan sessions, extract durable knowledge, promote to MEMORY.md
- **goal skill** — Goal-driven sessions with stop conditions and verification checklists
- **budgeted-read.sh** — Token-aware file reading with section-aware truncation
- **checkpoint.md** — 11-section session state snapshot (MiMo-Code inspired)
- **Context reconstruction protocol** — Structured approach to rebuild context from checkpoint

### Changed
- **memcore.md** — Added context reconstruction protocol section
- **Session auto-save** — Now includes dream consolidation step
- **VERSION.yaml** — Updated to v1.2.0 with new skills and features

## [1.1.0] - 2026-06-18

### Added
- **memcore-plan agent** — Read-only planning agent (mode: plan) for safe codebase exploration
- **Permission system** — opencode.json now configures bash: ask for safety
- **Session index** — Cross-session recall index for quick search
- **Knowledge graph** — Cross-skill references (observation ↔ post-mortem ↔ library)
- **Post-mortem edit** — Update sections after creation
- **Post-mortem arguments** — Add details inline: --symptoms, --cause, --resolution, --lesson, --prevention
- **Library delete** — Remove knowledge entries
- **Remind edit** — Edit existing reminders
- **Input validation** — Pipe character validation for lru, reminders, work-plan
- **--force flag** — Non-interactive execution for forge, library, observation

### Fixed
- **Skill aliases** — All references now use exact registered skill names
- **Session count corruption** — LRU switch preserves session count
- **Post-mortem ID collision** — Auto-increment IDs for same-day entries
- **Forge sed portability** — Replaced GNU sed with portable awk
- **Non-interactive hangs** — Added --force flag to prevent read -r hangs
- **Stale documentation** — Updated agent/skill counts across all files

### Changed
- **Bash permission** — Changed from allow to ask for safety
- **Forge scan** — Now does real code pattern analysis (complexity, validation, dependencies)
- **Forge create** — Generates useful template with --force, validation, error handling
- **Observation** — Now analyzes post-mortem data for error frequency
- **Grep optimization** — Language detection from 13 calls to 2 calls

### Improved
- **opencode.json** — Added permission block, skill permissions, plan agent config
- **Validation script** — Updated for 2 agents, added plan agent permission check
- **Memory templates** — Added session-index.md, knowledge-graph.md, improved current-session.md

## [1.0.0] - 2026-05-12

### Refocus
- **Identity**: Memory intelligence layer for OpenCode — fully standalone
- **Core**: Reduced from 5 agents + 19 skills → 1 agent + 7 skills
- Stripped 12 overlapping skills (planner, research, memory, decision-log,
  orchestration, init-project, setup-profile, save-diary, echo-recall,
  auto-commit, memory-consolidation, session-briefing)
- Stripped 4 overlapping agents (planner, research, memory, decision-log)

### Polish
- Removed all external dependencies from remaining 7 skills
- Fixed observation skill — now reads from session diary, not planner.md
- Fixed work-plan skill — standalone plan files, no planner.md dependency
- Fixed forge skill — removed references to deleted memory/save-diary skills
- Rewrote TUTORIALS.md — 587 lines → clean 7-skill focused guide
- Updated memcore.md routing, session protocol, auto-save workflow
- All docs, config, and install files updated for new scope
- Zero broken references — fully standalone

## [0.1.0] - 2026-05-11

### Added
- Initial release of MemCore — Memory-focused AI agent system for OpenCode CLI

### Agents
- `memcore` — Primary orchestrator with routing, guardrails, self-healing
- `planner` — Task breakdown, estimation, dependency tracking
- `research` — Codebase analysis, pattern matching
- `memory` — Session persistence, keyword search, context management
- `decision-log` — Design decision tracking with rationale

### Skills
- `orchestration` — Central workflow, self-healing, parallel execution
- `planner` — Task planning logic
- `research` — Codebase analysis methodology
- `memory` — Session persistence, global diary format
- `decision-log` — Decision format and tracking
- `auto-commit` — Structured git commits with session context
- `echo-recall` — Keyword recall from global memory
- `forge` — Self-improvement pattern scanning and skill generation
- `init-project` — New project scaffolding
- `library-system` — Knowledge library with 4 categories
- `lru-projects` — Multi-project LRU tracking (10 active slots)
- `memory-consolidation` — Session diary compression and memory audit
- `observation` — Behavioral learning and profiling
- `post-mortem` — Failure analysis and logging
- `reminders` — Cross-session reminders with due dates
- `save-diary` — Structured session diary saving
- `session-briefing` — Session start brief
- `setup-profile` — User profile wizard
- `work-plan` — Task execution plan management
