function Test-IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-OnlineStatus {
    try {
        return [bool](Test-Connection -ComputerName "1.1.1.1" -Count 1 -Quiet -ErrorAction Stop)
    } catch {
        return $false
    }
}

function Get-SystemSummary {
    $os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        ComputerName   = $env:COMPUTERNAME
        UserName       = $env:USERNAME
        WindowsVersion = if ($os) { "$($os.Caption) ($($os.Version))" } else { "Unknown" }
        PSVersion      = $PSVersionTable.PSVersion.ToString()
        IsAdmin        = Test-IsAdmin
        Online         = Test-OnlineStatus
    }
}

function Read-KeyPress {
    return [Console]::ReadKey($true)
}

function Center-Text {
    param([string]$Text, [int]$Width)
    if ($Text.Length -ge $Width) { return $Text }
    $pad = [int](($Width - $Text.Length) / 2)
    return (" " * $pad) + $Text
}

Export-ModuleMember -Function *
