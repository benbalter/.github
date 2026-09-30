# Default community health files

This is [@benbalter](https://github.com/benbalter)'s `.github` repository. GitHub uses the files here as [defaults for any of @benbalter's public repositories](https://docs.github.com/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file) that don't have their own copy.

| File | Purpose |
| --- | --- |
| [`docs/CONTRIBUTING.md`](docs/CONTRIBUTING.md) | Contributing guidelines |
| [`docs/CODE_OF_CONDUCT.md`](docs/CODE_OF_CONDUCT.md) | Contributor Covenant 2.1 |
| [`docs/SECURITY.md`](docs/SECURITY.md) | How to report vulnerabilities |
| [`.github/ISSUE_TEMPLATE/`](.github/ISSUE_TEMPLATE/) | Bug report and feature request issue forms |
| [`.github/pull_request_template.md`](.github/pull_request_template.md) | Pull request checklist |
| [`.github/funding.yml`](.github/funding.yml) | Sponsor button |

A repository that has its own version of a file (in its root, `.github/`, or `docs/`) uses that instead of the default here.

These files are plain, not templated with per-repository values, because GitHub shows them as-is in every repository that inherits them.

This repository used to hold a Ruby script that synced templated copies of these files, app installations, and branch protection to a list of repositories. That script was retired in favor of GitHub's built-in inheritance. It's still in the git history if you need it.
