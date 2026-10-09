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

Use installed Helium browser for visual checks of websites. Check desktop 
applications in their native app. Never install Playwright or its browser binaries.

# Background processes

Track every background process you start for a task. Stop it as soon as its
purpose is complete, and verify it exited before ending your turn. After an
interruption or change of direction, clean up processes from the abandoned
work when you resume. Leave a process running only when the user explicitly
asks for it, and report what is running and why. Preserve pre-existing user
processes.

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

