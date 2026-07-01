<#
 Arrow-key driven TUI menu engine. Renders any list of items (categories or tools)
 and lets the user navigate with Up/Down, select with Enter, go back with Esc,
 and filter with "/".
#>

function Show-TeraSelectMenu {
    param(
        [Parameter(Mandatory)][array]$Items,
        [scriptblock]$RenderItem,
        [string]$Title = "",
        [switch]$AllowSearch
    )

    if (-not $Items -or $Items.Count -eq 0) {
        Write-TeraLine "No items to display." -Color $Global:TeraTheme.Warning
        Start-Sleep -Seconds 1
        return $null
    }

    $selected = 0
    $filter = ""
    $allItems = $Items

    while ($true) {
        $displayItems = if ($filter) { Search-Toolbox -Tools $allItems -Query $filter } else { $allItems }
        if ($displayItems.Count -eq 0) { $displayItems = $allItems }
        if ($selected -ge $displayItems.Count) { $selected = $displayItems.Count - 1 }
        if ($selected -lt 0) { $selected = 0 }

        Write-TeraHeader -Root $Global:TeraRoot
        if ($Title) {
            Write-TeraLine $Title -Color $Global:TeraTheme.Accent
            Write-TeraLine ""
        }
        if ($AllowSearch -and $filter) {
            Write-TeraLine "Filter: $filter" -Color $Global:TeraTheme.Warning
            Write-TeraLine ""
        }

        for ($i = 0; $i -lt $displayItems.Count; $i++) {
            $line = & $RenderItem $displayItems[$i]
            if ($i -eq $selected) {
                Write-Host " > $line " -ForegroundColor $Global:TeraTheme.Highlight -BackgroundColor $Global:TeraTheme.Primary
            } else {
                Write-TeraLine "   $line"
            }
        }

        Write-TeraLine ""
        $hint = "Up/Down: navigate | Enter: select | Esc: back"
        if ($AllowSearch) { $hint += " | /: search" }
        Write-TeraLine $hint -Color $Global:TeraTheme.Muted

        $key = Read-KeyPress
        switch ($key.Key) {
            "UpArrow"   { $selected-- }
            "DownArrow" { $selected++ }
            "Enter"     { return $displayItems[$selected] }
            "Escape"    { return $null }
            "Backspace" { if ($filter.Length -gt 0) { $filter = $filter.Substring(0, $filter.Length - 1) } }
            default {
                if ($AllowSearch -and $key.KeyChar -and $key.KeyChar -match '[a-zA-Z0-9 ]') {
                    $filter += $key.KeyChar
                    $selected = 0
                }
            }
        }
    }
}

function Show-TeraMainMenu {
    param([array]$Tools)

    $recentPath = Join-Path $Global:TeraRoot "Cache\recent.json"
    while ($true) {
        $categories = Get-TeraCategories -Tools $Tools
        $menuEntries = @()
        $menuEntries += [PSCustomObject]@{ Type = "Category"; Name = "All Tools (search)" }
        foreach ($c in $categories) {
            $menuEntries += [PSCustomObject]@{ Type = "Category"; Name = $c }
        }
        $menuEntries += [PSCustomObject]@{ Type = "Exit"; Name = "Exit" }

        $choice = Show-TeraSelectMenu -Items $menuEntries -Title "Main Menu" -RenderItem {
            param($item)
            "$($item.Name)"
        }

        if (-not $choice -or $choice.Type -eq "Exit") { return }

        if ($choice.Name -eq "All Tools (search)") {
            $tool = Show-TeraSelectMenu -Items $Tools -Title "All Tools" -AllowSearch -RenderItem {
                param($t) "$($t.Icon)  $($t.Name)  -  $($t.Description)"
            }
            if ($tool) {
                Invoke-TeraTool -ToolInfo $tool
            }
            continue
        }

        $categoryTools = $Tools | Where-Object { $_.Category -eq $choice.Name }
        while ($true) {
            $tool = Show-TeraSelectMenu -Items $categoryTools -Title "Category: $($choice.Name)" -RenderItem {
                param($t) "$($t.Icon)  $($t.Name)  -  $($t.Description)"
            }
            if (-not $tool) { break }
            Invoke-TeraTool -ToolInfo $tool
        }
    }
}
