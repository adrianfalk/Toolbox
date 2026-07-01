$Tool = @{
    Name          = "Top Resource-Hungry Processes"
    Category      = "Diagnostics"
    Description   = "Lists the 15 processes using the most CPU and memory right now"
    Icon          = "📊"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

Write-TeraLine "Top 15 by CPU:" -Color $Global:TeraTheme.Primary
Get-Process | Sort-Object CPU -Descending | Select-Object -First 15 Name, Id, CPU, @{N = "Mem(MB)"; E = { [math]::Round($_.WorkingSet64 / 1MB, 1) } } |
    Format-Table -AutoSize

Write-TeraLine "`nTop 15 by memory:" -Color $Global:TeraTheme.Primary
Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 15 Name, Id, @{N = "Mem(MB)"; E = { [math]::Round($_.WorkingSet64 / 1MB, 1) } }, CPU |
    Format-Table -AutoSize
