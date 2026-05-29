#!/usr/bin/env bash
set -eu

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPT="$ROOT_DIR/scripts/inspect-agent-config.sh"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

assert_contains() {
  file="$1"
  text="$2"
  if ! grep -Fq "$text" "$file"; then
    echo "Expected to find: $text" >&2
    echo "--- output ---" >&2
    cat "$file" >&2
    exit 1
  fi
}

make_base() {
  scenario="$1"
  home="$TMP_DIR/$scenario/home"
  workspace="$home/Workspaces"
  mkdir -p "$home" "$workspace"
}

run_scenario() {
  scenario="$1"
  home="$TMP_DIR/$scenario/home"
  workspace="$home/Workspaces"
  output="$TMP_DIR/$scenario.out"
  "$SCRIPT" --home "$home" --workspace "$workspace" > "$output"
  echo "$output"
}

bash -n "$SCRIPT"

make_base greenfield
greenfield_out="$(run_scenario greenfield)"
assert_contains "$greenfield_out" "MISSING neutral global AGENTS.md"
assert_contains "$greenfield_out" "Inspection complete. No files were modified."

make_base claude-first
mkdir -p "$home/.claude" "$home/.codex"
printf '%s\n' "# Claude" > "$home/.claude/CLAUDE.md"
ln -s ../.claude/CLAUDE.md "$home/.codex/AGENTS.md"
ln -s .claude "$home/.agents"
claude_first_out="$(run_scenario claude-first)"
assert_contains "$claude_first_out" "HINT neutral home points into Claude config"
assert_contains "$claude_first_out" "HINT Codex global instructions point through Claude"

make_base agents-first
mkdir -p "$home/.agents" "$home/.claude" "$home/.codex"
printf '%s\n' "# Agents" > "$home/.agents/AGENTS.md"
ln -s ../.agents/AGENTS.md "$home/.claude/CLAUDE.md"
ln -s ../.agents/AGENTS.md "$home/.codex/AGENTS.md"
printf '%s\n' "# Workspace" > "$workspace/AGENTS.md"
ln -s AGENTS.md "$workspace/CLAUDE.md"
agents_first_out="$(run_scenario agents-first)"
assert_contains "$agents_first_out" "OK file neutral global AGENTS.md"
assert_contains "$agents_first_out" "OK symlink Claude global CLAUDE.md"
assert_contains "$agents_first_out" "No obvious real-file adapter conflicts found"

make_base broken-symlink
mkdir -p "$home/.claude"
ln -s missing.md "$home/.claude/CLAUDE.md"
broken_out="$(run_scenario broken-symlink)"
assert_contains "$broken_out" "BROKEN symlink Claude global CLAUDE.md"

make_base conflicting-real-files
mkdir -p "$home/.agents" "$home/.claude" "$home/.codex"
printf '%s\n' "# Agents" > "$home/.agents/AGENTS.md"
printf '%s\n' "# Claude" > "$home/.claude/CLAUDE.md"
printf '%s\n' "# Codex" > "$home/.codex/AGENTS.md"
printf '%s\n' "# Workspace" > "$workspace/AGENTS.md"
printf '%s\n' "# Claude Workspace" > "$workspace/CLAUDE.md"
conflict_out="$(run_scenario conflicting-real-files)"
assert_contains "$conflict_out" "CONFLICT global Claude adapter"
assert_contains "$conflict_out" "CONFLICT global Codex adapter"
assert_contains "$conflict_out" "CONFLICT workspace Claude adapter"

echo "All tests passed"
