@ECHO OFF
REM ant build
SET HAZELCAST_SERVER_HOME=%~dp0
SET HAZELCAST_SERVER_HOME=%HAZELCAST_SERVER_HOME%build

IF [%1]==[] GOTO default
IF [%1]==[/?] GOTO help
IF [%1]==[-?] GOTO help
IF [%1]==[/h] GOTO help
IF [%1]==[/H] GOTO help
IF [%1]==[-h] GOTO help
IF [%1]==[-H] GOTO help
SET HAZELCAST_MEMORY_MB=%1
GOTO exec

:help
ECHO Usage:
ECHO     server_start.bat [memory in Mb]
ECHO     server_start.bat /?
GOTO end

:default
SET HAZELCAST_MEMORY_MB=32

:exec
java -server -Xms%HAZELCAST_MEMORY_MB%m -Xmx%HAZELCAST_MEMORY_MB%m -Djava.net.preferIPv4Stack=true -DhazelcastServerHome=%HAZELCAST_SERVER_HOME% -classpath "%HAZELCAST_SERVER_HOME%\lib;%HAZELCAST_SERVER_HOME%\lib\*" -DconfigFile=%HAZELCAST_SERVER_HOME%\config\hazelcast.xml ddth.hazelcastserver.HazelcastServerBootstrap

:end
