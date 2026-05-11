---
name: session-briefing
description: Auto-brief bila sesi baru start — ringkaskan projek, task aktif
---

# Session Briefing Skill

Memberi ringkasan pantas tentang status projek.

## Primary Functions

| Function | Description |
|----------|-------------|
| **brief** | Brief penuh |
| **status** | Status ringkas |
| **changes** | Perubahan terkini |

## Execute Logic

```bash
# brief
if [[ "\$1" == "brief" || -z "\$1" ]]; then
    echo "📋 Session Brief - \$(date +%Y-%m-%d)"
    [ -f "planner.md" ] && echo "Active:" && grep -E "^- \[ \]" planner.md | head -10
    [ -f "docs/session-diary.md" ] && echo "Last:" && grep "^## Session" docs/session-diary.md | tail -3
fi

# status
if [[ "\$1" == "status" ]]; then
    [ -f "docs/current-state.md" ] && grep -E "Phase|Status|Version" docs/current-state.md
    echo "Active tasks: \$(grep -c '^- \[' planner.md 2>/dev/null || echo 0)"
fi

# changes
if [[ "\$1" == "changes" ]]; then
    [ -f "docs/current-state.md" ] && grep -E "^- " docs/current-state.md | head -10
fi
```
