#!/bin/bash

# if minecraft directory not exist, create it
if [ ! -d "/minecraft" ]; then
  mkdir /minecraft
fi
cd /minecraft

# install dependencies
apt-get update && apt-get install -y cron nodejs npm jq curl

# scheduled-tasks
if [ ! -d "./scheduled-tasks" ]; then
  if [ -d "/app/scheduled-tasks" ]; then
    mv /app/scheduled-tasks /minecraft
  fi
else
  if [ -d "/app/scheduled-tasks" ]; then
    rm -rf /app/scheduled-tasks
  fi
fi

TASKS_FILE="./scheduled-tasks/tasks.conf.json"

crontab -r

schedules=$(jq -r 'keys[]' $TASKS_FILE)

for schedule in $schedules; do
  cron_time=$(jq -r ".[\"$schedule\"].cron" $TASKS_FILE)

  (crontab -l 2>/dev/null; echo "$cron_time node ./scheduled-tasks/script.js $schedule") | crontab -
done

cron 

# setup minecraft server
FABRIC_SERVER_MC_FILE="fabric-server-mc.${MINECRAFT_VERSION}-loader.${FABRIC_LOADER_VERSION}-launcher.${FABRIC_INSTALLER_VERSION}.jar"

if [ ! -f "/minecraft/$FABRIC_SERVER_MC_FILE" ]; then
  rm -rf /minecraft/fabric-server-mc.*
  curl -sS -o $FABRIC_SERVER_MC_FILE https://meta.fabricmc.net/v2/versions/loader/${MINECRAFT_VERSION}/${FABRIC_LOADER_VERSION}/${FABRIC_INSTALLER_VERSION}/server/jar
  mv $FABRIC_SERVER_MC_FILE /minecraft
  chmod +x /minecraft/$FABRIC_SERVER_MC_FILE
fi

echo "eula=${EULA}" > eula.txt
echo "enable-rcon=${RCON_ENABLE}" > server.properties
echo "rcon.password=${RCON_PASSWORD}" >> server.properties
echo "rcon.port=25575" >> server.properties

npm install -g rcon

# start
java -Xms${INIT_MEMORY} -Xmx${MAX_MEMORY} -jar $FABRIC_SERVER_MC_FILE nogui