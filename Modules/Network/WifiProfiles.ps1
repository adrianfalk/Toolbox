$Tool = @{
    Name          = "List Wi-Fi Profiles"
    Category      = "Network"
    Description   = "Shows all saved Wi-Fi profiles and their authentication type"
    Icon          = "📶"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

$output = netsh wlan show profiles
$profileNames = $output | Select-String "All User Profile\s*:\s*(.+)$" | ForEach-Object {
    $_.Matches[0].Groups[1].Value.Trim()
}

if (-not $profileNames) {
    Write-TeraLine "No saved Wi-Fi profiles found." -Color $Global:TeraTheme.Warning
    return
}

foreach ($name in $profileNames) {
    $details = netsh wlan show profile name="$name"
    $auth = ($details | Select-String "Authentication\s*:\s*(.+)$" | Select-Object -First 1).Matches.Groups[1].Value.Trim()
    Write-TeraLine "$name  (Auth: $auth)" -Color $Global:TeraTheme.Text
}
