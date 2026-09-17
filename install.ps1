param (
    [string]$TargetDir = ""
)

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  ReShade MFG 4X + OptiScaler DLSS-NR Universal Installer" -ForegroundColor Cyan
Write-Host "================================================================`n"

$distDir = Join-Path $PSScriptRoot "dist"

if (-not $TargetDir) {
    $defaultCp = "C:\Program Files (x86)\Steam\steamapps\common\Cyberpunk 2077\bin\x64"
    if (Test-Path (Join-Path $defaultCp "Cyberpunk2077.exe")) {
        Write-Host "Detected Cyberpunk 2077 at:`n  $defaultCp`n" -ForegroundColor Yellow
        $resp = Read-Host "Deploy to this directory? [Y/N, default Y]"
        if ($resp -eq "" -or $resp -match "^[Yy]") {
            $TargetDir = $defaultCp
        }
    }
}

if (-not $TargetDir) {
    $TargetDir = Read-Host "Enter the absolute path to the game's executable directory"
}

$TargetDir = $TargetDir.Trim('"')

if (-not (Test-Path $TargetDir)) {
    Write-Error "Target directory does not exist: $TargetDir"
    exit 1
}

Write-Host "`nDeploying files to: $TargetDir" -ForegroundColor Green
Write-Host "----------------------------------------------------------------"

# Backup
$dxgi = Join-Path $TargetDir "dxgi.dll"
if (Test-Path $dxgi) {
    $bak = Join-Path $TargetDir "dxgi.dll.bak"
    if (-not (Test-Path $bak)) {
        Copy-Item $dxgi $bak -Force
        Write-Host "Backed up dxgi.dll to dxgi.dll.bak" -ForegroundColor Gray
    }
}

$ini = Join-Path $TargetDir "OptiScaler.ini"
if (Test-Path $ini) {
    $bakIni = Join-Path $TargetDir "OptiScaler.ini.bak"
    if (-not (Test-Path $bakIni)) {
        Copy-Item $ini $bakIni -Force
        Write-Host "Backed up OptiScaler.ini to OptiScaler.ini.bak" -ForegroundColor Gray
    }
}

Copy-Item (Join-Path $distDir "*") $TargetDir -Recurse -Force
Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host "  Installation completed successfully!" -ForegroundColor Green
Write-Host "================================================================`n"
Write-Host "In-Game Controls:" -ForegroundColor Yellow
Write-Host "  [F11] - OptiScaler Menu (DLSS Neural Rendering, Super Resolution)"
Write-Host "  [F10] - ReShade Menu (Add-ons tab -> MFG Unlock for 3X/4X)"
Write-Host "  [+]   - Quick Toggle DLSS Neural Rendering On/Off`n"
