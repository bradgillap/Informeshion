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
    echo "Not logged in as root, using sudo"
fi


####### SET STATIC IP ########

WLANIP=$(whiptail --no-button "Quit" --inputbox "Set a unique static IP address for each mesh node. Example node1 = 192.168.1.1 , node2=192.168.1.2 etc. " 15 50 192.168.1.1 --title "Wireless Static IP" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "User selected Ok and entered " $WLANIP #Capture and use on configuration step
    echo $WLANIP
else
    echo "User selected Exit at set IP"
    exit 1
fi

echo "(Exit status was $exitstatus)"



####### SET STATIC SUBNET MASK ########

SUBNETMASK=$(whiptail --no-button "Quit" --inputbox "Set a subnet mask. Usually 255.255.255.0 " 15 50 255.255.255.0 --title "Wireless Static Subnet Mask" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "User selected Ok and entered " $SUBNETMASK #Capture and use on configuration step
    echo $SUBNETMASK
else
    echo "User selected Exit at set SUBNET MASK" #needs to exit completely
    exit 1
fi

####### SET STATIC BROADCAST ADDRESS ########

BROADCAST=$(whiptail --no-button "Quit" --inputbox "Set a broadcast address. Usually 255.255.255.255 " 15 50 255.255.255.255 --title "Wireless Static Broadcast" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "User selected Ok and entered " $BROADCAST #Capture and use on configuration step
    echo $BROADCAST
else
    echo "User selected Exit at set BROADCAST"
    exit 1
fi

echo "(Exit status was $exitstatus)"



######## UPDATE RASPBIAN #######

if (whiptail --title "Update Raspbian" --yes-button "Update" --no-button "Skip"  --yesno "We must update packages repos and packages before we begin." 15 50 ) then

	$SUDO apt-get update
	$SUDO apt-get upgrade -y
else
	echo "Skipped apt-get update $?"
fi

####### Configure PI RASP-CONFIG #######
if (whiptail --title "Run Raspi-Config?" --no-button "Skip" --yesno "Do you need to run Raspi-Config to expand your SDCard size? \n \n Current Partition size is: \n \n $space"  15 50 ) then
	echo "Exiting autoinstall.sh and starting raspi-config $?."
	$SUDO raspi-config
else
   echo "Skipped raspi-config $?."
fi

###### INSTALL PACKAGES ######

if (whiptail --title "Install Needed Packages?" --yesno "We will now install the required packages. Continue?"  15 50 ) then

	$SUDO apt-get install dnsutils dnsmasq olsrd olsrd-plugins -y #

else
    echo "User quit at package install. $?."
    exit 1
fi

if (whiptail --title "Continue Configuring Services?" --no-button "Quit" --yesno "We will now configure your services, Continue?" 15 50 ) then

#dnsmasq.conf
	$SUDO sed -i 's/#interface=/interface=wlan0/g' /etc/dnsmasq.conf
	$SUDO sed -i 's/#dhcp-range=192.168.0.50,192.168.0.150,12h/dhcp-range=192.168.0.10,192.168.0.254,1h/g' /etc/dnsmasq.conf
	$SUDO sed -i 's,#address=/double-click.net/127.0.0.1,address=/#/192.168.0.1,g' /etc/dnsmasq.conf  #Had use different delimiters because of slashes in line.
#restart services
	$SUDO service dnsmasq restart

else

	echo "User quit at configuration CONFIGURE SERVICES $?."
    exit 1
fi

# NEXT TODO: Figure out configuration options for dnsmasq and olcr mesh stuff 
#END OF FILE

