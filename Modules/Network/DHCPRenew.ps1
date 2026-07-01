$Tool = @{
    Name          = "DHCP Renew"
    Category      = "Network"
    Description   = "Releases and renews the DHCP lease on all adapters"
    Icon          = "🔄"
    RequiresAdmin = $true
    Hidden        = $false
    Version       = "1.0"
}

Write-TeraLine "Releasing IP..." -Color $Global:TeraTheme.Primary
ipconfig /release | Out-Null
Write-TeraLine "Renewing IP..." -Color $Global:TeraTheme.Primary
ipconfig /renew | Out-Null
Write-TeraLine "DHCP lease renewed." -Color $Global:TeraTheme.Success
