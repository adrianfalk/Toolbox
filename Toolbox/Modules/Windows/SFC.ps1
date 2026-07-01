$Tool = @{
    Name          = "System File Checker (SFC)"
    Category      = "Windows"
    Description   = "Scans and repairs protected Windows system files"
    Icon          = "🛠️"
    RequiresAdmin = $true
    Hidden        = $false
    Version       = "1.0"
}

Write-TeraLine "Running SFC /scannow, this may take several minutes..." -Color $Global:TeraTheme.Primary
sfc /scannow
