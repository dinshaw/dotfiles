# Rails conventions

Import from a Rails repo's CLAUDE.md with: @~/.claude/rails.md

- Specs always, test-first preferred. Use the sign_in helper unless testing login itself.
- Write system specs for user-facing changes, but don't run system specs locally unless they cover the change. GitHub CI runs the full suite.
- Run rubocop + relevant specs before calling work done.
- Double quotes, 100-char lines, alphabetize arrays/hashes/params/constants.
- Migrations change schema only; data goes in seeds or rake tasks.
- Service objects: NounVerber, `call`, private attr_reader for injected deps.
