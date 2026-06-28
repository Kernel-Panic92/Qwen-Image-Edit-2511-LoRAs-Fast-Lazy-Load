@echo off
title Qwen-Image-Edit
cd /d "%~dp0"

set "LOG=%~dp0launcher.log"
echo [%date% %time%] Iniciando > "%LOG%"

echo.
echo === Qwen-Image-Edit - Windows Launcher ===
echo.

:: Use bundled uv.exe if available, otherwise search PATH
set "UV="
if exist "%~dp0uv.exe" set "UV=%~dp0uv.exe"
if not defined UV (
    where uv.exe >nul 2>&1 && set "UV=uv.exe"
)
if not defined UV (
    echo [ERROR] uv no encontrado.
    echo [%date% %time%] ERROR: uv no encontrado >> "%LOG%"
    echo.
    echo Instalalo con:
    echo   powershell -c "irm https://astral.sh/uv/install.ps1 ^| iex"
    echo.
    pause
    exit /b 1
)
echo [OK] uv: %UV%
echo [%date% %time%] uv: %UV% >> "%LOG%"

:: Check Python version
"%UV%" run python --version 2>&1
if errorlevel 1 (
    echo [ERROR] Python no disponible. Ejecutando 'uv python install'...
    echo [%date% %time%] Instalando Python via uv >> "%LOG%"
    "%UV%" python install 3.12
    if errorlevel 1 (
        echo [ERROR] No se pudo instalar Python.
        pause
        exit /b 1
    )
)

:: First run - install dependencies
if not exist ".venv" (
    echo.
    echo [..] Primera ejecucion - instalando dependencias...
    echo [..] Esto puede tomar varios minutos (PyTorch ~3GB).
    echo [..] Revisa el archivo launcher.log para ver el progreso.
    echo.
    "%UV%" sync >> "%LOG%" 2>&1
    if errorlevel 1 (
        echo [ERROR] Fallo al instalar dependencias.
        echo [%date% %time%] ERROR: uv sync fallo >> "%LOG%"
        echo.
        echo Revisa el log: %LOG%
        pause
        exit /b 1
    )
    echo [OK] Dependencias instaladas.
    echo [%date% %time%] uv sync OK >> "%LOG%"
    echo.
)

echo [OK] Iniciando aplicacion...
echo [%date% %time%] Iniciando app.py >> "%LOG%"
echo.
echo Abre http://localhost:7860 en tu navegador
echo Presiona Ctrl+C para cerrar.
echo.

"%UV%" run app.py >> "%LOG%" 2>&1

echo [%date% %time%] app.py termino con codigo: %ERRORLEVEL% >> "%LOG%"
echo.
echo [INFO] La aplicacion se cerro. Revisa el log: %LOG%
pause
