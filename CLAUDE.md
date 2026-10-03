# CLAUDE.md

Default community health files for [@benbalter](https://github.com/benbalter)'s public repositories. GitHub shows these in any repository that lacks its own copy; see the [README](README.md) for the file list.

## Deploying

There's no build. Merging to the default branch changes the contributing guide, code of conduct, security policy, issue forms, and PR template that every inheriting repository shows, immediately. Get the owner's explicit go-ahead before merging.

## Commands

- CI runs [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2) on `**/*.md`. Check locally with `npx markdownlint-cli2 "**/*.md"`. Line length (MD013) is off; [`.github/.markdownlint.jsonc`](.github/.markdownlint.jsonc) also turns off the first-line-heading rule for the PR template.

## Gotchas

- Keep the files plain. GitHub serves them as-is in every repository, so per-repository placeholders show up as literal text. The old Ruby sync script that templated and copied these files was retired in [#8](https://github.com/benbalter/.github/pull/8); don't bring it back.
- A file only works as a default in the root, `.github/`, or `docs/`. Issue forms must live in `.github/ISSUE_TEMPLATE/`.
