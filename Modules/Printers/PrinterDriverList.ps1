$Tool = @{
    Name          = "List Printer Drivers"
    Category      = "Printers"
    Description   = "Shows all installed printer drivers and their version"
    Icon          = "🖋️"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

Get-PrinterDriver | Select-Object Name, Manufacturer, DriverVersion, PrinterEnvironment | Format-Table -AutoSize
