#!/bin/bash

# Set the base directory to the current working directory
BASE_DIR=$(pwd)

# File paths
DEVICE_FILE="${BASE_DIR}/devices.txt"

# Ensure the device file exists
if [ ! -f "$DEVICE_FILE" ]; then
    echo "ERROR: Device file not found."
    exit 1
fi

# Check if the device file is empty
if [ ! -s "$DEVICE_FILE" ]; then
    echo "ERROR: Device file is empty. No devices to test."
    exit 1
fi

# Loop through each line in the device file and test the API key
while IFS=' ' read -r PAN_IP API_KEY; do
    if [ -n "$PAN_IP" ] && [ -n "$API_KEY" ]; then
        echo "Testing API key for ${PAN_IP}..."

        # Perform the test API call
        RESPONSE=$(curl -s -k -X POST "https://${PAN_IP}/api/?type=op&cmd=<show><system><info></info></system></show>&key=${API_KEY}")

        # Check if the API call was successful
        if echo "$RESPONSE" | grep -q "<response status=\"success\">"; then
            DEVICENAME=$(echo "$RESPONSE" | grep -oP '(?<=<devicename>).*?(?=</devicename>)')
            UPTIME=$(echo "$RESPONSE" | grep -oP '(?<=<uptime>).*?(?=</uptime>)')
            VERSION=$(echo "$RESPONSE" | grep -oP '(?<=<sw-version>).*?(?=</sw-version>)')

            echo "SUCCESS: API key for ${PAN_IP} is valid."
            echo "Device Name: ${DEVICENAME}"
            echo "Uptime: ${UPTIME}"
            echo "Software Version: ${VERSION}"
            echo
        else
            echo "ERROR: API key for ${PAN_IP} is invalid or connection failed."
            echo
        fi
    fi
done < "$DEVICE_FILE"
