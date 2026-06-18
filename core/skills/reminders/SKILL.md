---
name: reminders
description: >
  Cross-session reminders with due dates and persistence.
  Set reminders that persist across sessions.
---

Cross-session reminders.

## Functions

| Command | What |
|---------|------|
| `reminders set <due> <message>` | Set a new reminder |
| `reminders list` | Show all pending reminders |
| `reminders done <id>` | Mark reminder complete |
| `reminders edit <id> <due> <message>` | Edit an existing reminder |
| `reminders clear` | Clear all completed reminders |

Due options: `next-session`, `tomorrow`, `YYYY-MM-DD`

## Example

```
User: reminders set tomorrow "Review PR"
AI:   Reminder set: REM-001 — "Review PR" (due: tomorrow)

User: reminders list
AI:   ⚠️ Due reminders:
      REM-001 — "Review PR" (due: tomorrow)

User: reminders done REM-001
AI:   ✓ Completed: REM-001
```

## Storage

`~/.config/opencode/global-memory/reminders.md`
