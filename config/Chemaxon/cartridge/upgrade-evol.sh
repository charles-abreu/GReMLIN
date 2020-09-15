#!/bin/bash

if [ ! -n "$ORACLE_HOME" ] ; then
    echo "ORACLE_HOME environment variable has to be set."
    exit 1
fi

if [ ! -x "$ORACLE_HOME"/bin/sqlplus ] ; then
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

upgradeTypeEvol() {
set -x
$JAVA_CMD \
    -classpath ../lib/jchem.jar:$ORACLE_HOME/jdbc/lib/ojdbc5.jar:$ORACLE_HOME/jdbc/lib/ojdbc14.jar \
    -Djava.util.logging.config.file=conf/logging.properties \
    chemaxon.jchem.cartridge.install.UpgradeTypeEvol \
    --oracle-home "$ORACLE_HOME" $@
set +x
}

upgradeCmdLine() {
set -x
$JAVA_CMD \
    -classpath ../lib/jchem.jar:$ORACLE_HOME/jdbc/lib/ojdbc5.jar:$ORACLE_HOME/jdbc/lib/ojdbc14.jar \
    -Djava.util.logging.config.file=conf/logging.properties \
    chemaxon.jchem.cartridge.install.UpgradeCmdLine \
    --oracle-home "$ORACLE_HOME" $@
set +x
}

upgradeCmdLine $@
