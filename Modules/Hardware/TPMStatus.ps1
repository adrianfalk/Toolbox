$Tool = @{
    Name          = "TPM Status"
    Category      = "Hardware"
    Description   = "Shows whether a TPM chip is present, enabled and ready (required for BitLocker/Autopilot)"
    Icon          = "🔒"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

$tpm = Get-Tpm -ErrorAction SilentlyContinue

if (-not $tpm) {
    Write-TeraLine "No TPM information available on this device." -Color $Global:TeraTheme.Warning
    return
}

Write-TeraLine "TPM present:  $($tpm.TpmPresent)" -Color $Global:TeraTheme.Text
Write-TeraLine "TPM ready:    $($tpm.TpmReady)" -Color $Global:TeraTheme.Text
Write-TeraLine "TPM enabled:  $($tpm.TpmEnabled)" -Color $Global:TeraTheme.Text
Write-TeraLine "TPM version:  $($tpm.ManufacturerVersionFull20)" -Color $Global:TeraTheme.Text
