<#
.SYNOPSIS
    Toolbox bootstrap loader. This is the ONLY file end users need to fetch via:
        irm https://tools.ecit.com | iex

.DESCRIPTION
    Downloads/refreshes the full Toolbox framework into a local cache folder
    and launches it. This file should change as rarely as possible - all real
    logic lives in Core/ and Modules/, which are pulled from the repo below.
#>

$RepoRawBaseUrl = "https://raw.githubusercontent.com/adrianfalk/toolbox/main"
$RepoZipUrl     = "https://github.com/adrianfalk/toolbox/archive/refs/heads/main.zip"

# Deliberately avoid any per-user path (LOCALAPPDATA, TEMP, USERPROFILE, ...).
# On accounts whose Windows profile was provisioned with a dotted username,
# the profile's registry entry (and every API built on top of it - env vars,
# [Environment]::GetFolderPath, [IO.Path]::GetTempPath) can point at an 8.3
# short-name alias (e.g. ADRIAN~1.FAL) that doesn't actually exist on disk
# when 8dot3 name creation is disabled on the volume. %ProgramData% is a
# fixed OS path with no username in it, so it isn't affected.
$InstallDir = Join-Path $env:ProgramData "Toolbox"

function Sync-ToolboxSource {
    param([string]$Destination, [string]$ZipUrl)

    $tempRoot = Join-Path $env:ProgramData "Toolbox_tmp"
    if (-not (Test-Path $tempRoot)) { New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null }
    $tempZip = Join-Path $tempRoot "toolbox_bootstrap.zip"
    $tempExtract = Join-Path $tempRoot "toolbox_bootstrap"

    Write-Host "Fetching Toolbox..." -ForegroundColor Cyan

    Invoke-WebRequest -Uri $ZipUrl -OutFile $tempZip -UseBasicParsing -ErrorAction Stop

    if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force }
    Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

    $sourceDir = Get-ChildItem $tempExtract -Directory | Select-Object -First 1
    if (-not $sourceDir) {
        throw "Downloaded archive did not contain the expected folder structure."
    }

    if (-not (Test-Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }
    Copy-Item -Path (Join-Path $sourceDir.FullName "*") -Destination $Destination -Recurse -Force

    Remove-Item $tempZip -Force -ErrorAction SilentlyContinue
    Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
}

try {
    Sync-ToolboxSource -Destination $InstallDir -ZipUrl $RepoZipUrl

    $entryPoint = Join-Path $InstallDir "Start-Toolbox.ps1"
    if (-not (Test-Path $entryPoint)) {
        throw "Entry point not found after sync: $entryPoint"
    }

    & $entryPoint -Root $InstallDir
} catch {
    Write-Host "Toolbox failed to start: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Check your internet connection and try again." -ForegroundColor Yellow
}
