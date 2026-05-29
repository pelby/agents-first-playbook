# Agents-First Playbook

One brain, many agents.

Most AI coding tools want their own instruction file and config folder. That is useful for tool runtime state, but it is a bad place to store durable working preferences. If each tool has a separate source of truth, the instructions drift.

This playbook uses `AGENTS.md` as the shared source of truth, with tool-specific files acting as adapters.

## Core idea

```text
~/.agents/AGENTS.md          # shared global instructions
~/.claude/CLAUDE.md          # adapter to shared instructions
~/.codex/AGENTS.md           # adapter to shared instructions
~/.gemini/GEMINI.md          # adapter or config pointing to shared instructions

~/Workspaces/AGENTS.md       # shared workspace instructions
~/Workspaces/example-project/AGENTS.md
```

Shared, durable behaviour belongs in `AGENTS.md` or `.agents`. Runtime state stays with the tool that owns it.

## Why this exists

This is a practical pattern for people who switch between Claude Code, Codex, Gemini CLI, and future agents. It gives each tool the instructions it expects without making any single vendor the canonical home for your operating system.

I wrote this after working through the problem in real multi-agent use: the useful bit was not just the final symlink map, but the migration process that kept private runtime state separate from durable shared guidance.

The approach is based on public documentation for:

- [OpenAI Codex `AGENTS.md`](https://developers.openai.com/codex/guides/agents-md)
- [Claude Code memory and `AGENTS.md` compatibility](https://code.claude.com/docs/en/memory)
- [Gemini CLI context files](https://google-gemini.github.io/gemini-cli/docs/cli/gemini-md.html)

## What goes where

| Content | Canonical home | Notes |
| --- | --- | --- |
| Cross-agent preferences | `AGENTS.md` | Style, workflow, project conventions, routing |
| Shared skills and playbooks | `.agents/skills/` | Optional, reusable, vendor-neutral where possible |
| Claude runtime | `.claude/` | Settings, sessions, memory, hooks, slash-command adapters |
| Codex runtime | `.codex/` | Config, sessions, caches, tool state |
| Gemini runtime | `.gemini/` | Gemini-specific config and context settings |

## Start here

If you are setting up from scratch, read [`GREENFIELD.md`](GREENFIELD.md).

If you already have `.claude`, `.codex`, `CLAUDE.md`, `AGENTS.md`, or mixed symlinks, read [`MIGRATION.md`](MIGRATION.md).

If you want an agent to help, use the prompts in [`prompts/`](prompts/) and the optional skill in [`skills/agents-first-setup/`](skills/agents-first-setup/).

Before changing anything, run the read-only inspector:

```bash
./scripts/inspect-agent-config.sh
```

The inspector reports files, symlinks, likely conflicts, and broken links. It does not print instruction contents, move files, or create symlinks.

## Recommended workspace shape

```text
~/Workspaces/
  AGENTS.md
  personal-vault/
  company-knowledge/
  code-projects/
    example-project/
      AGENTS.md
```

The workspace-level `AGENTS.md` gives agents enough context to route work across multiple projects without duplicating instructions in every repo.

## Public safety rule

Never publish your real personal agent config directly. Treat it like an operating manual for your life and work.

Use this repo as a pattern. Replace all private names, client details, paths, tool inventories, memories, and contact details with placeholders before sharing anything publicly.

## Status

This is v1 of the playbook. It intentionally includes docs, prompts, templates, a read-only audit script, and a lightweight skill. It does not include an automatic migration script.
