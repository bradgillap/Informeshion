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

if (whiptail --title "Update Raspbian" --yes-button "Update" --no-button "Skip"  --yesno "We must update packages repos and packages before we begin." 20 90 ) then

	$SUDO apt-get update
	$SUDO apt-get upgrade -y
else
	echo "Skipped apt-get update $?"
fi

####### Configure PI RASP-CONFIG #######
if (whiptail --title "Run Raspi-Config?" --no-button "Skip" --yesno "Do you need to run Raspi-Config to expand your SDCard size? \n \n Current Partition size is: \n \n $space"  20 90 ) then
	echo "Yes $?."
	$SUDO raspi-config
else
   echo "Skipped raspi-config $?."
fi

###### INSTALL PACKAGES ######

if (whiptail --title "Install Needed Packages?" --yesno "We will now install the required packages. Continue?"  20 90 ) then

	$SUDO apt-get install dnsutils dnsmasq olsrd olsrd-plugins -y #

else
   #Need a gotoexit or don't continue configuring
   echo "User quit at package install. $?."
fi

if (whiptail --title "Continue Configuring Services?" --yesno "We will not configure your services, Continue?" 20 90 ) then

#dnsmasq.conf
	$SUDO sed -i 's/#interface=/interface=wlan0/g' /etc/dnsmasq.conf

else

	echo "User quit at configuration stage. $?."
fi

# NEXT TODO: Figure out configuration options for hostapd and dhcp server. Script bash to modify the proper lines in those config files. 
#END OF FILE

