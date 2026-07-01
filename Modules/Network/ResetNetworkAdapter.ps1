$Tool = @{
    Name          = "Reset Network Stack"
    Category      = "Network"
    Description   = "Resets Winsock and TCP/IP - fixes many connectivity issues. Requires a restart"
    Icon          = "🔧"
    RequiresAdmin = $true
    Hidden        = $false
    Version       = "1.0"
}

Write-TeraLine "This will reset Winsock and the TCP/IP stack." -Color $Global:TeraTheme.Warning
Write-TeraLine "A restart is required afterwards for changes to take effect." -Color $Global:TeraTheme.Warning
$confirm = Read-Host "Continue? (y/N)"

if ($confirm -ne "y") {
    Write-TeraLine "Cancelled." -Color $Global:TeraTheme.Muted
    return
}

Write-TeraLine "Resetting Winsock..." -Color $Global:TeraTheme.Primary
netsh winsock reset | Out-Null

Write-TeraLine "Resetting TCP/IP stack..." -Color $Global:TeraTheme.Primary
netsh int ip reset | Out-Null

Write-TeraLine "Done. Please restart the computer for the reset to take effect." -Color $Global:TeraTheme.Success
