#Requires -Version 5.1
<#
.SYNOPSIS
    Copy bucket/visioflow.json from the canonical manifest in VisioFlow-QR.

.DESCRIPTION
    Source of truth: VisioFlow-QR/scripts/packaging/scoop/visioflow.json
    Used locally and by .github/workflows/sync-visioflow.yml.
#>
param(
    [string]$Ref = 'main',
    [string]$SourceUrl,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$dest = Join-Path $repoRoot 'bucket/visioflow.json'
$url = if ($SourceUrl) {
    $SourceUrl
} else {
    "https://raw.githubusercontent.com/zunaidFarouque/VisioFlow-QR/$Ref/scripts/packaging/scoop/visioflow.json"
}

$tmp = Join-Path $env:TEMP "visioflow-scoop-$(Get-Random).json"
try {
    Write-Host "Fetching $url"
    Invoke-WebRequest -Uri $url -OutFile $tmp -UseBasicParsing
    Get-Content -LiteralPath $tmp -Raw | ConvertFrom-Json | Out-Null

    Copy-Item -LiteralPath $tmp -Destination $dest -Force

    if ($env:SCOOP_HOME -and (Test-Path (Join-Path $env:SCOOP_HOME 'bin/formatjson.ps1'))) {
        & (Join-Path $PSScriptRoot 'formatjson.ps1') visioflow
    } elseif (Get-Command scoop -ErrorAction SilentlyContinue) {
        & (Join-Path $PSScriptRoot 'formatjson.ps1') visioflow
    } else {
        Write-Warning 'SCOOP_HOME not set and scoop not on PATH; skipped formatjson (JSON validated only).'
    }

    if ($DryRun) {
        git -C $repoRoot diff --no-color -- bucket/visioflow.json
    } else {
        Write-Host "Updated $dest"
    }
} finally {
    Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
}
