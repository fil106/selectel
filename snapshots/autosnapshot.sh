#!/bin/bash

check_log_file() {
    if [ ! -f "$logFile" ]; then
        touch "$logFile"
    fi
}

check_rc_file() {
    if [ ! -f "$rcFile" ]; then
        echo "Make sure you specify the OpenStack RC-FILE"
        exit 1
    fi
}

rcFile="${1:-${PWD}/rc.sh}"
logFile="./snapshots_creating.log"
telegramToken="YOUR_TELEGRAM_BOT_TOKEN"
chatId="YOUR_TELEGRAM_CHAT_ID"

check_log_file

check_rc_file

source $rcFile

retentionDays=8
date=$(date +"%Y-%m-%d")
expireTime="$retentionDays days ago"
epochExpire=$(date --date "$expireTime" +'%s')
region=${OS_REGION_NAME:?"Please set the OS_REGION_NAME environment variable"}
zone="a"
panelLink=""

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") $1"
    echo "$(date +"%Y-%m-%d %H:%M:%S") $1" >> "$logFile"
}

install_openstack_cli() {
    if ! command -v openstack >/dev/null 2>&1; then
        echo "Installing OpenStack CLI..."
        # Add the installation command specific to your system package manager
        # For example, on Ubuntu, you can use: sudo apt-get install -y python3-openstackclient
        # Replace the command below with the appropriate package manager command for your system
        echo "Please install the OpenStack CLI utility."
        exit 1
    fi
}

send_telegram_message() {
    message="$1"
    curl -s -X POST "https://api.telegram.org/bot$telegramToken/sendMessage" -d "parse_mode=HTML" -d "chat_id=$chatId" -d "text=$message" >/dev/null
}

# Функция для ожидания определенных статусов снапшота
wait_for_snapshot_status() {
    local snapshotID="$1"
    local expected_statuses="$2"
    local timeout="$3"

    local start_time=$(date +%s)
    local end_time=$((start_time + timeout))

    while true; do
        local current_time=$(date +%s)
        if [[ $current_time -ge $end_time ]]; then
            log "Timeout reached. Exiting..."
            send_telegram_message "🚨🚨🚨 <b>ВНИМАНИЕ! Превышено время ожидания для снапшота $snapshotID</b>"
            break
        fi

        local snapshot_status=$(openstack volume snapshot show $snapshotID -c status -f value)

        if [[ $expected_statuses =~ $snapshot_status ]]; then
            log "Snapshot $snapshotID is in status: $snapshot_status"
            break
        fi

        log "Snapshot $snapshotID is in status: $snapshot_status, waiting..."
        sleep 5
    done
}

create_snapshots() {
    log "Creating volume snapshots..."

    for volume in $(openstack volume list -c ID -f value); do
        properties=$(openstack volume show $volume -c properties -f value | sed 's/ //g')
        volumeName=$(openstack volume show ${volume} -c name -f value)

        if [[ $properties == *"'autoSnapshot':'true'"* ]]; then
            log "Found autoSnapshot on ${volumeName} - ${volume}"

            curSnapshotID=$(openstack volume snapshot list -c ID -f value)
            openstack volume snapshot delete $curSnapshotID

            snapshotID=$(openstack volume snapshot create ${volume} --force -c id -f value --description "autoSnapshot_${date}_${volumeName}" | xargs)

            # Ожидание, пока статус снапшота не станет одним из ожидаемых или не пройдет 30 секунд
            wait_for_snapshot_status "$snapshotID" "available" 30

            openstack volume snapshot set $snapshotID --property autoSnapshot=true --name "autoSnapshot_${date}_${volumeName}"

            createdDiskName=$(openstack volume create --snapshot $snapshotID --type="fast.$region$zone" $(date "+BKP_%d-%m-%y_%H-%M") -c name -f value 2>&1)
            if [[ $? -eq 0 ]]; then
                createdDiskID=$(openstack volume list --name $createdDiskName -c ID -f value)
                log "Volume $createdDiskName from snapshot $snapshotID - created!"
                send_telegram_message "👍👍👍 <b>Диск успешно создан:</b>%0AИмя диска: <b>$createdDiskName</b>%0AСсылка: $panelLink/$createdDiskID"
            else
                log "Failed to create volume from snapshot $snapshotID: $createdDiskName"
                send_telegram_message "🚨🚨🚨 <b>ВНИМАНИЕ! Ошибка при создании диска из снапшота:</b>%0AИмя диска: <b>$createdDiskName</b>%0A<b>Необходимо проверить квоты!</b>"
            fi
        else
            log "Skipping volume! Metadata key not set: ${volumeName} - ${volume}"
        fi
    done
}

delete_old_snapshots() {
    log "Deleting old volumes..."

    for vsnapshot in $(openstack volume list -c ID -f value); do
        vsnapshotName=$(openstack volume show ${vsnapshot} -c name -f value)

        if [[ $vsnapshotName == "BKP"* ]]; then
            epochCreated=$(date --date "$(openstack volume show ${vsnapshot} -f value -c created_at)" "+%s")

            if [ $epochCreated -lt $epochExpire ]; then
                log "Deleting old BKP volume: ${vsnapshot}"
                openstack volume delete $vsnapshot
            else
                log "Skipping volume snapshot: ${vsnapshot}"
            fi
        else
            log "Skipping volume snapshot: ${vsnapshot}"
        fi
    done
}

##########################
#       Main Script      #
##########################

install_openstack_cli

create_snapshots

delete_old_snapshots
