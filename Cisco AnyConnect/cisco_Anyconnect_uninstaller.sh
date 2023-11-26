#!/bin/sh

######################################################################################################
## Script to remove Cisco Anyconnect on macOS                                                    #####
## Created by Shri Sivakumaran, Slack me @Shri / GitHub - macbudS                                #####
## This script will clean up Cisco Anyconnect 4.1.08005 to 4.9.xxx, tested in macOS 10.15.7 & 11 #####
## Cisco Anyconnect, Dart, iseposture and Umbrella will be removed                               #####
######################################################################################################

### Display message to close all application and files
MESSAGE=$(osascript -e 'display alert "Action need to be taken before uninstalling Cisco Anyconnecct" message "Kindly save and close all your files and application, your Mac will reboot at end of this process. click on Ok button once you closed application(s) and file(s)"buttons {"Cancel","Ok"}')

v=$(echo "$MESSAGE" | /usr/bin/awk -F "button returned:|," '{print $2}')
if [[ $v == 'Ok' ]]; then
sleep 20

MESSAGE=$(osascript -e 'display alert "Are you ready to uninstall Cisco Anyconnect..." message ""buttons {"No","Yes"}')

v=$(echo "$MESSAGE" | /usr/bin/awk -F "button returned:|," '{print $2}')
if [[ $v == 'Yes' ]]; then
echo "Cisco Anyconnect uninstaller starts..."

## Uninstallating Cisco Anyconnect, Dart,iseposture,umbrella
sh /opt/cisco/vpn/bin/vpn_uninstall.sh
sh /opt/cisco/vpn/bin/dart_uninstall.sh
sh /opt/cisco/anyconnect/bin/anyconnect_uninstall.sh
sh /opt/cisco/anyconnect/bin/vpn_uninstall.sh
sh /opt/cisco/anyconnect/bin/umbrella_uninstall.sh
sh /opt/cisco/anyconnect/bin/dart_uninstall.sh
sh /opt/cisco/anyconnect/bin/iseposture_uninstall.sh

## Cleaning left over files and Profiles
rm -rf /System/Library/StartupItems/CiscoVPN
rm -rf /Library/StartupItems/CiscoVPN
rm -rf /System/Library/Extensions/CiscoVPN.kext
rm -rf /Library/Extensions/CiscoVPN.kext
rm -rf /Library/Receipts/vpnclient-kext.pkg
rm -rf /Library/Receipts/vpnclient-startup.pkg
rm -rf /Library/Frameworks/cisco-vpnclient.framework
rm -rf /Library/Extensions/tun.kext
rm -rf /Library/Extensions/tap.kext
rm -rf /Library/Receipts/vpnclient-api.pkg
rm -rf /Library/Receipts/vpnclient-bin.pkg
rm -rf /Library/Receipts/vpnclient-gui.pkg
rm -rf /Library/Receipts/vpnclient-profiles.pkg
rm -rf ~/Library/Preferences/com.cisco.VPNClient.plist
rm -rf /opt/cisco
pkgutil --forget com.cisco.pkg.anyconnect.vpn
## Uninstallation completed, displaying restart message
echo "uninstallation completed successfully"
osascript -e 'display alert "Cisco Anyconnect uninstallation completed" message "System will restart now"'
jamf recon
sleep 5
reboot

else

echo "process stopped"
osascript -e 'display alert "Cisco Anyconnect uninstallation process stopped" message "If you like to continue, run the policy again"'
fi
else
echo "User stopped the uninstallation process"
fi
exit 0