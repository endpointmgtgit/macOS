#!/usr/bin/env bash
#set -x

############################################################################################
##
## Script to create Local Admin Account for IT Use
##
###########################################

# Define variables

adminaccountname="ictadmin"       # This is the accountname of the new admin
adminaccountfullname="ictadmin"  # This is the full name of the new admin user
scriptname="Create Local Admin Account"
logandmetadir="/Library/IntuneScripts/createLocalAdminAccount"
password="passwordhere"
log="$logandmetadir/createLocalAdminAccount.log"

# function to delay until the user has finished setup assistant.
waitforSetupAssistant () {
  until [[ -f /var/db/.AppleSetupDone ]]; do
    delay=$(( $RANDOM % 50 + 10 ))
    echo "$(date) |  + Setup Assistant not done, waiting [$delay] seconds"
    sleep $delay
  done
  echo "$(date) | Setup Assistant is done, lets carry on"
}

## Check if the log directory has been created and start logging
if [ -d $logandmetadir ]; then
    ## Already created
    echo "# $(date) | Log directory already exists - $logandmetadir"
else
    ## Creating Metadirectory
    echo "# $(date) | creating log directory - $logandmetadir"
    mkdir -p $logandmetadir
fi


# start logging
exec 1>> $log 2>&1

# Begin Script Body

echo ""
echo "##############################################################"
echo "# $(date) | Starting $scriptname"
echo "############################################################"
echo ""

echo "Creating new local admin account [$adminaccountname]"
#p=`system_profiler SPHardwareDataType | awk '/Serial/ {print $4}' | tr '[A-Z]' '[K-ZA-J]' | tr 0-9 4-90-3 | base64`

waitforSetupAssistant
echo "Adding $adminaccountname to hidden users list"
#sudo defaults write /Library/Preferences/com.apple.loginwindow HiddenUsersList -array-add "$adminaccountname"
#sudo sysadminctl -deleteUser "$adminaccountname" # Remove existing admin account if it exists
#sudo sysadminctl -adminUser "$adminaccountname" -adminPassword "$p" -addUser "$adminaccountname" -fullName "$adminaccountfullname" -password "$p" -admin


dscl . -create /Users/$adminaccountname
dscl . -create /Users/$adminaccountname UserShell /bin/bash
dscl . -create /Users/$adminaccountname RealName $adminaccountfullname
dscl . -create /Users/$adminaccountname UniqueID "2001"
dscl . -create /Users/$adminaccountname PrimaryGroupID 20
dscl . -create /Users/$adminaccountname NFSHomeDirectory /Users/$adminaccountname
dscl . -passwd /Users/$adminaccountname $password
dscl . -append /Groups/admin GroupMembership $adminaccountname