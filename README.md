# palo-backup

This is a collection of scripts to simplify the workflow of making a backup of the XML configuration of a Palo Alto Firewall.

## How to use

Terminal commands:

git clone https://github.com/palmar/palo-backup.git
cd palo-backup/
chmod a+x *.sh
./generate-api-key.sh
  (Follow the prompts)
./test-api-key.sh
./palo-backup.sh

This should create your initial backup of the firewall. Run ./palo-backup.sh any time you want to make a backup.

You can run ./generate-api-key.sh script for every firewall you want to add, or you can manually edit the devices.txt file.

## Security concerns

The script will require API keys in plain text to be saved to the machine. By default the devices.txt uses the 600 permissions, but that doesn't stop a user with root access from reading the file.
Additionally, the backups themselves may contain data that needs to be secured. Make sure you understand access to the backup machine .

## Automation

Add the palo-backup script to cron if you like!
