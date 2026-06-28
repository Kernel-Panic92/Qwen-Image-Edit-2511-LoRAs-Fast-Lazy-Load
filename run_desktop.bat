@echo off
title Qwen-Image-Edit (Desktop)
cd /d "%~dp0"

echo.
echo === Qwen-Image-Edit - Desktop Native Window ===
echo.

:: Find uv
set "UV="
if exist "%~dp0uv.exe" set "UV=%~dp0uv.exe"
if not defined UV where uv.exe >nul 2>&1 && set "UV=uv.exe"
if not defined UV (
    echo [ERROR] uv no encontrado.
    echo Instalalo con: powershell -c "irm https://astral.sh/uv/install.ps1 ^| iex"
    pause
    exit /b 1
)
echo [OK] uv: %UV%

:: Install deps
echo.
echo [..] Instalando dependencias...
"%UV%" sync
if errorlevel 1 (
    echo [..] Python no disponible. Instalando Python 3.12...
    "%UV%" python install 3.12
    if errorlevel 1 (
        echo [ERROR] No se pudo instalar Python.
        echo Instalalo manualmente: https://www.python.org/downloads/
        pause
        exit /b 1
    )
    "%UV%" sync
    if errorlevel 1 (
        echo [ERROR] Fallo al instalar dependencias.
        pause
        exit /b 1
    )
)

:: Replace CPU PyTorch with CUDA version
"%UV%" run python -c "import torch; torch.cuda.current_device()" >nul 2>&1
if errorlevel 1 (
    echo [..] Instalando PyTorch con CUDA...
    "%UV%" pip install torch torchvision --index-url https://download.pytorch.org/whl/cu124 --force-reinstall --no-deps
    if errorlevel 1 (
        echo [AVISO] No se pudo instalar PyTorch CUDA. Usando CPU.
    )
)

:: Install pywebview if needed
"%UV%" run python -c "import webview" >nul 2>&1
if errorlevel 1 (
    echo [..] Instalando pywebview para modo ventana...
    "%UV%" add pywebview
)

echo.
echo [OK] Iniciando ventana nativa...
"%UV%" run app.py --desktop

echo.
echo [INFO] Ventana cerrada (codigo: %ERRORLEVEL%).
pause
