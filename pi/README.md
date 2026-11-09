# Shared Pi configuration

## Install

Install Pi before you apply this configuration. Clone this repository into `~/dev/priv/dotfiles` on each machine.

From the repository root, run:

```sh
python3 pi/setup.py
pi update --extensions
```

The setup command links these paths to the repository:

| Live path | Repository path |
| --- | --- |
| `~/.agents/AGENTS.md` | `agents/AGENTS.md` |
| `~/.agents/skills/<name>` | `agents/skills/<name>` |
| `~/.pi/agent/settings.json` | `pi/settings.json` |
| `~/.pi/agent/extensions` | `pi/extensions` |
| `~/.pi/agent/themes` | `pi/themes` |

The shared skills directory stays local. Each repository skill links into it, so app-managed skills can coexist outside the repository.

Pi's `AGENTS.md` and `skills` link to `~/.agents`. Pi's `mcp.json` links to the machine-local `~/.agents/mcp.json`, if present.

The setup command moves previous files into `~/.pi/backups/<timestamp>/`. It preserves credentials, custom model definitions, sessions, installed packages, and caches.

`auth.json`, `models.json`, and MCP credentials stay outside Git. Custom model definitions currently contain an API key.

## Receive changes

From the repository root, run:

```sh
git pull --ff-only
python3 pi/setup.py
pi update --extensions
```

Restart Pi after changes. The links expose repository changes directly, without a separate copy step.

## Send changes

Edit the live files or their repository targets. Both paths refer to the same files.

From the repository root, review and commit only the intended files:

```sh
git diff
git add pi/settings.json
git commit -m "Update Pi settings"
git push origin master
```

Replace the example path with the files you changed. On the other machine, receive changes before you make further edits.

`sync.sh` still imports unrelated application configuration. It skips paths that already link to their repository targets and copies shared agent links as file contents.

## Machine-specific integrations

Ego, Rex, and Esploro applications require separate installation.

Shared extensions load on both machines. Esploro connects only when you request it. Machine-specific credentials remain local.
