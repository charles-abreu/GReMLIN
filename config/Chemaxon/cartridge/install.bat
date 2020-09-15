@echo off

if not "%ORACLE_HOME%" == "" goto zero
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

if not "%1" == "" goto third
echo Usage: install.bat username[/password][@connect_string] [URL]
goto eof

:third

set URL=localhost:1099

if not "%2" == "" set URL="%2"

echo Loading Java classes into Oracle Server
echo     This process can take several minutes

if not "%ORACLE_JDBC_CONNECT_STRING%" == "" goto loadjava_thin
@echo on
call %ORACLE_HOME%\bin\loadjava.bat -force -user "%1" .\jcart.jar
goto prepare_jchem_cart_sql

:loadjava_thin
@echo on
call %ORACLE_HOME%\bin\loadjava.bat -thin -force -user "%ORACLE_JDBC_CONNECT_STRING%" .\jcart.jar 

:prepare_jchem_cart_sql
@echo on
@echo Hard-wire the name of the JChem owner's schema into the the jchem_core_pkg...
"%JAVA_HOME%\bin\java.exe" -cp ../lib/jchem.jar chemaxon.jchem.cartridge.install.ChUrl prepare-sqlscript %1 jchem_cart.sql
@echo off

@echo off
IF %ERRORLEVEL% GEQ 1 GOTO eof

@echo on
call %ORACLE_HOME%\bin\sqlplus "%1" @jchem_cart.sql_
call %ORACLE_HOME%\bin\sqlplus "%1" @jchem_util.sql
call %ORACLE_HOME%\bin\sqlplus "%1" @jchem_opti.sql
call %ORACLE_HOME%\bin\sqlplus "%1" @privman.sql

@echo on
echo Create the SQL script used to register the JChem service URLs...
"%JAVA_HOME%\bin\java.exe" -cp "../lib/jchem.jar;%ORACLE_HOME%\jdbc\lib\ojdbc14.jar" chemaxon.jchem.cartridge.install.ChUrl register-urls %1 %URL%
@echo off

call %ORACLE_HOME%\bin\sqlplus "%1" @register-urls.sql
:eof
