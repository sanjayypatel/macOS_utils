#!/bin/zsh
# Written by Sanjay Patel
# Updated 2022-06-07
# Deletes a local user account. Intended for use as a utility when testing user creation workflows.
# NO SAFETIES IN PLACE! USE AT YOUR OWN RISK
# Not intended for general support usage.

jamf_binary="/usr/local/bin/jamf"

# sudo check.  Should NOT be run as root/sudo
sudo_check=$( whoami )
if [ "$sudo_check" = root ]
then
	echo "Must be run as admin (not root). Do not run with sudo."
	exit 1
fi

echo "This will remove a user with no backups. CTL-C to exit."

echo "Provide the local admin password for sysadminctl:"
read -s admin_pass

echo "User to delete: "
read username

echo "Deleting $username. You may be get a prompt for sudo password."
sudo sysadminctl -deleteUser "$username" -adminUser atg -adminPassword $admin_pass

echo "Updating jamf"
sudo $jamf_binary recon
