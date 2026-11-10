# Codex Jev alerts

Jev checks recent Codex conversation text and tool output for consequential mistakes, unsupported claims, data loss, and security risks.
Luna writes a short warning when Jev's warning probability reaches 0.85.
The observer shares Pi's classifier and reviewer. It uses the installed Pi runtime and existing subscription credentials.
It does not start another agent or give the reviewer tools.

The design follows upstream [PR #849](https://github.com/nateberkopec/dotfiles/pull/849).
Later upstream changes retained Jev and Luna. The author removed the entire observer in [PR #908](https://github.com/nateberkopec/dotfiles/pull/908).
This checkout keeps the two-stage design and uses your existing Pi subscription for Luna.

`PostToolUse` checks in the background, at most once every 30 seconds per session.
`Stop` waits for pending checks and checks the final response. It only shows warnings.
Neither hook requests corrections, changes tool results, or blocks actions.
The automatic correction code remains commented out in `jev/observer.mjs`.

## Install or receive changes

Install Node.js 24, Pi, and a Codex version with lifecycle hooks.
Use Pi's `/login` command for the `openai-codex` subscription and `typesafe` API key.
Alternatively, export `TYPESAFE_API_KEY` before you start Codex.
Credentials stay in the environment or machine-local `~/.pi/agent/auth.json`.

From the repository root, run:

```sh
git pull --ff-only
python3 codex/setup.py
```

Start a new Codex session. Open `/hooks` and trust the Jev `PostToolUse` and `Stop` hooks.
In the desktop app, use Settings > Hooks.
The installer preserves other hooks and backs up changed files under `~/.codex/backups/`.
It links `~/.codex/jev` and `~/.local/bin/codex-jev` to this checkout.
Later repository changes appear through those links.
The installer does not copy hook trust decisions between machines.

## Control alerts

```sh
codex-jev off
codex-jev on
codex-jev status
```

The switch takes effect on the next hook call, without a restart.
It also suppresses results from checks that finish after you turn alerts off.
The switch stays local to this machine. It does not affect Pi or other Codex hooks.
If `~/.local/bin` is absent from PATH, use `node ~/.codex/jev/observer.mjs off`.

Shared defaults are in `jev/settings.json`.

## Check the providers

```sh
codex-jev test
```

This command sends a synthetic failed-test conversation to real Jev and Luna providers. Normal provider charges and subscription usage apply.
It does not read project files or the current Codex conversation.
The command succeeds only when the providers produce a warning.

## Data and limitations

The observer sends up to 24,000 characters of recent conversation text and tool output to Jev.
Luna receives the same text only after Jev flags a concern.
Images, reasoning, and developer instructions are excluded from transcript messages.
Ordinary text can still contain sensitive data.
The local state under `~/.codex/state/jev` stores hashes, the previous warning, and usage. It does not store transcript text.

Alerts are advisory and can miss mistakes.
Provider errors produce an unavailable warning, never a successful verification claim.
Background alerts appear at Codex's next safe point. The final check can delay the end of a turn.
Codex's transcript format can change. Run the self-test after provider upgrades and check transcript compatibility after Codex upgrades.

Hook behavior and trust requirements follow the [official OpenAI documentation](https://learn.chatgpt.com/docs/hooks).
