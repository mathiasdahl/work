#!/bin/bash

echo

echo Downloading SMB test client source code...

curl -s -H "Cache-Control: no-cache" https://raw.githubusercontent.com/mathiasdahl/work/main/MySmbClient.java > MySmbClient.java

echo Compiling...

myclasspath=".:javaimpl/jcifs-2.1.16.jar:wlp/lib/com.ibm.ws.org.slf4j.api.1.7.7_1.0.60.jar:wlp/lib/com.ibm.ws.org.slf4j.jdk14.1.7.7_1.0.60.jar:javaimpl/bcprov-jdk15on-1.64.jar:/opt/ifs/wlp/usr/servers/defaultServer/apps/expanded/ifs-odata-provider.war/WEB-INF/lib/slf4j-api-1.7.25.jar"

if $JAVA_HOME/bin/javac -classpath $myclasspath MySmbClient.java; then

  cat <<LOGPROPS
  
  ############################################################
#       Default Logging Configuration File
#
# You can use a different file by specifying a filename
# with the java.util.logging.config.file system property.
# For example java -Djava.util.logging.config.file=myfile
############################################################

############################################################
#       Global properties
############################################################

# "handlers" specifies a comma separated list of log Handler
# classes.  These handlers will be installed during VM startup.
# Note that these classes must be on the system classpath.
# By default we only configure a ConsoleHandler, which will only
# show messages at the INFO and above levels.
handlers= java.util.logging.ConsoleHandler

# To also add the FileHandler, use the following line instead.
#handlers= java.util.logging.FileHandler, java.util.logging.ConsoleHandler

# Default global logging level.
# This specifies which kinds of events are logged across
# all loggers.  For any given facility this global level
# can be overriden by a facility specific level
# Note that the ConsoleHandler also has a separate level
# setting to limit messages printed to the console.
.level= FINE

############################################################
# Handler specific properties.
# Describes specific configuration info for Handlers.
############################################################

# default file output is in user's home directory.
java.util.logging.FileHandler.pattern = %h/java%u.log
java.util.logging.FileHandler.limit = 50000
java.util.logging.FileHandler.count = 1
# Default number of locks FileHandler can obtain synchronously.
# This specifies maximum number of attempts to obtain lock file by FileHandler
# implemented by incrementing the unique field %u as per FileHandler API documentation.
java.util.logging.FileHandler.maxLocks = 100
java.util.logging.FileHandler.formatter = java.util.logging.XMLFormatter

# Limit the message that are printed on the console to INFO and above.
java.util.logging.ConsoleHandler.level = FINE
java.util.logging.ConsoleHandler.formatter = java.util.logging.SimpleFormatter

# Example to customize the SimpleFormatter output format
# to print one-line log message like this:
#     <level>: <log message> [<date/time>]
#
# java.util.logging.SimpleFormatter.format=%4$s: %5$s [%1$tc]%n

############################################################
# Facility specific properties.
# Provides extra control for each logger.
############################################################

# For example, set the com.xyz.foo logger to only log SEVERE
# messages:
com.xyz.foo.level = SEVERE

  
  LOGPROPS > logging.properties

  alias smbtest="$JAVA_HOME/bin/java -classpath $myclasspath MySmbClient"
  alias smbtestdebug="$JAVA_HOME/bin/java -Djava.util.logging.config.file=logging.properties -classpath $myclasspath MySmbClient"

  echo -n "Enter password for the SMB test (it will not be shown): "
  read -s password
  echo

  echo All done.

  echo
  echo Now try an SMB upload with: 'smbtest smb://SERVER/SHARE/FILENAME DOMAIN USERNAME $password [NUMBEROFLINESTOWRITE]'
  echo
  echo 'DOMAIN can be empty ("")'
  echo NUMBEROFLINESTOWRITE is the number of 100 byte long lines to write to the file
  echo '$password should be written like that and is the variable that keeps the password you entered earlier.'
  echo
  echo There is also an alias named smbtestdebug that does the same thing with more debug information.
  echo
  echo Example:
  echo '  smbtest smb://myserver/myshare/test.txt "" myusername $password' 10

else
  echo Java compile failed. See error above.
fi
