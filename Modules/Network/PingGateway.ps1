$Tool = @{
    Name          = "Ping Default Gateway"
    Category      = "Network"
    Description   = "Pings the default gateway to check local connectivity"
    Icon          = "📡"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

$gateway = (Get-NetRoute -DestinationPrefix "0.0.0.0/0" -ErrorAction SilentlyContinue |
    Sort-Object -Property RouteMetric | Select-Object -First 1).NextHop

if (-not $gateway) {
    Write-TeraLine "No default gateway found." -Color $Global:TeraTheme.Error
    return
}

Write-TeraLine "Pinging gateway $gateway ..." -Color $Global:TeraTheme.Primary
Test-Connection -ComputerName $gateway -Count 4 | Format-Table -AutoSize
