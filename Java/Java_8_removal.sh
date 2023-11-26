#!/bin/sh

#  Java_8_removal.sh
#  
#
#  Created by Shri Sivakumaran C on 04/09/23.
#  
LoggedUser=$(stat -f "%Su" /dev/console)
echo $LoggedUser

sudo rm -fr /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin

sudo rm -fr /Library/PreferencePanes/JavaControlPanel.prefPane


sudo rm -rf /User/$LoggedUser/Library/Application\ Support/Oracle/Java

rm -fr /Library/Java/JavaVirtualMachines/jdk1.8*
  
  ##update inventory to Jamf Pro
  jamf recon

exit 0
