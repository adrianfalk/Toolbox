$Tool = @{
    Name          = "DISM Restore Health"
    Category      = "Windows"
    Description   = "Repairs the Windows component store using DISM"
    Icon          = "🧩"
    RequiresAdmin = $true
    Hidden        = $false
    Version       = "1.0"
}

Write-TeraLine "Running DISM /RestoreHealth, this may take a while..." -Color $Global:TeraTheme.Primary
DISM /Online /Cleanup-Image /RestoreHealth
