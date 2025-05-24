@echo off
:: Enable CPU Idle Mode only if it's currently disabled
for /f "tokens=2 delims=:(" %%a in ('powercfg /getactivescheme') do set scheme=%%a
for /f "tokens=*" %%b in ('powercfg /query %scheme% sub_processor IDLEDISABLE') do (
    echo %%b | find "0x00000001" >nul && (
        powercfg -setacvalueindex %scheme% sub_processor IDLEDISABLE 0
        reg add "HKCR\DesktopBackground\Shell\PowerPlan\Shell\02menu" /v "MUIVerb" /t REG_SZ /d "Idle Mode: ON" /f
		powercfg -setactive %scheme%
        goto :eof
    )
)
exit /b 0