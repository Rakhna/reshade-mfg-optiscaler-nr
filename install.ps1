param (
    [string]$TargetDir = ""
)

& (Join-Path $PSScriptRoot "scripts\install.ps1") -TargetDir $TargetDir
