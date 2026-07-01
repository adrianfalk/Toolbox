$Tool = @{
    Name          = "Clean Temp Files"
    Category      = "Maintenance"
    Description   = "Removes files from the user and system Temp folders"
    Icon          = "🧽"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

$paths = @($env:TEMP, "$env:SystemRoot\Temp")
$freed = 0

foreach ($path in $paths) {
    if (Test-Path $path) {
        $items = Get-ChildItem $path -Recurse -Force -ErrorAction SilentlyContinue
        $freed += ($items | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
        $items | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-TeraLine ("Freed approx. {0:N0} MB of temp files." -f ($freed / 1MB)) -Color $Global:TeraTheme.Success
