#! /bin/bash

## Time for a rewrite
## Two menu tracks this time. One beginner and one advanced

## INITIALIZE VARIABLES ##
 exitstatus=""
## MENU VARIABLES
 MAINSEL=""
 PKGSEL=""
 ADVSEL=""

## ROOT CHECK ## 
# Are we root? If not use sudo
if [[ $EUID -eq 0 ]];then
    echo "You are root."
else
    echo "Sudo will be used for the install."
    # Check if it is actually installed
    # If it isn't, exit because the install cannot complete
    if [[ $(dpkg-query -s sudo) ]];then
        export SUDO="sudo"
    else
        echo "Please install sudo or run this as root."
        exit 1
    fi
fi

## FUNCTIONS ##

    ## INTERNET CHECK##

function internetCheck() {
    wget -q --spider http://google.com

    if [ $? -eq 0 ]; then
        echo "Okay we are connected to the Internet. Let's proceed"
    else
        echo "Plase connect to the Internet with cable and try running again"
        exit 1
    fi

    ## CHECK FREE DISK SPACE ##
}
function verifyFreeDiskSpace() {
    # Figure out minimum space required. Currently set at 25MB, thanks pi-hole.
    requiredFreeBytes=25600
    existingFreeBytes=`df -lkP / | awk '{print $4}' | tail -1`

    if [[ $existingFreeBytes -lt $requiredFreeBytes ]]; then
        whiptail --msgbox --backtitle "Insufficient Disk Space" --title "Insufficient Disk Space" "\nYour system appears to be low on disk space. Informeshion recomends a minimum of $requiredFreeBytes Bytes.\nYou only have $existingFreeBytes Free.\n\nIf this is a new install you may need to expand your disk.\n\nTry running:\n    'sudo raspi-config'\nChoose the 'expand file system option'\n\nAfter rebooting, run this installation again."
        exit 1
    fi
}

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
    grep -q -F "batman-adv" /etc/modules ||  echo "batman-adv" | $SUDO tee -a /etc/modules #Add module to boot only if not in /etc/modules 

}

function AdvancedMenu() {
    ADVSEL=$(whiptail --title "Advanced Menu" --menu "Choose an option" 15 60 4 \
        "1" "Choose Packages to Install" \
        "2" "Configure Services" \
        "3" "Back" 3>&1 1>&2 2>&3)
    case $ADVSEL in
        1)
            echo "User selected Package install."
            AdvancedInstall
        ;;
        2)
            echo "User selected Configure Services."
            ConfigureServices
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

function ConfigureServices() {
    if (whiptail --title "Configure Services" --yesno "This will configure the following. Enable batman kernel extension on boot." 15 60) then
        echo "User selected Yes, exit status $?."
        grep -q -F "batman-adv" /etc/modules ||  echo "batman-adv" | $SUDO tee -a /etc/modules #Add module to boot only if not in /etc/modules
        AdvancedMenu
    else
        echo "User selected no, exit status $?."
        AdvancedMenu
    fi
}

internetCheck
verifyFreeDiskSpace
MainMenu
