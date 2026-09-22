@echo off
setlocal enabledelayedexpansion

echo ================================================================
echo   ReShade MFG 4X + OptiScaler DLSS-NR Universal Installer
echo ================================================================
echo.

if exist "%~dp0dist" (
    set "DIST_DIR=%~dp0dist"
) else (
    set "DIST_DIR=%~dp0..\dist"
)

set "TARGET_DIR=%~1"

if "%TARGET_DIR%"=="" (
    set "DEFAULT_CP2077=C:\Program Files (x86)\Steam\steamapps\common\Cyberpunk 2077\bin\x64"
    if exist "!DEFAULT_CP2077!\Cyberpunk2077.exe" (
        echo Detected Cyberpunk 2077 at:
        echo   !DEFAULT_CP2077!
        echo.
        set /p "USE_DEFAULT=Deploy to this directory? [Y/N, default Y]: "
        if /i "!USE_DEFAULT!"=="" set "TARGET_DIR=!DEFAULT_CP2077!"
        if /i "!USE_DEFAULT!"=="y" set "TARGET_DIR=!DEFAULT_CP2077!"
    )
)

if "%TARGET_DIR%"=="" (
    echo.
    set /p "TARGET_DIR=Enter the absolute path to the game's executable directory: "
)

set "TARGET_DIR=%TARGET_DIR:"=%"

if not exist "%TARGET_DIR%" (
    echo ERROR: Target directory does not exist: "%TARGET_DIR%"
    exit /b 1
)

echo.
echo Deploying files to: "%TARGET_DIR%"
echo ----------------------------------------------------------------

if exist "%TARGET_DIR%\dxgi.dll" (
    if not exist "%TARGET_DIR%\dxgi.dll.bak" (
        echo Backing up existing dxgi.dll to dxgi.dll.bak
        copy /y "%TARGET_DIR%\dxgi.dll" "%TARGET_DIR%\dxgi.dll.bak" >nul
    )
)
if exist "%TARGET_DIR%\OptiScaler.ini" (
    if not exist "%TARGET_DIR%\OptiScaler.ini.bak" (
        echo Backing up existing OptiScaler.ini to OptiScaler.ini.bak
        copy /y "%TARGET_DIR%\OptiScaler.ini" "%TARGET_DIR%\OptiScaler.ini.bak" >nul
    )
)

xcopy /y /e /i "%DIST_DIR%\*" "%TARGET_DIR%\" >nul
if errorlevel 1 (
    echo ERROR: File copy failed. Make sure the game is closed and run as administrator if required.
    exit /b 1
)

echo.
echo ================================================================
echo   Installation completed successfully!
echo ================================================================
echo.
echo In-Game Controls:
echo   [F11] - OptiScaler Menu (DLSS Neural Rendering, Super Resolution)
echo   [F10] - ReShade Menu (Add-ons tab -^> MFG Unlock for 3X/4X)
echo   [+]   - Quick Toggle DLSS Neural Rendering On/Off
echo.
pause
