#!/usr/bin/env bash

#set uuid
UUID=$(uuidgen)
cat >>$RDECK_BASE/etc/framework.properties <<END
rundeck.server.uuid = $UUID
END

API_KEY=${API_KEY:-letmein99}
cat > $RDECK_BASE/etc/tokens.properties <<END
admin: $API_KEY
END

#rd settings
mkdir ~/.rd
cat > ~/.rd/rd.conf <<END
export RD_TOKEN=$API_KEY
export RD_URL="http://localhost:8080/rundeck"
export RD_COLOR=0
export RD_OPTS="-Dfile.encoding=utf-8"
export RD_HTTP_TIMEOUT=300
#export RD_DEBUG=1
END

# pass rundeck home to tomcat

cat > /usr/local/tomcat/bin/setenv.sh <<END
JAVA_OPTS="$JAVA_OPTS -Drdeck.base=$RDECK_BASE -Drundeck.config.location=$RDECK_BASE/etc/rundeck-config.properties"
END

# undeplpy rundeckpro and load log4j.properties
cd $CATALINA_HOME/webapps
unzip -d rundeckpro rundeckpro.war

cp $RDECK_BASE/etc/log4j.properties $CATALINA_HOME/webapps/rundeckpro/WEB-INF/classes/

