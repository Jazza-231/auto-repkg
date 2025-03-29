@echo off
setlocal enabledelayedexpansion

set /p input=Enter folder name: 

:: Set working directories
set tempDir=%TEMP%\RePKG_Temp
set zipFile=%tempDir%\RePKG.zip
set outputDir=./%input%

:: Check if RePKG is already downloaded and extracted
if not exist "%tempDir%\RePKG.exe" (
    echo RePKG not found, downloading...
    if not exist "%tempDir%" mkdir "%tempDir%"
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/notscuffed/repkg/releases/download/v0.4.0-alpha/RePKG.zip' -OutFile '%zipFile%'"
    powershell -Command "Expand-Archive -Path '%zipFile%' -DestinationPath '%tempDir%' -Force"
)

:: Find the RePKG executable
for /r "%tempDir%" %%F in (RePKG.exe) do (
    set repkgExe=%%F
    goto found
)
echo RePKG executable not found after extraction!
exit /b

:found
mkdir "%outputDir%" 2>nul

if exist "C:\Program Files (x86)\Steam\steamapps\workshop\content\431960\%input%\scene.pkg" (
    "%repkgExe%" extract -e tex -s -o "%outputDir%" "C:\Program Files (x86)\Steam\steamapps\workshop\content\431960\%input%\scene.pkg"
    
    DEL /S *.tex *.tex-json
) else (
    echo No scene.pkg file found. Collecting MP4 files instead...
    for /r "C:\Program Files (x86)\Steam\steamapps\workshop\content\431960\%input%" %%F in (*.mp4) do (
        xcopy "%%F" "%outputDir%\" /Y
    )
)

endlocal

echo Thank you to ShikuTeshi on steam and github.com/notscuffed/repkg
pause
