#!/bin/bash

# Set the base directory to the current working directory
BASE_DIR=$(pwd)

# File paths
DEVICE_FILE="${BASE_DIR}/devices.txt"
LOG_FILE="${BASE_DIR}/backups.log"

# Ensure the log file exists
touch "$LOG_FILE"

# Ensure the device file exists, create it if not
if [ ! -f "$DEVICE_FILE" ]; then
    touch "$DEVICE_FILE"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - ERROR: Device file not found. Created an empty devices.txt file." >> "$LOG_FILE"
    exit 1
fi

# Check if the device file is empty
if [ ! -s "$DEVICE_FILE" ]; then
    echo "$(date +'%Y-%m-%d %H:%M:%S') - ERROR: Device file is empty. No devices to backup." >> "$LOG_FILE"
    exit 1
fi

# Loop through each line in the device file and perform the backup
while IFS=' ' read -r PAN_IP API_KEY; do
    if [ -n "$PAN_IP" ] && [ -n "$API_KEY" ]; then
        echo "$(date +'%Y-%m-%d %H:%M:%S') - INFO: Starting backup for ${PAN_IP}." >> "$LOG_FILE"
        BACKUP_FOLDER="${BASE_DIR}/backups/${PAN_IP}"
        mkdir -p "$BACKUP_FOLDER"
        BACKUP_FILE="${BACKUP_FOLDER}/backup-${PAN_IP}-$(date +%F).xml"

        # Perform the backup and save directly to file
        curl -s -k "https://${PAN_IP}/api/?type=export&category=configuration&key=${API_KEY}" -o "$BACKUP_FILE"

        # Check if the backup file was created and is not empty
        if [ -s "$BACKUP_FILE" ]; then
            echo "$(date +'%Y-%m-%d %H:%M:%S') - INFO: Backup for ${PAN_IP} saved as $BACKUP_FILE." >> "$LOG_FILE"
        else
            echo "$(date +'%Y-%m-%d %H:%M:%S') - ERROR: Backup failed for ${PAN_IP}. No data saved." >> "$LOG_FILE"
            rm -f "$BACKUP_FILE"  # Remove the empty file if the backup failed
        fi
    fi
done < "$DEVICE_FILE"
