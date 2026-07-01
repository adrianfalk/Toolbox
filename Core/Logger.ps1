<#
 Central logging for Toolbox. Writes structured log lines to a per-day log file.
#>

function Initialize-TeraLogger {
    param([string]$Root)
    $logDir = Join-Path $Root "Logs"
    if (-not (Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }
    $Global:TeraLogFile = Join-Path $logDir ("Toolbox_{0}.log" -f (Get-Date -Format "yyyy-MM-dd"))
}

function Write-TeraLog {
    param(
        [Parameter(Mandatory)][string]$Message,
        [ValidateSet("INFO", "WARN", "ERROR", "SUCCESS")][string]$Level = "INFO",
        [string]$Tool = ""
    )
    if (-not $Global:TeraLogFile) { return }
    $entry = [PSCustomObject]@{
        Timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        Level     = $Level
        User      = $env:USERNAME
        Computer  = $env:COMPUTERNAME
        Tool      = $Tool
        Message   = $Message
    }
    $line = "[{0}] [{1}] user={2} computer={3} tool={4} :: {5}" -f `
        $entry.Timestamp, $entry.Level, $entry.User, $entry.Computer, $entry.Tool, $entry.Message
    try {
        Add-Content -Path $Global:TeraLogFile -Value $line -Encoding UTF8
    } catch { }
}

function Invoke-TeraToolRun {
    param(
        [Parameter(Mandatory)][hashtable]$Tool,
        [Parameter(Mandatory)][scriptblock]$ScriptBlock
    )
    Write-TeraLog -Message "Starting tool" -Level "INFO" -Tool $Tool.Name
    try {
        & $ScriptBlock
        Write-TeraLog -Message "Completed successfully" -Level "SUCCESS" -Tool $Tool.Name
    } catch {
        Write-TeraLog -Message "Failed: $($_.Exception.Message)" -Level "ERROR" -Tool $Tool.Name
        Write-TeraLine "`nError: $($_.Exception.Message)" -Color $Global:TeraTheme.Error
    }
}
