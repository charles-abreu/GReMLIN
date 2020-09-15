#!/bin/bash

if [ ! -n "$ORACLE_HOME" ] ; then
    echo "ORACLE_HOME environment variable has to be set."
    exit 1
fi

if [ ! -x "$ORACLE_HOME"/bin/sqlplus ] ; then
    echo "ORACLE_HOME is not set properly. ORACLE_HOME/bin/sqlplus cannot be found."
    exit 1
fi

if [ "$#" != 1 ] ; then
    echo "Usage: uninstall.sh username/password[@connect_string]"
    exit 1
fi

echo "Removing JChem Cartridge services from Oracle Server"
echo "    This process can take several minutes."

$ORACLE_HOME/bin/sqlplus "$1" @drop.sql

echo "Removing Java classes from Oracle Server"

set -x
$ORACLE_HOME/bin/dropjava -user "$1" ./jcart.jar
set +x

exit 0
