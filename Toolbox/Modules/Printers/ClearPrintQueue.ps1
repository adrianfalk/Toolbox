$Tool = @{
    Name          = "Clear Print Queue"
    Category      = "Printers"
    Description   = "Stops the print spooler and clears all stuck print jobs"
    Icon          = "🧹"
    RequiresAdmin = $true
    Hidden        = $false
    Version       = "1.0"
}

Write-TeraLine "Stopping Print Spooler service..." -Color $Global:TeraTheme.Primary
Stop-Service -Name Spooler -Force

$spoolPath = "$env:SystemRoot\System32\spool\PRINTERS"
Get-ChildItem $spoolPath -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue

Write-TeraLine "Starting Print Spooler service..." -Color $Global:TeraTheme.Primary
Start-Service -Name Spooler

Write-TeraLine "Print queue cleared." -Color $Global:TeraTheme.Success
