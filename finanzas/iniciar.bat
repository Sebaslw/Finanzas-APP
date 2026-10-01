@echo off
title Finanzas - servidor local
cd /d "%~dp0"
echo.
echo  Iniciando Finanzas en localhost...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0servidor.ps1"
echo.
pause
