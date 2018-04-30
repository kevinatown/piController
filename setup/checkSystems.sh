#!/bin/bash

# this scipt should be added to /etc/rc.local to run on each set up

which dnsmasq 1>/dev/null 
if [ $? == 0 ]; then
  echo "dnsmasq is installed" 
else
  echo "dnsmasq is not installed, installing it and hostapd now"
  source /piController/setup/wifiSetup.sh
fi

pip show gopigo 1>/dev/null 
if [ $? == 0 ]; then
  echo "gopigo is installed" 
else
  echo "gopigo is not installed, installing it and hostapd now"
  source /piController/setup/gpg.sh
fi

# ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` 1>/dev/null
grep 'wifi' /continue.conf 1>/dev/null
if [ $? == 0 ]; then
  echo "connected to the internet"
  systemctl stop hostapd
  systemctl stop dnsmasq

  ifdown wlan0 && ifup wlan0
  wpa_cli -i wlan0 reconfigure
else
  echo "not connected to the internet"
  echo "Starting hotspot"
  cp /piController/configs/interfaces.hotspot /etc/network/interfaces
  systemctl start hostapd
  systemctl start dnsmasq
  # systemctl restart networking
  ifdown wlan0 && ifup wlan0
  # wpa_cli -i wlan0 reconfigure

  echo "Running the piController app"
  /piController/piController/main.py
fi
