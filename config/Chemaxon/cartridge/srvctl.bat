SET SCRIPTDIR=%~dp0
FOR %%? IN ("%~dp0..") DO SET PARENT=%%~f?

IF NOT "%JAVA_HOME%" == "" GOTO check_java_exe
SET ERRMESSAGE=JAVA_HOME is not set
GOTO bye

:check_java_exe
IF EXIST "%JAVA_HOME%\bin\java.exe" GOTO set_java_exe
SET ERRMESSAGE=Invalid JAVA_HOME environment variable, %JAVA_HOME%\bin\java.exe not found
GOTO bye

:set_java_exe
SET JAVA_EXE=%JAVA_HOME%\bin\java.exe

SET CP=%PARENT%\lib\jchem.jar

IF NOT "%1" == "" GOTO start
SET ERRMESSAGE=Missing argument
GOTO bye

:start
IF NOT "%LOGFILE_PATH%" == "" GOTO start_with_log
@echo on
"%JAVA_EXE%" -Xrs -classpath "%CP%" chemaxon.jchem.cartridge.ServerControl %*
@echo off
GOTO bye

:bye
IF "%ERRMESSAGE%" == "" GOTO adieu
echo %ERRMESSAGE%
IF "%LOGFILE_PATH%" == "" GOTO adieu
echo %ERRMESSAGE% >> "%LOGFILE_PATH%"

:adieu

EXIT /b %ERRORLEVEL%
