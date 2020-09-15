@echo off

if not "%ORACLE_HOME%" == "" goto first
echo ORACLE_HOME is not set.
goto eof

:zero
if exist "%JAVA_HOME%\bin\java.exe" goto first
echo The JAVA_HOME environment variable is not or not appropriately set.
goto eof

:first

if exist "%ORACLE_HOME%\bin\sqlplus.exe" goto second
echo ORACLE_HOME is not set properly. ORACLE_HOME\bin\sqlplus.exe cannot found.
goto eof

:second 

@echo on
"%JAVA_HOME%\bin\java" -classpath "..\lib\jchem.jar;%ORACLE_HOME%\jdbc\lib\ojdbc5.jar;%ORACLE_HOME%\jdbc\lib\ojdbc14.jar" -Djava.util.logging.config.file=conf\logging.properties chemaxon.jchem.cartridge.install.UpgradeCmdLine --oracle-home "%ORACLE_HOME%" %*
@echo off

:eof
