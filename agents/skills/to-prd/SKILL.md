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

A checklist of the work. An agent does the tasks in order.

### Task syntax — follow this exactly

Task tools read this file with a scanner that matches `^- \[[ x]\] `. A task
written any other way is invisible to them. Obey every rule below.

1. Start every task with `- [ ] ` at column 0. Use a hyphen. Never use an
   ordered list (`1. [ ]`), never `*` or `+`, never a heading, never a table
   row, never an indented bullet.
2. Write the punctuation exactly: hyphen, one space, `[`, one space, `]`, one
   space. Not `-[ ]`, not `- []`, not `- [ ]` with two spaces.
3. Put the whole task statement on that one physical line, in bold, and do not
   wrap it. The line may run past 80 characters. A scanner and a cold agent
   both read the first line only, so a wrapped statement loses its second half.
4. Never start the text with a counter. `**1. Add ...**` and `**Task 3:**` are
   wrong. The renderer already draws the checkbox and the ordering, so a
   leading `N.` prints as visible clutter beside it.
5. Give each task a stable handle at the END of the line instead, in the form
   ` (T1)`, ` (T2)`, and so on, after the closing `**`. This keeps the rendered
   line clean and still lets the rest of the PRD point at a task.
6. Refer to a task by its handle in prose: "the placement confirmed by T1".
   Do not write "task 1" or "the first task".
7. Make that bold line self-contained. Name the action and the outcome, so an
   agent can take the task cold without reading the rest of the document.
8. Indent the `Files` and `Check` sub-bullets by exactly two spaces, and indent
   their wrapped continuation lines by four.
9. Put one blank line between tasks.
10. Use `- [ ]` nowhere else in the PRD. Out of Scope, Further Notes, and the
   decision sections use plain bullets, so a checkbox count equals the task
   count.

Each task must give:

- The action and its outcome, on the bold line.
- The files or folders to edit or create, in a `Files` sub-bullet.
- A check that proves the task is done, in a `Check` sub-bullet: a test, a
  command, or an observable result.

<task-example>
- [ ] **Add the `balance` field to the account schema and generate the migration.** (T1)
  - Files: `src/db/schema/accounts.ts`, `src/db/migrations/`
  - Check: `npm run migrate` succeeds, and the new column exists.

- [ ] **Show the balance on the account card, formatted with the shared money helper.** (T2)
  - Files: `src/components/AccountCard.tsx`
  - Check: the test in `src/components/AccountCard.test.tsx` passes.
</task-example>

Open the section with a short "How to read this plan" paragraph: how a reader
takes a task, what the sub-bullets mean, what the `(T1)` handle is for, and
whether the order is strict.

If the plan has more than about twelve tasks, group them under `###` phase
headings. Give each phase a **Goal** line and a **Done when** line. Keep the
`(T1)`, `(T2)` handles running continuously across all phases.

To mark a task complete, change `[ ]` to `[x]` in `PRD.md`. Keep the file as
the record of progress.

### Verify before you finish

After you write `PRD.md`, run this and confirm the count equals the number of
tasks you intended:

```sh
grep -c '^- \[[ x]\] ' PRD.md
```

Then run both of these. Each must print nothing:

```sh
grep -n '^[[:space:]]*[0-9]\+\. \[' PRD.md
grep -n '^- \[[ x]\] \*\*[0-9]' PRD.md
```

The first hit means you wrote an ordered-list checkbox; convert it to `- [ ]`.
The second means you put a counter at the start of a task; move it to the end
as a ` (Tn)` handle.

## Out of Scope

A description of the things that are out of scope for this PRD.

## Further Notes

Any further notes about the feature.

</prd-template>
