<#
 Simple fuzzy-ish search across tool names / descriptions / categories.
#>

function Search-Toolbox {
    param(
        [array]$Tools,
        [string]$Query
    )
    if ([string]::IsNullOrWhiteSpace($Query)) { return $Tools }
    $q = $Query.Trim()
    return $Tools | Where-Object {
        $_.Name -like "*$q*" -or
        $_.Description -like "*$q*" -or
        $_.Category -like "*$q*"
    }
}
