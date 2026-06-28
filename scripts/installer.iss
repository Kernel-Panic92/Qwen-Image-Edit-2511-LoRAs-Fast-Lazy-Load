; Qwen-Image-Edit Windows Installer
; Requires Inno Setup 6+ (https://jrsoftware.org/isinfo.php)
;
; BUILD:
;   1. Run scripts/build_installer.ps1 (downloads uv.exe automatically)
;      OR manually place uv.exe in scripts\redist\uv.exe
;   2. Open this file in Inno Setup Compiler and click Build
;   3. Output: scripts\output\Qwen-Image-Edit-Setup-{version}.exe

#define MyAppName "Qwen-Image-Edit"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Prithiv Sakthi"
#define MyAppURL "https://github.com/PRITHIVSAKTHIUR/Qwen-Image-Edit-2511-LoRAs-Fast-Lazy-Load"
#define MyAppExec "run.bat"
#define MyAppAssocName "Qwen Image Edit"

[Setup]
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

; Install to C:\Qwen-Image-Edit (avoids AppData filesystem restrictions)
DefaultDirName=C:\{#MyAppName}
DefaultGroupName={#MyAppName}
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=dialog
OutputBaseFilename=Qwen-Image-Edit-Setup-{#MyAppVersion}

OutputDir=output
SetupIconFile=icon.ico
UninstallDisplayIcon={app}\icon.ico
UninstallDisplayName={#MyAppName}

Compression=lzma2/ultra64
SolidCompression=yes
LZMAUseSeparateProcess=yes
DiskSpanning=no

; Windows version range
MinVersion=10.0.17763
ArchitecturesInstallIn64BitMode=x64compatible
ChangesAssociations=no

; Appearance
WizardStyle=modern
WizardSizePercent=100,100
DisableProgramGroupPage=yes
DisableReadyPage=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Messages]
SetupAppTitle=Qwen-Image-Edit
SetupWindowTitle=Instalador de Qwen-Image-Edit - {#MyAppVersion}

[Tasks]
; Empty - icons are created unconditionally below

[Files]
; Source code
Source: "..\app.py"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\pyproject.toml"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\requirements.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\README.md"; DestDir: "{app}"; Flags: ignoreversion

; QwenImage package
Source: "..\qwenimage\*.py"; DestDir: "{app}\qwenimage"; Flags: ignoreversion

; Example images
Source: "..\examples\*.jpg"; DestDir: "{app}\examples"; Flags: ignoreversion
Source: "..\examples\*.jpeg"; DestDir: "{app}\examples"; Flags: ignoreversion

; uv binary (downloaded by build script)
Source: "redist\uv.exe"; DestDir: "{app}"; Flags: ignoreversion

; Launchers
Source: "..\run.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\run_desktop.bat"; DestDir: "{app}"; Flags: ignoreversion

; Python detection script
Source: "check_python.ps1"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExec}"; WorkingDir: "{app}"
Name: "{autoprograms}\{#MyAppName} (Ventana Nativa)"; Filename: "{app}\run_desktop.bat"; WorkingDir: "{app}"; IconFilename: "{app}\icon.ico"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExec}"; WorkingDir: "{app}"
Name: "{autodesktop}\{#MyAppName} (Ventana Nativa)"; Filename: "{app}\run_desktop.bat"; WorkingDir: "{app}"; IconFilename: "{app}\icon.ico"
; Uninstall
Name: "{autoprograms}\Desinstalar {#MyAppName}"; Filename: "{uninstallexe}"

[Run]
; Run the app after install (user checkbox)
Filename: "{app}\{#MyAppExec}"; Description: "Ejecutar {#MyAppName} ahora"; Flags: postinstall nowait skipifsilent shellexec

[UninstallRun]
; Clean up virtual environment to free space
Filename: "{cmd}"; Parameters: "/C rmdir /S /Q ""{app}\.venv"""; Flags: runhidden
; Clean up HF cache
Filename: "{cmd}"; Parameters: "/C rmdir /S /Q ""{app}\.hf_cache"""; Flags: runhidden

[Code]
