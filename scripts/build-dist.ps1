<#
.SYNOPSIS
    Assembles the production deployment package in 'dist/' from modular components.
.DESCRIPTION
    Copies core OptiScaler and ReShade proxy files to the root of dist/,
    and places all FSR / XeSS upscaler and FG backend libraries into the
    canonical 'dist/OptiScaler/' subdirectory expected by OptiDllPath.
#>

[CmdletBinding()]
param()

$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$componentsDir = Join-Path $root "components"
$distDir = Join-Path $root "dist"
$distOptiDir = Join-Path $distDir "OptiScaler"

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  ReShade MFG + OptiScaler NR: Package Builder" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "Source:      $componentsDir"
Write-Host "Destination: $distDir`n"

# Ensure target directories exist
if (-not (Test-Path $distDir)) {
    New-Item -ItemType Directory -Path $distDir -Force | Out-Null
}
if (-not (Test-Path $distOptiDir)) {
    New-Item -ItemType Directory -Path $distOptiDir -Force | Out-Null
}

# 1. OptiScaler Core -> dist/
Write-Host "[1/3] Copying OptiScaler core components to root of dist/..." -ForegroundColor Yellow
$optiFiles = Get-ChildItem (Join-Path $componentsDir "optiscaler") -File
foreach ($file in $optiFiles) {
    Copy-Item $file.FullName (Join-Path $distDir $file.Name) -Force
    Write-Host "  + $($file.Name)" -ForegroundColor Gray
}

# 2. ReShade MFG -> dist/
Write-Host "`n[2/3] Copying ReShade MFG components to root of dist/..." -ForegroundColor Yellow
$reshadeFiles = Get-ChildItem (Join-Path $componentsDir "reshade") -File
foreach ($file in $reshadeFiles) {
    Copy-Item $file.FullName (Join-Path $distDir $file.Name) -Force
    Write-Host "  + $($file.Name)" -ForegroundColor Gray
}

# 3. Backend Libraries -> dist/OptiScaler/
Write-Host "`n[3/3] Copying backend libraries to dist/OptiScaler/..." -ForegroundColor Yellow
$backendFiles = Get-ChildItem (Join-Path $componentsDir "backends") -File
foreach ($file in $backendFiles) {
    Copy-Item $file.FullName (Join-Path $distOptiDir $file.Name) -Force
    Write-Host "  + OptiScaler/$($file.Name)" -ForegroundColor Gray
}

# Clean any legacy loose backend files in dist/ root if present
foreach ($file in $backendFiles) {
    $loose = Join-Path $distDir $file.Name
    if (Test-Path $loose) {
        Remove-Item $loose -Force
        Write-Host "  - Removed loose root file: $($file.Name)" -ForegroundColor DarkGray
    }
}

Write-Host "`n================================================================" -ForegroundColor Green
Write-Host "  Distribution package successfully assembled in dist/!" -ForegroundColor Green
Write-Host "================================================================`n"
