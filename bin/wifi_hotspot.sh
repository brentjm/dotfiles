#!/bin/bash
# Usage:
# $sudo ./wifi_hotspot.sh

# Script to setup a wifi hotspot for Raspberry Pi
# Set the SSID and and WPA_Passphrase in function configureHostapd below.
# Select one of the DHCP server installation/configuration functions.
    # Comparison: https://en.wikipedia.org/wiki/Comparison_of_DHCP_server_software
    # useDNSMasq
    # useIscDhcpServer
    # useUDHCP
# usage
#$sudo ./wifi_hotspot.sh


function purgeExistingSoftware() {
    # Remove any possible conflicting software.
    rm -fr /etc/hostapd
    rm -f /etc/systemd/system/hostapd.service
    rm -f /etc/dnsmasq.conf 
    rm -f /etc/default/isc_dhcp_server
    rm -f /etc/udhcpd.conf 
    cp -f /etc/network/interfaces /etc/network/interfaces_old
    apt-get remove --purge -y hostapd dnsmasq isc-dhcp-server udhcpd
    apt-get autoremove -y

    ifdown wlan0
}


function installConfigureHostapd() {
    # hostapd is the access point daemon
    # https://w1.fi/hostapd/
    apt-get install -y hostapd

    # Configure hostapd. This is done regardless of the DHCP server.
#    cat > /etc/systemd/system/hostapd.service <<EOF
#[Unit]
#Description=Hostapd IEEE 802.11 Access Point
#After=sys-subsystem-net-devices-wlan0.device
#BindsTo=sys-subsystem-net-devices-wlan0.device
#
#[Service]
#Type=forking
#PIDFile=/var/run/hostapd.pid
#ExecStart=/usr/sbin/hostapd -B /etc/hostapd/hostapd.conf -P /var/run/hostapd.pid
#
#[Install]
#WantedBy=multi-user.target
#EOF

    # See https://w1.fi/cgit/hostap/plain/hostapd/hostapd.conf
    cat > /etc/hostapd/hostapd.conf <<EOF
interface=wlan0
driver=nl80211
#driver=rtl871xdrv
ssid=RPi
hw_mode=g
channel=6
auth_algs=1
macaddr_acl=0
ignore_broadcast_ssid=0
wpa=2
wpa_key_mgmt=WPA-PSK
#wpa_pairwise=CCMP
#rsn_pairwise=CCMP
wpa_passphrase=RPiPasswd
#wpa_group_rekey=86400
ieee80211n=1
#wme_enabled=1
wmm_enabled=1
#ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]
#country_code=US
EOF

    sed -i -e 's/^#*DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/' /etc/default/hostapd
    sed -i -e 's/DAEMON_CONF=/DAEMON_CONF=\/etc\/hostapd\/hostapd.conf/' /etc/init.d/hostapd
}


function configureInterfaces() {
    # Configure the network interface
    sed -i -e '/^allow-hotplug wlan0/d' /etc/network/interfaces
    sed -i -e '/iface wlan0 inet manual/d' /etc/network/interfaces
    sed -i -e '/wpa_supplicant/d' /etc/network/interfaces

    # Do we want this?
    #wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
    cat >> /etc/network/interfaces <<EOF

allow-hotplug wlan0
  iface wlan0 inet static
  address 10.0.0.1
  netmask 255.255.255.0
  network 10.0.0.0
  broadcast 10.0.0.255
  # Gateway 
EOF
}

function useDNSMasq() {
    # Call this function to install and configure dnsmasq
    # https://en.wikipedia.org/wiki/Dnsmasq
    apt-get install -y dnsmasq
    cat > /etc/dnsmasq.conf <<EOF
# The following two come from 
# http://www.techrepublic.com/blog/linux-and-open-source/using-dnsmasq-for-dns-and-dhcp-services/
# expand-hosts # Maybe
# domain=sensor.com # 

interface=wlan0
dhcp-range=10.0.0.2,10.0.0.5,255.255.255.0,12h
EOF

    # Linux changed how the network is configured.
    # Need to shut off dhcp.
    echo "denyinterfaces wlan0" >> /etc/dhcpcd.conf
}

function useIscDhcpServer() {
    # https://help.ubuntu.com/community/isc-dhcp-server
    apt-get install -y isc-dhcp-server

    sed -i -e 's/^option domain-name "example.org"/#option domain-name "example.org"/' /etc/dhcp/dhcpd.conf
    sed -i -e 's/^option domain-name-server/#option domain-name-server/' /etc/dhcp/dhcpd.conf
    sed -i -e 's/^#authoritative/authoritative/' /etc/dhcp/dhcpd.conf

    # This is questionable for the last line below.
    #option domain-name-servers 8.8.8.8, 8.8.4.4;
    cat >> /etc/dhcp/dhcpd.conf <<EOF
subnet 10.0.0.0 netmask 255.255.255.0 {
  range 10.0.0.2 10.0.05;
  option routers 10.0.0.1;
  option broadcast-address 10.0.0.255;
  default-lease-time 600;
  max-lease-time 7200;
  option domain-name "local";
}
EOF

    sed -i -e 's/^#INTERFACES=/INTERFACES="wlan0"/' /etc/default/isc_dhcp_server
    # Do I need these two lines?
    sed -i -e 's/^#DHCPD_CONF=/DHCPD_CONF=\/etc\/dhcp\/dhcpd.conf/' /etc/default/isc_dhcp_server
    sed -i -e 's/^#DHCPD_PID=/DHCPD_PID=\/var\/run\/dhcpd.pid/' /etc/default/isc_dhcp_server

    ifconfig wlan0 10.0.0.1
}


function useUDHCP() {
    # https://udhcp.busybox.net/
    apt-get install -y udhcpd

    # TODO check if this file contains other information.
    cat >> /etc/udhcpd.conf <<EOF
start 192.168.42.2 # This is the range of IPs that the hostspot will give to client devices.
end 192.168.42.20
interface wlan0 # The device uDHCP listens on.
remaining yes
opt dns 8.8.8.8 4.2.2.2 # The DNS servers client devices will use.
opt subnet 255.255.255.0
opt router 192.168.42.1 # The Pi's IP address on wlan0 which we will set up shortly.
opt lease 864000 # 10 day DHCP lease time in seconds
EOF

    sed -i -e 's/^DHCPD_ENABLED="no"/#DHCPD_ENABLED="no"/g' /etc/default/udhcpd

    ifconfig wlan0 10.0.0.1
}


function systemServices() {
    # Start the service
    service hostapd start

    # Do we do this?
    #systemctl enable hostapd

    # Depending if isc-dhcp-server was used
    service isc-dhcp-server start
}


function removeWPASupplicant() {
    # Remove the WPA supplicant service 
    # May be needed for only certain distros.
    mv /usr/share/dbus-1/system-services/fi.epitest.hostap.WPASupplicant.service ~/Downloads/.
}


function NATForwarding() { 
    # This will configure the NAT to forward packets # eth0 <--> wlan0
    # Only do this if the computer will be plugged into an ethernet 
    apt-get install -y iptables-persistent
    sed -i -e 's/#net.ipv4.ip_forward/net.ipv4.ip_forward/g' /etc/sysctl.conf
    sed -i -e 's/net.ipv4.ip_forward=0/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
    
    echo 1 > /proc/sys/net/ipv4/ip_forward

    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

    # Check the following
    iptables-save > /etc/iptables/rules.v4
    #sh -c "iptables-save > /etc/iptables.ipv4.nat"
    #echo "iptables-restore < /etc/iptables.ipv4.nat" > /lib/dhcpcd/dhcpcd-hooks/70-ipv4-nat
}


purgeExistingSoftware
installConfigureHostapd
#configureInterfaces
#useDNSMasq
useIscDhcpServer
#useUDHCP
#systemServices
#NATForwarding
#removeWPASupplicant
