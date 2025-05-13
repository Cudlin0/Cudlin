@echo off
setlocal EnableDelayedExpansion
:: Disable & Enable CPU Idle States Automatically:
for /f "tokens=2 delims=:(" %%a in ('Powercfg /getactivescheme') do set activeScheme=%%a
for /f "tokens=*" %%b in ('Powercfg /query %activeScheme% sub_processor IDLEDISABLE') do (
echo %%b | find "0x00000000" && (
    Powercfg -setacvalueindex %activeScheme% sub_processor IDLEDISABLE 1 && Reg Add "HKCR\DesktopBackground\Shell\PowerPlan\Shell\02menu" /v "MUIVerb" /t REG_SZ /d "Idle Mode: OFF" /f && goto PowerRefresh )
echo %%b | find "0x00000001" && (
    Powercfg -setacvalueindex %activeScheme% sub_processor IDLEDISABLE 0 && Reg Add "HKCR\DesktopBackground\Shell\PowerPlan\Shell\02menu" /v "MUIVerb" /t REG_SZ /d "Idle Mode: ON" /f && goto PowerRefresh )
) >nul 2>&1
:: Power Refresh [+] Config Refresh
:PowerRefresh
Powercfg -setactive %activeScheme%
Reg Add "HKCR\DesktopBackground\Shell\PowerPlan" /v "Icon" /t REG_SZ /d "powercpl.dll" /f >nul 2>&1
Reg Add "HKCR\DesktopBackground\Shell\PowerPlan" /v "MUIVerb" /t REG_SZ /d "Power Idle Mode" /f >nul 2>&1
Reg Add "HKCR\DesktopBackground\Shell\PowerPlan" /v "Position" /t REG_SZ /d "Bottom" /f >nul 2>&1
Reg Add "HKCR\DesktopBackground\Shell\PowerPlan" /v "SubCommands" /t REG_SZ /d "" /f >nul 2>&1
Reg Add "HKCR\DesktopBackground\Shell\PowerPlan\Shell\02menu\command" /ve /t REG_SZ /d "wscript.exe ""%SYSTEMDRIVE%\Cudlin\resources\StartIdle.vbs""" /f >nul 2>&1
Reg Add "HKCR\DesktopBackground\Shell\PowerPlan\Shell\02menu" /v "Icon" /t REG_SZ /d "powercpl.dll" /f >nul 2>&1
Exit /B 0
