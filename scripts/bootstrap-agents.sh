#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF2'
Usage:
  bootstrap-agents.sh [TARGET_DIR]

Description:
  Create a single-source instruction setup in TARGET_DIR:
  - .agent-core/INSTRUCTIONS.md (source of truth)
  - AGENTS.md, CLAUDE.md, GEMINI.md, CODEX.md -> symlink to source
  - .agent-core/dsh deterministic shell wrapper

Environment overrides:
  AGENT_SYNC_INSTRUCTIONS_NAME   default: INSTRUCTIONS.md
  AGENT_SYNC_TZ                  default: UTC
  AGENT_SYNC_PATH                default: /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
EOF2
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

target_dir="${1:-.}"
mkdir -p "$target_dir"
target_dir="$(cd "$target_dir" && pwd)"

instructions_name="${AGENT_SYNC_INSTRUCTIONS_NAME:-INSTRUCTIONS.md}"
tz_value="${AGENT_SYNC_TZ:-UTC}"
path_value="${AGENT_SYNC_PATH:-/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin}"

core_dir="$target_dir/.agent-core"
src_file="$core_dir/$instructions_name"
dsh_file="$core_dir/dsh"

mkdir -p "$core_dir"

if [[ ! -e "$src_file" ]]; then
  cat > "$src_file" <<'EOF2'
# Shared Agent Instructions

This file is the single source of truth for Codex, Claude, and Gemini.
Edit this file only.
EOF2
fi

for name in AGENTS.md CLAUDE.md GEMINI.md CODEX.md; do
  ln -sfn ".agent-core/$instructions_name" "$target_dir/$name"
done

cat > "$dsh_file" <<EOF2
#!/usr/bin/env bash
set -euo pipefail

if [[ "\${1:-}" == "" ]]; then
  echo "Usage: .agent-core/dsh <command> [args...]" >&2
  exit 1
fi

umask 022

env -i \\
  HOME="$target_dir" \\
  SHELL="/bin/bash" \\
  PATH="$path_value" \\
  LANG="C.UTF-8" \\
  LC_ALL="C.UTF-8" \\
  TZ="$tz_value" \\
  bash --noprofile --norc -c '"\$@"' -- "\$@"
EOF2

chmod +x "$dsh_file"

echo "Bootstrapped: $target_dir"
echo "Source of truth: $src_file"
echo "Links: AGENTS.md CLAUDE.md GEMINI.md CODEX.md"
echo "Deterministic shell: $dsh_file"
