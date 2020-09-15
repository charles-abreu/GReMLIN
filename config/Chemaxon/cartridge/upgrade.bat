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

if "%1" == "" goto missing_param

echo Loading Java classes into Oracle Server
echo     This process can take several minutes

@echo on
call %ORACLE_HOME%\bin\loadjava.bat -force -user "%1" .\jcart.jar 

@echo on
echo "Execute generated SQL script..."
call %ORACLE_HOME%\bin\sqlplus "%1" @drop-force.sql
@echo off
IF %ERRORLEVEL% GEQ 1 GOTO eof

@echo on
@echo Hard-wire the name of the JChem owner's schema into the the jchem_core_pkg...
"%JAVA_HOME%\bin\java.exe" -cp ../lib/jchem.jar chemaxon.jchem.cartridge.install.ChUrl prepare-sqlscript %1 jchem_cart.sql
@echo off

@echo off
IF %ERRORLEVEL% GEQ 1 GOTO eof

@echo on
call %ORACLE_HOME%\bin\sqlplus "%1" @jchem_cart.sql_
call %ORACLE_HOME%\bin\sqlplus "%1" @jchem_util.sql
call %ORACLE_HOME%\bin\sqlplus "%1" @privman.sql
@echo off
IF %ERRORLEVEL% GEQ 1 GOTO eof

:set_rmiurl
set rmiurl=localhost:1099
if not "%2" == "" set rmiurl=%2
echo declare > rmiurl.sql
echo   c number; >> rmiurl.sql
echo begin >> rmiurl.sql
echo   select count(*) into c from jc_idx_property where prop_name = 'rmi.server.1'; >> rmiurl.sql
echo     if c ^> 0 then >> rmiurl.sql
echo       execute immediate 'update jc_idx_property set prop_value = :a where prop_name = ''rmi.server.1''' using '%rmiurl%'; >> rmiurl.sql
echo     else >> rmiurl.sql
echo       execute immediate 'insert into jc_idx_property values(''rmi.server.1'', :a, null)' using '%rmiurl%'; >> rmiurl.sql
echo     end if; >> rmiurl.sql
echo end; >> rmiurl.sql
echo /  >> rmiurl.sql
echo quit >>rmiurl.sql
%ORACLE_HOME%\bin\sqlplus %1 @rmiurl.sql

goto eof

:missing_param
echo "Missing connection parameters"

:eof
