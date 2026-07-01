$Tool = @{
    Name          = "Traceroute"
    Category      = "Network"
    Description   = "Traces the network path to a host you specify"
    Icon          = "🧭"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

$target = Read-Host "Host or IP to trace (e.g. google.com)"
if ([string]::IsNullOrWhiteSpace($target)) {
    Write-TeraLine "No host entered." -Color $Global:TeraTheme.Warning
    return
}

Write-TeraLine "Tracing route to $target ..." -Color $Global:TeraTheme.Primary
$result = Test-NetConnection -ComputerName $target -TraceRoute -ErrorAction SilentlyContinue

if (-not $result -or -not $result.TraceRoute) {
    Write-TeraLine "Could not trace a route to $target." -Color $Global:TeraTheme.Error
    return
}

$hop = 1
foreach ($ip in $result.TraceRoute) {
    Write-TeraLine ("{0,2}  {1}" -f $hop, $ip) -Color $Global:TeraTheme.Text
    $hop++
}
