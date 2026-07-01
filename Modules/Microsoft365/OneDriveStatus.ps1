$Tool = @{
    Name          = "OneDrive Sync Status"
    Category      = "Microsoft 365"
    Description   = "Shows whether OneDrive is running and its sync folder path"
    Icon          = "☁️"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

$process = Get-Process OneDrive -ErrorAction SilentlyContinue
if ($process) {
    Write-TeraLine "OneDrive is running (PID $($process.Id))." -Color $Global:TeraTheme.Success
} else {
    Write-TeraLine "OneDrive is not running." -Color $Global:TeraTheme.Warning
}

$syncPath = $env:OneDrive
if ($syncPath) {
    Write-TeraLine "Sync folder: $syncPath" -Color $Global:TeraTheme.Text
} else {
    Write-TeraLine "No OneDrive sync folder found for this user." -Color $Global:TeraTheme.Warning
}

$commercialPath = $env:OneDriveCommercial
if ($commercialPath) {
    Write-TeraLine "Work/School folder: $commercialPath" -Color $Global:TeraTheme.Text
}
