---
name: library-system
description: Knowledge library organised by categories — architecture, workflow, database, integration
---

# Library System Skill

Knowledge repository untuk simpan dan recall informasi ikut kategori.

## Primary Functions

| Function | Description |
|----------|-------------|
| **save** | Simpan entry ke library |
| **search** | Cari entry guna keyword |
| **list** | Senarai entry ikut kategori |
| **get** | Baca entry spesifik |

## Categories

| Category | Description |
|----------|-------------|
| **architecture** | System design, patterns, tech decisions |
| **workflow** | Processes, pipelines, automations |
| **database** | Schema, queries, migrations, data models |
| **integration** | API contracts, third-party services, auth |

## Storage Format

Setiap entry disimpan di `docs/library/<category>/` sebagai markdown:

```
docs/library/
├── architecture/
│   └── <entry-name>.md
├── workflow/
│   └── <entry-name>.md
├── database/
│   └── <entry-name>.md
└── integration/
    └── <entry-name>.md
```

Format entry:

```markdown
---
id: LIB-<YYYY>-<NNN>
category: <category>
created: <date>
tags: [tag1, tag2]
---
# <Title>

## Context
Why this entry exists.

## Content
The knowledge body.

## References
Related entries or external links.
```

## Execute Logic

```bash
# @library save <category> <name> [content]
# Saves an entry interactively or with provided content
if [[ "$1" == "save" ]]; then
    CATEGORY="$2"
    NAME="$3"
    shift 3
    CONTENT="$*"

    VALID_CATEGORIES="architecture workflow database integration"
    if ! echo "$VALID_CATEGORIES" | grep -wq "$CATEGORY"; then
        echo "Invalid category: $CATEGORY"
        echo "Valid: architecture, workflow, database, integration"
        exit 1
    fi

    DATE=$(date +%Y-%m-%d)
    DIR="docs/library/$CATEGORY"
    mkdir -p "$DIR"

    # Generate ID
    COUNT=$(ls "$DIR"/*.md 2>/dev/null | wc -l)
    ID=$(printf "LIB-%s-%03d" "$(date +%Y)" $((COUNT + 1)))
    FILE="$DIR/$NAME.md"

    if [[ -f "$FILE" ]]; then
        echo "Entry '$NAME' exists in $CATEGORY. Overwrite? [y/N]"
        read -r CONFIRM
        [[ "$CONFIRM" != "y" ]] && echo "Cancelled." && exit 0
    fi

    if [[ -z "$CONTENT" ]]; then
        # Interactive mode — create template
        cat > "$FILE" << EOF
---
id: $ID
category: $CATEGORY
created: $DATE
tags: []
---
# $NAME

## Context

## Content

## References
---
EOF
        echo "Template created: $FILE"
        echo "Edit the file to add content."
    else
        cat > "$FILE" << EOF
---
id: $ID
category: $CATEGORY
created: $DATE
tags: []
---
# $NAME

$CONTENT
---
EOF
        echo "Entry saved: $ID -> $FILE"
    fi
fi

# @library search <keyword>
if [[ "$1" == "search" ]]; then
    KEYWORD="$2"
    echo "Searching library for '$KEYWORD'..."
    RESULTS=$(grep -ril "$KEYWORD" docs/library/ 2>/dev/null)
    if [[ -z "$RESULTS" ]]; then
        echo "No results found."
    else
        echo "$RESULTS" | while read -r FILE; do
            ID=$(grep "^id:" "$FILE" 2>/dev/null | sed 's/id: //')
            TITLE=$(grep "^# " "$FILE" 2>/dev/null | sed 's/# //')
            echo "  $ID - $TITLE ($(dirname "$FILE" | xargs basename))"
        done
    fi
fi

# @library list [category]
if [[ "$1" == "list" ]]; then
    CATEGORY="$2"
    if [[ -n "$CATEGORY" ]]; then
        DIR="docs/library/$CATEGORY"
        if [[ ! -d "$DIR" ]]; then
            echo "No entries in $CATEGORY."
            exit 0
        fi
        echo "=== $CATEGORY ==="
        for FILE in "$DIR"/*.md; do
            [[ -f "$FILE" ]] || continue
            ID=$(grep "^id:" "$FILE" | sed 's/id: //')
            TITLE=$(grep "^# " "$FILE" | sed 's/# //')
            echo "  $ID - $TITLE"
        done
    else
        for CAT in architecture workflow database integration; do
            DIR="docs/library/$CAT"
            COUNT=$(ls "$DIR"/*.md 2>/dev/null | wc -l)
            echo "$CAT: $COUNT entries"
        done
    fi
fi

# @library get <category> <name>
if [[ "$1" == "get" ]]; then
    FILE="docs/library/$2/$3.md"
    if [[ -f "$FILE" ]]; then
        cat "$FILE"
    else
        echo "Entry not found: $2/$3"
        echo "Use '@library list $2' to see available entries."
    fi
fi
```
