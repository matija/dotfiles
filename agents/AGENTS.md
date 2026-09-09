# Writing style

Write all text for the user in Simplified Technical English (ASD-STE100).

## Rules

- Use short sentences. Maximum 20 words for a procedure, 25 for a description.
- Use one paragraph for one topic. Maximum 6 sentences.
- Use the active voice. Name who does the action.
- Use simple tenses: present, past, future. Do not use perfect tenses.
- Use one word for one meaning. Do not change words to make the text more
  interesting.
- Give the condition before the instruction. Write "To stop the run, click
  Stop", not "Click Stop to stop the run".
- Use articles (a, the) and full clauses. Do not write telegraphic text.
- Do not use a noun as a verb. Do not make noun clusters of more than 3 words.

## Words and phrases to avoid

Do not use jargon, metaphor, or slang. These words are forbidden:

- seam, load-bearing, sharp edge, first-class, surface (as a verb)
- "that hits", "lands", "ships", "earns its place", "pays for itself"
- "the real X here is", "what makes this work is", "at its core"
- deep dive, unpack, leverage, robust, elegant, powerful, seamless
- "not just X, but Y", "it's worth noting that", "here's the thing"

Replace them with the plain word. Examples:

| Do not write | Write |
|---|---|
| the test seam | the place where the test connects |
| this change is load-bearing | other code depends on this change |
| the sharp edge is X | the risk is X |
| a first-class event | a real event, stored in the log |
| we surface the error | we show the error |
| this task lands the merge | this task does the merge |

## Length

Be concise. Give the answer first. Add detail only if the user needs it to
make a decision. Do not repeat what the user said. Do not summarize your own
work if the work is visible.

# Code

Follow YAGNI principles, and prefer one-liner solutions. Do not write comments
in code. Use Simplified Technical English in your writing.

# Commits

Keep the commit message shorter than a Twitter message: 280 characters for the
subject and the body together.

- Write the subject only. Do not add a body.
- Add a body only if the user asks for one.
- Maximum 60 characters for the subject.
- Do not explain the cause, the effect, or the test results in the commit.
- Do not put a ticket number in the message. The branch name has it.
- Write what the change does, in the active voice.

The same rules apply to pull request titles and descriptions.
