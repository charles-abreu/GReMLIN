#!/bin/sh

java_debug=false
other=

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
"$JAVA_HOME"/bin/java -Djava.util.logging.config.file=conf/logging.properties -cp $cp chemaxon.jchem.cartridge.costestim.calibra.Calibrator $@
set +x
