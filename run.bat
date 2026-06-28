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
    echo Instalalo con: powershell -c "irm https://astral.sh/uv/install.ps1 ^| iex"
    pause
    exit /b 1
)
echo [OK] uv: %UV%

:: Use %USERPROFILE% for Python dir (AppData has untrusted mount point error 448)
set "UV_PYTHON_INSTALL_DIR=%USERPROFILE%\.qwen_uv_python"

:: Ensure Python 3.12 (system may have 3.14, too new for CUDA torch wheels)
"%UV%" python install 3.12 --force

:: Check if .venv was created with wrong Python version
if exist ".venv\pyvenv.cfg" (
    findstr /c:"version = 3.12" ".venv\pyvenv.cfg" >nul 2>&1
    if errorlevel 1 (
        echo [..] Recreando entorno con Python 3.12...
        rmdir /s /q ".venv"
    )
)

:: Install project dependencies
echo.
echo [..] Instalando dependencias...
if not exist ".venv" (
    "%UV%" sync --python 3.12
) else (
    "%UV%" sync
)
if errorlevel 1 (
    echo [ERROR] Fallo al instalar dependencias.
    pause
    exit /b 1
)

:: Replace CPU PyTorch with CUDA version
"%UV%" run python -c "import torch; torch.cuda.current_device()" >nul 2>&1
if errorlevel 1 (
    echo [..] Instalando PyTorch con CUDA...
    "%UV%" pip install --python 3.12 torch torchvision --index-url https://download.pytorch.org/whl/cu124 --force-reinstall --no-deps
    if errorlevel 1 (
        echo [AVISO] No se pudo instalar PyTorch CUDA. Usando CPU.
    )
)

echo.
echo [OK] Iniciando servidor...
echo Abriendo http://localhost:7860 en tu navegador...
"%UV%" run app.py

echo.
echo [INFO] Servidor cerrado (codigo: %ERRORLEVEL%).
pause
