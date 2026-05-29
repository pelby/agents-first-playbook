# Migration Guide

Use this path when you already have agent instructions, especially a Claude-first setup.

## Migration principle

Do not start by moving files.

First inventory, classify, plan, then migrate. Agent config often contains private memory, runtime logs, auth state, local permissions, and tool-managed files. Treat it carefully.

## Phase 0: Inventory

Run:

```bash
./scripts/inspect-agent-config.sh
```

Then ask an agent to inspect without changing anything:

```text
Use prompts/inventory-only.md. Do not mutate files.
```

Capture:

- real files vs symlinks
- broken symlinks
- which file currently owns the instruction content
- tool runtime folders
- private memories and logs
- scripts that hardcode `.claude`, `.codex`, or another tool folder

## Phase 1: Classify

Classify each item:

| Classification | Examples | Action |
| --- | --- | --- |
| Shared durable instruction | style, routing, conventions | move or copy into `AGENTS.md` |
| Shared reusable workflow | skills, playbooks, templates | move toward `.agents/` |
| Tool adapter | `CLAUDE.md`, `GEMINI.md` wrapper | keep thin and tool-specific |
| Tool runtime | sessions, logs, auth, settings | keep in tool folder |
| Review manually | hooks, commands, generated scripts | inspect before moving |

## Phase 2: Decide the canonical direction

Target direction:

```text
real file:     AGENTS.md
adapter file:  CLAUDE.md -> AGENTS.md
adapter file:  GEMINI.md or context config -> AGENTS.md
tool config:   stays in tool folder
```

If a tool cannot follow symlinks reliably, use a small import wrapper instead.

## Phase 3: Make the smallest safe cut

Recommended first cut:

- make global shared instructions live in `~/.agents/AGENTS.md`
- make workspace shared instructions live in `~/Workspaces/AGENTS.md`
- point tool instruction adapters at those files
- do not move skills, hooks, commands, or settings yet

This gives you the main benefit without rewriting all tooling at once.

## Phase 4: Update scripts and commands

Any reusable script that currently assumes one tool should prefer neutral config and fall back:

```text
prefer .agents/<name>
fallback to .claude/<name> or .codex/<name>
```

Do not rename runtime folders until the fallback behaviour is tested.

## Phase 5: Validate

Validate in each tool:

- the shared `AGENTS.md` content loads
- adapters do not duplicate or conflict
- broken symlinks are gone
- private runtime state has not been moved into a public repo
- existing commands still work or have a documented follow-up

## Rollback points

Commit after each safe phase. If something goes wrong, revert the latest phase rather than trying to repair a half-migrated setup manually.
