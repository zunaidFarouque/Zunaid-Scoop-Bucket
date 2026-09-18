# Zunaid-Scoop-Bucket

[![CI](https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket/actions/workflows/ci.yml/badge.svg)](https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket/actions/workflows/ci.yml) [![Excavator](https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket/actions/workflows/excavator.yml/badge.svg)](https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket/actions/workflows/excavator.yml) [![Sync visioflow](https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket/actions/workflows/sync-visioflow.yml/badge.svg)](https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket/actions/workflows/sync-visioflow.yml) [![Sync processsentinel](https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket/actions/workflows/sync-processsentinel.yml/badge.svg)](https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket/actions/workflows/sync-processsentinel.yml)

Personal [Scoop](https://scoop.sh) bucket: custom app manifests that are not (or not yet) in the default buckets.

**Repository:** [github.com/zunaidFarouque/Zunaid-Scoop-Bucket](https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket)

## Install

```pwsh
scoop bucket add zunaid-scoop-bucket https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket
scoop install zunaid-scoop-bucket/<manifest-name>
```

Replace `<manifest-name>` with the JSON filename in [`bucket/`](bucket/) without the `.json` extension.

### Available packages

#### Featured projects (created / maintained by me)

1. **visioflow** — Visual payload router for QR capture and automation ([VisioFlow-QR](https://github.com/zunaidFarouque/VisioFlow-QR)). The Scoop manifest is maintained in that repo and [synced into this bucket](.github/workflows/sync-visioflow.yml) automatically.

   ```pwsh
   scoop install zunaid-scoop-bucket/visioflow
   ```

2. **processsentinel** — Modular rule-based Windows watchdog engine and modern desktop dashboard ([ProcessSentinel](https://github.com/zunaidFarouque/ProcessSentinel)). The Scoop manifest is maintained in that repo and [synced into this bucket](.github/workflows/sync-processsentinel.yml) automatically.

   ```pwsh
   scoop install zunaid-scoop-bucket/processsentinel
   ```

3. **taskbarmediacontrols-plus** — Taskbar media controls for Windows 10 and 11 with plus fork improvements ([TaskbarMediaControls-Plus](https://github.com/zunaidFarouque/TaskbarMediaControls-Plus)).

   ```pwsh
   scoop install zunaid-scoop-bucket/taskbarmediacontrols-plus
   ```

#### Other packages

There are also several other useful packages maintained in this bucket that were not originally created by me:

- **calcpad-ce** — Open-source engineering worksheet editor with real-time rendered math output ([CalcpadCE](https://github.com/imartincei/CalcpadCE)).
- **chataigne** — Modular OSC / MIDI / DMX control software for interactive and live projects ([Chataigne](https://benjamin.kuperberg.fr/chataigne/en)).
- **everyone-piano** — Virtual piano keyboard software ([Everyone Piano](https://www.everyonepiano.com/)).
- **flexasio-gui** — Configuration GUI for FlexASIO audio driver ([FlexASIO GUI](https://github.com/flipswitchingmonkey/FlexASIO_GUI)).
- **fps-overlay** — Lightweight, no-bloat FPS overlay for Windows games ([fps-overlay](https://github.com/aneeskhan47/fps-overlay)).
- **harmony-music** — Cross-platform music streaming app for YouTube Music and local audio ([Harmony Music](https://github.com/anandnet/Harmony-Music)).
- **hotkey-screener** — System-wide hotkey enumeration and conflict detection tool ([HotkeyScreener](https://github.com/bozbez/HotkeyScreener)).
- **koord-asio-np** — Universal multi-client ASIO driver installer (`-np`) ([KoordASIO](https://github.com/koord-live/KoordASIO)).
- **loopmidi-np** — Virtual loopback MIDI cable driver installer (`-np`) ([loopMIDI](https://www.tobias-erichsen.de/software/loopmidi.html)).
- **protokol** — MIDI, OSC, and Art-Net monitor and diagnostic tool ([Protokol](https://hexler.net/protokol)).
- **rapidraw** — Fast, non-destructive, GPU-accelerated RAW image editor ([RapidRAW](https://github.com/RapidRAW/RapidRAW)).
- **scratch-md** — Minimalist, offline-first Markdown note-taking app ([scratch-md](https://github.com/marchellodev/scratch-md)).

### Non-portable packages (`-np`)

Manifests whose names end with **`-np`** only **automate** the vendor setup: download, hash check, silent install. The app then lives entirely under **Program Files** (or equivalent) with **vendor shortcuts**—typically **no `bin` shims**, so Scoop does not pretend to own the executable. Scoop still records the install and can run **`scoop uninstall`** to invoke the vendor uninstaller and clear that record. Prefer an **elevated** shell when the installer needs admin.

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
