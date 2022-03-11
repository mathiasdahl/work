#!/bin/bash

echo Downloading Java source code...

curl https://raw.githubusercontent.com/mathiasdahl/work/main/MySmbClient.java > MySmbClient.java

echo Compiling...

myclasspath=".:javaimpl/jcifs-2.1.16.jar:wlp/lib/com.ibm.ws.org.slf4j.api.1.7.7_1.0.60.jar:wlp/lib/com.ibm.ws.org.slf4j.jdk14.1.7.7_1.0.60.jar:javaimpl/bcprov-jdk15on-1.64.jar:/opt/ifs/wlp/usr/servers/defaultServer/apps/expanded/ifs-odata-provider.war/WEB-INF/lib/slf4j-api-1.7.25.jar"

$JAVA_HOME/bin/javac -classpath $myclasspath MySmbClient.java

alias smbtest="$JAVA_HOME/bin/java -Djcifs.util.loglevel=10 -classpath $myclasspath MySmbClient"

echo -n "Enter password for the SMB test (it will not be shown): "
read -s password
echo

echo All done.

echo

echo Now try with: smbtest smb://SERVER/SHARE/test.txt "" USERNAME $password
echo
