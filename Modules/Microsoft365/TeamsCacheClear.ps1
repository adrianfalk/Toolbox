$Tool = @{
    Name          = "Clear Teams Cache"
    Category      = "Microsoft 365"
    Description   = "Closes Teams and clears its local cache folders"
    Icon          = "💬"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

Write-TeraLine "Closing Microsoft Teams..." -Color $Global:TeraTheme.Primary
Get-Process ms-teams, Teams -ErrorAction SilentlyContinue | Stop-Process -Force

$cachePaths = @(
    "$env:APPDATA\Microsoft\Teams\Cache",
    "$env:APPDATA\Microsoft\Teams\blob_storage",
    "$env:APPDATA\Microsoft\Teams\databases",
    "$env:APPDATA\Microsoft\Teams\GPUCache",
    "$env:APPDATA\Microsoft\Teams\Local Storage"
)

foreach ($path in $cachePaths) {
    if (Test-Path $path) {
        Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-TeraLine "Teams cache cleared. Start Teams again." -Color $Global:TeraTheme.Success
