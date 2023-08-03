#!/bin/bash

# if minecraft directory not exist, create it
if [ ! -d "/minecraft" ]; then
  mkdir /minecraft
fi

# install dependencies
apt-get update && apt-get install -y cron nodejs npm jq curl
cd /app/scheduled-tasks && npm install
cd /minecraft

# scheduled-tasks
if [ ! -f "./tasks.conf.json" ]; then
  if [ -f "/app/scheduled-tasks/tasks.conf.json" ]; then
    mv /app/scheduled-tasks/tasks.conf.json /minecraft/tasks.conf.json
  fi
else
  if [ -f "/app/scheduled-tasks/tasks.conf.json" ]; then
    rm -rf /app/scheduled-tasks/tasks.conf.json
  fi
fi

TASKS_FILE="./tasks.conf.json"

crontab -r
(crontab -l 2>/dev/null; echo "RCON_PASSWORD=${RCON_PASSWORD}") | crontab -

schedules=$(jq -r 'keys[]' $TASKS_FILE)

for schedule in $schedules; do
  cron_time=$(jq -r ".[\"$schedule\"].cron" $TASKS_FILE)

  (crontab -l 2>/dev/null; echo "$cron_time node /app/scheduled-tasks/script.js $schedule") | crontab -
done

cron 

# setup minecraft server
FABRIC_SERVER_MC_FILE="fabric-server-mc.${MINECRAFT_VERSION}-loader.${FABRIC_LOADER_VERSION}-launcher.${FABRIC_INSTALLER_VERSION}.jar"

if [ ! -f "/minecraft/$FABRIC_SERVER_MC_FILE" ]; then
  rm -rf /minecraft/fabric-server-mc.*
  curl -sS -o $FABRIC_SERVER_MC_FILE https://meta.fabricmc.net/v2/versions/loader/${MINECRAFT_VERSION}/${FABRIC_LOADER_VERSION}/${FABRIC_INSTALLER_VERSION}/server/jar
  chmod +x /minecraft/$FABRIC_SERVER_MC_FILE
fi

echo "eula=${EULA}" > eula.txt



# echo "enable-rcon=${RCON_ENABLE}" > server.properties
# echo "rcon.password=${RCON_PASSWORD}" >> server.properties
# echo "rcon.port=25575" >> server.properties


# Vérifiez si le fichier server.properties existe, sinon le crée
if [ ! -f server.properties ]; then
    touch server.properties
fi

tempfile=$(mktemp)

while IFS= read -r line
do
    property=$(echo "$line" | cut -d '=' -f 1)
    current_value=$(echo "$line" | cut -d '=' -f 2-)

    if [ "$property" = "enable-rcon" ]; then
        if [ "$current_value" != "$RCON_ENABLE" ]; then
            echo "enable-rcon=$RCON_ENABLE" >> $tempfile
        else
            echo "$line" >> $tempfile
        fi
    elif [ "$property" = "rcon.password" ]; then
        if [ "$current_value" != "$RCON_PASSWORD" ]; then
            echo "rcon.password=$RCON_PASSWORD" >> $tempfile
        else
            echo "$line" >> $tempfile
        fi
    elif [ "$property" = "rcon.port" ]; then
        if [ "$current_value" != "25575" ]; then
            echo "rcon.port=25575" >> $tempfile
        else
            echo "$line" >> $tempfile
        fi
    else
        echo "$line" >> $tempfile
    fi
done < server.properties

mv $tempfile server.properties

# start
java -Xms${INIT_MEMORY} -Xmx${MAX_MEMORY} -jar $FABRIC_SERVER_MC_FILE nogui