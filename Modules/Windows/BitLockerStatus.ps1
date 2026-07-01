$Tool = @{
    Name          = "BitLocker Status"
    Category      = "Windows"
    Description   = "Shows BitLocker protection status and recovery key IDs for all drives"
    Icon          = "🔐"
    RequiresAdmin = $true
    Hidden        = $false
    Version       = "1.0"
}

Get-BitLockerVolume | Select-Object MountPoint, VolumeStatus, ProtectionStatus, EncryptionPercentage |
    Format-Table -AutoSize

Write-TeraLine "`nRecovery key IDs (full key stays in Azure AD / AD, not shown here):" -Color $Global:TeraTheme.Muted
Get-BitLockerVolume | ForEach-Object {
    $keyProtector = $_.KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" } | Select-Object -First 1
    if ($keyProtector) {
        Write-TeraLine "$($_.MountPoint)  ->  $($keyProtector.KeyProtectorId)" -Color $Global:TeraTheme.Text
    }
}
