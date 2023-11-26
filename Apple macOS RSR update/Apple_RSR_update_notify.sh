#!/bin/sh

######################################################################################################
## script to check and install macOS Ventura RSR updates                                         #####
## Created by Shri Sivakumaran, Slack me @Shri / GitHub - macbudS                                #####
######################################################################################################


description="Critical update for macOS Ventura !!!!

Apple released update to fix high severity vulnerability on macOS. Kindly install the updates as soon as possible from System Settings --> Gerenal --> Software Update.

System will restart at end of the update.

This process will take less than 5 minutes."

#icon=logo or image path

check=$(softwareupdate -l | grep Rapid | grep -o 'Rapid[^[:blank:]]*' | head -n 1)
 echo "$check"
 if [ -z "$check" ];
 then 

echo "No updates available for macOS"
else

/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -button1 "Ok" -windowType "utility" -icon "$icon" -description "$description"  -heading "***IMPORTANT UPDATE***"  -defaultButton 1 -title "Message from IT team" -timeout 120

echo "Updates available for macOS Ventura"

fi

exit 0