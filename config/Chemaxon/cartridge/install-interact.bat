@echo off

for %%p in (%*) do (
    if "%%p" == "--jcserver-only" goto java_home_check
)

if not "%ORACLE_HOME%" == "" goto oracle_home_check
echo ORACLE_HOME is not set.
goto eof

:oracle_home_check
if exist "%ORACLE_HOME%\bin\sqlplus.exe" goto java_home_check
echo ORACLE_HOME is not set properly. ORACLE_HOME\bin\sqlplus.exe cannot found.
goto eof

:java_home_check
if exist "%JAVA_HOME%\bin\java.exe" goto cwd_check
echo The JAVA_HOME environment variable is not or not appropriately set.
goto eof

:cwd_check
if exist "..\lib\jchem.jar" goto install
echo "Wrong current working directory"
goto eof

:install
"%JAVA_HOME%\bin\java.exe" -classpath ..\lib\jchem.jar;%ORACLE_HOME%\jdbc\lib\ojdbc5.jar;%ORACLE_HOME%\jdbc\lib\ojdbc14.jar -Djava.util.logging.config.file=conf\logging.properties chemaxon.jchem.cartridge.install.InstallCmdLine --oracle-home "%ORACLE_HOME%" %*

:eof
