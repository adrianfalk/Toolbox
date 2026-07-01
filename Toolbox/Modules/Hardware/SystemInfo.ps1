$Tool = @{
    Name          = "CPU / RAM / BIOS Overview"
    Category      = "Hardware"
    Description   = "Displays a summary of CPU, RAM and BIOS information"
    Icon          = "🖥️"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

$cpu = Get-CimInstance Win32_Processor
$ram = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
$bios = Get-CimInstance Win32_BIOS

Write-TeraLine "CPU: $($cpu.Name)" -Color $Global:TeraTheme.Text
Write-TeraLine "RAM: $([math]::Round($ram.Sum / 1GB, 1)) GB" -Color $Global:TeraTheme.Text
Write-TeraLine "BIOS: $($bios.Manufacturer) $($bios.SMBIOSBIOSVersion)" -Color $Global:TeraTheme.Text
