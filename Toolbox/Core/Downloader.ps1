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
        $tempZip = Join-Path $env:TEMP "toolbox_update.zip"
        $tempExtract = Join-Path $env:TEMP "toolbox_update"

        Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -ErrorAction Stop
        if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force }
        Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

        $sourceDir = Get-ChildItem $tempExtract -Directory | Select-Object -First 1
        Copy-Item -Path (Join-Path $sourceDir.FullName "*") -Destination $Root -Recurse -Force

        Remove-Item $tempZip -Force -ErrorAction SilentlyContinue
        Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue

        Write-TeraLog -Message "Updated from $CurrentVersion to $latest" -Level "SUCCESS"
        return $true
    } catch {
        Write-TeraLine "Update failed: $($_.Exception.Message)" -Color $Global:TeraTheme.Error
        Write-TeraLog -Message "Update failed: $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}
