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
        if [ $(ls -td /var/backups/aof_*/ | wc -l) -gt 3 ]; then
            ls -td /var/backups/aof_* | tail -n +4 | xargs rm -rf
        fi
        echo "$(date '+%Y_%m_%d %H:%M:%S') Файлы успешно скопированы в $backupDir" >>"$logFile"
    else
        echo "$(date '+%Y_%m_%d %H:%M:%S') Подключение отклонено для $ipAddress:$port" >>"$logFile"
        continue
    fi
done

# cron */10 * * * *
