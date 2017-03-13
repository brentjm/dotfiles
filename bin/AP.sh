#!/bin/bash
#Usage:
#$sudo AP.sh


function setup() {
# Setup hostapd and dnsmasq

apt-get install -y hostapd dnsmasq

# Interface is configured by dhcpcd by default and we want it done in network interfaces.
cat >> /etc/dhcpcd.conf << EOF
denyinterfaces wlan0
EOF

sed -i -e 's/iface eth0 inet manual/iface eth0 inet dhcp/' /etc/network/interfaces

# wlan0 should be static instead of manual
sed -i -e 's/iface wlan0 inet manual/iface wlan0 inet static/' /etc/network/interfaces

# Add the new network configuration for wlan0
sed -i -e '/iface wlan0 inet/a\\taddress 172.24.1.1\n\tnetmask 255.255.255.0\n\tnetwork 172.24.1.0\n\tbroadcast 172.24.1.255' /etc/network/interfaces

# Do not use wpa_supplicant
sed -i -e '/wpa_supplicant/s/^/#/' /etc/network/interfaces

# For some reason the network/interfaces references wlan1, so comment them out.
sed -i -e '/wlan1/s/^/#/' /etc/network/interfaces

# Restart the dhcp server and re-bring up the interface.
service dhcpcd restart
ifdown wlan0
ifup wlan0

# Configure hostapd.conf
# This file clearly is picky.
cat > /etc/hostapd/hostapd.conf << EOF
# This is the name of the WiFi interface we configured above
interface=wlan0

# Use the nl80211 driver with the brcmfmac driver. May still see error messages
# about brcmfmac in the system log.
driver=nl80211

# This is the name of the network
ssid=Pi3-AP

# Use the 2.4GHz band
hw_mode=g

# Use channel 6
channel=6

# Enable 802.11n
ieee80211n=1

# Enable WMM
wmm_enabled=1

# Enable 40MHz channels with 20ns guard interval
ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]

# Accept all MAC addresses
macaddr_acl=0

# Use WPA authentication
auth_algs=1

# Require clients to know the network name
ignore_broadcast_ssid=0

# Use WPA2
wpa=2

# Use a pre-shared key
wpa_key_mgmt=WPA-PSK

# The network passphrase
wpa_passphrase=raspberry

# Use AES, instead of TKIP
rsn_pairwise=CCMP
EOF

# Let the hosapd daemon know where the configuration file is.
sed -i -e 's/#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/' /etc/default/hostapd

# Make a new version of the dnsmasq configuration.
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

cat > /etc/dnsmasq.conf << EOF
interface=wlan0      # Use interface wlan0  
listen-address=172.24.1.1 # Explicitly specify the address to listen on  
bind-interfaces      # Bind to the interface to make sure we aren't sending things elsewhere  
server=8.8.8.8       # Forward DNS requests to Google DNS  
domain-needed        # Don't forward short names  
bogus-priv           # Never forward addresses in the non-routed address spaces.  
dhcp-range=172.24.1.50,172.24.1.150,12h # Assign IP addresses between 172.24.1.50 and 172.24.1.150 with a 12 hour lease time  
EOF
}


function NATtables() {
# Sets up packet forwarding from
# eth0 <---> wlan0

# Remove the comment in sysctl for IP4 forwarding
sed -i -e 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf

# This will make the changes to the running OS for forwarding
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

# Setup the NAT eth0 <---> wlan0
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  
iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT  
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT  

# Save the NAT rules.
sh -c "iptables-save > /etc/iptables.ipv4.nat"

# Call the new rules upon reboot.
sed -i -e '/exit 0/ i iptables-restore < \/etc\/iptables.ipv4.nat' /etc/rc.local

# Start the daemons.
service hostapd start
service dnsmasq start

# reboot
shutdown -r now
}


function removeNAT() {
# Removes the NAT rules
# Comment out in sysctl to stop IP4 forwarding
sed -i -e 's/net.ipv4.ip_forward=1/#net.ipv4.ip_forward=1/' /etc/sysctl.conf

# This will make the changes to the running OS for forwarding
sh -c "echo 0 > /proc/sys/net/ipv4/ip_forward"

# Flush the NAT tables
iptables -F

# Save the NAT rules.
sh -c "iptables-save > /etc/iptables.ipv4.nat"
}


setup
NATtables
#removeNAT
