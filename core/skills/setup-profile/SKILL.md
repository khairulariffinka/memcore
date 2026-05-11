---
name: setup-profile
description: Interactive setup wizard to configure user profile for global memory
---

## When to Use

- User says: "setup profile", "setup-profile", "configure profile"
- First session detected (no user-profile.md filled in)

## What It Does

1. Checks if user-profile.md exists
2. If not complete, prompts user to fill in
3. Opens the profile file for editing
4. Confirms when complete

## How It Works

### Step 1: Check Profile Status

Read `~/.config/opencode/global-memory/user-profile.md`:

Check if these fields are filled:
- Name (not empty)

### Step 2: If Not Complete

Prompt user with examples:

```
Welcome! Let's set up your profile.

Required:
- Name: [your name]

Optional (skip if preferred):
- Language: English / Auto-select
- Language Style: Auto-detect (follow user's input)
- Response Style: Brief / Detailed
- Emoji: Yes / No

Examples:
| Style | You get |
|-------|---------|
| Brief, No emoji | "Done. File at src/auth.ts" |
| Brief, Yes emoji | "Done! File at src/auth.ts" |
| Detailed | "I've added login because..." |

Say "done" when finished.
```

Then open: `~/.config/opencode/global-memory/user-profile.md`

### Step 3: If Complete

```
Profile: [Name]
Language: [Language]
Language Style: [Style]

Update anytime: "setup profile"
```

## Commands

| Trigger | Action |
|---------|--------|
| "setup profile" | Start/updates profile |
| "show profile" | Display current profile |

## Notes

- Required: Name only
- Language: Auto-select by default (follows user's input)
- Language Style: Auto-detect (follow user's input)
- Profile is GLOBAL - all projects