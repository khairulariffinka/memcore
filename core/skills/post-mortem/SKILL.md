---
name: post-mortem
description: Failure learning log — record error, root cause, solution, and prevention
---

# Post-Mortem Skill

Sistem merekod dan belajar dari kegagalan.

## Primary Functions

| Function | Description |
|----------|-------------|
| **log** | Log failure baru dengan details |
| **edit** | Update section post-mortem |
| **list** | Senarai post-mortem |
| **lessons** | Tunjukkan lesson learned |
| **delete** | Padam post-mortem |

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

```bash
# @pm log <title> [severity] [--symptoms "..."] [--cause "..."] [--resolution "..."] [--lesson "..."] [--prevention "..."]
if [[ "$1" == "log" ]]; then
    TITLE="$2"
    SEVERITY="${3:-Medium}"

    # Parse optional flags
    SYMPTOMS=""
    CAUSE=""
    RESOLUTION=""
    LESSON=""
    PREVENTION=""
    shift 2
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --symptoms)  SYMPTOMS="$2"; shift 2 ;;
            --cause)     CAUSE="$2"; shift 2 ;;
            --resolution) RESOLUTION="$2"; shift 2 ;;
            --lesson)    LESSON="$2"; shift 2 ;;
            --prevention) PREVENTION="$2"; shift 2 ;;
            *) shift ;;
        esac
    done

    DATE=$(date +%Y-%m-%d)
    mkdir -p docs

    # Find next available ID for today
    NEXT_ID=1
    if [[ -f "docs/post-mortem.md" ]]; then
        LAST_ID=$(grep -o "PM-$DATE-[0-9]\+" docs/post-mortem.md 2>/dev/null | tail -1 | grep -o '[0-9]\+$')
        if [[ -n "$LAST_ID" ]]; then
            NEXT_ID=$((LAST_ID + 1))
        fi
    fi
    ID="PM-$DATE-$(printf '%03d' $NEXT_ID)"

    cat >> docs/post-mortem.md << EOF

## $ID: $TITLE
**Date:** $DATE
**Severity:** $SEVERITY
**Status:** Open
### Symptoms
${SYMPTOMS:-_TBD — use: @pm edit $ID symptoms "description"_}
### Root Cause
${CAUSE:-_TBD — use: @pm edit $ID cause "description"_}
### Resolution
${RESOLUTION:-_TBD — use: @pm edit $ID resolution "description"_}
### Lesson Learned
${LESSON:-_TBD — use: @pm edit $ID lesson "description"_}
### Prevention
${PREVENTION:-_TBD — use: @pm edit $ID prevention "description"_}
---
EOF
    echo "Post-mortem created: $ID"
    if [[ -z "$SYMPTOMS" && -z "$CAUSE" ]]; then
        echo "Tip: Use @pm edit $ID <section> <content> to fill in details"
    fi
fi

# @pm edit <id> <section> <content>
# Sections: symptoms, cause, resolution, lesson, prevention
if [[ "$1" == "edit" ]]; then
    ID="$2"
    SECTION="$3"
    shift 3
    CONTENT="$*"

    if [[ -z "$ID" || -z "$SECTION" || -z "$CONTENT" ]]; then
        echo "Usage: @pm edit <id> <section> <content>"
        echo "Sections: symptoms, cause, resolution, lesson, prevention"
        echo "Example: @pm edit PM-2026-06-18-001 cause 'JWT token expired'"
        exit 1
    fi

    if [[ ! -f "docs/post-mortem.md" ]]; then
        echo "No post-mortem file found."
        exit 1
    fi

    if ! grep -q "^## $ID:" docs/post-mortem.md 2>/dev/null; then
        echo "Post-mortem '$ID' not found."
        exit 1
    fi

    # Map section name to header
    case "$SECTION" in
        symptoms)   HEADER="### Symptoms" ;;
        cause)      HEADER="### Root Cause" ;;
        resolution) HEADER="### Resolution" ;;
        lesson)     HEADER="### Lesson Learned" ;;
        prevention) HEADER="### Prevention" ;;
        *)
            echo "Invalid section: $SECTION"
            echo "Valid: symptoms, cause, resolution, lesson, prevention"
            exit 1
            ;;
    esac

    # Find the line number of the section within this entry
    # Extract the entry block first, then find the section
    START_LINE=$(grep -n "^## $ID:" docs/post-mortem.md | head -1 | cut -d: -f1)
    if [[ -z "$START_LINE" ]]; then
        echo "Could not locate entry $ID"
        exit 1
    fi

    # Find the section line (search from start of entry)
    SECTION_LINE=$(sed -n "${START_LINE},\$p" docs/post-mortem.md | grep -n "^$HEADER" | head -1 | cut -d: -f1)
    if [[ -z "$SECTION_LINE" ]]; then
        echo "Section '$SECTION' not found in $ID"
        exit 1
    fi

    ABS_LINE=$((START_LINE + SECTION_LINE - 1))
    # Replace the next line after the header with new content
    sed -i "$((ABS_LINE + 1))s/.*/$CONTENT/" docs/post-mortem.md

    DATE=$(date +%Y-%m-%d)
    sed -i "s/_Last updated: .*/_Last updated: $DATE_/" docs/post-mortem.md 2>/dev/null || true

    echo "Updated $ID.$SECTION"
fi

# @pm list
if [[ "$1" == "list" ]]; then
    if [ -f "docs/post-mortem.md" ]; then
        grep "^## PM-" docs/post-mortem.md
    else
        echo "Tiada post-mortem"
    fi
fi

# @pm lessons
if [[ "$1" == "lessons" ]]; then
    if [ -f "docs/post-mortem.md" ]; then
        grep -B 2 -A 5 "Lesson Learned" docs/post-mortem.md | head -60
    fi
fi

# @pm delete <id>
if [[ "$1" == "delete" ]]; then
    ID="$2"
    if [[ -z "$ID" ]]; then
        echo "Usage: @pm delete <id>"
        echo "Example: @pm delete PM-2026-06-18-001"
        exit 1
    fi

    if [[ ! -f "docs/post-mortem.md" ]]; then
        echo "No post-mortem file found."
        exit 0
    fi

    if grep -q "^## $ID:" docs/post-mortem.md 2>/dev/null; then
        # Delete the entry (from ## ID line to next ## or ---)
        sed -i "/^## $ID:/,/^---/d" docs/post-mortem.md
        echo "Deleted: $ID"
    else
        echo "Post-mortem '$ID' not found."
    fi
fi
```
