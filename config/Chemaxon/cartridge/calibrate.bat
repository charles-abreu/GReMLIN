@echo off
REM -------------------------------------------
REM You normally shouldn't touch the code below
REM -------------------------------------------

SET ERRMESSAGE=

IF NOT "%JAVA_HOME%" == "" GOTO check_java_exe
SET ERRMESSAGE=JAVA_HOME is not set
GOTO bye

:check_java_exe
IF EXIST "%JAVA_HOME%\bin\java.exe" GOTO set_java_exe
SET ERRMESSAGE=Invalid JAVA_HOME environment variable, %JAVA_HOME%\bin\java.exe not found
GOTO bye

:set_java_exe
SET JAVA_EXE=%JAVA_HOME%\bin\java.exe

IF NOT "%ORACLE_JDBC_DRIVER%" == "" GOTO check_jdbc_driver_file

IF NOT "%ORACLE_HOME%" == "" GOTO set_jdbc_driver
SET ERRMESSAGE=Neither ORACLE_JDBC_DRIVER nor ORACLE_HOME is set
GOTO bye

:set_jdbc_driver
SET ORACLE_JDBC_DRIVER=%ORACLE_HOME%\jdbc\lib\ojdbc14.jar

:check_jdbc_driver_file
IF EXIST "%ORACLE_JDBC_DRIVER%" GOTO set_classpath
SET ERRMESSAGE=%ORACLE_JDBC_DRIVER% does not exist
GOTO bye

:set_classpath
SET CP=..\lib\jchem.jar;%ORACLE_JDBC_DRIVER%

IF NOT "%1" == "" GOTO start
SET ERRMESSAGE=Missing argument
GOTO bye

:start
IF NOT "%LOGFILE_PATH%" == "" GOTO start_with_log
@echo on
"%JAVA_EXE%" -server -Dchemaxon.jchem.cartridge.config.file=conf\jcart.properties -Djava.util.logging.config.file=conf\logging.properties -classpath %CP% %OTHER_OPTIONS% chemaxon.jchem.cartridge.costestim.calibra.Calibrator %*
@echo off
GOTO bye

:bye
IF "%ERRMESSAGE%" == "" GOTO adieu
echo %ERRMESSAGE%
IF "%LOGFILE_PATH%" == "" GOTO adieu
echo %ERRMESSAGE% >> %LOGFILE_PATH%

:adieu
EXIT /b %ERRORLEVEL%
