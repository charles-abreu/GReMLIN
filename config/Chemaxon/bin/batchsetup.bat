@ECHO OFF

REM
REM Setup absolute path of jchem directory
REM /s - run in silent mode
if "%1" == "" (
	wscript.exe //NoLogo config.vbs 
) else if "%1" == "/s" (
	cscript.exe //NoLogo config.vbs
)

