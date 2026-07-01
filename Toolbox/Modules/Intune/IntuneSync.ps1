$Tool = @{
    Name          = "Intune Sync"
    Category      = "Intune"
    Description   = "Triggers an immediate Intune device policy sync"
    Icon          = "🔁"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

try {
    $enrollmentId = (Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Enrollments" -ErrorAction Stop |
        Where-Object { (Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue).ProviderID -eq "MS DM Server" } |
        Select-Object -First 1).PSChildName

    if (-not $enrollmentId) {
        Write-TeraLine "No Intune enrollment found on this device." -Color $Global:TeraTheme.Warning
        return
    }

    $task = Get-ScheduledTask -TaskName "PushLaunch" -TaskPath "\Microsoft\Windows\EnterpriseMgmt\$enrollmentId\" -ErrorAction Stop
    Start-ScheduledTask -InputObject $task
    Write-TeraLine "Intune sync triggered." -Color $Global:TeraTheme.Success
} catch {
    Write-TeraLine "Could not trigger Intune sync: $($_.Exception.Message)" -Color $Global:TeraTheme.Error
}
