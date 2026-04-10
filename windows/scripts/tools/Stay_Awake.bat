@echo off
COLOR 0A
mode 69,9
title Stay Awake
echo Dim objResult > %temp%\stay_awake.vbs
echo Set objShell = WScript.CreateObject("WScript.Shell")    >> %temp%\stay_awake.vbs
echo Do While True >> %temp%\stay_awake.vbs
echo  objResult = objShell.sendkeys("{NUMLOCK}{NUMLOCK}") >> %temp%\stay_awake.vbs
echo  Wscript.Sleep (5000) >> %temp%\stay_awake.vbs
echo Loop >> %temp%\stay_awake.vbs
echo Start Time: %date% %time%
ECHO Please close this window to stop the Stay_Awake Script
echo.
cscript %temp%\stay_awake.vbs
