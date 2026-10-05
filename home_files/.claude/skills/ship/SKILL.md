---
name: ship
description: Commit current work and open a PR. Use only when I run /ship.
disable-model-invocation: true
---

Ship the current work:

1. If on main (or the default branch), create a descriptively named branch first. Never commit to main.
2. Review `git status` and the diff. Group changes into clean, logical commits that rebase well, including my uncommitted changes. Headline past tense, 70 chars max; body wrapped at 80.
3. In a Rails repo, run rubocop and the specs relevant to the change. Skip system specs unless they cover the change. Fix failures before pushing.
4. Push the branch and open a PR with `gh pr create`: a short summary of what changed and why, and how it was tested.
5. Stop and give me the PR link. Do not merge.

If my request includes `#merge`: after opening the PR, watch GitHub CI (`gh pr checks --watch`), fix failures and push, and merge once all checks are green. Report the result.
