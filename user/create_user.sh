#!/bin/zsh
# Written by Sanjay patel
# Updated 2022-06-07
# RUN WITH SUDO
# Create a user using sysadminctl and createhomedir
# Runs interactively at command line. Does not need GUI session.

jamf_binary="/usr/local/bin/jamf"

# sudo check.  Should NOT be run as root/sudo
sudo_check=$( whoami )
if [ "$sudo_check" = root ]
then
	echo "Must be run as admin (not root). Do not run with sudo."
	exit 1
fi

# default settings
primary_group_id="20"
user_shell="/bin/zsh"
user_picture="/Library/User Pictures/Animals/Penguin.tif"

# figure out next available uid
last_id=$( dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1 )
user_uid=$((last_id + 1))

echo "Create a new user."
echo "Provide the local admin password for sysadminctl:"
read -s admin_pass

echo "Users Full Name (John Smith): "
read full_name
echo "Username (jsmith): "
read username
user_home="/Users/$username"
echo "Password: "
read -s password
echo "Admin? (y/n): "
read is_admin

echo "Creating User"
sudo sysadminctl -addUser "$username" -fullName "$full_name" -UID "$user_uid"  -GID "$primary_group_id" -shell "$user_shell" -password "$password" -home "$user_home" -picture "$user_picture" -adminUser atg -adminPassword $admin_pass
echo "Creating Home Directory $user_home"
sudo createhomedir -lc -u "$username"

# Add to admin group
if [ "$is_admin" = "y" ]
then
      echo "Added $username to admin group"
      sudo dscl . -append /Groups/admin GroupMembership "$username"
fi

echo "Updating jamf"
sudo $jamf_binary recon

echo "Created $username."
