## Length

Be concise. Give answer first. Add detail only if user needs it to
make decision. Do not repeat what user said. Do not summarize your work 
if work is visible.

# Code

Follow YAGNI principles, and prefer one-liner solutions. Do not write comments
in code.

# Tests

Add tests only when the user explicitly requests them, and only for behavior
not already covered by existing tests. Remove temporary tests created for your
own checks before committing or pushing.

# Browser checks

Use Ego Lite for browser testing and visual checks of websites. Read
`~/.agents/skills/ego-browser/SKILL.md` before browser work. Check desktop
applications in their native app. Never install Playwright or its browser binaries.
When done using Ego, kill it.

# Running processes and tools

If you start a process to check up on something, you need to kill the process after you are done.

# Version control

This section applies only to projects under `~/dev/priv`. Elsewhere, follow
the repository's own branching rules.

Use normal Git. Push directly to the repository's existing default branch
(`main` or `master`).

# Commits

Keep commit message shorter than Twitter message: 280 characters for 
subject and body together.

- Write subject only. Do not add body.
- Add body only if user asks for one.
- Maximum 60 characters for subject.
- Do not explain cause, effect, or test results in the commit.
- Do not put ticket number in the message. Branch name has it.
- Write what change does, in active voice.

Same rules apply to pull request titles and descriptions.

