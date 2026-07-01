<#
 Handles update checks and self-updating from the central GitHub repo.
 The bootstrap Loader.ps1 never needs to change - all update logic lives here.
#>

function Get-TeraLatestVersion {
    param([string]$ApiUrl)
    try {
        $release = Invoke-RestMethod -Uri "$ApiUrl/releases/latest" -ErrorAction Stop
        return $release.tag_name.TrimStart("v")
    } catch {
        return $null
    }
}

function Update-Toolbox {
    param(
        [string]$Root,
        [string]$RepoRawBaseUrl,
        [string]$RepoApiUrl,
        [string]$CurrentVersion
    )

    $latest = Get-TeraLatestVersion -ApiUrl $RepoApiUrl
    if (-not $latest -or $latest -eq $CurrentVersion) {
        return $false
    }

    Write-TeraLine "`nNew version available" -Color $Global:TeraTheme.Warning
    Write-TeraLine ""
    Write-TeraLine "Current: $CurrentVersion" -Color $Global:TeraTheme.Muted
    Write-TeraLine "Latest:  $latest" -Color $Global:TeraTheme.Success
    Write-TeraLine "`nUpdating..." -Color $Global:TeraTheme.Primary

    try {
        $zipUrl = "$RepoRawBaseUrl/../archive/refs/heads/main.zip"
        # Use %ProgramData% rather than the per-user temp path - see Loader.ps1
        # for why user-profile-based paths can break on dotted usernames.
        $tempRoot = Join-Path $env:ProgramData "Toolbox_tmp"
        if (-not (Test-Path $tempRoot)) { New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null }
        $tempZip = Join-Path $tempRoot "toolbox_update.zip"
        $tempExtract = Join-Path $tempRoot "toolbox_update"

        Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -ErrorAction Stop
        if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force }
        Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

        $sourceDir = Get-ChildItem $tempExtract -Directory | Select-Object -First 1
        if (-not $sourceDir) {
            throw "Downloaded archive did not contain the expected folder structure."
        }

        # Wipe Core/Modules/Assets before copying the fresh versions in, so a
        # module that was renamed or moved to a different category upstream
        # doesn't leave a stale duplicate copy sitting next to the new one.
        foreach ($dir in @("Core", "Modules", "Assets")) {
            $path = Join-Path $Root $dir
            if (Test-Path $path) { Remove-Item $path -Recurse -Force }
        }
        Copy-Item -Path (Join-Path $sourceDir.FullName "*") -Destination $Root -Recurse -Force

        Remove-Item $tempZip -Force -ErrorAction SilentlyContinue
        Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item $tempRoot -Recurse -Force -ErrorAction SilentlyContinue

        Write-TeraLog -Message "Updated from $CurrentVersion to $latest" -Level "SUCCESS"
        return $true
    } catch {
        Write-TeraLine "Update failed: $($_.Exception.Message)" -Color $Global:TeraTheme.Error
        Write-TeraLog -Message "Update failed: $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}
