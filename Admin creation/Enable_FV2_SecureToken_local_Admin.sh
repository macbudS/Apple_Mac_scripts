#!/bin/sh   

######################################################################################################
## Script to add FV2 abd secure token to local admin on macOS                                    #####
## Created by Shri Sivakumaran, Slack me @Shri                                                   #####
######################################################################################################

adminName="localadmin account name" #give your local admin name here or pass it from $4
adminPass="enter password here" #password of local admin account or pass it from $5
## Get the logged in user's name
userName=`stat -f%Su /dev/console`

## This first user check sees if the logged in account is already authorized with FileVault 2
userCheck=$(sudo fdesetup list | grep -F $adminName)
if [ "$userCheck" != "" ]; then
echo "This user is already added to the FileVault 2 list."
exit 3
fi

## Check to see if the encryption process is complete
encryptCheck=`fdesetup status`
statusCheck=$(echo "${encryptCheck}" | grep "FileVault is On.")
expectedStatus="FileVault is On."
if [ "${statusCheck}" != "${expectedStatus}" ]; then
echo "The encryption process has not completed, unable to add user at this time."
echo "${encryptCheck}"
exit 4
fi

## Get the logged in user's password via a prompt
echo "Prompting ${userName} for their login password."
#USERPASS="$(osascript -e 'Tell application "System Events" to display dialog "Please enter your login password:" default answer "" with title "Login Password" with text buttons {"Ok"} default button 1 with hidden answer' -e 'text returned of result')"
USERPASS=$(osascript -e '
tell application "Finder"
   display dialog "Enter your Mac login password please to enable FileVault" default answer "" with hidden answer
    set USERPASS to the (text returned of the result)
end tell')
echo "Adding user to FileVault 2 list."

# create the plist file:
echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>Username</key>
<string>'$userName'</string>
<key>Password</key>
<string>'$USERPASS'</string> 
<key>AdditionalUsers</key>
<array>
    <dict>
        <key>Username</key>
        <string>'$adminName'</string>
        <key>Password</key>
        <string>'$adminPass'</string>
    </dict>
</array>
</dict> 
</plist>' > /tmp/fvenable.plist

# now enable FileVault
fdesetup add -inputplist < /tmp/fvenable.plist

# now enable Secure Token
sudo sysadminctl -secureTokenOn $adminName -password $adminPass -adminUser $userName -adminPassword $USERPASS
sysadminctl -secureTokenStatus $adminName

## This second user check sees if the logged in account was successfully added to the FileVault 2 list
userCheck=`fdesetup list | awk -v usrN="$adminName" -F, 'index($0, usrN) {print $1}'`
if [ "${userCheck}" != "${adminName}" ]; then
echo "Failed to add user to FileVault 2 list."
exit 5
fi

echo "${adminName} has been added to the FileVault 2 list."
## clean up
if [[ -e /tmp/fvenable.plist ]]; then
    rm /tmp/fvenable.plist
fi
jamf recon
exit 0