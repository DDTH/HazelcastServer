@ECHO OFF

REM ==================================================
REM Hazelcast Server start script for Windows
REM ==================================================

REM ==================================================
REM Uncomment only one of the two lines below
REM ==================================================
REM SET ENV_NAME=production
SET ENV_NAME=development

SET HAZELCAST_SERVER_HOME=%~dp0
SET HAZELCAST_SERVER_HOME=%HAZELCAST_SERVER_HOME%\..

IF [%1]==[] GOTO default
IF [%1]==[/?] GOTO help
IF [%1]==[-?] GOTO help
IF [%1]==[/h] GOTO help
IF [%1]==[/H] GOTO help
IF [%1]==[-h] GOTO help
IF [%1]==[-H] GOTO help
SET JAVA_MEM_MB=%1
GOTO exec

:help
ECHO Usage:
ECHO     server_start.bat [memory in Mb]
ECHO     server_start.bat /?
GOTO end

:default
SET JAVA_MEM_MB=64

:exec
REM -XX:-UseGCOverheadLimit
SET OPTS_JVM=-server -Xms%JAVA_MEM_MB%m -Xmx%JAVA_MEM_MB%m -Djava.net.preferIPv4Stack=true -Djava.awt.headless=true -XX:+UseParNewGC -XX:+UseConcMarkSweepGC
SET OPTS_GC_LOG=-XX:PrintFLSStatistics=1 -XX:PrintCMSStatistics=1 -XX:+PrintTenuringDistribution -XX:+PrintGCDetails -XX:+PrintGCDateStamps -verbose:gc -Xloggc:%HAZELCAST_SERVER_HOME%\logs\garbage.log
SET OPTS_HAZELCAST_SERVER=-Dhazelcastserver.home=%HAZELCAST_SERVER_HOME% -DconfigFile=%HAZELCAST_SERVER_HOME%\bin\hazelcast.xml
SET OPTS_CLASSPATH=-classpath "%HAZELCAST_SERVER_HOME%\lib;%HAZELCAST_SERVER_HOME%\lib\*"

java %OPTS_JVM% %OPTS_GC_LOG% %OPTS_HAZELCAST_SERVER% %OPTS_CLASSPATH% com.github.ddth.hazelcastserver.bootstrap.StandaloneBootstrap
REM -Dspring.profiles.active=%ENV_NAME% -Dlogback.configurationFile=%HAZELCAST_SERVER_HOME%\bin\logback-%ENV_NAME%.xml

:end
