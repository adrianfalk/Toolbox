$Tool = @{
    Name          = "Export Autopilot Hardware Hash (HWID)"
    Category      = "Intune"
    Description   = "Generates the Autopilot hardware hash CSV for this device, ready to import into Intune"
    Icon          = "🪪"
    RequiresAdmin = $true
    Hidden        = $false
    Version       = "1.0"
}

try {
    if (-not (Get-Command Get-WindowsAutoPilotInfo -ErrorAction SilentlyContinue)) {
        Write-TeraLine "Get-WindowsAutoPilotInfo not found locally, installing it..." -Color $Global:TeraTheme.Primary

        if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
            Install-PackageProvider -Name NuGet -Force -Scope CurrentUser | Out-Null
        }
        if ((Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue).InstallationPolicy -ne "Trusted") {
            Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        }

        Install-Script -Name Get-WindowsAutoPilotInfo -Repository PSGallery -Force -Scope CurrentUser -ErrorAction Stop
    }

    $scriptCmd = Get-Command Get-WindowsAutoPilotInfo -ErrorAction SilentlyContinue
    if ($scriptCmd) {
        $scriptPath = $scriptCmd.Source
    } else {
        $installed = Get-InstalledScript -Name Get-WindowsAutoPilotInfo -ErrorAction Stop
        $scriptPath = Join-Path $installed.InstalledLocation "Get-WindowsAutoPilotInfo.ps1"
    }

    $fileName = "AutopilotHWID_{0}_{1}.csv" -f $env:COMPUTERNAME, (Get-Date -Format "yyyyMMdd_HHmmss")
    $defaultFolder = [Environment]::GetFolderPath("Desktop")

    Write-TeraLine "Where should the CSV be saved?" -Color $Global:TeraTheme.Primary
    Write-TeraLine "Enter a folder path (e.g. D:\ for a USB drive), or press Enter for the Desktop." -Color $Global:TeraTheme.Muted
    $inputPath = Read-Host "Folder"

    $targetFolder = if ([string]::IsNullOrWhiteSpace($inputPath)) { $defaultFolder } else { $inputPath.Trim() }

    if (-not (Test-Path $targetFolder)) {
        try {
            New-Item -ItemType Directory -Path $targetFolder -Force -ErrorAction Stop | Out-Null
        } catch {
            Write-TeraLine "Folder '$targetFolder' does not exist and could not be created ($($_.Exception.Message)). Falling back to Desktop." -Color $Global:TeraTheme.Warning
            $targetFolder = $defaultFolder
        }
    }

    $csvPath = Join-Path $targetFolder $fileName

    Write-TeraLine "Collecting hardware hash for $env:COMPUTERNAME - this can take a minute..." -Color $Global:TeraTheme.Primary
    & $scriptPath -OutputFile $csvPath

    if (Test-Path $csvPath) {
        Write-TeraLine "`nCSV created: $csvPath" -Color $Global:TeraTheme.Success
        Write-TeraLine "Import it under Intune admin center > Devices > Enrollment devices > Windows Autopilot Devices > Import." -Color $Global:TeraTheme.Muted
        Start-Process explorer.exe "/select,`"$csvPath`""
    } else {
        Write-TeraLine "CSV was not created - check the output above for errors." -Color $Global:TeraTheme.Error
    }
} catch {
    Write-TeraLine "Failed to generate the Autopilot HWID: $($_.Exception.Message)" -Color $Global:TeraTheme.Error
}
