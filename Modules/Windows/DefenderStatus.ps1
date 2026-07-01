$Tool = @{
    Name          = "Windows Defender Status"
    Category      = "Windows"
    Description   = "Shows real-time protection, signature age and last scan results"
    Icon          = "🛡️"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

$status = Get-MpComputerStatus -ErrorAction SilentlyContinue

if (-not $status) {
    Write-TeraLine "Windows Defender status is not available on this device." -Color $Global:TeraTheme.Warning
    return
}

Write-TeraLine "Real-time protection: $($status.RealTimeProtectionEnabled)" -Color $Global:TeraTheme.Text
Write-TeraLine "Antivirus enabled:    $($status.AntivirusEnabled)" -Color $Global:TeraTheme.Text
Write-TeraLine "Signature age (days): $($status.AntivirusSignatureAge)" -Color $Global:TeraTheme.Text
Write-TeraLine "Last quick scan:      $($status.QuickScanEndTime)" -Color $Global:TeraTheme.Text
Write-TeraLine "Last full scan:       $($status.FullScanEndTime)" -Color $Global:TeraTheme.Text
