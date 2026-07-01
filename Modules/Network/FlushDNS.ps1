$Tool = @{
    Name          = "Flush DNS"
    Category      = "Network"
    Description   = "Clears the local DNS resolver cache"
    Icon          = "🌐"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

Write-TeraLine "Flushing DNS cache..." -Color $Global:TeraTheme.Primary
Clear-DnsClientCache
Write-TeraLine "DNS cache cleared successfully." -Color $Global:TeraTheme.Success
