# AGENTS.md

This repo is a public playbook for AGENTS-first agent configuration. Keep it generic, safe to share, and free of private local setup details.

## Working rules

- Do not copy real personal or company config into this repo.
- Use placeholders such as `~/Workspaces`, `example-project`, and `you@example.com`.
- Keep scripts read-only unless a future change explicitly adds a reviewed setup command.
- Run `tests/run.sh` and the privacy scan before publishing.
- Keep the optional skill concise; the human-facing docs are the source of truth.

## Project shape

- `README.md` explains the methodology.
- `GREENFIELD.md` is for new setups.
- `MIGRATION.md` is for existing setups.
- `prompts/` contains pasteable prompts for agents.
- `templates/` contains generic instruction templates.
- `scripts/inspect-agent-config.sh` is read-only.
- `skills/agents-first-setup/SKILL.md` makes the process agent-executable.
