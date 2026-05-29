# Plan-Migration Prompt

I want to migrate to an AGENTS-first, tool-neutral agent configuration.

Goal:

- shared instructions live in `AGENTS.md`
- shared global config lives in `~/.agents`
- Claude, Codex, Gemini CLI, and future tools use adapters
- tool runtime stays in tool-specific folders
- private content is not copied into any public repo

Please produce a phased migration plan.

Requirements:

- inspect current state before proposing edits
- classify files as shared instruction, shared workflow, adapter, runtime, or manual review
- prefer a small first cut: global and workspace instructions before skills/hooks/commands
- include rollback points
- include validation steps for each tool
- ask before making changes
