$Tool = @{
    Name          = "Generate MDM Diagnostics Report"
    Category      = "Intune"
    Description   = "Runs MdmDiagnosticsTool to produce a full enrollment/compliance diagnostics ZIP on the desktop"
    Icon          = "🩺"
    RequiresAdmin = $true
    Hidden        = $false
    Version       = "1.0"
}

$desktop = [Environment]::GetFolderPath("Desktop")
$outputDir = Join-Path $desktop ("MDMDiagnostics_{0}" -f (Get-Date -Format "yyyyMMdd_HHmmss"))
New-Item -ItemType Directory -Path $outputDir -Force | Out-Null

Write-TeraLine "Running MdmDiagnosticsTool, this can take a minute..." -Color $Global:TeraTheme.Primary
Start-Process "MdmDiagnosticsTool.exe" -ArgumentList "-area DeviceEnrollment;DeviceProvisioning;Autopilot -cab `"$outputDir\report.cab`"" -Wait

if (Test-Path (Join-Path $outputDir "report.cab")) {
    Write-TeraLine "Report created: $outputDir\report.cab" -Color $Global:TeraTheme.Success
    Start-Process explorer.exe $outputDir
} else {
    Write-TeraLine "Report generation did not produce an output file." -Color $Global:TeraTheme.Error
}
