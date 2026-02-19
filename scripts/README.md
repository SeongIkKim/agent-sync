# agent-sync

`Codex`, `Claude`, `Gemini` instruction files can be unified with one source file and symlinks.

## Files created in a target project

- `.agent-core/INSTRUCTIONS.md` (single source of truth)
- `AGENTS.md -> .agent-core/INSTRUCTIONS.md`
- `CLAUDE.md -> .agent-core/INSTRUCTIONS.md`
- `GEMINI.md -> .agent-core/INSTRUCTIONS.md`
- `CODEX.md -> .agent-core/INSTRUCTIONS.md`
- `.agent-core/dsh` deterministic shell wrapper

## Usage

From this repository:

```bash
./scripts/agent-sync/bootstrap-agents.sh /path/to/your/project
./scripts/agent-sync/check-agents.sh /path/to/your/project
```

Install globally:

```bash
./scripts/agent-sync/install.sh
agent-sync-bootstrap /path/to/your/project
agent-sync-check /path/to/your/project
```

## Deterministic shell

`dsh` starts commands with:

- `env -i` (clean environment)
- fixed `PATH`, `LANG`, `LC_ALL`, `TZ`
- `umask 022`
- `bash --noprofile --norc`

Override defaults with env vars before bootstrap:

- `AGENT_SYNC_INSTRUCTIONS_NAME` (default: `INSTRUCTIONS.md`)
- `AGENT_SYNC_TZ` (default: `UTC`)
- `AGENT_SYNC_PATH` (default: `/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin`)

## Open-source publish suggestion

Make a small standalone repo with:

- `scripts/agent-sync/*.sh`
- this document as `README.md`
- `LICENSE` (MIT or Apache-2.0)
- a simple CI job that runs:
  - `shellcheck scripts/agent-sync/*.sh`
  - bootstrap/check on a temp directory
