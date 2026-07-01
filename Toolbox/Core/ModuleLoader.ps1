<#
 Discovers modules under /Modules by reading their $Tool metadata block.
 No menu is ever hardcoded - adding a .ps1 file under Modules/<Category>/ is enough.
#>

function Get-Toolbox {
    param([string]$Root)
    $modulesPath = Join-Path $Root "Modules"
    $tools = @()

    if (-not (Test-Path $modulesPath)) { return $tools }

    Get-ChildItem -Path $modulesPath -Filter "*.ps1" -Recurse | ForEach-Object {
        $file = $_
        try {
            $tokens = $null
            $errors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$errors)

            $sb = [scriptblock]::Create((Get-Content $file.FullName -Raw))
            $variables = $sb.Ast.FindAll({ $args[0] -is [System.Management.Automation.Language.AssignmentStatementAst] -and $args[0].Left.VariablePath.UserPath -eq "Tool" }, $true)

            if ($variables.Count -gt 0) {
                $hashAst = $variables[0].Right
                $toolData = $hashAst.SafeGetValue()

                if ($toolData -and -not $toolData.Hidden) {
                    $tools += [PSCustomObject]@{
                        Name          = $toolData.Name
                        Category      = if ($toolData.Category) { $toolData.Category } else { Split-Path (Split-Path $file.FullName -Parent) -Leaf }
                        Description   = $toolData.Description
                        Icon          = if ($toolData.Icon) { $toolData.Icon } else { "*" }
                        RequiresAdmin = [bool]$toolData.RequiresAdmin
                        Version       = $toolData.Version
                        Path          = $file.FullName
                    }
                }
            }
        } catch {
            Write-TeraLog -Message "Failed to load module metadata: $($file.FullName) - $($_.Exception.Message)" -Level "WARN"
        }
    }

    return $tools
}

function Get-TeraCategories {
    param([array]$Tools)
    return $Tools | Select-Object -ExpandProperty Category -Unique | Sort-Object
}

function Invoke-TeraTool {
    param([PSCustomObject]$ToolInfo)

    if ($ToolInfo.RequiresAdmin -and -not (Test-IsAdmin)) {
        Write-TeraLine "`nThis tool requires administrator privileges." -Color $Global:TeraTheme.Error
        Write-TeraLine "Please restart Toolbox as Administrator." -Color $Global:TeraTheme.Warning
        Write-TeraLine "`nPress any key to continue..." -Color $Global:TeraTheme.Muted
        Read-KeyPress | Out-Null
        return
    }

    Clear-Host
    Write-TeraLine "=== $($ToolInfo.Icon)  $($ToolInfo.Name) ===" -Color $Global:TeraTheme.Primary
    Write-TeraLine $ToolInfo.Description -Color $Global:TeraTheme.Muted
    Write-TeraLine ("-" * 60) -Color $Global:TeraTheme.Border
    Write-TeraLine ""

    Invoke-TeraToolRun -Tool @{ Name = $ToolInfo.Name } -ScriptBlock {
        & $ToolInfo.Path
    }

    Write-TeraLine "`nPress any key to return to the menu..." -Color $Global:TeraTheme.Muted
    Read-KeyPress | Out-Null
}
