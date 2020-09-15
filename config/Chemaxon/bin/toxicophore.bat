@echo off
SETLOCAL

rem ###########################################################################

rem # HEAP_LIMIT: the maximum amount of memory to be allocated by the
rem # Java Virtual Machine (JVM) in megabytes.
rem # Corresponds to the "-Xmx" JVM option.
rem # The obsolete JCHEM_JAVA_OPTS environment variable may override this
rem # setting if specified.
rem # The -Xmx(size) command line parameter of Java can also overwrite it.
rem # The default setting is "200".

set HEAP_LIMIT=500

rem # SERVER_MODE: if set to "true", the Java Virtual Machine (JVM) spends more
rem # time with run time code opimization, resulting slower startup but higher
rem # execution speed after a prolonged period.
rem # Suitable for long runnig tasks.
rem # Corresponds to the "-server" JVM option.
rem # The obsolete JCHEM_JAVA_OPTS environment variable may override this
rem # setting if specified.
rem # The -client or -server command line parameters of Java can also 
rem # overwrite it.
rem # The default setting is "false".

set SERVER_MODE=false

rem ###########################################################################

if ["%HEAP_LIMIT%"]==[""] (
    set HEAP_LIMIT=200
)
set XMX_MODE=-Xmx%HEAP_LIMIT%m

if ["%SERVER_MODE%"]==[""] (
    set SERVER_MODE=false
)

if not ["%SERVER_MODE%"]==["true"] (
    set SERVER_MODE=
) else (
    set SERVER_MODE=-server
)

rem # JCHEMHOME: The location of JChem directory
rem # Installer substitutes the @JCHEMHOME@ pattern to target 
rem # directory of JChem installation. In this case JCHEMHOME
rem # system variable is ignored.
rem # If the batch script has not been updated by installer,
rem # the JCHEMHOME sytstem variable is prefered.
rem # If neither was set, JCHEMHOME will be the parent directory.
rem # It means that the script can run properly only from this
rem # directory.

rem # Please don't include jchem.jar in CLASSPATH,
rem # because classes may conflict with the ones
rem # used by the Marvin applets. Use JCHEMCLASSPATH instead.

if exist @JCHEMHOME@. (
    set SETUPBAT="@JCHEMHOME@\bin\setup.bat"
    set JCHEMCLASSPATH="@JCHEMHOME@\lib\jchem.jar;%CLASSPATH%"
    GOTO AFTER_CLASSPATH
)
if exist %JCHEMHOME%. (
	set SETUPBAT="%JCHEMHOME%\bin\setup.bat"
	set JCHEMCLASSPATH="%JCHEMHOME%\lib\jchem.jar;%CLASSPATH%"
	GOTO AFTER_CLASSPATH
)
set SETUPBAT="..\bin\setup.bat"
set JCHEMCLASSPATH="..\lib\jchem.jar;%CLASSPATH%"

:AFTER_CLASSPATH

set Z=%JVMPATH%
if exist %SETUPBAT%. (
    call %SETUPBAT%
) else (
    set JVMPATH=java
)

set JVM_PARAM=

:START_JVMPARAM
if [%1]==[] GOTO END_JVMPARAM
    
:: Remove quotes
set nqparam=%1
   SET nqparam=###%nqparam%###
   SET nqparam=%nqparam:"###=%
   SET nqparam=%nqparam:###"=%
   SET nqparam=%nqparam:###=%
REM check first two characters of the parameter
set pam=%nqparam%
set hpam=%pam:~0,2%
if "%hpam%"=="-X" (
    set hhpam=%pam:~0,4%
    if "%hhpam%"=="-XMX" (
        REM reset default settings
        set XMX_MODE=
    )
    set JVM_PARAM=%JVM_PARAM% %1
    SHIFT
    GOTO START_JVMPARAM
)

if %1==-client (
    REM reset default settings
    set SERVER_MODE=
    set JVM_PARAM=%JVM_PARAM% %1
    SHIFT
    GOTO START_JVMPARAM
)

if %1==-server (
    REM reset default settings
    set SERVER_MODE=
    set JVM_PARAM=%JVM_PARAM% %1
    SHIFT
    GOTO START_JVMPARAM
)
:END_JVMPARAM

if not [%SERVER_MODE%]==[] (
    set JAVA_OPTS=%SERVER_MODE%
)
if not [%XMX_MODE%]==[] (
    set JAVA_OPTS=%JAVA_OPTS% %XMX_MODE%
)

rem JCHEM_JAVA_OPTS owerwrites above Java options
if not ["%JCHEM_JAVA_OPTS%"]==[""] (
    set JAVA_OPTS=%JCHEM_JAVA_OPTS%
)

if not ["%JVM_PARAM%"]==[""] (
    set JAVA_OPTS=%JAVA_OPTS% %JVM_PARAM%
)

set JAVA_OPTS=%JAVA_OPTS% -classpath %JCHEMCLASSPATH%

shift
set P1=%0
shift
set P2=%0
shift
set P3=%0
shift
set P4=%0
shift
set P5=%0
shift
set P6=%0
shift
set P7=%0
shift
set P8=%0
shift
set P9=%0
shift
set P10=%0
shift
set P11=%0
shift
set P12=%0
shift
set P13=%0
shift
set P14=%0
shift
set P15=%0
shift
set P16=%0
shift
set P17=%0
shift
set P18=%0
shift
set P19=%0
shift
set P20=%0
shift
set P21=%0
shift
set P22=%0
shift
set P23=%0
shift
set P24=%0
shift
set P25=%0
shift
set P26=%0
shift
set P27=%0
shift
set P28=%0
shift
set P29=%0
shift
set P30=%0
shift
set P31=%0
shift
set P32=%0
shift
set P33=%0
shift
set P34=%0
shift
set P35=%0
shift
set P36=%0
shift
set P37=%0
shift
set P38=%0
shift
set P39=%0
shift
set P40=%0
shift
set ENDTEST=%0
if not _%ENDTEST%==_ goto Error

rem #---------------- END OF HEADER ------------------------------------

"%JVMPATH%" %JAVA_OPTS% -Xmx512m chemaxon.toxic.ToxicophoreGenerator %P1% %P2% %P3% %P4% %P5% %P6% %P7% %P8% %P9% %P10% %P11% %P12% %P13% %P14% %P15% %P16% %P17% %P18% %P19% %P20% %P21% %P22% %P23% %P24% %P25% %P26% %P27% %P28% %P29% %P30% %P31% %P32% %P33% %P34% %P35% %P36% %P37% %P38% %P39% %P40%
rem #--------------- BEGIN OF FOOTER ------------------------------------

goto End

:Error
echo Error: Too many parameters. You are probably not using quotes for parameters
echo that contain more words
:End

rem # restore original JVMPATH
set JVMPATH=%Z%



