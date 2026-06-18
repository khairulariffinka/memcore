# MemCore Knowledge Graph

> Cross-references between skills. Enables recall across different knowledge domains.

---

## Skill Cross-References

### observation ↔ post-mortem

| Observation | Post-Mortem | Connection |
|-------------|-------------|------------|
| High error frequency | [PM-ID] | Pattern indicates systemic issue |
| Low completion rate | [PM-ID] | Related to recurring failure |

### observation ↔ library

| Pattern | Library Entry | Connection |
|---------|---------------|------------|
| Prefers [technology] | [LIB-ID] | Matches saved knowledge |
| Frequent [workflow] | [LIB-ID] | Aligns with documented process |

### library ↔ post-mortem

| Library Entry | Post-Mortem | Connection |
|---------------|-------------|------------|
| [LIB-ID] | [PM-ID] | Decision led to failure |
| [LIB-ID] | [PM-ID] | Knowledge prevented recurrence |

### reminders ↔ work-plan

| Reminder | Plan Task | Connection |
|----------|-----------|------------|
| [REM-ID] | [task] | Blocks plan progress |
| [REM-ID] | [task] | Related to plan milestone |

### lru-projects ↔ observation

| Project | Pattern | Connection |
|---------|---------|------------|
| [project] | [pattern] | Most active project |
| [project] | [pattern] | Least recently used |

---

## Decision Impact Map

<!-- Track how decisions ripple across the system -->
| Decision | Skills Affected | Outcomes |
|----------|-----------------|----------|
| [decision] | [skills] | [what happened] |

---

## Failure Patterns

<!-- Cross-reference failures with observations -->
| Failure Type | Frequency | Root Cause | Prevention |
|--------------|-----------|------------|------------|
| [type] | [count] | [cause] | [prevention] |

---

_Last updated: [YYYY-MM-DD]_
