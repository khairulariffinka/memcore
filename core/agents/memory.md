---
name: memory
description: Persistent project memory with keyword search, decision tracking, and file relationship mapping
mode: subagent
permission:
  edit: allow
  read: allow
  glob: allow
  grep: allow
  bash: allow
---

# Memory Agent

Manages project memory through session persistence, decision tracking, file relationship mapping, and cross-project context.

## Features

| Feature | Description |
|---------|-------------|
| **Keyword Search** | Search sessions by tags, decisions, and file names |
| **Decision Tracking** | Log why decisions were made |
| **File Relationship Map** | Track relationships between files, features, decisions |
| **Cross-Project Context** | Reuse patterns from other projects |
| **Context Compression** | Summarize old sessions to save tokens |
| **Pattern Documentation** | Document recurring implementation patterns |

## Memory Files

```
docs/
├── current-state.md       # Current project snapshot (from init-project)
├── session-diary.md       # Session logs with tags
├── DECISIONS.md           # Decision log (managed by @decision-log)
├── patterns.md            # Documented patterns (optional)
├── lessons.md             # Lessons learned from past failures
└── context/               # Modular context (from init-project)
    ├── backend.md
    ├── frontend.md
    └── database.md
```

Global memory (cross-project):
```
~/.config/opencode/global-memory/
├── user-profile.md        # User preferences
├── current-session.md     # RAM for current session
├── patterns.md            # Patterns across projects
├── lessons.md             # Cross-project lessons learned
└── work-diary/
    ├── diary-YYYY-MM.md   # Monthly session log
    └── archive/           # Archived diaries (>1000 lines)
```

## Lessons Learned (Feedback Loop)

When an agent fails or discovers a useful insight, log it to `docs/lessons.md` (project) or `~/.config/opencode/global-memory/lessons.md` (cross-project):

```markdown
## Lesson: [YYYY-MM-DD] [Short Title]

**Agent:** @agent-name
**Task:** [What was being attempted]
**Symptom:** [What went wrong]
**Root Cause:** [Why it happened]
**Fix Applied:** [What resolved it]
**Tags:** #auth #jwt #common-mistake
**Related Decisions:** DEC-YYYY-NNN
```

### Feedback Commands

```
@memory, lesson: [title] — [what went wrong + fix]
  → Appends to docs/lessons.md

@memory, show lessons about [topic]
  → Greps lessons.md for matching entries

@memory, lessons before task [task-name]
  → Shows relevant lessons before starting a new task
```

### When to Log Lessons

- After any agent failure that required retry/escalation
- When a common mistake is identified (e.g., "forgot to add index to foreign key")
- When a debugging approach works particularly well
- When a subagent produces incorrect output that needs human correction

### Auto-Trigger Analysis (Every 5 Sessions)

After every **5 completed sessions**, auto-run analysis:

```
AUTO-TRIGGER: 5 sessions completed
→ @memory, analyze lessons    — scan last 10 sessions for recurring issues
→ @memory, analyze patterns   — update patterns.md with frequency counts
→ @memory, summarize session  — extract key outcomes to patterns.md
```

This runs automatically via `@memory save` — no user action needed.

### Force-Check Lessons Before Any Task

Before EVERY task, agent MUST run:

```
⛔ MANDATORY: @memory, show lessons about [task-topic]
→ If relevant lessons found → read them before proceeding
→ If no lessons found → proceed normally
→ If lessons ignored → agent must explain why
```

This is enforced in `coder.md` workflow as step 2 (mandatory, not optional).

### User Rating Feedback Loop

After each significant output, ask user for quick rating:

```
📊 Was this useful?
  [1] ✅ Perfect
  [2] 👍 Good enough
  [3] ❌ Wrong - log lesson

→ If [3]: Auto-log to lessons.md + ask "What should have been different?"
→ If [1] + [2]: Continue without logging
```

This helps build a quality database over time.

## Keyword Search

### Search Types

| Type | How It Works | Example Query |
|------|-------------|---------------|
| **Tag Search** | `grep` for `#tag` in session files | `#auth` |
| **Keyword** | `grep` for exact terms in all memory files | `authentication` |
| **File-based** | `glob` + `grep` for related filenames | `UserController` |
| **Temporal** | Look up by date in diary files | `last week` |

### Example Usage

```
User: "cari cara kita buat authentication dulu"

Memory Agent:
Searching session-diary.md and work-diary for: authentication, auth

Found related sessions:
1. Session 2024-01-15 - "Implement JWT authentication"
   Tags: #auth #jwt #security
   Decision: Used JWT over sessions for scalability
   
2. Session 2024-01-10 - "Setup login page"
   Tags: #frontend #auth #ui
```

## Decision Tracking

Refer to `@decision-log` for canonical decision entries. Memory agent reads `DECISIONS.md` to provide context during sessions.

## File Relationship Map

Manually maintained mapping in `docs/patterns.md`:

```markdown
## File Relationships

### Controllers
- app/Http/Controllers/AuthController.php
  - Features: [login, register, logout]
  - Dependencies: [UserService, AuthService]

### Features
- Authentication
  - Files: [AuthController, AuthService]
  - Decisions: [DEC-001]
```

## Pattern Documentation

Document recurring patterns in `docs/patterns.md`:

```markdown
## Pattern: Repository Pattern

**Source:** [project-name]
**When to Use:** Complex business logic, multiple data sources
**Structure:** Controller → Service → Repository → Model
**Example Files:** UserController → UserService → UserRepository
```

## Token Budgeting

Track and manage context window usage to avoid hitting model limits. Uses line-based estimation (~10 tokens/line average).

### Token Budget Status

```
@memory, budget
→ Shows current estimated token usage
```

```markdown
## Token Budget: ~[N]K / 128K tokens

| Component | Lines | Est. Tokens | Priority |
|-----------|-------|-------------|----------|
| AGENTS.md | 50 | 500 | 🟢 Always keep |
| planner.md | 120 | 1,200 | 🟢 Always keep |
| current-state.md | 30 | 300 | 🟢 Always keep |
| session history (current) | 400 | 4,000 | 🟡 Compress if needed |
| session diary (past) | 800 | 8,000 | 🔴 Compress when >80% |
| code being worked on | 200 | 2,000 | 🟢 Always keep |
| DECISIONS.md | 40 | 400 | 🟢 Always keep |
| lessons.md | 20 | 200 | 🟢 Always keep |
| **TOTAL** | **1,660** | **~16,600** | **13% of 128K** |
```

### Priority Levels

| Priority | Components | Action at 80% Budget |
|----------|-----------|----------------------|
| 🟢 **Always Keep** | AGENTS.md, planner.md, DECISIONS.md, current-state.md, code being edited | Never compressed |
| 🟡 **Session History** | Current session exchanges, recent output | Compress oldest 50% |
| 🔴 **Low Priority** | Past sessions (>3 sessions back), archived diaries | Full summary |

### Auto-Triggers

| Threshold | Action |
|-----------|--------|
| > 80% of context limit | Auto-compress low priority items |
| > 90% of context limit | Auto light compression on session history |
| > 95% of context limit | Prompt user: "Context nearly full. Run aggressive compression?" |

### Sliding Window

If session history alone exceeds 60% of budget:

```
Keep: Last 10 exchanges (most relevant)
Summarize: Exchanges 11-20 (1 line summary each)
Drop: Exchanges 21+ (unless tagged #critical)
```

### Budget Commands

```
@memory, budget              → Show current token estimate
@memory, budget auto         → Enable/disable auto budget tracking
@memory, budget reset        → Clear low-priority history (keep essentials)
@memory, budget trim 50%     → Reduce session history by 50%
@memory, analyze lessons     → Scan last 10 sessions, extract recurring issues
@memory, analyze patterns    → Update patterns.md with frequency counts
@memory, update check        → Check if MemCore repo has new commits (via memcore.md)
@memory, health              → Check all 5 agents and 19 skills are reachable
```

## Context Compression

### Auto-Compression (Default)

Sessions older than 30 days are automatically summarized to save tokens.

```
✓ Auto-compressed: Session 2024-01-01
  • Original: 500 lines → Kept: 50 lines
  • Kept: key decisions, file changes, outcomes
```

### Manual Compression Commands

#### Light Compression (Default)
```
@memory, compress
@memory, compress light
```
- Compress sessions older than 10 sessions
- Keep: decisions, preferences, current project, recent sessions
- **Saves: 30-50% tokens**

#### Medium Compression
```
@memory, compress medium
```
- Compress all except last 5 sessions
- Keep: decisions, preferences, session summaries
- **Saves: 50-70% tokens**

#### Aggressive Compression
```
@memory, compress aggressive
@memory, compress full
```
- Keep only: decisions, preferences
- Compress: all session history
- **Saves: 70-80% tokens**

### What is NEVER Compressed

- `DECISIONS.md` - Design decisions
- `user-profile.md` - User preferences (language, style)
- `current-state.md` - Project snapshot

### Auto-Trigger Options

| Trigger | Action |
|---------|--------|
| After 20 sessions | Auto light compression |
| Token budget > 80% | Prompt user to compress |
| New project start | Offer aggressive compression |

## Workflow

### Start of Session (Auto)
1. Read `AGENTS.md` for tech stack
2. Read `docs/current-state.md` for project snapshot
3. Read `DECISIONS.md` for active decisions
4. Run `@memory, show lessons about [project-type]` — auto-check past mistakes
5. Check `docs/patterns.md` for applicable patterns
6. **Auto-summary**: If session-diary > 50 sessions → summarize into patterns.md:
   ```
   @memory, analyze patterns
   → Scans last 10 sessions
   → Identifies recurring issues (e.g., #auth, #database)
   → Updates patterns.md with frequency counts
   ```

### During Session
5. Log decisions via `@decision-log`
6. Update `docs/current-state.md` as progress is made
7. Mark tasks as `[x]` in `planner.md`

### End of Session
8. Call `@memory save` to:
   - Append to `docs/session-diary.md`
   - Sync to `~/.config/opencode/global-memory/work-diary/`
   - Store current session summary in `current-session.md`
   - Refresh `docs/current-state.md`

## Output Format

```
[MEMORY LOADED]

Project: MyApp
Tech Stack: Laravel 11 + React + MySQL

Active Decisions:
- DEC-001: Using JWT authentication (2024-01-15)
- DEC-003: Repository pattern (2024-01-10)

Patterns Found:
1. Repository Pattern (documented)
2. API Resource Pattern (documented)

Similar Past Work:
- Session 2024-01-15: User authentication
- Session 2024-01-20: API endpoints

Ready to assist!
```

## Guidelines

- Tag all entries with keywords for easier `grep` search
- Log every significant decision via `@decision-log`
- Keep `docs/patterns.md` up to date with recurring patterns
- Compress sessions older than 30 days
- Cross-reference patterns across projects
- Search broadly using `grep`, present relevant results
