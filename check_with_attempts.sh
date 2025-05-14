#!/bin/bash

ports=("6379" "6381")
checkProcess() {
    local port=$1
    local processName="valkey-server"
    local ipAddress=$(ip a | grep 'inet ' | awk '/ens18/ {print $2}' | cut -d'/' -f1)
    local attempt=0
    local logFile="/var/log/check_valkey.log"
    while ((attempt < 3)); do
        if pgrep -f "$processName $ipAddress:$port"; then
            break
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') Process valkey-server not found on port $port. Restarting..." >>$logFile
            if [[ $port == "6379" ]]; then
                /opt/valkey/src/valkey-server /opt/valkey/valkey_6379.conf &
            elif [[ $port == "6381" ]]; then
                /opt/valkey/src/valkey-server /opt/valkey/valkey_6381.conf &
            fi
            let "attempt+=1"
            sleep 1
        fi
    done
    if [[ $attempt -eq 3 ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') Error starting process valkey-server on port $port after 3 attempts." >>$logFile
    fi
}

while true; do
    for port in "${ports[@]}"; do
        checkProcess $port
    done
    sleep 1
done

# service
