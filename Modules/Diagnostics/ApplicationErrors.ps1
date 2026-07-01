$Tool = @{
    Name          = "Recent Application Errors"
    Category      = "Diagnostics"
    Description   = "Shows the 25 most recent Application log errors"
    Icon          = "❗"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

Get-WinEvent -LogName Application -MaxEvents 200 -ErrorAction SilentlyContinue |
    Where-Object { $_.LevelDisplayName -eq "Error" } |
    Select-Object -First 25 TimeCreated, Id, ProviderName, Message |
    Format-Table -Wrap -AutoSize
