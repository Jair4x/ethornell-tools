@echo off
setlocal enabledelayedexpansion

echo ================================================
echo    ARC Rebuild - Batch Processing Tool
echo ================================================
echo.

REM Find arc_rebuild.py
set "script="
if exist "arc_rebuild.py" (
    set "script=arc_rebuild.py"
) else if exist "..\arc_rebuild.py" (
    set "script=..\arc_rebuild.py"
) else (
    echo Error: arc_rebuild.py not found!
    echo Please make sure arc_rebuild.py is in the current directory or parent directory.
    pause
    exit /b 1
)

set /p parent="Enter parent folder name (e.g., extracted): "

if not exist "%parent%" (
    echo Error: Folder "%parent%" does not exist!
    pause
    exit /b 1
)

echo.
echo Processing all subfolders in "%parent%"...
echo.

set count=0

for /d %%D in (%parent%\*) do (
    set "folder=%%D"
    set "name=%%~nxD"
    echo [!count!] Processing: !name!
    python "%script%" "%%D" "!name!"
    echo.
    set /a count+=1
)

if !count! equ 0 (
    echo No subfolders found in "%parent%".
) else (
    echo ================================================
    echo Done! Processed !count! folder(s^).
    echo All .arc.new files have been created.
    echo ================================================
)

echo.
pause
