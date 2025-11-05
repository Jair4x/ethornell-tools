@echo off
setlocal enabledelayedexpansion

echo ================================================
echo    DSC Analyze Keys - Batch Processing Tool
echo ================================================
echo.

REM Find analyze_key.py
set "script="
if exist "analyze_key.py" (
    set "script=analyze_key.py"
) else if exist "..\analyze_key.py" (
    set "script=..\analyze_key.py"
) else (
    echo Error: analyze_key.py not found!
    echo Please make sure analyze_key.py is in the current directory or parent directory.
    pause
    exit /b 1
)

set /p folder="Enter folder with DSC files to analyze: "

if not exist "%folder%" (
    echo Error: Folder "%folder%" does not exist!
    pause
    exit /b 1
)

echo.
echo Analyzing all DSC (extensionless) files in "%folder%"...
echo.

set count=0
set output_file=keys.txt

REM Clear or create keys.txt
echo. > "%output_file%"

for %%F in (%folder%\*) do (
    set "filepath=%%F"
    set "filename=%%~nxF"
    
    REM Check if file has no extension (no dot in filename)
    echo !filename! | findstr /R "^[^.]*$" >nul
    if !errorlevel! equ 0 (
        echo [!count!] Analyzing: !filename!
        
        REM Run analyze_key.py and capture the key
        for /f "tokens=2" %%K in ('python "%script%" "%%F" ^| findstr /C:"Encryption Key:"') do (
            echo !filename! - %%K >> "%output_file%"
        )
        
        set /a count+=1
    )
)

echo.
echo ================================================

if !count! equ 0 (
    echo No DSC (extensionless) files found in "%folder%".
    del "%output_file%" 2>nul
) else (
    echo Done! Analyzed !count! file(s^).
    echo Keys saved to: %output_file%
)

echo.
pause
