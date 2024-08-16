#!/bin/bash

# Prompt the user for the base directory, defaulting to the current working directory
read -p "Enter the base directory for backups (default: current working directory): " BASE_DIR
BASE_DIR=${BASE_DIR:-$(pwd)}

# Prompt the user for the firewall IP, username, and password
read -p "Enter the Palo Alto Firewall IP: " PAN_IP
read -p "Enter the Username: " USERNAME
read -s -p "Enter the Password: " PASSWORD
echo

# Generate the API key using curl and extract it using grep and sed
API_KEY=$(curl -s -k -H "Content-Type: application/x-www-form-urlencoded" -X POST "https://${PAN_IP}/api/?type=keygen" -d "user=${USERNAME}&password=${PASSWORD}" | grep -oP '(?<=<key>).*?(?=</key>)')

# Check if the API key was successfully retrieved
if [ -n "$API_KEY" ]; then
    echo "API Key: $API_KEY"

    # Ask the user if they want to add this to devices.txt
    read -p "Do you want to add this IP and API key to devices.txt for backups? (y/n): " ADD_TO_DEVICES

    if [ "$ADD_TO_DEVICES" == "y" ]; then
        # Define the devices.txt file path
        DEVICE_FILE="${BASE_DIR}/devices.txt"

        # Ensure the base directory exists
        mkdir -p "$BASE_DIR"

        # Append the IP and API key to devices.txt using space as the separator
        echo "${PAN_IP} ${API_KEY}" >> "$DEVICE_FILE"
        echo "Added ${PAN_IP} and its API key to ${DEVICE_FILE}."
    else
        echo "The IP and API key were not added to devices.txt."
    fi
else
    echo "Failed to retrieve API key. Please check your credentials and try again."
fi
