@echo off
set "INSTRUMENT_MARKET_RAWARGS=%*"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0instrument-market.ps1"
