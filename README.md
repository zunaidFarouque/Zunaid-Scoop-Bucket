# Zunaid-Scoop-Bucket

[![CI](https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket/actions/workflows/ci.yml/badge.svg)](https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket/actions/workflows/ci.yml) [![Excavator](https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket/actions/workflows/excavator.yml/badge.svg)](https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket/actions/workflows/excavator.yml)

Personal [Scoop](https://scoop.sh) bucket: custom app manifests that are not (or not yet) in the default buckets.

**Repository:** [github.com/zunaidFarouque/Zunaid-Scoop-Bucket](https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket)

## Install

```pwsh
scoop bucket add zunaid-scoop-bucket https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket
scoop install zunaid-scoop-bucket/<manifest-name>
```

Replace `<manifest-name>` with the JSON filename in [`bucket/`](bucket/) without the `.json` extension.

## Contributing / maintenance

- **AI assistants:** see [AGENTS.md](AGENTS.md) for how this repo is structured and how to add or change manifests safely.
- **Humans:** new manifests should follow the [Contributing Guide](https://github.com/ScoopInstaller/.github/blob/main/.github/CONTRIBUTING.md) and [App Manifests](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifests) wiki.

### GitHub Actions (required once per repo)

1. **Settings → Actions → General → Actions permissions:** allow all actions and reusable workflows, then save.
2. **Settings → Actions → General → Workflow permissions:** choose **Read and write permissions**, then save.

This enables CI and excavator-style automation from the upstream bucket template. After your first push, open the **CI** workflow on `main` and confirm it succeeds.

### Discoverability (optional)

To list this bucket on [scoop.sh](https://scoop.sh), add the GitHub topic **`scoop-bucket`** to the repository.

## License

Repository files from [ScoopInstaller/BucketTemplate](https://github.com/ScoopInstaller/BucketTemplate) are under [Unlicense](LICENSE). Individual application licenses are stated in each manifest’s `license` field.
