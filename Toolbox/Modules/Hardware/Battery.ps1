$Tool = @{
    Name          = "Battery Report"
    Category      = "Hardware"
    Description   = "Generates a battery health report (laptops only)"
    Icon          = "🔋"
    RequiresAdmin = $true
    Hidden        = $false
    Version       = "1.0"
}

$reportPath = Join-Path $env:TEMP "battery-report.html"
powercfg /batteryreport /output $reportPath | Out-Null

if (Test-Path $reportPath) {
    Write-TeraLine "Battery report generated: $reportPath" -Color $Global:TeraTheme.Success
    Start-Process $reportPath
} else {
    Write-TeraLine "Could not generate battery report (no battery detected?)." -Color $Global:TeraTheme.Warning
}
