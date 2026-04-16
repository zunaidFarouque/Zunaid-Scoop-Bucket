@echo off
setlocal
set "SCRIPT_DIR=%~dp0"
set "PS1=%SCRIPT_DIR%force-update-taskbarmediacontrols-plus.ps1"
pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%PS1%"
if errorlevel 1 (
  echo.
  echo Script failed. Press any key to close.
  pause >nul
  exit /b 1
)
echo.
echo Done. Press any key to close.
pause >nul
