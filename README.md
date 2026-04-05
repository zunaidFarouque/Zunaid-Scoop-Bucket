# Zunaid-Scoop-Bucket

[![CI](https://github.com/Zunaid/Zunaid-Scoop-Bucket/actions/workflows/ci.yml/badge.svg)](https://github.com/Zunaid/Zunaid-Scoop-Bucket/actions/workflows/ci.yml) [![Excavator](https://github.com/Zunaid/Zunaid-Scoop-Bucket/actions/workflows/excavator.yml/badge.svg)](https://github.com/Zunaid/Zunaid-Scoop-Bucket/actions/workflows/excavator.yml)

Personal [Scoop](https://scoop.sh) bucket: custom app manifests that are not (or not yet) in the default buckets.

## Publishing (first time on GitHub)

1. Create a **public** repository named `Zunaid-Scoop-Bucket` on GitHub under account **`Zunaid`** (or change the remote and replace `Zunaid` everywhere below with your owner name).
2. From this directory run: `git push -u origin main`
3. In the repo **Settings → Actions**, enable permissions as described in [GitHub Actions](#github-actions-required-once-per-repo) below.
4. Open the **CI** workflow run on `main` and confirm it succeeds.

If your GitHub username is not `Zunaid`, run `git remote set-url origin https://github.com/<you>/Zunaid-Scoop-Bucket.git` and update the badge URLs in this file, [`bin/auto-pr.ps1`](bin/auto-pr.ps1), and [`AGENTS.md`](AGENTS.md).

## Install

```pwsh
scoop bucket add zunaid-scoop-bucket https://github.com/Zunaid/Zunaid-Scoop-Bucket
scoop install zunaid-scoop-bucket/<manifest-name>
```

Replace `<manifest-name>` with the JSON filename in [`bucket/`](bucket/) without the `.json` extension.

## Contributing / maintenance

- **AI assistants:** see [AGENTS.md](AGENTS.md) for how this repo is structured and how to add or change manifests safely.
- **Humans:** new manifests should follow the [Contributing Guide](https://github.com/ScoopInstaller/.github/blob/main/.github/CONTRIBUTING.md) and [App Manifests](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifests) wiki.

### GitHub Actions (required once per repo)

1. **Settings → Actions → General → Actions permissions:** allow all actions and reusable workflows, then save.
2. **Settings → Actions → General → Workflow permissions:** choose **Read and write permissions**, then save.

This enables CI and excavator-style automation from the upstream bucket template.

### Discoverability (optional)

To list this bucket on [scoop.sh](https://scoop.sh), add the GitHub topic **`scoop-bucket`** to the repository.

## License

Repository files from [ScoopInstaller/BucketTemplate](https://github.com/ScoopInstaller/BucketTemplate) are under [Unlicense](LICENSE). Individual application licenses are stated in each manifest’s `license` field.
