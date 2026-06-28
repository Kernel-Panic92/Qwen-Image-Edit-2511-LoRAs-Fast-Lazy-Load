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
    echo Instalalo con:
    echo   powershell -c "irm https://astral.sh/uv/install.ps1 ^| iex"
    pause
    exit /b 1
)
echo [OK] uv: %UV%

:: Check / install Python
"%UV%" run python --version
if errorlevel 1 (
    echo [..] Instalando Python 3.12...
    "%UV%" python install 3.12
    if errorlevel 1 (
        echo [ERROR] No se pudo instalar Python.
        pause
        exit /b 1
    )
)

:: Install deps if needed
if not exist ".venv" (
    echo.
    echo [..] Primera ejecucion - instalando dependencias...
    echo [..] Esto puede tomar varios minutos (PyTorch ~3GB)
    echo.
    "%UV%" sync
    if errorlevel 1 (
        echo [ERROR] Fallo al instalar dependencias.
        pause
        exit /b 1
    )
    echo.
    echo [OK] Dependencias instaladas.
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
