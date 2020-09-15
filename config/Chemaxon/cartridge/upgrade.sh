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

if [ "$#" = 0 ] ; then
    echo "Missing connection parameters"
    exit 1;
fi

$ORACLE_HOME/bin/sqlplus "$1" @drop-force.sql || exit 1;

echo "Loading Java classes into Oracle Server."
echo "    This process can take several minutes."

set -x
$ORACLE_HOME/bin/loadjava -force -user "$1" ./jcart.jar || exit 1;
set +x

[ -f jchem_cart_.sql ] && rm jchem_cart_.sql
set -x
"$JAVA_CMD" -cp ../lib/jchem.jar chemaxon.jchem.cartridge.install.ChUrl prepare-sqlscript $1 jchem_cart.sql || exit 1;
set +x

$ORACLE_HOME/bin/sqlplus "$1" @jchem_cart.sql_ || exit 1;
$ORACLE_HOME/bin/sqlplus "$1" @jchem_util.sql || exit 1;
$ORACLE_HOME/bin/sqlplus "$1" @privman.sql || exit 1;

rmiurl="localhost:1099"
[ -n "$2" ] && rmiurl=$2
echo "declare
  c number;
begin
  select count(*) into c from jc_idx_property where prop_name = 'rmi.server.1';
    if c > 0 then
      execute immediate 'update jc_idx_property set prop_value = :a where prop_name = ''rmi.server.1''' using '$rmiurl';
    else
      execute immediate 'insert into jc_idx_property values(''rmi.server.1'', :a, null)' using '$rmiurl';
    end if;
end;
/
" > rmiurl.sql
echo "quit" >>rmiurl.sql
$ORACLE_HOME/bin/sqlplus "$1" @rmiurl.sql || exit 1;

exit 0
