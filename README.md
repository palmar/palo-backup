# palo-backup

This is a collection of scripts to simplify the workflow of making a backup of the XML configuration of a Palo Alto Firewall.

## Security concerns

The script will require API keys in plain text to be saved to the machine. By default it uses the 600 permissions, but that doesn't stop a user with root access from reading the file.
Additionally, the backups themselves may contain data that needs to be secured. Make sure you understand access to the backup machine .

## Automation

Add the palo-backup script to cron if you like!
