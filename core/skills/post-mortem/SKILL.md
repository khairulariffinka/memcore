---
name: post-mortem
description: Failure learning log — record error, punca, solution
---

# Post-Mortem Skill

Sistem merekod dan belajar dari kegagalan.

## Primary Functions

| Function | Description |
|----------|-------------|
| **log** | Log failure baru |
| **list** | Senarai post-mortem |
| **lessons** | Tunjukkan lesson learned |

## Format

```
## PM-YYYY-NNN: [Title]
Severity: Critical | High | Medium | Low
Status: Open | Resolved
Symptoms:
Root Cause:
Resolution:
Lesson Learned:
Prevention:
```

## Execute Logic

bash:
# @pm log <title> [severity]
if [[ "\$1" == "log" ]]; then
    TITLE="\$2"
    SEVERITY="\${3:-Medium}"
    DATE=\$(date +%Y-%m-%d)
    ID="PM-\$DATE-001"
    mkdir -p docs
    cat >> docs/post-mortem.md << EOF

## \$ID: \$TITLE
**Date:** \$DATE
**Severity:** \$SEVERITY
**Status:** Open
### Symptoms
### Root Cause
### Resolution
### Lesson Learned
### Prevention
---
EOF
    echo "Post-mortem created: \$ID"
fi

# @pm list
if [[ "\$1" == "list" ]]; then
    if [ -f "docs/post-mortem.md" ]; then
        grep "^## PM-" docs/post-mortem.md
    else
        echo "Tiada post-mortem"
    fi
fi

# @pm lessons
if [[ "\$1" == "lessons" ]]; then
    if [ -f "docs/post-mortem.md" ]; then
        grep -B 2 -A 5 "Lesson Learned" docs/post-mortem.md | head -60
    fi
fi
