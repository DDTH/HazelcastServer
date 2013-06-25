#!/usr/bin/env bash

HAZELCAST_SERVER_HOME=@@HAZELCAST_SERVER_HOME@@
HAZELCAST_SERVER_PID="$HAZELCAST_SERVER_HOME/hazelcast_server.pid"

JAVA_MEM_MB=$2
if [ "$MEM_LIMIT" = "" ]
then
    JAVA_MEM_MB=32
fi

JAVA=$(which java)
JAVA_OPTS="-server -Xms${JAVA_MEM_MB}m -Xmx${JAVA_MEM_MB}m -Djava.net.preferIPv4Stack=true"
JAVA_OPTS+=("-DhazelcastServerHome=$HAZELCAST_SERVER_HOME")
JAVA_OPTS+=("-classpath $HAZELCAST_SERVER_HOME/lib:$HAZELCAST_SERVER_HOME/lib/*")
JAVA_OPTS+=("-DconfigFile=$HAZELCAST_SERVER_HOME/config/hazelcast.xml")
JAVA_OPTS+=("ddth.hazelcastserver.HazelcastServerBootstrap")

RUN_CMD=("$JAVA" ${JAVA_OPTS[@]})

running()
{
    local PID=$(cat "$1" 2>/dev/null) || return 1
    kill -0 "$PID" 2>/dev/null
}

usage()
{
    echo "Usage: ${0##*/} <{start|stop}> [JVM mem limit in mb]"
    exit 1
}

ACTION=$1

case "$ACTION" in
    start)
        echo -n "Starting Hazelcast Server: "

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
            
        echo "STARTED Hazelcast Server `date`" 
        
        ;;

    stop)
        echo -n "Stopping HazelcastServer: "

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
