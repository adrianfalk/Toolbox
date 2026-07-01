$Tool = @{
    Name          = "Show Public IP"
    Category      = "Network"
    Description   = "Retrieves the current public IP address"
    Icon          = "🛰️"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

try {
    $ip = Invoke-RestMethod -Uri "https://api.ipify.org?format=json" -ErrorAction Stop
    Write-TeraLine "Public IP: $($ip.ip)" -Color $Global:TeraTheme.Success
} catch {
    Write-TeraLine "Could not retrieve public IP (no internet?)." -Color $Global:TeraTheme.Error
}
