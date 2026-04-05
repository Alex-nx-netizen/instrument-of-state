@echo off
setlocal
powershell -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "%~dp0instrument-guard.ps1" %*
exit /b %errorlevel%
