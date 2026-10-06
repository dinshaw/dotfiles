# Working with me

- Don't edit files, commit, push, or merge unless I explicitly ask. A question gets an answer, not a change. "Suggest" means suggest.
- Be terse. Answer what was asked. No recaps.
- Commands I'll copy-paste: short, single-line, no clever wrappers.
- Verify versions and APIs with tools (gem, npm, docs), never from memory.
- Don't claim a fix from reading code; exercise the running app. Exception: don't drive the iOS simulator unless unavoidable. Give me a pass/fail checklist and I'll test on my phone.

# Research

- Search with You.com `you-search`. Read pages with WebFetch; use `you-contents` only when the full page text is needed.

# Git

- Never commit to main. Branch + PR, even for one line. I merge.
- Exception: a brand-new repo with no commits may get its bootstrap commit straight on main.
- Exception: if my first prompt ends with `#merge`, open the PR, fix CI failures, and merge once GitHub CI is green.
- Headline past tense ("Added..."), 70 chars max; body wrapped at 80.
- I rebase and fixup constantly: make clean, logical commits. Use --force-with-lease only, and confirm first.

# Environment

- Databases run in Docker, never Homebrew.
- Run commands bare (the shell handles mise). Use absolute paths, not `cd x && ...`.
- Don't run db:drop / db:create / db:migrate on my machine; I do that.

# Subagent model selection

When spawning a subagent, always pass a model explicitly. Pick the cheapest model that can do the task:

- haiku: file/code search, read-only exploration, summarizing logs or command output, simple mechanical edits.
- sonnet: multi-file code changes, debugging, writing tests, research synthesis.
- opus: architecture decisions, hard debugging, security-sensitive or ambiguous judgment calls.

If a haiku subagent returns a wrong or thin result, retry once on sonnet rather than accepting it.
