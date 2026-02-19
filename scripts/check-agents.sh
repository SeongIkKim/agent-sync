#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  check-agents.sh [TARGET_DIR]

Description:
  Validate shared instruction links and deterministic shell setup.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

target_dir="${1:-.}"
target_dir="$(cd "$target_dir" && pwd)"

src_file="$target_dir/.agent-core/INSTRUCTIONS.md"
dsh_file="$target_dir/.agent-core/dsh"

if [[ ! -f "$src_file" ]]; then
  echo "Missing source file: $src_file" >&2
  exit 1
fi

if [[ ! -x "$dsh_file" ]]; then
  echo "Missing executable deterministic shell: $dsh_file" >&2
  exit 1
fi

if command -v shasum >/dev/null 2>&1; then
  hash_cmd='shasum -a 256'
elif command -v sha256sum >/dev/null 2>&1; then
  hash_cmd='sha256sum'
else
  echo "Need shasum or sha256sum installed" >&2
  exit 1
fi

src_hash="$($hash_cmd "$src_file" | awk '{print $1}')"

for name in AGENTS.md CLAUDE.md GEMINI.md CODEX.md; do
  path="$target_dir/$name"
  if [[ ! -L "$path" ]]; then
    echo "Not a symlink: $path" >&2
    exit 1
  fi
  resolved="$(cd "$(dirname "$path")" && pwd)/$(readlink "$path")"
  if [[ ! -f "$resolved" ]]; then
    echo "Broken symlink: $path -> $(readlink "$path")" >&2
    exit 1
  fi
  target_hash="$($hash_cmd "$resolved" | awk '{print $1}')"
  if [[ "$target_hash" != "$src_hash" ]]; then
    echo "Hash mismatch: $path" >&2
    exit 1
  fi
done

shell_probe="$("$dsh_file" env | grep -E '^(PATH|LANG|LC_ALL|TZ)=' | sort)"
echo "$shell_probe"

if ! echo "$shell_probe" | grep -E '^LANG=C.UTF-8$' >/dev/null; then
  echo "LANG is not deterministic" >&2
  exit 1
fi
if ! echo "$shell_probe" | grep -E '^LC_ALL=C.UTF-8$' >/dev/null; then
  echo "LC_ALL is not deterministic" >&2
  exit 1
fi

echo "OK: links and deterministic shell verified for $target_dir"
