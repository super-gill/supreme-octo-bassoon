# TOME Platform Updater
# Fetches the full repo tree from GitHub and downloads everything that isn't
# user data. New platform files in future versions are picked up automatically.
# Usage: Right-click > Run with PowerShell, or: powershell -ExecutionPolicy Bypass -File update.ps1 [-Force]

param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$Repo     = "super-gill/tome.md"
$Branch   = "main"
$BaseUrl  = "https://raw.githubusercontent.com/$Repo/$Branch"
$TreeUrl  = "https://api.github.com/repos/$Repo/git/trees/${Branch}?recursive=1"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# User data — these paths are NEVER overwritten.
# Everything else in the repo is considered platform and will be updated.
$Protected = @(
    "Books/"
    "tome.json"
    "export-branding/"
)

# --- Helpers ---

function Log($msg)  { Write-Host "[TOME] $msg" -ForegroundColor Cyan }
function Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Err($msg)  { Write-Host "[ERR]  $msg" -ForegroundColor Red }

function Download($url, $dest) {
    $dir = Split-Path -Parent $dest
    if ($dir -and !(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    try {
        (New-Object Net.WebClient).DownloadFile($url, $dest)
        return $true
    } catch {
        return $false
    }
}

function Is-Protected($path) {
    foreach ($p in $Protected) {
        if ($p.EndsWith("/") -and $path.StartsWith($p)) { return $true }
        if ($path -eq $p) { return $true }
    }
    return $false
}

# --- Version check ---

Log "Checking for updates..."

$TmpDir = Join-Path ([IO.Path]::GetTempPath()) "tome-update-$(Get-Random)"
New-Item -ItemType Directory -Path $TmpDir -Force | Out-Null

try {
    $remoteVersionFile = Join-Path $TmpDir "version.json"
    if (!(Download "$BaseUrl/version.json" $remoteVersionFile)) {
        Err "Could not reach GitHub. Check your connection."
        exit 1
    }

    $remoteVersion = (Get-Content $remoteVersionFile | ConvertFrom-Json).version
    $localVersion = "(unknown)"
    $localVersionFile = Join-Path $ScriptDir "version.json"
    if (Test-Path $localVersionFile) {
        $localVersion = (Get-Content $localVersionFile | ConvertFrom-Json).version
    }

    Log "Local:  $localVersion"
    Log "Remote: $remoteVersion"

    if ($localVersion -eq $remoteVersion -and !$Force) {
        Log "Already up to date. Use -Force to re-download anyway."
        exit 0
    }

    # --- Fetch repo tree ---

    Log "Fetching file list from GitHub..."

    $treeFile = Join-Path $TmpDir "tree.json"
    if (!(Download $TreeUrl $treeFile)) {
        Err "Could not fetch repository tree."
        exit 1
    }

    $tree = Get-Content $treeFile -Raw | ConvertFrom-Json

    $platformFiles = @()
    $skippedCount = 0

    foreach ($entry in $tree.tree) {
        if ($entry.type -ne "blob") { continue }
        if (Is-Protected $entry.path) {
            $skippedCount++
        } else {
            $platformFiles += $entry.path
        }
    }

    Log "Found $($platformFiles.Count) platform files, $skippedCount user files protected."

    # --- Backup and download ---

    $backupDir = Join-Path $ScriptDir ".update-backup"
    if (Test-Path $backupDir) { Remove-Item $backupDir -Recurse -Force }
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

    $failed  = @()
    $updated = 0

    foreach ($file in $platformFiles) {
        $dest = Join-Path $ScriptDir ($file -replace "/", "\")

        # Backup existing file
        if (Test-Path $dest) {
            $backupPath = Join-Path $backupDir ($file -replace "/", "\")
            $backupPathDir = Split-Path -Parent $backupPath
            if (!(Test-Path $backupPathDir)) { New-Item -ItemType Directory -Path $backupPathDir -Force | Out-Null }
            Copy-Item $dest $backupPath
        }

        Log "  $file"
        if (Download "$BaseUrl/$file" $dest) {
            $updated++
        } else {
            Warn "  Failed: $file"
            $failed += $file
        }
    }

    # --- Result ---

    Write-Host ""
    Write-Host ([string]::new([char]0x2500, 41))
    if ($failed.Count -gt 0) {
        Write-Host "  UPDATE FAILED" -ForegroundColor Red
        Write-Host ([string]::new([char]0x2500, 41))
        Write-Host ""
        Warn "$updated files updated, $($failed.Count) failed:"
        foreach ($f in $failed) { Err "  x $f" }
        Write-Host ""
        Warn "Previous versions backed up to .update-backup/"
        exit 1
    } else {
        Write-Host "  UPDATE SUCCESSFUL" -ForegroundColor Green
        Write-Host ([string]::new([char]0x2500, 41))
        Write-Host ""
        Log "$localVersion -> $remoteVersion  ($updated files)"
        Log "Backup saved to .update-backup/"
    }
} finally {
    Remove-Item $TmpDir -Recurse -Force -ErrorAction SilentlyContinue
}
