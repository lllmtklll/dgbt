@echo off
setlocal enabledelayedexpansion

REM フォルダのパスを指定
set "folderPath=test"

REM 出力ファイル名とパスを指定
set "outputFile=output.txt"

REM 出力ファイルを初期化
type nul > "%outputFile%"

REM テキストファイルを処理
for %%F in ("%folderPath%\*.txt") do (
    REM ファイル名を取得
    set "fileName=%%~nxF"

    REM ファイルの内容を読み込んで処理
    set "matches="
    set "count=0"
    for /f "usebackq delims=" %%L in ("%%F") do (
        REM 正規表現を使用して8連続の数字を抽出
        echo %%L | findstr /r "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]" > nul
        if not errorlevel 1 (
            REM 抽出した数字を変数に追加
            set "match=%%L"
            if defined matches (
                set "matches=!matches!,!match!"
            ) else (
                set "matches=!match!"
            )
            set /a "count+=1"
            REM 8つの数字が2つある場合に出力ファイルに追記してリセット
            if !count! equ 2 (
                echo !fileName!: !matches! >> "%outputFile%"
                set "matches="
                set "count=0"
            )
        )
    )
    REM カンマ区切りの数字が1つだけ残っている場合に出力ファイルに追記
    if defined matches (
        echo !fileName!: !matches! >> "%outputFile%"
    )
)
