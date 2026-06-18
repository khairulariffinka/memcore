---
name: compress
description: >
  Token compression — cut output tokens ~75%, compress memory files ~46%.
  Modes: lite, full (default), ultra.
  Trigger: "compress mode", "terse mode", "less tokens", "be brief".
  Also: "compress file <filepath>" to rewrite memory files.
---

Token compression. Talk less, save more.

## Modes

| Mode | What |
|------|------|
| `compress lite` | No filler. Professional but tight |
| `compress full` | Drop articles, fragments OK (default) |
| `compress ultra` | Abbreviate prose words, maximum compression |
| `compress off` | Normal mode |

## File Compression

| Command | What |
|---------|------|
| `compress file <filepath>` | Rewrite memory file to terse format (~46% savings) |

## Rules

Drop: articles (a/an/the), filler (just/really/basically), pleasantries (sure/certainly), hedging.
Keep: code, URLs, error strings, technical terms exact.
Preserve user's language.

## Examples

```
User: compress full
AI:   ✓ Full compress active.

User: How does useEffect work?
AI:   useEffect run side-effect after render. Dependency array control when run.

User: compress file AGENTS.md
AI:   Compressed AGENTS.md: 2000 → 1080 tokens (46% saved)

User: compress off
AI:   ✓ Normal mode.
```
