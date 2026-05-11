---
name: decision-log
description: Decision logging system - tracks design decisions with rationale and tracks impacted files
---

# Decision Log Skill

## Purpose

Capture design decisions during development with full context and traceability to source code.

## Decision Format (Enhanced)

```markdown
## DEC-YYYY-NNN: [Title]

**Date:** YYYY-MM-DD
**Status:** Active | Deprecated | Superseded

### Context

[What problem or question was being addressed?]

### Options Considered

| Option | Pros | Cons |
| ------ | ---- | ---- |
| A      | ...  | ...  |
| B      | ...  | ...  |

### Decision

**Chosen:** [Option]

### Rationale

[Detailed explanation - "because X" not "because it's better"]

### Impacted Files ⭐

- [path/to/file1.ext] - [Description of change]
- [path/to/file2.ext] - [Description of change]

### Implications

- **Positive:** [Impact]
- **Trade-offs:** [Impact]

### Related

- Related: DEC-YYYY-XXX
- Files: [directory/path]
```
