$Tool = @{
    Name          = "DirectX Diagnostics"
    Category      = "Diagnostics"
    Description   = "Runs DXDiag and saves a report to the desktop"
    Icon          = "🎮"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

$reportPath = Join-Path $env:USERPROFILE "Desktop\DxDiag_Report.txt"
Start-Process dxdiag.exe -ArgumentList "/t `"$reportPath`"" -Wait
Write-TeraLine "DXDiag report saved to: $reportPath" -Color $Global:TeraTheme.Success
