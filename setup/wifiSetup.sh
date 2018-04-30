#!/bin/bash

apt-get update
apt-get upgrade

apt-get install dnsmasq hostapd

systemctl stop dnsmasq
systemctl stop hostapd

mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
touch /etc/dnsmasq.conf


# configure dnsmaq.conf
echo interface=wlan0 >> /etc/dnsmasq.conf
echo usually wlan0 >> /etc/dnsmasq.conf
echo '  dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h' >> /etc/dnsmasq.conf

# configure hostapd.conf
touch /etc/hostapd/hostapd.conf
echo interface=wlan0 >> /etc/hostapd/hostapd.conf
echo driver=nl80211 >> /etc/hostapd/hostapd.conf
echo "ssid=$(cat /etc/hostname)" >> /etc/hostapd/hostapd.conf
echo hw_mode=g >> /etc/hostapd/hostapd.conf
echo channel=7 >> /etc/hostapd/hostapd.conf
echo wmm_enabled=0 >> /etc/hostapd/hostapd.conf
echo macaddr_acl=0 >> /etc/hostapd/hostapd.conf
echo auth_algs=1 >> /etc/hostapd/hostapd.conf
echo ignore_broadcast_ssid=0 >> /etc/hostapd/hostapd.conf
echo wpa=2 >> /etc/hostapd/hostapd.conf
echo "wpa_passphrase=HelloIAm$(cat /etc/hostname)" >> /etc/hostapd/hostapd.conf
echo wpa_key_mgmt=WPA-PSK >> /etc/hostapd/hostapd.conf
echo wpa_pairwise=TKIP >> /etc/hostapd/hostapd.conf
echo rsn_pairwise=CCMP >> /etc/hostapd/hostapd.conf

echo DAEMON_CONF="/etc/hostapd/hostapd.conf" >> /etc/default/hostapd

# add alias
echo "192.168.4.1    $(cat /etc/hostname).pi" >> /etc/hosts

# fix net
echo "iface wlan0 inet static" >> /etc/network/interfaces
echo "addresss 192.168.4.1" >> /etc/network/interfaces
echo "netmask 255.255.255.0" >> /etc/network/interfaces
echo "broadcast 255.0.0.0" >> /etc/network/interfaces

systemctl start hostapd
systemctl start dnsmasq

# routing and masqurade
echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
iptables -t nat -A  POSTROUTING -o eth0 -j MASQUERADE
sh -c "iptables-save > /etc/iptables.ipv4.nat"

# add to /etc/rc.local
# iptables-restore < /etc/iptables.ipv4.nat
