@echo off
setlocal
rem Windows launcher for create_stac_parser.sh so it works from ANY terminal
rem (CMD, PowerShell, Windows Terminal, VS Code integrated terminal).
rem
rem Auto-detects bash from Git for Windows, MSYS2, Cmder, or WSL, then
rem forwards all arguments to the portable shell script.
rem
rem Usage:
rem   create_stac_parser.cmd MyWidget
rem   create_stac_parser.cmd MyWidget layout/custom

set "ROOT=%~dp0"
set "SH=create_stac_parser.sh"

rem The script uses relative lib/ paths, so run from the project root.
cd /d "%ROOT%"

rem 1) bash on PATH (Git Bash, MSYS2, Cmder, ...)
where bash >nul 2>nul
if not errorlevel 1 (
  bash "%ROOT%%SH%" %*
  exit /b %errorlevel%
)

rem 2) Common Git for Windows install locations
for %%P in (
  "%ProgramFiles%\Git\bin\bash.exe"
  "%ProgramFiles(x86)%\Git\bin\bash.exe"
  "%LocalAppData%\Programs\Git\bin\bash.exe"
) do (
  if exist %%P (
    %%P "%ROOT%%SH%" %*
    exit /b %errorlevel%
  )
)

rem 3) Windows Subsystem for Linux
where wsl >nul 2>nul
if not errorlevel 1 (
  for /f "delims=" %%W in ('wsl wslpath -a "%ROOT%"') do set "WSLROOT=%%W"
  wsl bash -c "cd '%WSLROOT%' && ./%SH% %*"
  exit /b %errorlevel%
)

echo Error: no bash interpreter found.
echo Install Git for Windows (https://git-scm.com/downloads/win) or enable WSL,
echo then re-run this script from any terminal (CMD, PowerShell, Windows Terminal).
exit /b 1