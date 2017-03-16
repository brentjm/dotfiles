#!/bin/bash
# Creates a WiFi signal that other devices can attach, but the host computer
#does not need to be connected to the internet. Consequently, the connected
#computers will be connected with no internet.
# Acknowlegements:
# http://www.raspberryconnect.com/network/item/315-rpi3-auto-wifi-hotspot-if-no-internet
#Usage:
#$sudo AP.sh


function purgeExistingSoftware() {
    # Remove any possible conflicting software.
    rm -fr /etc/hostapd
    rm -f /etc/systemd/system/hostapd.service
    rm -f /etc/dnsmasq.conf 
    cp -f /etc/network/interfaces /etc/network/interfaces_old
    apt-get remove --purge -y hostapd dnsmasq isc-dhcp-server udhcpd
    apt-get autoremove -y

    ifdown wlan0
}


function setup() {
# Setup hostapd and dnsmasq
apt-get update && apt-get upgrade -y
apt-get install -y hostapd dnsmasq

# TODO Should we use this?
# Interface is configured by dhcpcd by default and we want it done 
# in network interfaces.
cat >> /etc/dhcpcd.conf << EOF
denyinterfaces wlan0
EOF

# Configure hostapd.conf
# This file clearly is picky.
cat > /etc/hostapd/hostapd.conf << EOF
interface=wlan0
driver=nl80211
ssid=RPI3hot
hw_mode=g
channel=6
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=1234567890
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF

# Let the hosapd daemon know where the configuration file is.
sed -i -e 's/#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/' /etc/default/hostapd

# Append some additional configurations to dnsmasq.
cat >> /etc/dnsmasq.conf << EOF
#Pi3Hotspot Config
#stop DNSmasq from using resolv.conf
no-resolv
#Interface to use
interface=wlan0
bind-interfaces
dhcp-range=10.0.0.3,10.0.0.20,12h
EOF

# Configure /etc/network/interfaces
sed -i -e 's/auto lo/auto lo wlan0/' /etc/network/interfaces
sed -i -e '/wpa_supplicant/s/^/#/' /etc/network/interfaces
}


function createAdHocNetwork() {
    ip link set dev wlan0 down
    ip a add 10.0.0.5/24 dev wlan0
    ip link set dev wlan0 up
    service dnsmasq start
    service hostapd start
}

setup
#createAdHocNetwork
