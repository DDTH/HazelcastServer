#!/usr/bin/env bash

# ==================================================
# Hazelcast Server start/stop script for *NIX
# ==================================================

# Uncomment only one of the two lines below
#ENV_NAME=production
ENV_NAME=development

# from http://stackoverflow.com/questions/242538/unix-shell-script-find-out-which-directory-the-script-file-resides
pushd $(dirname "${0}") > /dev/null
_basedir=$(pwd -L)
# Use "pwd -P" for the path without links. man bash for more info.
popd > /dev/null

# Or you can hardcode the directory as you wish
HAZELCAST_SERVER_HOME=$_basedir/..
HAZELCAST_SERVER_PID="$HAZELCAST_SERVER_HOME/hazelcastserver.pid"

JAVA_MEM_MB=$2
if [ "$JAVA_MEM_MB" = "" ]
then
    JAVA_MEM_MB=64
fi

_appName_=HAZELCAST_SERVER

JAVA=$(which java)
JAVA_OPTS="-server -Xms${JAVA_MEM_MB}m -Xmx${JAVA_MEM_MB}m -Djava.net.preferIPv4Stack=true -Djava.awt.headless=true -XX:+UseParNewGC -XX:+UseConcMarkSweepGC"
JAVA_OPTS+=("-XX:PrintFLSStatistics=1 -XX:PrintCMSStatistics=1 -XX:+PrintTenuringDistribution -XX:+PrintGCDetails -XX:+PrintGCDateStamps -verbose:gc -Xloggc:$HAZELCAST_SERVER_HOME/logs/garbage.log")
JAVA_OPTS+=("-Dhazelcastserver.home=$HAZELCAST_SERVER_HOME")
JAVA_OPTS+=("-DconfigFile=$HAZELCAST_SERVER_HOME/bin/hazelcast.xml")
JAVA_OPTS+=("-classpath $HAZELCAST_SERVER_HOME/lib:$HAZELCAST_SERVER_HOME/lib/*")
#JAVA_OPTS+=("-Dlog4j.configuration=$HAZELCAST_SERVER_HOME/bin/log4j.properties")
JAVA_OPTS+=("com.github.ddth.hazelcastserver.bootstrap.StandaloneBootstrap")

RUN_CMD=("$JAVA" ${JAVA_OPTS[@]})

running()
{
    local PID=$(cat "$1" 2>/dev/null) || return 1
    kill -0 "$PID" 2>/dev/null
}

usage()
{
    echo "Usage: ${0##*/} <{start|stop|jpda}> [JVM mem limit in mb]"
    echo "- start: start the server normally"
    echo "- stop : stop the server"
    echo
    echo "Example: start server with remote debugging and 64mb memory limit"
    echo "  ${0##*/} start 64"
    echo
    exit 1
}

ACTION=$1

case "$ACTION" in    
    start)
        echo -n "Starting $_appName_ Server: "

        if [ -f "$HAZELCAST_SERVER_PID" ]
        then
            if running $HAZELCAST_SERVER_PID
            then
                echo "Already Running!"
                exit 1
            else
                # dead pid file - remove
                rm -f "$HAZELCAST_SERVER_PID"
            fi            
        fi
        
        "${RUN_CMD[@]}" &
        disown $!
        echo $! > "$HAZELCAST_SERVER_PID"
            
        echo "STARTED $_appName_ Server `date`" 
        
        ;;

    stop)
        echo -n "Stopping $_appName_: "

        PID=$(cat "$HAZELCAST_SERVER_PID" 2>/dev/null)
        kill "$PID" 2>/dev/null

        TIMEOUT=30
        while running $HAZELCAST_SERVER_PID; do
            if (( TIMEOUT-- == 0 )); then
                kill -KILL "$PID" 2>/dev/null
            fi
            sleep 1
        done

        rm -f "$HAZELCAST_SERVER_PID"
        echo OK
        
        ;;

    *)
        usage
        
        ;;
esac

exit 0
