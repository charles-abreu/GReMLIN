#!/bin/sh

if [ -z "$JAVA_HOME" ];
then
    echo "JAVA_HOME is not set";
    exit 1;
elif [ ! -x "$JAVA_HOME"/bin/java ];
then
    echo "Invalid JAVA_HOME environment variable" 
    echo "No executable $JAVA_HOME/bin/java found"
    exit 1;
else
    jcsrv_jvm="$JAVA_HOME"/bin/java;
fi

cp=$(dirname $0)/../lib/jchem.jar


set -x
"$jcsrv_jvm" -classpath $cp chemaxon.jchem.cartridge.ServerControl $@
set +x
