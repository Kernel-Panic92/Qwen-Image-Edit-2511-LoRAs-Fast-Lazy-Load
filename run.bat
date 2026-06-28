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

:: Check Python 3.12 - use local dir to avoid broken %APPDATA%\uv\python
set "UV_PYTHON_INSTALL_DIR=%~dp0.uv_python"
if not exist "%UV_PYTHON_INSTALL_DIR%" mkdir "%UV_PYTHON_INSTALL_DIR%"
"%UV%" run python --version
if errorlevel 1 (
    echo [..] Instalando Python 3.12...
    "%UV%" python install 3.12
    if errorlevel 1 (
        echo.
        echo [ERROR] No se pudo instalar Python.
        echo.
        echo Asegurate de tener Python 3.12 instalado en el sistema:
        echo   https://www.python.org/downloads/
        echo O desconecta OneDrive/antivirus y reintenta.
        echo.
        pause
        exit /b 1
    )
)

:: Install project dependencies
echo.
echo [..] Instalando dependencias...
"%UV%" sync
if errorlevel 1 (
    echo [ERROR] Fallo al instalar dependencias.
    pause
    exit /b 1
)

:: Ensure CUDA PyTorch (force reinstall from PyTorch index)
"%UV%" run python -c "import torch; torch.cuda.current_device()" >nul 2>&1
if errorlevel 1 (
    echo [..] Instalando PyTorch con CUDA...
    "%UV%" pip install torch torchvision --index-url https://download.pytorch.org/whl/cu124 --force-reinstall --no-deps
    if errorlevel 1 (
        echo [ADVERTENCIA] No se pudo instalar PyTorch con CUDA.
        echo La aplicacion funcionara en CPU (muy lento).
    )
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
