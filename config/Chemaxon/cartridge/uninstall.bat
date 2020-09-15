@echo off

if not "%ORACLE_HOME%" == "" goto first
echo ORACLE_HOME is not set.
goto eof

:first

if exist "%ORACLE_HOME%\bin\sqlplus.exe" goto second
echo ORACLE_HOME is not set properly. ORACLE_HOME\bin\sqlplus.exe cannot found.
goto eof

:second 

if not "%1" == "" goto third
echo Usage: install.bat username[/password][@connect_string]
goto eof

:third

call %ORACLE_HOME%\bin\sqlplus "%1" @drop.sql

@echo on
call %ORACLE_HOME%\bin\dropjava.bat -force -user "%1" ..\lib\jcart.jar 

:eof