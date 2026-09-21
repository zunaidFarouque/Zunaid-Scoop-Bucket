# AI Task Prompt: Configure Automated Scoop Bucket Release Pipeline

> **Instructions for User:**
> Copy everything below the horizontal divider and paste it into the AI coding assistant (Cursor, Antigravity, Copilot, Claude, etc.) inside your target project repository.

---

```markdown
I want to integrate this project with my personal Scoop bucket (`zunaidFarouque/Zunaid-Scoop-Bucket`) using the automated **ProcessSentinel release & sync pattern**.

### Context & Goal
I develop and maintain my own software packages distributed via Scoop in `https://github.com/zunaidFarouque/Zunaid-Scoop-Bucket`.
In my other project (`ProcessSentinel`), when I run `.\scripts\release.ps1` to release a new version, it automatically:
1. Packages the build distribution into a portable zip.
2. Computes the SHA-256 hash.
3. Updates the canonical Scoop manifest (`<app-name>.json`) stored right here in this project repo.
4. Commits and pushes the manifest to `main`.
5. Publishes the GitHub release using `gh release create`.
6. Triggers the Scoop bucket's GitHub Actions sync workflow via:
   `gh workflow run sync-<app-name>.yml -R zunaidFarouque/Zunaid-Scoop-Bucket`

I want you to set up this exact automated release pipeline in this repository.

---

### What You Need To Do:

#### 1. Inspect This Repository
- Identify the application name, executable name, and how portable builds/distributables are generated (e.g. `dist/<AppName>`, `target/release`, `bin/Release`, etc.).
- Identify where the main executable and any supporting folders/assets reside in the distributable.

#### 2. Create the Canonical Scoop Manifest (`<app-name>.json`)
- Place a valid Scoop manifest named `<app-name>.json` (lowercase, matching the app's scoop package name) in the root of this repository.
- Required fields:
  - `version`: Initial/current version (or "0.1.0").
  - `description`: Brief description of what the app does.
  - `homepage`: GitHub repository URL or website.
  - `license`: SPDX identifier (e.g. `MIT`, `Apache-2.0`, `GPL-3.0-only`, `Proprietary`).
  - `architecture.64bit.url`: `https://github.com/<owner>/<repo>/releases/download/v$version/<AppName>-v$version-windows-x64.zip`
  - `architecture.64bit.hash`: SHA-256 hash string (lowercase hex).
  - `bin`: Array or entry for the executable shim (e.g. `"<AppName>.exe"` or `[["<AppName>.exe", "<alias>"]]`).
  - `shortcuts`: Start menu shortcuts if applicable (e.g. `[["<AppName>.exe", "<AppName>"]]`).
  - `persist`: Persisted config/data directories if applicable.
- **Formatting Rule**: Must use 4-space indentation, CRLF line endings (`\r\n`), and UTF-8 encoding without BOM.

#### 3. Create the Release Script (`scripts/release.ps1`)
Create `scripts/release.ps1` with the following parameters:
- `[string]$Version`: Semantic version without `v` (e.g., "1.2.0").
- `[string]$Title`: Release title. Defaults to `<AppName> v<Version>`.
- `[string]$Notes`: Markdown text for release notes.
- `[string]$NotesFile`: Optional path to a markdown release notes file.
- `[string]$BucketRepo`: Defaults to `"zunaidFarouque/Zunaid-Scoop-Bucket"`.
- `[switch]$Force`: Bypasses interactive confirmation (required for non-interactive / agent execution).
- `[switch]$DryRun`: Simulates packaging, hashing, manifest editing without committing or pushing.

**The script must execute the following pipeline steps:**
1. **Pre-flight verification**:
   - Verify `$Version` is non-empty and well-formed.
   - Verify that the compiled build binary/folder exists (instructing the user which build command to run if missing).
   - Check that GitHub CLI (`gh`) is installed and authenticated (`gh auth status`).
   - Check that `git tag -l "v$Version"` does not already exist.
   - Prompt confirmation if neither `-Force` nor `-DryRun` is passed.
2. **Package Zip Archive**:
   - Compress the staged distribution folder into `<AppName>-v<Version>-windows-x64.zip`.
3. **Compute SHA-256**:
   - Calculate `(Get-FileHash -Path $zipPath -Algorithm SHA256).Hash.ToLower()`.
4. **Update Canonical Scoop Manifest**:
   - Update `<app-name>.json` in the repo root with the new `version`, `architecture.64bit.url`, and `architecture.64bit.hash`.
   - Write back using UTF-8 without BOM and CRLF line endings.
5. **Commit & Push Manifest**:
   - `git add <app-name>.json`
   - `git commit -m "chore(release): Bump Scoop manifest to v<Version>"`
   - `git push origin main`
6. **Publish GitHub Release**:
   - `gh release create "v$Version" $zipPath --title $Title [--notes-file / --notes / --generate-notes]`
7. **Trigger Bucket Sync**:
   - Dispatch workflow run to Scoop bucket:
     `gh workflow run sync-<app-name>.yml -R $BucketRepo`
8. **Cleanup**:
   - Remove temporary zip archive.

#### 4. Add Release Safety Rules to `AGENTS.md`
If `AGENTS.md` exists (or create it), add a critical safety rule:
> **CRITICAL SAFETY RULE: RELEASES**
> NEVER execute `scripts/release.ps1` without the user's explicit, direct permission in the current prompt (e.g. "Please release version X.Y.Z"). Agents may build, test, and edit files, but must never autonomously trigger an official GitHub release.

#### 5. Output the Bucket-Side Files Needed in `Zunaid-Scoop-Bucket`
At the end of your response, provide the exact code for the two files that need to be added to `Zunaid-Scoop-Bucket`:
1. `.github/workflows/sync-<app-name>.yml`:
```yaml
name: Sync <app-name> manifest

on:
  workflow_dispatch:
  schedule:
    - cron: '0 5 * * *'
  repository_dispatch:
    types: [sync-<app-name>-manifest]

permissions:
  contents: write

jobs:
  sync:
    name: Sync from <RepoName>
    runs-on: windows-latest
    steps:
      - name: Checkout Bucket
        uses: actions/checkout@v4
      - name: Checkout Scoop
        uses: actions/checkout@v4
        with:
          repository: ScoopInstaller/Scoop
          path: scoop_core
      - name: Sync manifest
        shell: pwsh
        env:
          SCOOP_HOME: ${{ github.workspace }}/scoop_core
        run: .\bin\sync-<app-name>.ps1
      - name: Commit and push if changed
        shell: pwsh
        run: |
          git config user.name 'github-actions[bot]'
          git config user.email '41898282+github-actions[bot]@users.noreply.github.com'
          git add bucket/<app-name>.json
          git diff --staged --quiet
          if ($LASTEXITCODE -eq 0) {
            Write-Host '<app-name> manifest already in sync.'
            exit 0
          }
          git commit -m "<app-name>: Sync manifest from <RepoName>"
          git push
```

2. `bin/sync-<app-name>.ps1`:
```powershell
#Requires -Version 5.1
param(
    [string]$Ref = 'main',
    [string]$SourceUrl,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$dest = Join-Path $repoRoot 'bucket/<app-name>.json'
$url = if ($SourceUrl) {
    $SourceUrl
} else {
    "https://raw.githubusercontent.com/<Owner>/<RepoName>/$Ref/<app-name>.json"
}

$tmp = Join-Path $env:TEMP "<app-name>-scoop-$(Get-Random).json"
try {
    Write-Host "Fetching $url"
    Invoke-WebRequest -Uri $url -OutFile $tmp -UseBasicParsing
    Get-Content -LiteralPath $tmp -Raw | ConvertFrom-Json | Out-Null

    Copy-Item -LiteralPath $tmp -Destination $dest -Force

    if ($env:SCOOP_HOME -and (Test-Path (Join-Path $env:SCOOP_HOME 'bin/formatjson.ps1'))) {
        & (Join-Path $PSScriptRoot 'formatjson.ps1') '<app-name>'
    } elseif (Get-Command scoop -ErrorAction SilentlyContinue) {
        & (Join-Path $PSScriptRoot 'formatjson.ps1') '<app-name>'
    } else {
        Write-Warning 'SCOOP_HOME not set and scoop not on PATH; skipped formatjson (JSON validated only).'
    }

    if ($DryRun) {
        git -C $repoRoot diff --no-color -- 'bucket/<app-name>.json'
    } else {
        Write-Host "Updated $dest"
    }
} finally {
    Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
}
```

Now, please inspect this repository and set up the manifest, release pipeline, and safety documentation.
```
