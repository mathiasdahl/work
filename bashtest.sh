#!/bin/bash

echo Downloading Java source code...

curl -s -H "Cache-Control: no-cache" https://raw.githubusercontent.com/mathiasdahl/work/main/MySmbClient.java > MySmbClient.java

echo Compiling...

myclasspath=".:javaimpl/jcifs-2.1.16.jar:wlp/lib/com.ibm.ws.org.slf4j.api.1.7.7_1.0.60.jar:wlp/lib/com.ibm.ws.org.slf4j.jdk14.1.7.7_1.0.60.jar:javaimpl/bcprov-jdk15on-1.64.jar:/opt/ifs/wlp/usr/servers/defaultServer/apps/expanded/ifs-odata-provider.war/WEB-INF/lib/slf4j-api-1.7.25.jar"

if $JAVA_HOME/bin/javac -classpath $myclasspath MySmbClient.java; then

  alias smbtest="$JAVA_HOME/bin/java -Djcifs.util.loglevel=10 -classpath $myclasspath MySmbClient"

  echo -n "Enter password for the SMB test (it will not be shown): "
  read -s password
  echo

  echo All done.

  echo

  echo
  echo Now try with: smbtest smb://SERVER/SHARE/FILENAME DOMAIN USERNAME $password [NUMBEROFLINESTOWRITE]
  echo
  echo 'DOMAIN can be empty ("")'
  echo NUMBEROFLINESTOWRITE is the number of 100 byte long lines to write to the file
  echo '$password is the variable that keeps the password you entered earlier.'
  echo
  echo Example:
  echo '  smbtest smb://myserver/myshare/test.txt "" myusername $password'

else
  echo Java compile failed. See error above.
fi
