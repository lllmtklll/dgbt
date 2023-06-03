@echo off
setlocal enabledelayedexpansion

set "folderPath=test"
set "outputFile=output.txt"
type nul > "%outputFile%"

for %%F in ("%folderPath%\*.txt") do (
    set "fileName=%%~nxF"
    set "matches="
    set "count=0"
    for /f "usebackq delims=" %%L in ("%%F") do (
        echo %%L | findstr /r "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]" > nul && (
            set "match=%%L"
            if defined matches (set "matches=!matches!,!match!") else set "matches=!match!"
            set /a "count+=1"
            if !count! equ 2 (
                echo !fileName!: !matches! >> "%outputFile%"
                set "matches=" & set "count=0"
            )
        )
    )
    if defined matches echo !fileName!: !matches! >> "%outputFile%"
)