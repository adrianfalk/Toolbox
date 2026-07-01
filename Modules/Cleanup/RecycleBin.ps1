$Tool = @{
    Name          = "Empty Recycle Bin"
    Category      = "Maintenance"
    Description   = "Empties the Recycle Bin for all drives"
    Icon          = "🗑️"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-TeraLine "Recycle Bin emptied." -Color $Global:TeraTheme.Success
