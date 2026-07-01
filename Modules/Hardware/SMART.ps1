$Tool = @{
    Name          = "Disk SMART Status"
    Category      = "Hardware"
    Description   = "Shows SMART health status for all physical disks"
    Icon          = "💽"
    RequiresAdmin = $true
    Hidden        = $false
    Version       = "1.0"
}

Get-PhysicalDisk | Select-Object DeviceId, FriendlyName, HealthStatus, OperationalStatus, MediaType | Format-Table -AutoSize
