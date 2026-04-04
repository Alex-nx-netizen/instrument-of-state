@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0instrument-guard.ps1" %*
