#! /bin/bash

## Time for a rewrite
## Two menu tracks this time. One beginner and one advanced

## INITIALIZE VARIABLES ##
 SPACE=$(df -H /)
 exitstatus=""
## MENU VARIABLES
 INSTPACKAGES=""
 MAINSEL=""
 PKGSEL=""
 ADVSEL=""

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


## FUNCTIONS ##

function MainMenu() {
    MAINSEL=$(whiptail --title "Main Menu" --menu "Choose your option" 15 60 4 \
        "1" "Automatic Install" \
        "2" "Manual Install"  3>&1 1>&2 2>&3)

        case $MAINSEL in

            1)
                echo "User selected automatic install"
                SimpleInstall
            ;;
            2)
                echo "User selected advanced install"
                AdvancedMenu
            ;; 
        esac
}

function SimpleInstall() {
    $SUDO apt-get update && $SUDO apt-get upgrade -y
    $SUDO apt-get install batctl dnsutils dnsmasq -y
    $SUDO modprobe batman-adv
}

function AdvancedMenu() {
    ADVSEL=$(whiptail --title "Advanced Menu" --menu "Choose an option" 15 60 4 \
        "1" "Choose Packages to Install" \
        "2" "Something else" \
        "3" "Back" 3>&1 1>&2 2>&3)
    case $ADVSEL in
        1)
            echo "User selected Package install."
            AdvancedInstall
        ;;
        2)
            echo "User selected something else."
        ;;
        3)
            MainMenu
        ;;
    esac
}

function AdvancedInstall() {
    PKGSEL=$(whiptail --checklist --title "Select Packages" \
        "Choose packages to install." 15 60 4 \
        "batctl"   "Configure mesh layer 2 protocol." ON \
        "dnsutils" "Includes DNS query tools like dig." ON \
        "dnsmasq"  "DHCP and DNS server in one package." ON 3>&1 1>&2 2>&3)
    exitstatus=$?
        if [ $exitstatus = 0 ]; then
            echo "Installing selected packagese"
            PKGSEL=$(echo "$PKGSEL" | tr -d '"') #Removed double quotes from selection output.
            $SUDO apt-get install $PKGSEL
            whiptail --title "Package Install Complete" --msgbox "The installation is complete. Returning to Advanced Install Menu" 15 60
            AdvancedMenu
        else
            echo "You chose Cancel."
            MainMenu
        fi
}



#AdvancedInstall
MainMenu
