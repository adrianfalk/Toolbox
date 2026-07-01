<#
 Loads Assets/Theme.json into $Global:TeraTheme and provides drawing helpers.
#>

function Import-TeraTheme {
    param([string]$Root)
    $path = Join-Path $Root "Assets\Theme.json"
    if (Test-Path $path) {
        $Global:TeraTheme = Get-Content $path -Raw | ConvertFrom-Json
    } else {
        $Global:TeraTheme = [PSCustomObject]@{
            Primary = "Cyan"; Accent = "Magenta"; Success = "Green"
            Warning = "Yellow"; Error = "Red"; Muted = "DarkGray"
            Text = "White"; Border = "DarkCyan"; Highlight = "Black"
        }
    }
}

function Write-TeraLine {
    param(
        [string]$Text = "",
        [string]$Color = "White",
        [switch]$NoNewline
    )
    if ($NoNewline) {
        Write-Host $Text -ForegroundColor $Color -NoNewline
    } else {
        Write-Host $Text -ForegroundColor $Color
    }
}

function Write-TeraBox {
    param(
        [string[]]$Lines,
        [string]$BorderColor = $Global:TeraTheme.Border,
        [string]$TextColor = $Global:TeraTheme.Text
    )
    $width = ($Lines | Measure-Object -Property Length -Maximum).Maximum
    if (-not $width) { $width = 0 }
    $width += 4
    Write-TeraLine ("+" + ("-" * ($width - 2)) + "+") -Color $BorderColor
    foreach ($line in $Lines) {
        $padded = $line.PadRight($width - 4)
        Write-TeraLine "| $padded |" -Color $TextColor
    }
    Write-TeraLine ("+" + ("-" * ($width - 2)) + "+") -Color $BorderColor
}

function Write-TeraHeader {
    param([string]$Root)
    Clear-Host
    $logoPath = Join-Path $Root "Assets\Logo.txt"
    if (Test-Path $logoPath) {
        Write-TeraLine (Get-Content $logoPath -Raw -Encoding UTF8) -Color $Global:TeraTheme.Primary
    }
    $sys = Get-SystemSummary
    $onlineText = if ($sys.Online) { "Online" } else { "Offline" }
    $onlineColor = if ($sys.Online) { $Global:TeraTheme.Success } else { $Global:TeraTheme.Error }
    $adminText = if ($sys.IsAdmin) { "Yes" } else { "No" }

    Write-TeraLine "Version: $($Global:TeraConfig.Version)   |   Computer: $($sys.ComputerName)   |   User: $($sys.UserName)" -Color $Global:TeraTheme.Muted
    Write-TeraLine -NoNewline "Status: "
    Write-TeraLine -NoNewline $onlineText -Color $onlineColor
    Write-TeraLine "   |   $($sys.WindowsVersion)   |   PS $($sys.PSVersion)   |   Admin: $adminText" -Color $Global:TeraTheme.Muted
    Write-TeraLine ("-" * 70) -Color $Global:TeraTheme.Border
}
