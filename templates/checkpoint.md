# MemCore Checkpoint — Session State Snapshot

> Auto-maintained by MemCore. Based on MiMo-Code's checkpoint system.
> Each section has a token budget to keep context efficient.

---

## §1 Active Intent

<!-- User's most recent explicit request (verbatim). Max: 500 tokens -->
_User request goes here_

---

## §2 Next Concrete Action

<!-- Single next step to continue work. Max: 1,000 tokens -->
1. [ ] Next action

---

## §3 Directives

<!-- Session-specific working style rules. Max: 800 tokens -->
- Language: [Malay/English]
- Style: [brief/detailed]
- Mode: [dev/quick/review]

---

## §4 Task Tree

<!-- Hierarchical task view with status. Max: 1,000 tokens -->
```
T1: [Main task] ✓
  T1.1: [Subtask] ✓
  T1.2: [Subtask] ⏳
T2: [Next task] ○
```

Legend: ✓ done, ⏳ in progress, ○ pending, ✗ failed

---

## §5 Current Work

<!-- What was being done immediately before checkpoint. Max: 2,000 tokens -->
_Context of current work session_

---

## §6 Files and Code Sections

<!-- Files actively read/modified. Max: 1,500 tokens -->
| File | Action | Notes |
|------|--------|-------|
| [file] | read/modified/created | [what changed] |

---

## §7 Discovered Knowledge

<!-- Cross-task facts (candidates for MEMORY.md promotion). Max: 2,000 tokens -->
_Knowledge discovered during this session that should persist_

---

## §8 Errors and Fixes

<!-- Errors encountered and resolutions (newest first). Max: 1,500 tokens -->
| Error | Fix | Status |
|-------|-----|--------|
| [error] | [solution] | resolved/pending |

---

## §9 Live Resources

<!-- Branch, uncommitted files, running processes. Max: 1,000 tokens -->
- Branch: [branch name]
- Uncommitted: [files]
- Running: [processes]

---

## §10 Design Decisions

<!-- Decisions from discussion with no code artifact. Max: 3,000 tokens -->
| Decision | Rationale | Alternatives |
|----------|-----------|--------------|
| [decision] | [why] | [other options] |

---

## §11 Open Notes

<!-- Catch-all for items that don't fit §1-§10. Max: 800 tokens -->
_Notes that don't fit elsewhere_

---

_Last checkpoint: [YYYY-MM-DD HH:MM]_
_Next checkpoint: [auto-triggered at ~80% context usage]_
