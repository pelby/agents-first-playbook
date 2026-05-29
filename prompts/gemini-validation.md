# Gemini Validation Prompt

Validate Gemini CLI compatibility for an AGENTS-first setup.

Do not change files unless I explicitly approve.

Check:

- which context file Gemini CLI is configured to read
- whether it can read `AGENTS.md` directly or through an adapter
- whether imports resolve as expected
- whether project and workspace instructions load in the intended order
- whether Gemini-specific runtime config stays separate from shared instructions

Report concrete issues, paths, and recommended fixes.
