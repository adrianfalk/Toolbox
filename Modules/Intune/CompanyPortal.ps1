$Tool = @{
    Name          = "Open Company Portal"
    Category      = "Intune"
    Description   = "Launches the Company Portal app for compliance/device details"
    Icon          = "🏢"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

Start-Process "companyportal:"
Write-TeraLine "Company Portal launched." -Color $Global:TeraTheme.Success
