$Tool = @{
    Name          = "Export Support Package"
    Category      = "Diagnostics"
    Description   = "Collects system info, event logs and MSINFO32 into a ZIP for support"
    Icon          = "📦"
    RequiresAdmin = $true
    Hidden        = $false
    Version       = "1.0"
}

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$workDir = Join-Path $env:TEMP "TeraSupport_$stamp"
$zipPath = Join-Path $env:USERPROFILE "Desktop\TeraSupport_$stamp.zip"

New-Item -ItemType Directory -Path $workDir -Force | Out-Null

Write-TeraLine "Collecting system information..." -Color $Global:TeraTheme.Primary
Get-ComputerInfo | Out-File (Join-Path $workDir "ComputerInfo.txt")

Write-TeraLine "Exporting event logs..." -Color $Global:TeraTheme.Primary
Get-WinEvent -LogName System -MaxEvents 500 -ErrorAction SilentlyContinue |
    Select-Object TimeCreated, LevelDisplayName, Id, ProviderName, Message |
    Export-Csv (Join-Path $workDir "SystemEvents.csv") -NoTypeInformation

Write-TeraLine "Running MSINFO32 export..." -Color $Global:TeraTheme.Primary
Start-Process msinfo32.exe -ArgumentList "/report `"$(Join-Path $workDir 'msinfo32.txt')`"" -Wait

Write-TeraLine "Compressing package..." -Color $Global:TeraTheme.Primary
Compress-Archive -Path "$workDir\*" -DestinationPath $zipPath -Force
Remove-Item $workDir -Recurse -Force

Write-TeraLine "Support package created: $zipPath" -Color $Global:TeraTheme.Success
