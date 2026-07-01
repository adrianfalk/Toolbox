$Tool = @{
    Name          = "Office Activation Status"
    Category      = "Microsoft 365"
    Description   = "Shows the activation status of installed Office products"
    Icon          = "🔑"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

$ospp = Get-ChildItem -Path "${env:ProgramFiles}\Microsoft Office\Office*", "${env:ProgramFiles(x86)}\Microsoft Office\Office*" `
    -Filter "OSPP.VBS" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $ospp) {
    Write-TeraLine "OSPP.VBS not found. Is Office installed?" -Color $Global:TeraTheme.Warning
    return
}

cscript //nologo $ospp.FullName /dstatus
