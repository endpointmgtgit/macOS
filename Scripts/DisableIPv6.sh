#!/usr/bin/env bash
#set -x

############################################################################################
##
## Script to disable IPv6 for all Network Adapters
##
###########################################

##
## Notes
##
## This script looks for all network interfaces and disables IPv6

# Define variables

scriptname="DisableIPv6"
logandmetadir="/Library/Logs/Microsoft/Intune/Scripts/$scriptname"
log="$logandmetadir/$scriptname.log"

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

echo " $(date) | Disabling IPv6 for Network Interfaces"
NetworkInterfaces=$(sudo networksetup -listallnetworkservices)

if [[ $NetworkInterfaces == *"Ethernet"* ]]; then
  echo " $(date) | Disabling IPv6 for Ethernet"
  sudo networksetup -setv6off Ethernet
else
  echo " $(date) | No Ethernet Adapter"
fi

if [[ $NetworkInterfaces == *"Wi-Fi"* ]]; then
  echo " $(date) | Disabling IPv6 for Wi-Fi"
  sudo networksetup -setv6off Wi-Fi
else
  echo " $(date) | No Wi-Fi Adapter"
fi
