$Tool = @{
    Name          = "Azure AD Join Status (dsregcmd)"
    Category      = "Intune"
    Description   = "Shows device join/registration status with Azure AD"
    Icon          = "🆔"
    RequiresAdmin = $false
    Hidden        = $false
    Version       = "1.0"
}

dsregcmd /status
