#!/bin/bash

ports=("6379" "6381")
ipAddress=$(ip a | grep 'inet ' | awk '/ens18/ {print $2}' | cut -d'/' -f1)
timestamp=$(date +%Y_%m_%d-%H:%M)
logFile=/var/log/backup_valkey.log

for port in "${ports[@]}"; do
    command="/opt/valkey/src/valkey-cli -c -h \"$ipAddress\" -p $port BGSAVE"
    if eval "$command"; then
        backupDir="/var/backups/rdb_${timestamp}"
        if [ ! -d "$backupDir" ]; then
            mkdir -p "$backupDir"
        fi
        cp "/var/lib/valkey/dump_$port.rdb" "$backupDir/"
        if [ $(ls -td /var/backups/rdb_*/ | wc -l) -gt 3 ]; then
            ls -td /var/backups/rdb_* | tail -n +4 | xargs rm -rf
        fi
        echo "$(date '+%Y_%m_%d %H:%M:%S') Files copied successfully to $backupDir" >>"$logFile"
    else
        echo "$(date '+%Y_%m_%d %H:%M:%S') Connection rejected for $ipAddress:$port" >>"$logFile"
        continue
    fi
done

# cron 0 * * * *
