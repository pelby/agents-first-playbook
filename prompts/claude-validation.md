# Claude Validation Prompt

Validate Claude Code compatibility for an AGENTS-first setup.

Do not change files unless I explicitly approve.

Check:

- whether Claude Code loads `CLAUDE.md` when it points to or imports `AGENTS.md`
- whether the loaded content is the shared `AGENTS.md` content
- whether duplicate or conflicting instructions appear
- whether slash commands, hooks, or memory assume `.claude` paths
- whether settings or runtime files are being confused with shared config

Report concrete issues, paths, and recommended fixes.
