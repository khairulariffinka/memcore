---
name: work
description: >
  Work execution — plan tasks, track progress, set goals with stop conditions.
  Two functions: plan (task execution), goal (prevent premature stops).
---

Work execution layer. Two functions.

## Functions

| Command | What |
|---------|------|
| `work start <name>` | Start working on a plan |
| `work next` | Show next pending task |
| `work done [message]` | Mark task done (optional git commit) |
| `work status` | Show plan progress |
| `work goal set <goal> [verification]` | Set session goal |
| `work goal status` | Show goal progress |
| `work goal check` | Verify if goal met |
| `work goal stop` | Mark goal complete |
| `work goal clear` | Clear goal |

## Plan Example

```
User: work start refactor-auth
AI:   === Plan: refactor-auth ===
      Current task (line 3): Update login controller

User: work done "Refactored login controller"
AI:   ✓ Task done. Next: Add input validation

User: work status
AI:   Progress: [████░░░░░░] 2/5 (40%)
```

## Goal Example

```
User: work goal set "All tests passing" "npm test returns 0"
AI:   🎯 Goal: All tests passing
      Verification: npm test returns 0

User: work goal check
AI:   🔍 Verifying... ❌ FAIL: 3 tests failing

User: work goal check
AI:   🔍 Verifying... ✅ PASS: All tests green

User: work goal stop
AI:   Session complete.
```

## Why Goals?

Without goals, agents stop prematurely. Goals enforce verification.
