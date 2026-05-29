# AGENTS.md

Canonical shared instructions for AI agents on this machine.

## Source of truth

Shared, durable guidance lives here. Tool-specific files are adapters or runtime config.

Suggested adapters:

```text
~/.claude/CLAUDE.md -> ~/.agents/AGENTS.md
~/.codex/AGENTS.md  -> ~/.agents/AGENTS.md
```

For tools that do not follow symlinks reliably, use an import wrapper or configure the tool to read this file.

## User context

- Preferred timezone:
- Preferred language/style:
- Important safety rules:

## Workspace routing

Default workspace:

```text
~/Workspaces
```

Routing:

| Context | Destination |
| --- | --- |
| personal work | `~/Workspaces/personal/` |
| company work | `~/Workspaces/company/` |
| code projects | `~/Workspaces/code-projects/` |

## Tool policy

- Keep auth, logs, sessions, and generated state inside the owning tool folder.
- Do not duplicate durable instructions across tools.
- Prefer updating existing instructions over creating parallel files.
