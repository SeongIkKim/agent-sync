# agent-sync

Unify agent instruction files (`Codex`, `Claude`, `Gemini`) behind one source of truth.

## What it does

For any target project, `agent-sync` creates:

- `.agent-core/INSTRUCTIONS.md` (single source of truth)
- `AGENTS.md -> .agent-core/INSTRUCTIONS.md`
- `CLAUDE.md -> .agent-core/INSTRUCTIONS.md`
- `GEMINI.md -> .agent-core/INSTRUCTIONS.md`
- `CODEX.md -> .agent-core/INSTRUCTIONS.md`
- `.agent-core/dsh` deterministic shell wrapper

## Quick start

```bash
# from this repo
./scripts/bootstrap-agents.sh /path/to/project
./scripts/check-agents.sh /path/to/project
```

## Global install (local)

```bash
./scripts/install.sh
agent-sync-bootstrap /path/to/project
agent-sync-check /path/to/project
```

## Homebrew

Option A: install directly from formula URL

```bash
brew install --HEAD https://raw.githubusercontent.com/SeongIkKim/agent-sync/main/Formula/agent-sync.rb
```

Option B: tap then install

```bash
brew tap SeongIkKim/agent-sync https://github.com/SeongIkKim/agent-sync
brew install --HEAD agent-sync
```

## Deterministic shell

`dsh` runs commands with:

- `env -i`
- fixed `PATH`, `LANG`, `LC_ALL`, `TZ`
- `umask 022`
- `bash --noprofile --norc`

Override defaults during bootstrap:

- `AGENT_SYNC_INSTRUCTIONS_NAME` (default: `INSTRUCTIONS.md`)
- `AGENT_SYNC_TZ` (default: `UTC`)
- `AGENT_SYNC_PATH` (default: `/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin`)

## License

MIT
