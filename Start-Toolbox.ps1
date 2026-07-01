<#
.SYNOPSIS
    Toolbox main entry point. Loaded and executed by Loader.ps1 after sync,
    or can be run directly from a local clone for development:
        .\Start-Toolbox.ps1
#>
param(
    [string]$Root = $PSScriptRoot
)

$Global:TeraRoot = $Root

# Without this, Windows PowerShell renders the box-drawing/emoji glyphs used
# in the logo and icons as mojibake, since the console defaults to the
# system's legacy codepage rather than UTF-8.
try {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8
} catch { }

Import-Module (Join-Path $Root "Core\Helpers.psm1") -Force

. (Join-Path $Root "Core\Theme.ps1")
. (Join-Path $Root "Core\Logger.ps1")
. (Join-Path $Root "Core\Downloader.ps1")
. (Join-Path $Root "Core\ModuleLoader.ps1")
. (Join-Path $Root "Core\Search.ps1")
. (Join-Path $Root "Core\Menu.ps1")

$Global:TeraConfig = Get-Content (Join-Path $Root "Assets\Config.json") -Raw | ConvertFrom-Json

Import-TeraTheme -Root $Root
Initialize-TeraLogger -Root $Root

Clear-Host
Write-TeraLine "Checking for updates..." -Color $Global:TeraTheme.Muted
if ($Global:TeraConfig.UpdateCheck) {
    Update-Toolbox -Root $Root -RepoRawBaseUrl $Global:TeraConfig.RepoRawBaseUrl `
        -RepoApiUrl $Global:TeraConfig.RepoApiUrl -CurrentVersion $Global:TeraConfig.Version | Out-Null
}

Write-TeraLine "Loading modules..." -Color $Global:TeraTheme.Muted
$tools = Get-Toolbox -Root $Root
Write-TeraLog -Message "Loaded $($tools.Count) tools" -Level "INFO"

Show-TeraMainMenu -Tools $tools

Clear-Host
Write-TeraLine "Thanks for using Toolbox." -Color $Global:TeraTheme.Primary
