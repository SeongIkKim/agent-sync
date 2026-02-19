#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  install.sh [BIN_DIR]

Description:
  Install agent-sync commands into BIN_DIR (default: ~/.local/bin):
  - agent-sync-bootstrap
  - agent-sync-check
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bin_dir="${1:-$HOME/.local/bin}"
mkdir -p "$bin_dir"

ln -sfn "$script_dir/bootstrap-agents.sh" "$bin_dir/agent-sync-bootstrap"
ln -sfn "$script_dir/check-agents.sh" "$bin_dir/agent-sync-check"

chmod +x "$script_dir/bootstrap-agents.sh" "$script_dir/check-agents.sh" "$script_dir/install.sh"

echo "Installed:"
echo "  $bin_dir/agent-sync-bootstrap -> $script_dir/bootstrap-agents.sh"
echo "  $bin_dir/agent-sync-check     -> $script_dir/check-agents.sh"
echo
echo "If needed, add to PATH:"
echo "  export PATH=\"$bin_dir:\$PATH\""
