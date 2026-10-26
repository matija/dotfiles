# AGENTS.md

## Coding

Follow YAGNI principles.

When deleting code, leave no vestigial traces, whale legs, or references to the old implementation.

Never write a new unit test or integration test unless explicitly instructed. You may write new e2e or system level tests.

Never add new code comments.

Rather than dirty up the present working directory, put "temporary" work files in ./tmp if it exists or /tmp if it does not.

## Autonomy

Within the task I gave you, keep going: fix, retry, and take the next in-scope step yourself. Commit locally as you finish each logical unit, staging only files you changed. Ask before outward-facing actions I haven't requested, such as push, publish, deploy, messaging other people, or irreversible deletes.

End any turn that reports on long-running or delegated work with a short status: **Goal**, **Done**, **Next**, **Needs you** (or "nothing").

## Browser checks

Use Ego Lite for browser testing and visual checks of websites. Read
`~/.agents/skills/ego-browser/SKILL.md` before browser work. Check desktop
applications in their native app. Never install Playwright or its browser binaries.
When done using Ego, kill it.

## Running processes and tools

When starting external processes, don't leave them running when you're done.

## Version control

For projects under `~/dev/priv` push directly to the repository's existing default branch
(`main` or `master`).

## Commits

Keep commit message shorter than Twitter message: 280 characters for 
subject and body together.

- Write subject only. Do not add body.
- Add body only if user asks for one.
- Maximum 60 characters for subject.
- Do not explain cause, effect, or test results in the commit.
- Do not put ticket number in the message. Branch name has it.
- Write what change does, in active voice.

Same rules apply to pull request titles and descriptions.

