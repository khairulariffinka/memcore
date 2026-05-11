---
name: orchestration
description: Main orchestration logic with self-healing, parallel execution, and pre-commit validation
---

# Orchestration Skill

The central logic for coordinating agents, managing task flows, and ensuring system stability through self-healing protocols.

## Task Lifecycle

1. **Plan Generation**: Invoke `@planner` to break down user requests into tasks.
2. **Context Loading**: Ensure relevant modular context (`docs/context/`) is loaded for the assigned agent.
3. **Execution**: Distribute tasks to specialized agents (e.g., `planner`, `memory`).
4. **Validation**: Perform code review and compliance check.
5. **Commit**: Proceed with commit ONLY if audit status is `✅ PASSED`.

## Spec Change Propagation

When requirements change, propagate updates through the chain:

```
Requirements updated (new version or CR-XXX)
  ↓
@planner: recalculate estimates, adjust tasks, update dependencies
  ↓
@memory: log change in session diary
  ↓
@decision-log: log CR decision if applicable
```
Spec updated (new version or CR-XXX)
  ↓
@planner: recalculate estimates, adjust tasks, update dependencies
  ↓
@memory: log spec change in session diary
  ↓
@decision-log: log CR decision if applicable
```

### Change Request Flow

```
User: "Add TikTok integration"

1. @planner → Replan
   - Add tasks for TikTok feature
   - Adjust estimates and timeline
    
2. Execute new tasks → commit, diary save
```

## Self-Healing & Error Recovery

### 0. Guardrails (Always Active)

| Guardrail | Threshold | Action |
|-----------|-----------|--------|
| **Circuit Breaker** | 3 failures same agent/task | Halt all retries, generate Failure Report |
| **Rate Limit** | 5 subagent dispatches per msg | Batch remaining, execute sequentially |
| **Parallel Cap** | 3 concurrent agents max | Queue overflow agents for next batch |
| **File Modification Gate** | Existing file edit | Ask user before overwriting |

### 1. Agent Failure Continuum (Progressive)

When ANY agent fails (timeout, error, unexpected output):

| Attempt | Action |
|---------|--------|
| **1st** | Retry same agent with specific error context |
| **2nd** | Call `@research` to validate approach |
| **3rd** | ❌ Circuit Breaker trips — STOP all retries, AUTO-log lesson |
| **Final** | Generate Failure Report + auto-save to lessons.md, present to user |

### 2. Auditor Failure Loop

If audit returns `❌ FAILED`:

```
FAILED → Retry agent with error logs → FAILED → 
Call @research for pattern validation → FAILED → 
High-reasoning fix → FAILED → 
Failure Report → USER
```

### 3. Timeout Handling

If an agent takes too long or produces no output:

- **Wait threshold**: 30 seconds for simple tasks, 2 minutes for complex
- **First timeout**: Retry with `[timeout]` prefix to force immediate response
- **Second timeout**: Break task into smaller chunks via `@planner`
- **Persistent timeout**: Report as infrastructure issue

### 4. Partial Parallel Failure

When parallel agents run and ONE fails:

```
planner ✅  research ❌  memory ✅

Action:
1. Accept completed work (planner, memory)
2. Isolate failed task (research)
3. Retry failed agent only (not the whole group)
4. If retry fails → check dependency chain
5. If other agents depend on failed task → block them
6. Report partial completion to user
```

### 5. Routing Failure

If no subagent matches the task:

```
1. Check if task matches a known agent
2. Try @planner for generic planning fallback
3. If still no match → ask user for clarification
4. Log unknown task type for future pattern addition
```

### 6. Context Loading Failure

If `docs/context/` files are missing:

```
1. Check if init-project has been run (AGENTS.md exists?)
2. If not → prompt: "Project not initialized. Run 'init project' first?"
3. If yes but context missing → use AGENTS.md as fallback
4. Log missing context paths for user to create
```

### 7. Permission Denied Recovery

If an agent lacks permission for a critical action:

```
1. Check if alternative agent has the required permission
2. Route to alternative agent with context
3. If no alternative → report permission gap
```

### 8. Git Operation Failure

If git commit fails (pre-hook rejection, merge conflict):

```
1. Parse error output from git
2. If pre-hook → fix issues, retry commit
3. If merge conflict → call user to resolve manually
4. If auth error → check git remote config
```

### 9. Post-Mortem Feedback (Lessons Learned)

After ANY task completion or failure:

```
IF task FAILED after retries:
  → Log lesson to docs/lessons.md via @memory
  → Include: agent, symptom, root cause, fix

IF task SUCCEEDED but had notable challenges:
  → Log lesson if the approach was non-obvious
  → Include: what made it tricky, how it was solved

IF common mistake detected:
  → Log lesson so same agent doesn't repeat
  → Tag for easy search (#auth, #database, etc.)
```

**Before starting a NEW task of the same type:**
```
1. @memory, show lessons about [topic]
2. If relevant lessons exist → share with agent as context
3. Agent adjusts approach based on past mistakes
```

### 10. Auto-Lesson Logging (Self-Learning)

When circuit breaker trips (agent fails 3x), auto-log to lessons.md:

```
@memory, lesson: [Agent] [task] failed after 3 retries
  Root Cause: [from failure analysis]
  Fix Applied: [from last attempt]
  Tags: #[agent-name] #common-mistake #auto-logged
```

This happens automatically at step "Final" — no manual action needed.

### 11. Auto-Update Check (Self-Updating)

When a session starts, check if MemCore has updates available:

```
1. Check: git remote update 2>/dev/null
2. Compare: git rev-list HEAD...origin/main --count
3. If behind:
   "📦 MemCore update available ([N] commits behind).
    Auto-update? [y/N]"
   → If YES: git pull → re-run install
   → If NO: "You can update later via 'load update.md'"
4. If up to date: "✅ MemCore is up to date"
```

### 12. Failure Report Format

When all recovery attempts are exhausted:

```markdown
## Failure Report

**Task:** [original task description]
**Failed Agent:** @agent-name
**Attempts:** 3
**Root Cause:** [error message summary]

**Partial Work:**
- ✅ Completed: [files/tasks done]
- ❌ Failed: [files/tasks failed]
- ⏭️ Skipped: [dependent tasks not started]

**Recovery Actions Taken:**
1. Retry with context → FAILED
2. Research pattern validation → FAILED
3. High-reasoning fix → FAILED

**Suggested Next Steps:**
- [Recommendation 1]
- [Recommendation 2]

**Decision Logged**: DEC-YYYY-NNN (failure analysis)
```

## Pre-Commit Validation

Before allowing any `git commit` or `git push`:

- [ ] Auditor status must be `✅ PASSED`.
- [ ] Test status must be `✅ 100% SUCCESS`.
- [ ] No "TODO" or "FIXME" comments in files ready for production.

## Orchestration Modes

| Mode         | Behavior                                                          |
| ------------ | ----------------------------------------------------------------- |
| **Quick**    | Send directly to agent, skip audit (only for minor tasks). |
| **Standard** | Agent -> Audit -> Commit.                                          |
| **Strict**   | Agent -> Test -> Audit -> Commit.        |

## Guidelines

- **Efficiency**: Don't call 3 agents if 1 agent can complete.
- **Traceability**: Every orchestrator move must be recorded in `current-state.md`.
- **Safety First**: If decision has major impact on UI or core logic, must ask User.
