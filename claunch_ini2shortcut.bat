@setlocal enableextensions enabledelayedexpansion
@echo off
::codepage for chinese
rem chcp 65001>nul
set file=%~1

rem set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
set SCRIPT="C:\Users\Daibu\Desktop\kk.vbs"

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
            :: keyword "keyboard" indicates the end of a shortcut, xType to exclude claunch system shortcuts(nonono , "IconIndex" if have, indicates eof) 没icon的建议手动处理
            if "x!currkey!"=="xType" set xType=!currval!
            if "x!currkey!!xType!"=="xKeyboard00000001" (
                echo oLink.Save>>!SCRIPT!
                rem powershell -c "Get-Content -Encoding utf8 !SCRIPT! | Set-Content -Encoding unicode tmp00000001.vbs"
                cscript //Nologo !SCRIPT!
            )
        )
    )
)
echo !SCRIPT!
endlocal



rem Set oWS = WScript.CreateObject("WScript.Shell")
rem Set oLink = oWS.CreateShortcut("C:\Users\Daibu\Desktop\tmp527.lnk")
rem fname = "知云文献翻译"
rem oLink.TargetPath = "D:\ProgramFiles86\ZhiyunTranslator\ZhiYunTranslator.exe"
rem oLink.WorkingDirectory = "D:\ProgramFiles86\ZhiyunTranslator"
rem oLink.WindowStyle = "1"
rem oLink.Description = "知云文献翻译"
rem oLink.Save

:: 示例vbs，原本计划1.从vbs执行cmd命令或者调用FileSystemObject来重命名快捷方式,结果是代码中中文无法被使用，且cmd方式无法修改快捷方式的描述文字
rem oWS.Run "cmd /c rename tmp527.lnk " & fname

rem fname = "知云文献翻译"
rem Set Fso = WScript.CreateObject("Scripting.FileSystemObject")
rem Fso.MoveFile "C:\Users\Daibu\Desktop\name.lnk", fname & ".txt"


:: 示例vbs，原本计划2.以为Shell.Application可以应对unicode字符(不过该方式可以修改shortcut对象的全部属性),结果是只要在vbs中的中文路径名称都会乱码(表现为路径无法读-引用搜索、无法写-重命名)
rem Set objShell = CreateObject("Shell.Application")
rem Set objFolder = objShell.NameSpace("C:\Users\Daibu\Desktop\")
rem Set objFolderItem = objFolder.ParseName("tmp527.lnk")

rem objFolderItem.Name = "中文名称"
rem Set objShortcut = objFolderItem.GetLink
rem objShortcut.Description = "中文描述"
rem objShortcut.Save
rem Wscript.Echo objShortcut.Description

::最终，要么使用python编写脚本，要么对于含中文的少量shortcut手动新建2022-11-7
