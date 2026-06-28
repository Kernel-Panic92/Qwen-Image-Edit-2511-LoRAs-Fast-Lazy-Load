@echo off
title Qwen-Image-Edit
cd /d "%~dp0"

echo.
echo === Qwen-Image-Edit - Windows Launcher ===
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

echo.
echo [OK] Iniciando servidor...
echo Abriendo http://localhost:7860 en tu navegador...
echo Presiona Ctrl+C para cerrar.
echo.

"%UV%" run app.py

echo.
echo [INFO] Servidor cerrado (codigo: %ERRORLEVEL%).
pause
