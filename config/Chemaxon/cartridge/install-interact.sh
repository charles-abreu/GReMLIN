#!/bin/bash

check_ora_home=true
for param in $@;
do
    if [ ${param} == --jcserver-only ];
    then
        unset check_ora_home
        break;
    fi
done

if [ -n "$check_ora_home" -a ! -n "$ORACLE_HOME" ] ; then
    echo "ORACLE_HOME environment variable has to be set."
    exit 1
fi

if [ -n "$check_ora_home" -a ! -x "$ORACLE_HOME"/bin/sqlplus ] ; then
    echo "ORACLE_HOME is not set properly. ORACLE_HOME/bin/sqlplus cannot found."
    exit 1
fi

JAVA_CMD="$JAVA_HOME/bin/java"
if [ ! -x "$JAVA_CMD" ];
then
    echo "JAVA_HOME is not appropriately set";
    exit 1;
fi

if [ ! -f ../lib/jchem.jar ];
then
    echo "You current working directory is not appropriate."
    exit 1;
fi

install_interact() {
set -x
$JAVA_CMD \
    -classpath ../lib/jchem.jar:$ORACLE_HOME/jdbc/lib/ojdbc5.jar:$ORACLE_HOME/jdbc/lib/ojdbc14.jar \
    -Djava.util.logging.config.file=conf/logging.properties \
    chemaxon.jchem.cartridge.install.InstallCmdLine \
    --oracle-home "$ORACLE_HOME" $@
set +x
}

install_interact $@
