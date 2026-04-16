param(
    [string]$Repo = "zunaidFarouque/Zunaid-Scoop-Bucket",
    [string]$Workflow = "excavator.yml",
    [string]$Ref = "main"
)

$ErrorActionPreference = "Stop"

function Fail([string]$Message) {
    Write-Host "ERROR: $Message" -ForegroundColor Red
    exit 1
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Fail "GitHub CLI (gh) is not installed or not on PATH."
}

Write-Host "Checking GitHub CLI authentication..." -ForegroundColor Cyan
& gh auth status | Out-Null
if ($LASTEXITCODE -ne 0) {
    Fail "Not authenticated with gh. Run: gh auth login"
}

Write-Host "Triggering workflow '$Workflow' on '$Repo' (ref: $Ref)..." -ForegroundColor Cyan
& gh workflow run $Workflow --repo $Repo --ref $Ref
if ($LASTEXITCODE -ne 0) {
    Fail "Failed to trigger workflow."
}

Start-Sleep -Seconds 2

Write-Host "`nLatest run:" -ForegroundColor Green
& gh run list --repo $Repo --workflow $Workflow --limit 1
if ($LASTEXITCODE -ne 0) {
    Fail "Triggered workflow, but failed to fetch run list."
}

Write-Host "`nTo watch live, run:" -ForegroundColor Yellow
Write-Host "gh run watch --repo $Repo"
