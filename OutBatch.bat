@echo off
setlocal enabledelayedexpansion

REM フォルダのパスを指定
set "folderPath=test"

REM 出力ファイル名とパスを指定
set "outputFile=output.csv"

REM テキストファイルを処理してCSVファイルに出力
echo "File Name","First Number","Second Number" > "%outputFile%"
for %%F in ("%folderPath%\*.txt") do (
    REM ファイル名を取得
    set "fileName=%%~nxF"

    REM ファイルの内容を読み込んで処理
    set "firstNumber="
    set "secondNumber="
    for /f "usebackq delims=" %%L in ("%%F") do (
        REM 正規表現を使用して8連続の数字を抽出
        echo %%L | findstr /r "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]" > nul
        if not errorlevel 1 (
            REM 抽出した数字を変数に格納
            if not defined firstNumber (
                set "firstNumber=%%L"
            ) else (
                set "secondNumber=%%L"
            )
        )
    )
    REM 1つ目の数字と2つ目の数字をCSVファイルに出力
    if defined firstNumber (
        echo "!fileName!","!firstNumber!","!secondNumber!" >> "%outputFile%"
    )
)

REM CSVファイルをExcelで開く
start excel "%outputFile%"
