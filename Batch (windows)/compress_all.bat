@echo off
setlocal enabledelayedexpansion

echo ================================================
echo    DSC Compress - Batch Processing Tool
echo ================================================
echo.

REM Find dsc_compress.py
set "script="
if exist "dsc_compress.py" (
    set "script=dsc_compress.py"
) else if exist "..\dsc_compress.py" (
    set "script=..\dsc_compress.py"
) else (
    echo Error: dsc_compress.py not found!
    echo Please make sure dsc_compress.py is in the current directory or parent directory.
    pause
    exit /b 1
)

set /p folder="Enter folder with DSC files to compress: "

if not exist "%folder%" (
    echo Error: Folder "%folder%" does not exist!
    pause
    exit /b 1
)

if not exist "keys.txt" (
    echo Error: keys.txt not found!
    echo Please run analyze_all.bat first to generate the keys file.
    pause
    exit /b 1
)

echo.
echo Reading keys from keys.txt...
echo Processing all DSC (extensionless) files in "%folder%"...
echo.

set count=0

for %%F in (%folder%\*) do (
    set "filepath=%%F"
    set "filename=%%~nxF"
    
    REM Check if file has no extension (no dot in filename)
    echo !filename! | findstr /R "^[^.]*$" >nul
    if !errorlevel! equ 0 (
        REM Find the key for this file from keys.txt
        set "key="
        for /f "tokens=1,3" %%A in (keys.txt) do (
            if "%%A"=="!filename!" (
                set "key=%%B"
            )
        )
        
        if defined key (
            echo [!count!] Compressing: !filename! with key !key!
            python "%script%" "%%F" "%%F_compressed" !key!
            echo.
            set /a count+=1
        ) else (
            echo [!count!] Warning: No key found for !filename! in keys.txt, skipping...
            echo.
        )
    )
)

if !count! equ 0 (
    echo No DSC (extensionless) files found in "%folder%".
) else (
    echo ================================================
    echo Done! Compressed !count! file(s^).
    echo All files saved with "_compressed" suffix.
    echo ================================================
)

echo.
pause
