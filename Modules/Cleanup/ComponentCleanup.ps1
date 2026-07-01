$Tool = @{
    Name          = "Clean Up Component Store (WinSxS)"
    Category      = "Maintenance"
    Description   = "Runs DISM StartComponentCleanup to remove superseded Windows update files"
    Icon          = "🧹"
    RequiresAdmin = $true
    Hidden        = $false
    Version       = "1.0"
}

Write-TeraLine "Cleaning up the WinSxS component store, this may take several minutes..." -Color $Global:TeraTheme.Primary
DISM /Online /Cleanup-Image /StartComponentCleanup
