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

:: Find Python 3.12 (installed by installer, or system)
set "PYTHON="
if exist "C:\Python312\python.exe" set "PYTHON=C:\Python312\python.exe"
if not defined PYTHON if exist "C:\Python312\python3.exe" set "PYTHON=C:\Python312\python3.exe"
if not defined PYTHON (
    echo [ERROR] Python 3.12 no encontrado en C:\Python312
    echo Reinstala la aplicacion para instalar Python 3.12.
    echo.
    pause
    exit /b 1
)
echo [OK] Python: %PYTHON%

:: Create venv with Python 3.12 if needed
if not exist ".venv" (
    echo [..] Creando entorno virtual con Python 3.12...
    "%UV%" venv --python "%PYTHON%"
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

:: Install CUDA PyTorch (Python 3.12 is compatible with CUDA wheels)
"%UV%" run python -c "import torch; torch.cuda.current_device()" >nul 2>&1
if errorlevel 1 (
    echo [..] Instalando PyTorch con CUDA...
    "%UV%" pip install torch torchvision --index-url https://download.pytorch.org/whl/cu124 --force-reinstall --no-deps
    if errorlevel 1 (
        echo [AVISO] No se pudo instalar PyTorch CUDA.
    ) else (
        echo [OK] PyTorch CUDA instalado.
    )
)

echo.
echo [OK] Iniciando servidor...
echo Abriendo http://localhost:7860 en tu navegador...
"%UV%" run app.py

echo.
echo [INFO] Servidor cerrado (codigo: %ERRORLEVEL%).
pause
