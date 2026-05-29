# Codex Implementation Prompt

Implement the approved AGENTS-first migration plan.

Rules:

- make only the approved changes
- preserve unrelated dirty work
- do not use broad destructive commands
- use explicit staging paths
- keep private runtime state out of shared config
- prefer `AGENTS.md` as the real file and tool-specific files as adapters
- update scripts to prefer `.agents` and fall back to tool-specific folders
- run validation and privacy checks before committing

After implementation, report:

- changed files
- validation results
- remaining risks
- what another agent should verify
