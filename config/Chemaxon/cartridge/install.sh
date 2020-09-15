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

URL=""

if [ "$#" = 1 ] ; then
        URL="localhost:1099"
elif [ "$#" = 2 ] ; then
	URL=$2
else
# password is mandatory: loadjava requires it.
	echo "Usage: install.sh username/password[@connect_string] [URL]"
        exit 1
fi


echo "Loading Java classes into Oracle Server."
echo "    This process can take several minutes."

if [ -z "$ORACLE_JDBC_CONNECT_STRING" ];
then
    set -x
    $ORACLE_HOME/bin/loadjava -force -user "$1" ./jcart.jar || exit 1;
    set +x
else
    # The Solaris x86_64 - Oracle 10.2 hack
    set -x
    $ORACLE_HOME/bin/loadjava -force -thin -user "$ORACLE_JDBC_CONNECT_STRING" \
                              ./jcart.jar || exit 1;
    set +x
fi

[ -f jchem_cart_.sql ] && rm jchem_cart_.sql
echo "Hard-wire the name of the JChem owner's schema into the the jchem_core_pkg..."
set -x
"$JAVA_CMD" -cp ../lib/jchem.jar chemaxon.jchem.cartridge.install.ChUrl prepare-sqlscript $1 jchem_cart.sql || exit 1;
set +x

$ORACLE_HOME/bin/sqlplus "$1" @jchem_cart.sql_ || exit 1;
$ORACLE_HOME/bin/sqlplus "$1" @jchem_util.sql || exit 1;
$ORACLE_HOME/bin/sqlplus "$1" @jchem_opti.sql || exit 1;
$ORACLE_HOME/bin/sqlplus "$1" @privman.sql || exit 1;

set -x
echo "Create the SQL script used to register the JChem service URLs"
"$JAVA_CMD" -cp "../lib/jchem.jar:$ORACLE_HOME/jdbc/lib/ojdbc14.jar" chemaxon.jchem.cartridge.install.ChUrl register-urls $1 $URL || exit 1;
set +x

$ORACLE_HOME/bin/sqlplus "$1" @register-urls.sql || exit 1;

exit 0

