@setlocal enableextensions enabledelayedexpansion
@echo off
::codepage for chinese
rem chcp 65001>nul
set file=%~1
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
::traverse lines and skip blank lines by default, skip 312 lines
for /f "usebackq delims=" %%a in ("!file!") do (
    set ln=%%a
    if "x!ln:~0,4!"=="x[Btn" (
        :: this line is not used
        echo Set oWS = WScript.CreateObject^("WScript.Shell"^)>!SCRIPT!
    ) else (
        for /f "tokens=1,2 delims==" %%b in ("!ln!") do (
            set currkey=%%b
            set currval=%%c
            if "x!currkey!"=="xName" (
                echo Set oLink = oWS.CreateShortcut^("!currval!.lnk"^)>>!SCRIPT!
            )
            if "x!currkey!"=="xFile" (
                if DEFINED currval echo oLink.TargetPath = "!currval!">>!SCRIPT!
            )
            if "x!currkey!"=="xDirectory" (
                if DEFINED currval echo oLink.WorkingDirectory = "!currval!">>!SCRIPT!
            )
            if "x!currkey!"=="xParameter" (
                if DEFINED currval echo oLink.Arguments = "!currval!">>!SCRIPT!
            )
            if "x!currkey!"=="xWindowStat" (
                if DEFINED currval echo oLink.WindowStyle = "!currval!">>!SCRIPT!
            )
            if "x!currkey!"=="xIconFile" (
                if DEFINED currval echo oLink.IconLocation = "!currval!">>!SCRIPT!
            )
            if "x!currkey!"=="xTip" (
                if DEFINED currval echo oLink.Description = "!currval!">>!SCRIPT!
            )
            :: keyword "keyboard" indicates the end of a shortcut, xType to exclude claunch system shortcuts
            if "x!currkey!"=="xType" set xType=!currval!
            if "x!currkey!!xType!"=="xKeyboard00000001" (
                echo oLink.Save>>!SCRIPT!
                rem powershell -c "Get-Content -Encoding utf8 !SCRIPT! | Set-Content -Encoding unicode tmp00000001.vbs"
                cscript //Nologo !SCRIPT!
            )
        )
    )
)
echo "!SCRIPT!"
endlocal
