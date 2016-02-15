#! /bin/bash

## Time for a rewrite
## Two menu tracks this time. One beginner and one advanced

## INITIALIZE VARIABLES ##
 SPACE=$(df -H /)
 INSTPACKAGES=""


## ROOT CHECK ## 
# Are we root? If not use sudo
SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
    echo "Not logged in as root, using sudo"
fi

## INTERNET CHECK ##

wget -q --spider http://google.com

if [ $? -eq 0 ]; then
    echo "Okay we are connected to the Internet. Let's proceed"
else
    echo "Plase connect to the Internet with cable and try running again"
    exit 1
fi



## ADV SOFTWARE INSTALL ##
INSTPACKAGES=$(whiptail --title "Advanced - Choose Packages" --checklist \
"Choose packages to install. Required packages are already selected." 15 60 4 \
"batctl" "Configure mesh layer 2 protocol." ON \
"dnsutils" "Includes DNS query tools like dig." ON \
"dnsmasq" "DHCP and DNS server in one package." OFF 3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Installing selected packagese"
    INSTPACKAGES=$(echo "$INSTPACKAGES" | tr -d '"') #Removed double quotes from selection output.
    $SUDO apt-get install $INSTPACKAGES

else
    echo "You chose Cancel."
fi

