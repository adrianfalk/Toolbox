$Tool = @{
    Name          = "Disk Space Report"
    Category      = "Hardware"
    Description   = "Shows free/used space for every local drive"
    Icon          = "💾"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

Get-Volume | Where-Object { $_.DriveLetter } | ForEach-Object {
    [PSCustomObject]@{
        Drive       = "$($_.DriveLetter):"
        Label       = $_.FileSystemLabel
        "Free (GB)" = [math]::Round($_.SizeRemaining / 1GB, 1)
        "Size (GB)" = [math]::Round($_.Size / 1GB, 1)
        "Free (%)"  = if ($_.Size -gt 0) { [math]::Round(($_.SizeRemaining / $_.Size) * 100, 1) } else { 0 }
    }
} | Format-Table -AutoSize
