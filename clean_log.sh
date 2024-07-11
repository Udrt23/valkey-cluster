#!/bin/bash

fileSizeLimitMB=100
logFile="/var/log/log_size.log"
logFiles=(
    "/var/log/valkey_6379.log"
    "/var/log/valkey_6381.log"
)
for filePath in "${logFiles[@]}"; do
    while true; do
        fileSizeBytes=$(stat -c%s "$filePath")
        fileSizeMB=$(($fileSizeBytes / 1024 / 1024))
        if [ $fileSizeMB -le $fileSizeLimitMB ]; then
            break
        fi
        sedCommand=$(sed -i -e '1,100000d' "$filePath")
        eval $sedCommand
    done
    echo "$(date '+%Y-%m-%d %H:%M:%S') Текущий размер файла $filePath: $(($(stat -c%s "$filePath") / 1024 / 1024)) MB" >>$logFile
done

# cron 0 8 * * *
