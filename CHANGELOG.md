# Changelog

## [0.2.0] - 2026-05-12

### Changed
- **Refocus**: Stripped 12 overlapping skills, kept 7 unique memory skills
- **Identity**: Memory intelligence layer for OpenCode — complement to CodeXen
- **Core**: Reduced from 5 agents + 19 skills → 1 agent + 7 skills
- **memcore.md**: Updated routing table, session protocol, auto-save workflow
- **README.md**: Reflect new scope and positioning

### Removed
- Agents: planner, research, memory, decision-log
- Skills: planner, research, memory, decision-log, orchestration, init-project,
  setup-profile, save-diary, echo-recall, auto-commit, memory-consolidation,
  session-briefing

### Kept
- Skills: observation, reminders, library-system, lru-projects, forge,
  work-plan, post-mortem

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
