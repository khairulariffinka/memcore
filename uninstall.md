# Uninstall MemCore

> **When user loads this file:** User wants to uninstall MemCore from their system.

---

## Context

When this file is loaded, AI must know:
- User wants to uninstall/remove MemCore
- NOT just reading the file
- AI must execute uninstall steps

## Confirm

**Are you sure you want to uninstall MemCore?**

This will remove ALL MemCore data:
- 1 agent file
- 7 skill folders
- Version file
- Global memory (user profile, work diary, knowledge library)

**Choose your option:**

- `confirm` - Proceed with complete uninstallation
- `cancel` - Abort uninstallation

```
AI: Are you sure you want to uninstall MemCore?
     This will remove ALL agents, skills, and global memory.

     Type "confirm" to proceed or "cancel" to abort.
```

---

## Run Uninstall

When you load this file, run the following commands:

```bash
# ============================================
# Uninstall MemCore (with confirmation guard)
# ============================================
read -p "Type 'confirm' to uninstall MemCore: " CONFIRM
if [ "$CONFIRM" = "confirm" ]; then
  echo "Removing skills..."
  rm -rf ~/.config/opencode/skills

  echo "Removing agents..."
  rm -rf ~/.config/opencode/agents

  echo "Removing global memory..."
  rm -rf ~/.config/opencode/global-memory

  echo "✅ MemCore uninstalled successfully."
else
  echo "❌ Uninstall cancelled."
fi
```

---

## Verify Uninstallation

Restart terminal/CLI and type:

```
memcore
```

If you get "Agent not found" or error - uninstall successful!

---

## Notes

This will remove everything MemCore installed:
- Skills folder: 7 skill modules
- Agents folder: 1 agent (memcore)
- Global memory folder: 1 folder (user profile, work diary, knowledge library)

**After uninstall, you will need to run the setup again to use MemCore.**
