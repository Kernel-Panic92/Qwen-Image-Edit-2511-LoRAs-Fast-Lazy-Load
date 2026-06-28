@echo off
title Qwen-Image-Edit
cd /d "%~dp0"

echo.
echo === Qwen-Image-Edit - Windows Launcher ===
echo.

:: Find uv
set "UV="
if exist "%~dp0uv.exe" set "UV=%~dp0uv.exe"
if not defined UV where uv.exe >nul 2>&1 && set "UV=uv.exe"
if not defined UV (
    echo [ERROR] uv no encontrado.
    echo.
    pause
    exit /b 1
)
echo [OK] uv: %UV%

:: Find Python (avoid uv python install - creates symlinks blocked by Windows on this PC)
set "PYTHON="
if exist "C:\Python314\python.exe" set "PYTHON=C:\Python314\python.exe"
if not defined PYTHON if exist "C:\Python312\python.exe" set "PYTHON=C:\Python312\python.exe"
if not defined PYTHON where python.exe >nul 2>&1 && set "PYTHON=python.exe"
if not defined PYTHON (
    echo [ERROR] No se encuentra Python.
    pause
    exit /b 1
)
echo [OK] Python: %PYTHON%

:: Create venv if needed
if not exist ".venv" (
    echo [..] Creando entorno virtual...
    "%PYTHON%" -m venv .venv
    if errorlevel 1 (
        echo [ERROR] No se pudo crear el entorno virtual.
        pause
        exit /b 1
    )
)

:: Install dependencies
echo.
echo [..] Instalando dependencias...
"%UV%" sync
if errorlevel 1 (
    echo [ERROR] Fallo al instalar dependencias.
    pause
    exit /b 1
)

echo.
echo [OK] Iniciando servidor...
echo Abriendo http://localhost:7860 en tu navegador...
"%UV%" run app.py

echo.
echo [INFO] Servidor cerrado (codigo: %ERRORLEVEL%).
pause
