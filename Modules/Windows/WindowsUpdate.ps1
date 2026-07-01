$Tool = @{
    Name          = "Check Windows Update"
    Category      = "Windows"
    Description   = "Checks for and lists available Windows updates"
    Icon          = "🪟"
    RequiresAdmin = $true
    Hidden        = $false
    Version       = "1.0"
}

if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-TeraLine "PSWindowsUpdate module not installed." -Color $Global:TeraTheme.Warning
    Write-TeraLine "Install it with: Install-Module PSWindowsUpdate -Force" -Color $Global:TeraTheme.Muted
    return
}

Import-Module PSWindowsUpdate
Get-WindowsUpdate
