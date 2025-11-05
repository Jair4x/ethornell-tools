@echo off
setlocal enabledelayedexpansion

echo ================================================
echo    DSC Decompress - Batch Processing Tool
echo ================================================
echo.

REM Find dsc_decompress.py
set "script="
if exist "dsc_decompress.py" (
    set "script=dsc_decompress.py"
) else if exist "..\dsc_decompress.py" (
    set "script=..\dsc_decompress.py"
) else (
    echo Error: dsc_decompress.py not found!
    echo Please make sure dsc_decompress.py is in the current directory or parent directory.
    pause
    exit /b 1
)

set /p parent="Enter parent folder with subfolders (e.g., extracted): "

if not exist "%parent%" (
    echo Error: Folder "%parent%" does not exist!
    pause
    exit /b 1
)

set /p output_parent="Enter output parent folder name (e.g., decompressed): "

if "%output_parent%"=="" (
    echo Error: Output folder name is required!
    pause
    exit /b 1
)

REM Create output parent folder if it doesn't exist
if not exist "%output_parent%" (
    mkdir "%output_parent%"
    echo Created output folder: %output_parent%
)

echo.
echo Processing all subfolders in "%parent%"...
echo Output parent folder: %output_parent%
echo.

set count=0

for /d %%D in (%parent%\*) do (
    set "subfolder=%%D"
    set "subfolder_name=%%~nxD"
    
    echo ================================================
    echo Processing subfolder: !subfolder_name!
    echo ================================================
    
    REM Create corresponding output subfolder
    set "output_subfolder=%output_parent%\!subfolder_name!"
    if not exist "!output_subfolder!" (
        mkdir "!output_subfolder!"
    )
    
    set subcount=0
    
    for %%F in (%%D\*) do (
        set "filepath=%%F"
        set "filename=%%~nxF"
        
        REM Check if file has no extension (no dot in filename)
        echo !filename! | findstr /R "^[^.]*$" >nul
        if !errorlevel! equ 0 (
            echo   [!subcount!] Decompressing: !filename!
            python "%script%" "%%F" "!output_subfolder!/"
            set /a subcount+=1
        )
    )
    
    echo   Decompressed !subcount! file(s^) from !subfolder_name!
    echo.
    set /a count+=!subcount!
)

if !count! equ 0 (
    echo No DSC (extensionless) files found in "%parent%".
) else (
    echo ================================================
    echo Done! Decompressed !count! total file(s^) to "%output_parent%".
    echo ================================================
)

echo.
pause
