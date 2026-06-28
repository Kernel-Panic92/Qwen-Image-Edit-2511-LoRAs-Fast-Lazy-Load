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
    echo.
    pause
    exit /b 1
)
echo [OK] uv: %UV%

:: Find Python 3.12
set "PYTHON="
if exist "C:\Python312\python.exe" set "PYTHON=C:\Python312\python.exe"
if not defined PYTHON if exist "C:\Python312\python3.exe" set "PYTHON=C:\Python312\python3.exe"
if not defined PYTHON (
    echo [ERROR] Python 3.12 no encontrado en C:\Python312
    pause
    exit /b 1
)
echo [OK] Python: %PYTHON%

:: Create venv if needed
if not exist ".venv" (
    echo [..] Creando entorno virtual con Python 3.12...
    "%UV%" venv --python "%PYTHON%"
)

:: Install dependencies
echo.
echo [..] Instalando dependencias...
"%UV%" sync

:: Install CUDA PyTorch
"%UV%" run python -c "import torch; torch.cuda.current_device()" >nul 2>&1
if errorlevel 1 (
    echo [..] Instalando PyTorch con CUDA...
    "%UV%" pip install torch torchvision --index-url https://download.pytorch.org/whl/cu124 --force-reinstall --no-deps
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
