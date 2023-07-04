#!/bin/bash

rcFile="${1:-/usr/local/rcfile.sh}"

retentionDays=5

# Set Variables
date=$(date +"%Y-%m-%d")
expireTime="$retentionDays days ago"
epochExpire=$(date --date "$expireTime" +'%s')
region="ru-9a"

# If RC file exists load the rcfile, otherwise announce it does not exist and exit script with exit code 1
if [ -f "$rcFile" ]; then
    source $rcFile
else
    echo "Make sure you specify the Openstack RC-FILE"
    exit 1
fi

##########################
#   Snapshot Creation    #
##########################

# Announce volume snapshot creation
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo "Creating volume snapshots!"

# If an instance has the autoSnapshot metadata tag is true create snapshots!
for volume in $(openstack volume list -c ID -f value); do
    # Retrieve the required info from the instance.
    properties=$(openstack volume show $volume -c properties -f value | sed 's/ //g')
    volumeName=$(openstack volume show ${volume} -c name -f value)

    # Check if the autoSnapshot is set to true, if this is the case create a snapshot of that instance, otherwise skip the instance.
    if [[ $properties == *"'autoSnapshot':'true'"* ]]; then
        echo "Found autoSnapshot on ${volumeName} - ${volume}"

        echo "Deleting previous snapshot"
        curSnapshotID=$(openstack volume snapshot list -c ID -f value)
        openstack volume snapshot delete $curSnapshotID

        echo "Creating snapshot of volume: ${volumeName} - ${volume}"
        snapshotID=$(openstack volume snapshot create ${volume} --force -c id -f value --description "autoSnapshot_${date}_${volumeName}" | xargs)
        openstack volume snapshot set $snapshotID --property autoSnapshot=true --name "autoSnapshot_${date}_${volumeName}"
        
        echo "Creating volume from snapshot $snapshotID"
        openstack volume create --snapshot $snapshotID --type=fast.$region $(date "+BKP_%d-%m-%y_%H-%M")
    else
        echo "Skipping volume! Metadata key not set: ${volumeName} - ${volume}"
    fi
done

##########################
#   Snapshot Deletion    #
##########################

# Announce volume snapshot deletion
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo "Deleting old volumes!"

# Get all volumes uuid's which include autoSnapshot in their name
for vsnapshot in $(openstack volume list -c ID -f value); do

    # Check if the snapshot name starts with autoSnapshot
    vsnapshotName=$(openstack volume show ${vsnapshot} -c name -f value)
    if [[ $vsnapshotName == "BKP"* ]]; then

        # Get the epochtimestamp from when the snapshot wat created
        epochCreated=$(date --date "$(openstack volume show ${vsnapshot} -f value -c created_at)" "+%s")

        # If the snapshot is older then the above specified in variable expireTime delete the snapshot
        if [ $epochCreated -lt $epochExpire ]; then
            echo "Deleting old BKP volume: ${vsnapshot}"
            openstack volume delete $vsnapshot
        else
            echo "Skipping volume snapshot: ${vsnapshot}"
        fi
    else
        echo "Skipping volume snapshot: ${vsnapshot}"
    fi
done