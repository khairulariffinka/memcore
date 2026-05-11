---
name: echo-recall
description: Memory search and recall system
---

# Echo Recall Skill

Sistem recall balik memory dari sesi lepas.

## Primary Functions

| Function | Description |
|----------|-------------|
| **search** | Cari memory guna keyword |
| **recall** | Recall session tertentu |
| **recent** | Tunjukkan aktiviti terkini |

## Execute Logic

```bash
if [[ "\$1" == "search" ]]; then
    KEYWORD="\$2"
    echo "🔍 Echo Recall: Mencari \$KEYWORD..."
    [ -f "docs/session-diary.md" ] && grep -i -A 3 "\$KEYWORD" docs/session-diary.md | head -30
    [ -f "DECISIONS.md" ] && grep -i -A 2 "\$KEYWORD" DECISIONS.md | head -20
fi
if [[ "\$1" == "recall" ]]; then
    [ -f "docs/session-diary.md" ] && grep -i -A 10 "Session.*\$2" docs/session-diary.md | head -50
fi
if [[ "\$1" == "recent" ]]; then
    LIMIT="\${2:-5}"
    [ -f "docs/session-diary.md" ] && grep "^## Session" docs/session-diary.md | tail -\$LIMIT
fi
```
