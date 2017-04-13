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
    # Copy back the original file
    cp -f /etc/network/interfaces_orig /etc/network/interfaces
    apt-get remove --purge -y hostapd dnsmasq
    apt-get autoremove -y
    shutdown -r now
}


function setup() {
# Setup hostapd and dnsmasq and configure the
# /etc/network/interfaces file

#apt-get update && apt-get upgrade -y
apt-get install -y hostapd dnsmasq

# If this is the first time, copy the original interface file
cp -n /etc/network/interfaces /etc/network/interfaces_orig

# As this script was originally a switch, the services are 
# disabled by default.
systemctl disable hostapd
systemctl disable dnsmasq

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
# Leave the black spaces for clarity
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


function WPA_details() {
# This is only required if the WPA connection information
# was added into the /etc/network/intefaces file.
# NOTE: This requires modifying the network information!

sed -i -e '/iface wlan0 inet dhcp/s/^/#/' /etc/network/interfaces
sed -i -e '/wpa-ssid /s/^/#/' /etc/network/interfaces
sed -i -e '/wpa-psk /s/^/#/' /etc/network/interfaces

cat >> /etc/wpa_supplicant/wpa_supplicant.conf << EOF
network={
        ssid="mySSID"
        psk="Router Password"
        key_mgmt=WPA-PSK
}
EOF
}


function systemd_script() {
# Create a script to start the wlan on a specified IP
# NOTE: This requires modifying the ssids below!

cat > /usr/bin/autohotspot << EOF
#!/bin/bash
#
#Wifi config - if no prefered Wifi generate a hotspot
#enter required ssids: ssids=('ssid1' 'ssid2')
ssids=('mySSID1' 'mySSID2')
#Main script
createAdHocNetwork()
{
    ip link set dev wlan0 down
    ip a add 10.0.0.5/24 dev wlan0
    ip link set dev wlan0 up
    service dnsmasq start
    service hostapd start
}
connected=false
for ssid in "${ssids[@]}"
do
    if iw dev wlan0 scan ap-force | grep $ssid > /dev/null
    then
        wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null 2>&1
        if dhclient -1 wlan0
        then
            connected=true
            break
        else
            wpa_cli terminate
            break
        fi
    else
        echo "Not in range, WiFi with SSID:" $ssid
    fi
done
if ! $connected; then
    createAdHocNetwork
fi
EOF

chmod 755 /usr/bin/autohotspot

# Add a service file to systemd
cat > /etc/systemd/system/autohotspot.service << EOF
[Unit]
Description=Generates a non-internet Hotspot for ssh when a listed ssid is not in range.
After=network-online.target
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/autohotspot
[Install]
WantedBy=multi-user.target
EOF

systemctl enable autohotspot.service

}


#purgeExistingSoftware
setup
#WPA_details
systemd_script
