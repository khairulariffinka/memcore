---
name: planner
description: Advanced task planning with estimation, dependency tracking, and decision alignment
---

# Planner Skill

Breaks down complex requirements into manageable, sequential, or parallel tasks.

## Planning Workflow

1. **Analyze Requirements** - Read requirement docs and `DECISIONS.md`.
2. **Check Context** - Verify project context to avoid using deprecated patterns.
3. **Generate Task List** - Create entries in `planner.md` with hierarchical breakdown.
4. **Estimate Effort** - Set difficulty level (Low/Medium/High).
5. **Set Dependencies** - Mark tasks that require previous steps to be completed first.
6. **Define Parallel Groups** - Group independent tasks that can run simultaneously.
7. **Assign Agents** - Tag each task with the appropriate `@agent`.
8. **Review & Iterate** - Update plan as requirements change.

## Task Format in `planner.md`

```markdown
### [Phase Name]

- [ ] **TASK-ID**: [Title] | @agent | [Priority]
  - **Description**: [Goal]
  - **Dependencies**: [TASK-ID]
  - **Effort**: [Low/Medium/High]
  - **Parallel Group**: [1/2/3...]
  - **Reference**: [Ref: DEC-YYYY-XXX | REQ-XXX]
  - **Impacted Files**: [List from decision-log]
```

## Effort Estimation Criteria

| Level | Hours | Task Examples |
|-------|-------|---------------|
| **Low** | < 2h | Create model, add route, simple UI tweak |
| **Medium** | 2-8h | Full CRUD endpoint, form with validation |
| **High** | 8-24h | Payment integration, complex business logic |

## Parallel Grouping Rules

| Condition | Action |
|-----------|--------|
| No shared dependencies | Same parallel group |
| Frontend + Backend for same feature | Different groups (backend first) |
| DB schema change needed | Blocked until migration complete |
| Multiple UI components, same API | Same group (parallel) |
| Same file modified by two tasks | Must be in different groups (sequential) |
| Task A outputs data that Task B needs | Different groups (A before B) |

## Parallel Group Validation

Before executing parallel groups, validate the plan:

### 1. Dependency Check
```
For each parallel group:
  - Do any tasks in this group depend on each other?
  - If YES: Split into sequential groups or mark invalid
  - If NO: Group is valid for parallel execution
```

### 2. File Conflict Detection
```
For each pair of tasks in the same group:
  - Do they modify the same file?
  - If YES: Move one task to a different group (sequential)
  - If NO: Safe to run in parallel
```

### 3. Circular Dependency Check
```
For all tasks:
  - Does Task A → Task B → Task C → Task A exist?
  - If YES: Report circular dependency, ask user to resolve
  - If NO: Dependency chain is valid
```

### 4. Resource Check
```
For each parallel group:
  - Does any task require exclusive resource (DB migration, config change)?
  - If YES: Move to dedicated group
  - If NO: Safe for parallel
```

### Validation Output
```markdown
## Parallel Groups Validation
- Group 1: model (User schema) + ui (Login form) ✅
- Group 2: backend (Login API) [depends on Group 1] ✅
- Resource Conflicts: None ✅
- Circular Dependencies: None ✅
- **Valid for execution**
```

## Re-planning Workflow

When scope changes:
1. Identify impacted tasks in planner.md
2. Update effort estimates if needed
3. Recalculate dependencies
4. Log change in planner.md change log
5. Notify affected agents
