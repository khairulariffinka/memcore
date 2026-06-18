# Contributing to MemCore

First off, thanks for wanting to contribute! 🎉

## Development Workflow

1. **Fork** the repo
2. **Branch** from `develop`: `git checkout -b feat/your-feature`
3. **Code** your changes (agents in `core/agents/`, skills in `core/skills/`)
4. **Test**: `bash scripts/validate.sh`
5. **Commit** with conventional message: `feat: description`
6. **PR** to `develop` branch (not `main`)

## Branch Rules

| Branch | Purpose | Base |
|--------|---------|------|
| `main` | Stable releases | — |
| `develop` | Active development | `main` |
| `feat/*` | New features | `develop` |
| `fix/*` | Bug fixes | `develop` |
| `docs/*` | Documentation | `develop` |

## Agent & Skill Guidelines

### Agent Files (`core/agents/`)
- Must have YAML frontmatter (`name`, `description`, `mode`, `permission`)
- `mode: primary` for full-access agents, `mode: plan` for read-only agents
- Must reference existing skill names (use exact registered names)
- Keep focused on one responsibility
- Add guardrails if applicable

### Skill Files (`core/skills/*/SKILL.md`)
- Must have YAML frontmatter (`name`, `description`)
- Must be referenced by at least one agent
- Keep code examples executable

## Testing

```bash
# Validate all agents & skills
bash scripts/validate.sh

# Validate installed config
bash ~/.config/opencode/scripts/validate.sh --installed

# Test self-healing scenarios
bash tests/test-self-healing.sh
```

## Commit Convention

```
type(scope): description

Types: feat, fix, docs, style, refactor, test, chore
Examples:
  feat(auth): add JWT middleware
  fix(memory): correct sed pattern for planner
  docs: update architecture diagram
```

## Pull Request Checklist

- [ ] `bash scripts/validate.sh` passes
- [ ] YAML frontmatter valid
- [ ] All `@agent` references exist
- [ ] No overclaim terms ("semantic search", "knowledge graph")
- [ ] Changelog updated in `install.md` / `update.md`
- [ ] Docs updated if changing agent behavior
