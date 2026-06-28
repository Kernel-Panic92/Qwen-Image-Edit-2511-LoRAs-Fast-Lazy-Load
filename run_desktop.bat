@echo off
title Qwen-Image-Edit (Desktop)
cd /d "%~dp0"

echo.
echo === Qwen-Image-Edit - Desktop Native Window ===
echo.

:: Find uv
set "UV="
if exist "%~dp0uv.exe" set "UV=%~dp0uv.exe"
if not defined UV (
    where uv.exe >nul 2>&1 && set "UV=uv.exe"
)
if not defined UV (
    echo [ERROR] uv no encontrado.
    echo Instalalo con: powershell -c "irm https://astral.sh/uv/install.ps1 ^| iex"
    pause
    exit /b 1
)
echo [OK] uv: %UV%

:: Ensure Python 3.12
"%UV%" python install 3.12 2>nul

:: Install project dependencies
echo.
echo [..] Instalando dependencias...
"%UV%" sync
if errorlevel 1 (
    echo [ERROR] Fallo al instalar dependencias.
    pause
    exit /b 1
)

:: Ensure CUDA-enabled PyTorch (override CPU-only from PyPI)
"%UV%" run python -c "import torch; torch.cuda.current_device()" >nul 2>&1
if errorlevel 1 (
    echo [..] Instalando PyTorch con CUDA...
    "%UV%" pip install torch torchvision --index-url https://download.pytorch.org/whl/cu124 --force-reinstall --no-deps
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

echo.
echo [OK] Iniciando aplicacion en ventana nativa...
echo Cierra la ventana para detener la aplicacion.
echo.

"%UV%" run app.py --desktop

echo.
echo [INFO] Servidor cerrado (codigo: %ERRORLEVEL%).
pause
