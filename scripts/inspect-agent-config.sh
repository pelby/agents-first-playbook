#!/usr/bin/env bash
set -u

HOME_DIR="$HOME"
WORKSPACE_DIR="$HOME/Workspaces"

usage() {
  cat <<'USAGE'
Usage: inspect-agent-config.sh [--home PATH] [--workspace PATH]

Read-only inspection of common agent instruction files and adapters.
The script reports paths and link targets only. It does not print file contents.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --home)
      if [ "$#" -lt 2 ]; then
        echo "Missing value for --home" >&2
        exit 2
      fi
      HOME_DIR="$2"
      shift 2
      ;;
    --workspace)
      if [ "$#" -lt 2 ]; then
        echo "Missing value for --workspace" >&2
        exit 2
      fi
      WORKSPACE_DIR="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

report_path() {
  path="$1"
  label="$2"

  if [ -L "$path" ]; then
    target="$(readlink "$path")"
    if [ -e "$path" ]; then
      echo "OK symlink $label: $path -> $target"
    else
      echo "BROKEN symlink $label: $path -> $target"
    fi
  elif [ -f "$path" ]; then
    echo "OK file $label: $path"
  elif [ -d "$path" ]; then
    echo "OK directory $label: $path"
  else
    echo "MISSING $label: $path"
  fi
}

is_regular_file() {
  [ -f "$1" ] && [ ! -L "$1" ]
}

is_symlink() {
  [ -L "$1" ]
}

section() {
  echo
  echo "== $1 =="
}

section "Global instruction files"
report_path "$HOME_DIR/.agents" "neutral config home"
report_path "$HOME_DIR/.agents/AGENTS.md" "neutral global AGENTS.md"
report_path "$HOME_DIR/.claude" "Claude config home"
report_path "$HOME_DIR/.claude/CLAUDE.md" "Claude global CLAUDE.md"
report_path "$HOME_DIR/.claude/AGENTS.md" "Claude AGENTS alias"
report_path "$HOME_DIR/.codex" "Codex config home"
report_path "$HOME_DIR/.codex/AGENTS.md" "Codex global AGENTS.md"
report_path "$HOME_DIR/.gemini" "Gemini config home"
report_path "$HOME_DIR/.gemini/GEMINI.md" "Gemini context file"
report_path "$HOME_DIR/.gemini/AGENTS.md" "Gemini AGENTS adapter"

section "Workspace instruction files"
report_path "$WORKSPACE_DIR" "workspace root"
report_path "$WORKSPACE_DIR/AGENTS.md" "workspace AGENTS.md"
report_path "$WORKSPACE_DIR/CLAUDE.md" "workspace CLAUDE.md"
report_path "$WORKSPACE_DIR/GEMINI.md" "workspace GEMINI.md"

section "Likely conflicts"
conflict_count=0

check_conflict() {
  canonical="$1"
  adapter="$2"
  name="$3"

  if is_regular_file "$canonical" && is_regular_file "$adapter"; then
    echo "CONFLICT $name: both files are real files, review for duplicated instructions"
    conflict_count=$((conflict_count + 1))
  fi
}

check_conflict "$HOME_DIR/.agents/AGENTS.md" "$HOME_DIR/.claude/CLAUDE.md" "global Claude adapter"
check_conflict "$HOME_DIR/.agents/AGENTS.md" "$HOME_DIR/.codex/AGENTS.md" "global Codex adapter"
check_conflict "$WORKSPACE_DIR/AGENTS.md" "$WORKSPACE_DIR/CLAUDE.md" "workspace Claude adapter"
check_conflict "$WORKSPACE_DIR/AGENTS.md" "$WORKSPACE_DIR/GEMINI.md" "workspace Gemini adapter"

if [ "$conflict_count" -eq 0 ]; then
  echo "No obvious real-file adapter conflicts found"
fi

section "Ownership hints"
if is_symlink "$HOME_DIR/.agents" && readlink "$HOME_DIR/.agents" | grep -q ".claude"; then
  echo "HINT neutral home points into Claude config; consider flipping ownership so ~/.agents is real"
fi

if is_symlink "$HOME_DIR/.codex/AGENTS.md" && readlink "$HOME_DIR/.codex/AGENTS.md" | grep -q ".claude"; then
  echo "HINT Codex global instructions point through Claude; consider pointing to ~/.agents/AGENTS.md"
fi

if is_symlink "$WORKSPACE_DIR/AGENTS.md" && readlink "$WORKSPACE_DIR/AGENTS.md" | grep -q "CLAUDE.md"; then
  echo "HINT workspace AGENTS.md points to CLAUDE.md; consider making AGENTS.md canonical"
fi

section "Runtime folders to keep tool-specific"
for path in \
  "$HOME_DIR/.claude/projects" \
  "$HOME_DIR/.claude/sessions" \
  "$HOME_DIR/.claude/logs" \
  "$HOME_DIR/.codex/sessions" \
  "$HOME_DIR/.codex/logs" \
  "$HOME_DIR/.gemini/tmp"; do
  if [ -e "$path" ]; then
    echo "RUNTIME keep tool-specific: $path"
  fi
done

section "Automation surfaces to review"
report_path "$HOME_DIR/Library/LaunchAgents" "macOS user LaunchAgents"
report_path "/Library/LaunchAgents" "macOS system LaunchAgents"
report_path "/Library/LaunchDaemons" "macOS system LaunchDaemons"
report_path "$HOME_DIR/bin" "user bin directory"
report_path "$HOME_DIR/.local/bin" "user local bin directory"
report_path "$HOME_DIR/.config/systemd/user" "systemd user units"
report_path "$HOME_DIR/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup" "Windows startup folder"
echo "NOTE cron, systemd timers, Windows Task Scheduler jobs, and app-managed launch jobs may require platform-specific read-only inspection."
echo "NOTE review job definitions manually; this script does not print scheduled job contents."

section "Done"
echo "Inspection complete. No files were modified."
