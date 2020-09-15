@echo off
REM Variable that maybe needed for debugging when running as a Windows NT service
REM SET LOGFILE_PATH=C:\Program Files\jchem\cartridge\server.bat.log

REM Variables that maybe need for debugging
SET LICENS_HANDLER_TRACE=true
SET JAVA_DEBUG=false

REM SET JAVA_HEAP_SIZE=700m
REM SET ORACLE_HOME=C:\oracle\ora92

REM -------------------------------------------
REM You normally shouldn't touch the code below
REM -------------------------------------------

SET SCRIPTDIR=%~dp0
FOR %%? IN ("%~dp0..") DO SET PARENT=%%~f?

SET ERRMESSAGE=
rem try to update JAVA_HOME by installer
rem installer: set Z=%JAVA_HOME%
rem installer: set JAVA_HOME=@JAVA_HOME@

IF NOT "%JAVA_HOME%" == "" GOTO check_java_exe
SET ERRMESSAGE=JAVA_HOME is not set
GOTO bye

:check_java_exe
IF EXIST "%JAVA_HOME%\bin\java.exe" GOTO set_java_exe
SET ERRMESSAGE=Invalid JAVA_HOME environment variable, %JAVA_HOME%\bin\java.exe not found
GOTO bye

:set_java_exe
SET JAVA_EXE=%JAVA_HOME%\bin\java.exe

IF NOT "%ORACLE_HOME%" == "" GOTO eval_start
SET ERRMESSAGE=ORACLE_HOME is not set
GOTO bye

:eval_start
SET CP=%PARENT%\lib\jchem.jar
IF NOT "%1" == "" GOTO start
SET ERRMESSAGE=Missing argument
GOTO bye

:start
IF NOT "%LOGFILE_PATH%" == "" GOTO start_with_log
@echo on
"%JAVA_EXE%" -server -Xrs -XX:-OmitStackTraceInFastThrow -Dchemaxon.jchem.cartridge.config.file="%SCRIPTDIR%\conf\jcart.properties" -Djava.util.logging.config.class=chemaxon.jchem.cartridge.util.LoggingConfigurator -Djava.awt.headless=true -classpath "%CP%" %OTHER_OPTIONS% chemaxon.jchem.cartridge.server.Bootstrapper %*
@echo off
GOTO bye

:start_with_log
@echo on
echo Starting... >> "%LOGFILE_PATH%"
"%JAVA_EXE%" -server -Xrs -XX:-OmitStackTraceInFastThrow -Dchemaxon.jchem.cartridge.config.file="%SCRIPTDIR%\conf\jcart.properties" -Djava.util.logging.config.class=chemaxon.jchem.cartridge.util.LoggingConfigurator -Djava.awt.headless=true -classpath "%CP%" %OTHER_OPTIONS% chemaxon.jchem.cartridge.server.Bootstrapper %* >>"%LOGFILE_PATH%.stdout" 2>>"%LOGFILE_PATH%"
@echo off
GOTO bye

:bye
IF "%ERRMESSAGE%" == "" GOTO adieu
echo %ERRMESSAGE%
IF "%LOGFILE_PATH%" == "" GOTO adieu
echo %ERRMESSAGE% >> "%LOGFILE_PATH%"

:adieu

rem installer: set JAVA_HOME=%Z%
EXIT /b %ERRORLEVEL%
