@echo off
setlocal enabledelayedexpansion

echo ================================================
echo    ARC Extract - Batch Processing Tool
echo ================================================
echo.

REM Find arc_extract.py
set "script="
if exist "arc_extract.py" (
    set "script=arc_extract.py"
) else if exist "..\arc_extract.py" (
    set "script=..\arc_extract.py"
) else (
    echo Error: arc_extract.py not found!
    echo Please make sure arc_extract.py is in the current directory or parent directory.
    pause
    exit /b 1
)

set /p arc_folder="Enter folder with .arc files: "

if "%arc_folder%"=="" (
    echo Error: Folder path is required!
    pause
    exit /b 1
)

if not exist "%arc_folder%" (
    echo Error: Folder "%arc_folder%" does not exist!
    pause
    exit /b 1
)

set /p parent_dir="Enter parent folder name to create (e.g., extracted): "

if "%parent_dir%"=="" (
    echo Error: Parent folder name is required!
    pause
    exit /b 1
)

REM Create parent directory if it doesn't exist
if not exist "%parent_dir%" (
    mkdir "%parent_dir%"
    echo Created parent directory: %parent_dir%
)

echo.
echo Extracting all .arc files in "%arc_folder%"...
echo.

set count=0

for %%F in (%arc_folder%\*.arc) do (
    set "arc_file=%%F"
    set "arc_name=%%~nF"
    
    echo [!count!] Extracting: !arc_file!
    echo    Output: %parent_dir%\!arc_name!
    
    python "%script%" "%%F" "%parent_dir%\!arc_name!"
    echo.
    
    set /a count+=1
)

if !count! equ 0 (
    echo No .arc files found in "%arc_folder%".
) else (
    echo ================================================
    echo Done! Extracted !count! archive(s^) to "%parent_dir%".
    echo ================================================
)

echo.
pause
