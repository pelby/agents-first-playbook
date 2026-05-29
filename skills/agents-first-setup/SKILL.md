---
name: agents-first-setup
description: Use when setting up or migrating a tool-neutral AI agent configuration where AGENTS.md is the canonical instruction file and Claude, Codex, Gemini CLI, or other agents use adapters. Guides inventory, classification, planning, migration, validation, and privacy review.
---

# Agents-First Setup

Use this skill to help a user set up or migrate to an AGENTS-first agent configuration.

## Core rule

Shared durable behaviour belongs in `AGENTS.md` or `.agents`. Tool-specific folders are adapters or runtime state, not competing sources of truth.

## Workflow

1. Inventory before changing anything.
   - Inspect `~/.agents`, `~/.claude`, `~/.codex`, `~/.gemini`, and the workspace root.
   - Identify real files, symlinks, broken links, runtime folders, and conflicting canonical files.

2. Classify each item.
   - Shared instruction: move toward `AGENTS.md`.
   - Shared workflow: move toward `.agents/`.
   - Adapter: keep thin and tool-specific.
   - Runtime: keep in the owning tool folder.
   - Manual review: hooks, commands, settings, generated scripts.

3. Plan the smallest safe migration.
   - Prefer global and workspace instruction files first.
   - Defer skills, hooks, commands, and settings unless the user explicitly approves.
   - Include rollback points.

4. Implement only after approval.
   - Preserve unrelated changes.
   - Avoid broad destructive commands.
   - Prefer explicit file paths.

5. Validate in every target tool.
   - Confirm instructions load.
   - Confirm adapters do not conflict.
   - Confirm runtime state was not moved into shared config.

6. Privacy review before publishing.
   - Do not publish real private config.
   - Scan for emails, tokens, private names, local paths, logs, memories, and tool inventories.

## Use the repo docs

- Greenfield setup: `GREENFIELD.md`
- Existing setup migration: `MIGRATION.md`
- Paired agent process: `PAIRED-AGENT-PROTOCOL.md`
- Privacy review: `SECURITY-AND-PRIVACY.md`
- Pasteable prompts: `prompts/`
