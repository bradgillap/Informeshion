#!/bin/sh
#
# /etc/NetworkManager/dispatcher.d/05-batman

ESSID="Informeshion"

#IFACE="wlan0"
#ADDR="xx:xx:xx:xx:xx:xx"

IFACE="wlp0s29f7u3"
ADDR="xx:xx:xx:xx:xx:xx"

#IFACE="wlp0s29f7u2"

IP6ADDR="2001:470:xx:xx:8::3/80"
IPADDR="10.0.0.5"
log="/tmp/batlog.txt"

function current {
    s=`nmcli -t -f GENERAL.CONNECTION d show $IFACE`
    echo "$s" >>$log
    echo "$s"| cut -d\: -f2
}

interface=$1
status=$2

if [ ! "$interface" == $IFACE ]; then
  exit 0
fi

case $status in
  up)
    if [ "$(current)" == "$ESSID" ]; then
      modprobe batman-adv
      batctl if add $IFACE
      batctl gw_mode client
      # Keep the same MAC address (optional)
      ip link set dev bat0 address $ADDR
      ip -6 addr add $IP6ADDR dev bat0
      ip  addr add $IPADDR dev bat0
      ip link set dev $IFACE mtu 1532 # 1500+32
      ip link set dev bat0 up
      # DHCP (optional)
      #dhclient -r
      #dhclient -H $(hostname) bat0
    fi
    ;;
  down)
    if [ ! "$(current)" == "$ESSID" ]; then
      dhclient -r
      ip link set dev bat0 down
      batctl if del $IFACE
    fi
    ;;
esac
