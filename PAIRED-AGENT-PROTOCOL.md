# Paired Agent Protocol

This process is useful when migrating an existing setup with both Claude Code and Codex available.

## Roles

Codex is good at:

- filesystem inventory
- static analysis
- mechanical edits
- test scripts
- privacy scans
- cross-tool planning

Claude Code is good at:

- validating Claude-specific loading
- checking memory and slash-command behaviour
- testing `.claude` assumptions
- confirming whether import wrappers or symlinks work in practice

Gemini CLI or another agent can be added as a third validation pass.

## Recommended sequence

1. Codex performs a read-only inventory.
2. Codex writes a migration plan.
3. Claude Code validates Claude-specific risks.
4. Codex performs mechanical file changes.
5. Claude Code validates Claude loading and commands.
6. Codex runs privacy checks and commits.
7. A human reviews before publishing.

## Ground rules

- One canonical source of truth.
- No hidden rewrites of tool runtime state.
- No public copy of private config.
- No automatic migration until the inventory is understood.
- If agents disagree, stop and inspect the concrete files rather than debating from memory.

## Useful handoff prompt

```text
We are migrating to an AGENTS-first agent configuration.

Please validate only the behaviour specific to your tool. Do not change files unless asked.

Check:
- which instruction files are loaded
- whether symlinks or import wrappers work
- whether runtime files are being treated as instructions
- whether any commands or hooks assume a tool-specific path

Report concrete paths and recommended fixes.
```
