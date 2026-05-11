---
name: init-project
description: Initialize new project with Modular Memory, Decision-Log, and Current State - integrates with MemCore
trigger: init project | new project | setup project
---

# Init Project Skill (Modular & State Sync)

---

## Workflow

1. User: "init project"
2. Skill: Auto-create modular folders (`docs/context/`, `docs/decisions/`)
3. Skill: Generate Index `AGENTS.md` and Dashboard `docs/current-state.md`
4. Skill: Initialize `DECISIONS.md` and `planner.md`

---

## Execute

```bash
# 1. Create Folder Structure
mkdir -p docs/context
mkdir -p docs/decisions

# 2. Generate AGENTS.md (As Index)
cat > AGENTS.md << 'AGENTS_EOF'
# Project: PROJECT_NAME

## Tech Stack Index
- **Frontend:** Refer to `docs/context/frontend.md`
- **Backend:** Refer to `docs/context/backend.md`
- **Database:** Refer to `docs/context/database.md`

## Active Decisions
- Refer to `DECISIONS.md` for architectural history.

---
**Last Updated:** DATE
**Status:** INITIALIZED
AGENTS_EOF

# 3. Generate docs/current-state.md (As Dashboard)
cat > docs/current-state.md << 'EOF'
# PROJECT_NAME - Current State

> **Last Updated:** DATE
> **Status:** IN PROGRESS

---

## 🚀 Snapshot Status
| Component | Status | Context Reference |
| :--- | :--- | :--- |
| **Backend** | Initializing | `docs/context/backend.md` |
| **Frontend** | Initializing | `docs/context/frontend.md` |
| **Database** | Initializing | `docs/context/database.md` |

---

## ✅ Implemented Features
- [x] Initial Project Setup (Modular Structure) [Ref: DEC-DATE-001]
- [ ] Base Infrastructure (Pending)

---

## 🛠️ Current Environment
- **Branch:** main
- **Last Commit:** None
- **Active Decision:** DEC-DATE-001

---

**AI Note:** This file will be automatically updated by agents at the end of each session.
EOF

# 4. Generate DECISIONS.md (First Decision Log)
cat > DECISIONS.md << 'EOF'
# Project Decisions

## DEC-DATE-001: Initial Project Setup
**Date:** DATE
**Status:** ✅ ACTIVE

### Context
Initialization of a new project with Modular Context and Current State tracking.

### Impacted Files
- `AGENTS.md`
- `docs/current-state.md`
- `docs/context/`
EOF

# 5. Generate AI-AGENT-PROTOCOL.md ⭐
cat > docs/AI-AGENT-PROTOCOL.md << 'EOF'
# AI Agent Documentation Protocol (Modular Version)

> **Purpose:** Ensure all agents maintain synchronicity between code, decisions, and context.

---

## 🛑 Every Session MUST:

1. **Read Index FIRST**: Start by reading `AGENTS.md` and `docs/current-state.md`.
2. **Load Specific Context**: Only read `docs/context/[module].md` relevant to your task.
3. **Check Decisions**: Before implementing, verify `DECISIONS.md` to avoid using deprecated logic.

## ✅ Every Session End MUST:

1. **Update Current State**: Refresh the snapshot in `docs/current-state.md`.
2. **Log Decisions**: Record any technical choices in `DECISIONS.md` with "Impacted Files".
3. **Mark Progress**: Update `planner.md` status.
4. **Project Log**: Add entry to `docs/session-diary.md`.
5. **Global Sync**: Sync session data to global work-diary.
EOF

# 6. Generate Planner & Context Templates
cat > planner.md << 'EOF'
# Project Planner
- [ ] **TASK-001**: Define Tech Stack in `docs/context/` | @user
- [ ] **TASK-002**: Generate project plan | @planner
EOF

touch docs/context/backend.md docs/context/frontend.md docs/context/database.md

# 7. Project Naming & Date
sed -i "s/PROJECT_NAME/$(basename "$PWD")/g" AGENTS.md docs/current-state.md
sed -i "s/DATE/$(date +%Y-%m-%d)/g" AGENTS.md docs/current-state.md DECISIONS.md

# 8. Git Init
if [ ! -d .git ]; then git init; fi

echo "✅ MODULAR PROJECT, CURRENT STATE & PROTOCOL INITIALIZED!"
```
