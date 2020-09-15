#!/bin/bash

if [ ! -n "$ORACLE_HOME" ] ; then
    echo "ORA_HOME environment variable has to be set."
    exit 1
fi

if [ ! -x "$ORACLE_HOME"/bin/sqlplus ] ; then
    echo "ORA_HOME is not set properly. ORA_HOME/bin/sqlplus cannot found."
    exit 1
fi


if [ ! "$#" = 1 ] ; then
	echo "Usage: test.sh username[/password][@connect_string]"
        exit 1
fi


echo -e "$1\\n@test.sql" | $ORACLE_HOME/bin/sqlplus

