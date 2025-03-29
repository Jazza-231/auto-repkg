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
if exist "C:\Program Files (x86)\Steam\steamapps\workshop\content\431960\%input%\scene.pkg" (
    mkdir "%outputDir%" 2>nul
    "%repkgExe%" extract -e tex -s -o "%outputDir%" "C:\Program Files (x86)\Steam\steamapps\workshop\content\431960\%input%\scene.pkg"
    
    DEL /S *.tex *.tex-json
) else (
    :: Check if any MP4 files exist before creating output directory
    set mp4Found=0
    for /r "C:\Program Files (x86)\Steam\steamapps\workshop\content\431960\%input%" %%F in (*.mp4) do (
        set mp4Found=1
        goto mp4Exists
    )
    
    :mp4Exists
    if !mp4Found!==1 (
        echo Found MP4 files, copying...
        mkdir "%outputDir%" 2>nul
        for /r "C:\Program Files (x86)\Steam\steamapps\workshop\content\431960\%input%" %%F in (*.mp4) do (
            xcopy "%%F" "%outputDir%\" /Y
        )
    ) else (
        echo No MP4 files found, this script does not support Web or Application wallpapers. You would be better off copying those manually.
    )
)

endlocal
echo Thank you to ShikuTeshi on steam and github.com/notscuffed/repkg
pause