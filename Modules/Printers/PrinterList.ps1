$Tool = @{
    Name          = "List Installed Printers"
    Category      = "Printers"
    Description   = "Shows all installed printers and their status"
    Icon          = "🖨️"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

Get-Printer | Select-Object Name, DriverName, PortName, PrinterStatus | Format-Table -AutoSize
