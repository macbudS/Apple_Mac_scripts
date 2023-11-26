#!/bin/sh

######################################################################################################
## Java_version_EA.sh on macOS                                                                   #####
## Created by Shri Sivakumaran on 01/03/23., Slack me @Shri                                      #####
######################################################################################################


java_versions=$(/usr/libexec/java_home -V 2>&1 | grep -E "[0-9]+\.[0-9]+(_[0-9]+)?\+?" | awk '{ print $1 " " $3" "$4 }')

if [[ -z "$java_versions" ]]; then
  echo "<result>Java not installed</result>"
else
  java=${java_versions//\"/}
  echo "<result>$java</result>"
fi

exit 0