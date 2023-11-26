#!/bin/sh   

######################################################################################################
## script to create hidden admin account on Mac                                                  #####
## Created by Shri Sivakumaran, Slack me @Shri / GitHub - macbudS                                #####
######################################################################################################

adminName=localAdmin
adminPass=pa$$word%3
# If passing name and password from jmaf
#adminName=$4
#adminPass=$5


# Create a new user with the username New user   
sudo dscl . -create /Users/$adminName
# Add the display name of the User as Shri
sudo dscl . -create /Users/$adminName RealName "Shri"  
# Replace password_here with your desired password to set the password for this user  
sudo dscl . -passwd /Users/$adminName $adminPass 
# (Optional)Add a profile picture   
sudo dscl . -create /Users/$adminName picture “/Library/User Pictures/Nature/Leaf.heic”  
# Set the Unique ID for New user. Replace with a number that is not already taken.   
sudo dscl . -create /Users/$adminName UniqueID 504  
# Set the group ID for the user  
sudo dscl . -create /Users/$adminName PrimaryGroupID 20  
# Set the shell interpreter to Bash for New\ user   
sudo dscl . -create /Users/$adminName UserShell /bin/zsh 
# Create a Home folder for the user  
sudo dscl . -create /Users/$adminName NFSHomeDirectory /Local/Users/$adminName  
# Append the User with admin privilege. If this line is not included the user will be set as standard user. 
sudo dscl . -append /Groups/admin GroupMembership $adminName  
# Hidding the account
sudo dscl . -create /Users/$adminName IsHidden 1

exit 0