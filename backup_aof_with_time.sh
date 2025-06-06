#!/bin/bash

ports=("6379" "6381")
ipAddress=$(ip a | grep 'inet ' | awk '/ens18/ {print $2}' | cut -d'/' -f1)
timestamp=$(date +%Y_%m_%d-%H:%M)
logFile=/var/log/backup_valkey.log

for port in "${ports[@]}"; do
    command="/opt/valkey/src/valkey-cli -c -h \"$ipAddress\" -p $port BGREWRITEAOF"
    if eval "$command"; then
        backupDir="/var/backups/aof_${timestamp}"
        if [ ! -d "$backupDir" ]; then
            mkdir -p "$backupDir"
        fi
        cp -r "/var/lib/valkey/appendonlydir_$port" "$backupDir/"
        if [ $(ls -td /var/backups/aof_*/ | wc -l) -gt 6 ]; then
            ls -td /var/backups/aof_* | tail -n +7 | xargs rm -rf
        fi
        echo "$(date '+%Y_%m_%d %H:%M:%S') Files copied successfully to $backupDir" >>"$logFile"
    else
        echo "$(date '+%Y_%m_%d %H:%M:%S') Connection rejected for $ipAddress:$port" >>"$logFile"
        continue
    fi
done

# cron */10 * * * *
