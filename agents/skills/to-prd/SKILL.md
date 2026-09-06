---
name: to-prd
description: Turn current conversation context into a PRD and create tasks inside of the PRD.md file. Use when user wants to create a PRD from the current context.
---

Skill takes current conversation context and codebase understanding and produces PRD. Do NOT interview user — synthesize what you already know.

Issue tracking done as tasks inside PRD.md.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already. Use the project's domain glossary vocabulary throughout the PRD, and respect any ADRs in the area you're touching.

2. Decide where you connect the tests to the feature. Prefer the places where tests already connect. Connect at the highest level that you can. If you need a new place, propose it at the highest level possible.

Check with the user that these places match their expectations.

3. Write the PRD to `PRD.md` in the project root, with the template below. Do not open issues in GitHub or Jira. The task list in `PRD.md` is the only issue tracker for this PRD.

<prd-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

This list of user stories should be extremely extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Name the modules, not the files. Put the file paths in the Tasks section, where an agent needs them. Do NOT include code snippets here.

Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it within the relevant decision and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Tasks

A numbered checklist of the work. An agent does the tasks in order. Each task
must give:

- The action, in one sentence.
- The files or folders to edit or create.
- A check that shows the task is complete (a test, a command, or an observable result).

<task-example>
1. [ ] Add the `balance` field to the account schema.
   - Files: `src/db/schema/accounts.ts`, `src/db/migrations/`
   - Check: `npm run migrate` succeeds, and the new column exists.
2. [ ] Show the balance on the account card.
   - Files: `src/components/AccountCard.tsx`
   - Check: the test in `src/components/AccountCard.test.tsx` passes.
</task-example>

To mark a task complete, change `[ ]` to `[x]` in `PRD.md`. Keep the file as
the record of progress.

## Out of Scope

A description of the things that are out of scope for this PRD.

## Further Notes

Any further notes about the feature.

</prd-template>
