#!/bin/zsh
# Script: Get an IP list from Jamf advanced computer search
# The IP list is in the form of a text file with one IP address per line.
# Perfect for copy/paste into ansible ini inventory file OR ARD import

# Functions
comp_search_id()
{
	echo "Enter the ID number of the computer search you want to pull or leave blank for the default computer search ID number [209]:"
	read comp_search_id
	comp_search_id="${comp_search_id:-209}"
}
list_name()
{
	echo "Enter a name for the text file if not using the default computer search, or leave blank for the default name [ip_list.txt]"
	read list_name
	list_name="${list_name:-ip_list}"
}

#authenticate to Jamf instance, encode credentials and get Bearer token
echo "This script requires a Jamf login."
echo "Enter necessary information to begin deployment. To Cancel use Ctrl-C"
echo "Jamf Username:"
read jamf_user
echo "Jamf Password:"
read -s jamf_password
# encode credentials for subsequent token request
encoded_credentials=$( printf "$jamf_user:$jamf_password" | /usr/bin/iconv -t ISO-8859-1 | /usr/bin/base64 -i - )

# Current JSS address (assumes device is enrolled)
jss_url=$( /usr/bin/defaults read /Library/Preferences/com.jamfsoftware.jamf.plist jss_url )
# If this device is not enrolled, specify the jss url with a string
# jss_url="https://mycompany.jamfcloud.com"

# Use our base64 creds to generate a temporary API access token in JSON form
# Use tr to strip out line feeds or the JXA will not like the input
# Retrieve the read token from the JSON response
json_response=$( /usr/bin/curl -s "${jss_url}api/v1/auth/token" -H "authorization: Basic ${encoded_credentials}" -X POST | tr -d "\n" )
token=$( /usr/bin/osascript -l 'JavaScript' -e "JSON.parse(\`$json_response\`).token" )

echo "Token generated."
echo "Make sure the computer search includes Last Reported IP Address."

comp_search_id
list_name

# Pull advanced computer search
comp_search=$( /usr/bin/curl -s "${jss_url}JSSResource/advancedcomputersearches/id/${comp_search_id}" -H "authorization: Bearer ${token}" -H "accept: application/json" )
#echo "${comp_search}"
computers=$( /usr/bin/osascript -l 'JavaScript' -e "JSON.parse(\`$comp_search\`).advanced_computer_search.computers" )
echo "${computers}" | sed 's/, /\n/g' | grep "Last_Reported_IP_Address:" | awk -F: '{print $2}' > ~/Desktop/$list_name.txt
echo "IP list stored in $list_name.txt"

# Invalidate the token
/usr/bin/curl -s -k "${jss_url}api/v1/auth/invalidate-token" -H "authorization: Bearer ${token}" -X POST

exit 0