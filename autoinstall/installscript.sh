#!/bin/bash

#######VARIABLES######

STR="Hello World!"
echo $STR

# This is a  substitution variable. It assigns the output of a command to a variable
# Shows disk space in whiptail window
space=$(df -H /)


####### ROOT CHECK ######
# Are we root? If not use sudo
SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi


######## UPDATE RASPBIAN #######

#$SUDO apt-get update
#$SUDO apt-get upgrade -y


####### Configure Pi? #######
if (whiptail --title "" --yesno "Do you need to run Raspi-Config to expand your SDCard size? If you choose yes, you will need to restart the process. \n \n Current Partition size is: \n \n $space"  20 90 ) then
   echo "Yes $?."
   $SUDO raspi-config
else
   echo "No $?."
fi


########INSTALL SOME STUFF #######

# hostapd turns wifi cards into accesspoints, isc-dhcp-server hosts dhcp, 

#$SUDO apt-get install hostapd isc-dhcp-server -y

# NEXT TODO: Figure out configuration options for hostapd and dhcp server. Script bash to modify the proper lines in those config files. 








#END OF FILE

