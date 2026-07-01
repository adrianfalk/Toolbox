$Tool = @{
    Name          = "Reset Outlook Profile Cache"
    Category      = "Microsoft 365"
    Description   = "Closes Outlook and clears the local navigation pane cache"
    Icon          = "📧"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

Write-TeraLine "Closing Outlook..." -Color $Global:TeraTheme.Primary
Get-Process outlook -ErrorAction SilentlyContinue | Stop-Process -Force

$navCache = Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\Outlook" -Filter "*.xml" -ErrorAction SilentlyContinue
foreach ($file in $navCache) {
    Remove-Item $file.FullName -Force -ErrorAction SilentlyContinue
}

Write-TeraLine "Outlook navigation cache cleared. Restart Outlook to rebuild it." -Color $Global:TeraTheme.Success
