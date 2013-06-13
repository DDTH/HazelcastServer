@ECHO OFF
SET HAZELCAST_SERVER_HOME=%~dp0
java -server -Xms128m -Xmx128m -Djava.net.preferIPv4Stack=true -DhazelcastServerHome=%HAZELCAST_SERVER_HOME% -classpath "%HAZELCAST_SERVER_HOME%\..\lib;%HAZELCAST_SERVER_HOME%\..\lib\*" -DconfigFile=%HAZELCAST_SERVER_HOME%\..\config\hazelcast.xml ddth.hazelcastserver.HazelcastServerBootstrap
