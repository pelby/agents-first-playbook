# Greenfield Setup

Use this path when you are setting up agent instructions for the first time.

## 1. Choose a neutral home

Use a vendor-neutral directory for shared agent instructions:

```text
~/.agents/
  AGENTS.md
  skills/
```

This directory is your durable source of truth. Tool-specific folders can point to it, but they should not become competing knowledge bases.

## 2. Create global instructions

Start with `templates/global-AGENTS.md` and adapt it:

```bash
mkdir -p ~/.agents
cp templates/global-AGENTS.md ~/.agents/AGENTS.md
```

Keep it small. Put stable but bulky details in referenced files.

## 3. Add tool adapters

Choose the adapter style that your tool handles reliably.

Symlink style:

```bash
ln -s ~/.agents/AGENTS.md ~/.claude/CLAUDE.md
ln -s ~/.agents/AGENTS.md ~/.codex/AGENTS.md
```

Import wrapper style:

```text
@../.agents/AGENTS.md
```

Use symlinks when you want identical behaviour. Use import wrappers when a tool does not follow symlinks reliably or when the tool expects a real file.

## 4. Create a workspace root

Point your agents at one workspace folder and keep most work underneath it:

```text
~/Workspaces/
  AGENTS.md
  code-projects/
  personal/
  company/
```

Copy `templates/workspace-AGENTS.md` into `~/Workspaces/AGENTS.md`.

## 5. Add project instructions only when needed

Most repos do not need much. Add `AGENTS.md` inside a project when it has real local conventions:

```text
example-project/
  AGENTS.md
```

Copy `templates/project-AGENTS.md` and edit only the sections that matter.

## 6. Validate in each tool

Open a fresh session in each agent and ask it:

```text
Which instruction files did you load? Summarize the hierarchy and do not change files.
```

For Claude Code, also check its memory/instruction view if available. For Codex, start in the workspace root and confirm it sees the workspace `AGENTS.md`. For Gemini CLI, confirm the context filename configuration if you are using `AGENTS.md` rather than the default context file.
