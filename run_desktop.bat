@echo off
title Qwen-Image-Edit (Desktop)
cd /d "%~dp0"

echo.
echo === Qwen-Image-Edit - Desktop Native Window ===
echo.

:: Use bundled uv.exe if available, otherwise search PATH
set "UV="
if exist "%~dp0uv.exe" set "UV=%~dp0uv.exe"
if not defined UV (
    where uv.exe >nul 2>&1 && set "UV=uv.exe"
)
if not defined UV (
    echo [ERROR] uv no encontrado.
    echo.
    echo Instalalo con:
    echo   powershell -c "irm https://astral.sh/uv/install.ps1 ^| iex"
    echo.
    pause
    exit /b 1
)

:: First run - install dependencies
if not exist ".venv" (
    echo [..] Primera ejecucion - instalando dependencias...
    echo [..] Esto puede tomar varios minutos (PyTorch ~3GB).
    echo.
    "%UV%" sync
    if errorlevel 1 (
        echo [ERROR] Fallo al instalar dependencias.
        pause
        exit /b 1
    )
    echo [OK] Dependencias instaladas.
    echo.
)

:: Ensure pywebview is installed
"%UV%" run python -c "import webview" 2>nul
if errorlevel 1 (
    echo [..] Instalando pywebview para modo desktop...
    "%UV%" add pywebview
    if errorlevel 1 (
        echo [ERROR] Fallo al instalar pywebview.
        pause
        exit /b 1
    )
)

echo [OK] Iniciando aplicacion en ventana nativa...
echo Cierra la ventana para detener la aplicacion.
echo.

"%UV%" run app.py --desktop

if errorlevel 1 (
    echo.
    echo [ERROR] La aplicacion termino con error.
    pause
)
