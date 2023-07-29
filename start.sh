#!/bin/bash

FILE="/minecraft/scheduled-tasks/tasks.conf.json"

crontab -r

schedules=$(jq -r 'keys[]' $FILE)

for schedule in $schedules; do
  cron_time=$(jq -r ".[\"$schedule\"].cron" $FILE)

  (crontab -l 2>/dev/null; echo "$cron_time node /minecraft/scheduled-tasks/script.js $schedule") | crontab -
done

cron 
java -Xms${INIT_MEMORY} -Xmx${MAX_MEMORY} -jar fabric-server-mc.jar nogui