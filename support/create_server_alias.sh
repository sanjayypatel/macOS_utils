#!/bin/bash
# Script creates inetloc file that is double-clickable
# This will "bookmark" the server address (and optionally shared volume)
# The shortcut will also include the the username to connect with.

# Primarily used in environments with multiple accounts/directories

echo "Examples Setup: jsmith@server.company.com/shared_volume"
echo "Username for server (jsmith/jsmith2): "
read user_name
echo "Server path: "
read server_name
echo "Display name for the alias (180Net1):"
read display_server_name

file_path="${HOME}/Desktop/$user_name-$display_server_name.inetloc"
echo "Creatng alias at: $file_path"

# XML contents of alias
XML=$(echo "<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>URL</key>
	<string>smb://$user_name:*@$server_name</string>
</dict>
</plist>")

echo $XML >> $file_path

echo "Alias created on your Desktop."
open $HOME/Desktop