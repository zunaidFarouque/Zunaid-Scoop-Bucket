# Agent playbook: Zunaid-Scoop-Bucket

This file is for automated assistants (and humans) who add or update Scoop manifests in this repository.

## Repository role

- **Type:** Personal public Scoop bucket.
- **Manifests:** One JSON file per app under [`bucket/`](bucket/). The file basename (without `.json`) is the **package name** Scoop uses (`scoop install <bucket>/<basename>`).
- **Template:** Copy [`bucket/app-name.json.template`](bucket/app-name.json.template) to `bucket/<app>.json`, then fill in real values and **delete** keys you do not need (empty strings and unused blocks break or clutter manifests).

## Authoritative documentation

- [App Manifests (wiki)](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifests) — field reference and examples.
- [Contributing Guide](https://github.com/ScoopInstaller/.github/blob/main/.github/CONTRIBUTING.md) — expectations for manifests, licensing, and checklists.
- Upstream template reference: [ScoopInstaller/BucketTemplate](https://github.com/ScoopInstaller/BucketTemplate).

## Before adding a package

1. **Search existing buckets** ([Main](https://github.com/ScoopInstaller/Main/tree/master/bucket), [Extras](https://github.com/ScoopInstaller/Extras/tree/master/bucket), [Known buckets](https://github.com/ScoopInstaller/Scoop/blob/master/buckets.json)) so you do not duplicate an app unless this bucket intentionally provides a different build or fork.
2. Confirm **homepage**, **official download URL**, and **license** from the vendor’s site or release assets.

## Manifest rules (short)

- **`license` is required** — SPDX id when possible ([SPDX list](https://spdx.org/licenses/)); otherwise values like `Freeware`, `Proprietary`, `Unknown`, or a `license` URL as documented in the wiki.
- **`version`**, **`description`**, **`homepage`** are standard for almost all apps.
- **`url` + `hash`:** Prefer **SHA256** (`hash` field, or per-architecture under `architecture`). Compute with `scoop hash <file>` after downloading the same URL the manifest uses, or `Get-FileHash -Algorithm SHA256` in PowerShell.
- **`bin`:** Shims for executables; use an array for multiple binaries or aliases per wiki examples.
- **`architecture`:** Use when 32-bit, 64-bit, or arm64 URLs differ.
- **`checkver` / `autoupdate`:** Add when releases follow a predictable URL pattern so [Excavator](https://github.com/ScoopInstaller/BucketTemplate/blob/master/.github/workflows/excavator.yml) (or similar automation) can propose version bumps. Match patterns to the real release page or API the app uses.

Keep JSON **valid**: no comments except the `"##"` template note (remove that key in real manifests), no trailing commas, UTF-8 encoding. Respect [`.editorconfig`](.editorconfig).

## Local validation

1. Install [Scoop](https://scoop.sh) on Windows.
2. **Option A — path install:** `scoop install path\to\bucket\app.json` (use the path to the manifest under this repo).
3. **Option B — bucket install:** `scoop bucket add zunaid-scoop-bucket https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket` then `scoop install zunaid-scoop-bucket/<app>`.
4. **Automated tests (same as CI):** Clone [ScoopInstaller/Scoop](https://github.com/ScoopInstaller/Scoop), set `$env:SCOOP_HOME` to that directory, then run [`bin/test.ps1`](bin/test.ps1) from the bucket root. GitHub Actions runs this under Windows PowerShell and **pwsh** (see [`.github/workflows/ci.yml`](.github/workflows/ci.yml)).

Fix any **Pester** / manifest lint failures before pushing.

## Repo-specific configuration

- **Git remote:** `https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket.git` — if the GitHub owner or repo name changes, update [`README.md`](README.md) badges and install commands, and [`bin/auto-pr.ps1`](bin/auto-pr.ps1) (`$upstream = "Owner/Repo:main"`).
- **Bucket short name in docs:** `zunaid-scoop-bucket` (the name users pass to `scoop bucket add`). If you rename it, update **README.md** and examples here.

## Pull request hygiene

- Prefer **one application (or one logical change) per PR**.
- Mention **source URL**, **license**, and any **vendor EULA** quirks in the PR description when relevant.

## Do not

- Commit secrets, API keys, or paid download tokens into manifests.
- Remove or weaken CI workflows unless the maintainer explicitly wants a non-standard setup.
