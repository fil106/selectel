#!/bin/bash

rcFile="${1:-${PWD}/rc.sh}"
logFile="./snapshots_creating.log"

retentionDays=8
date=$(date +"%Y-%m-%d")
expireTime="$retentionDays days ago"
epochExpire=$(date --date "$expireTime" +'%s')
region=${OS_REGION_NAME:?"Please set the OS_REGION_NAME environment variable"}
zone="a"

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") $1"
    echo "$(date +"%Y-%m-%d %H:%M:%S") $1" >> "$logFile"
}

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
            openstack volume snapshot set $snapshotID --property autoSnapshot=true --name "autoSnapshot_${date}_${volumeName}"
            
            openstack volume create --snapshot $snapshotID --type="fast.$region$zone" $(date "+BKP_%d-%m-%y_%H-%M")
            log "Volume $(date "+BKP_%d-%m-%y_%H-%M") from snapshot $snapshotID - created!"
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

check_log_file

check_rc_file
source $rcFile

install_openstack_cli

create_snapshots

delete_old_snapshots
