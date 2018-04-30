#!/bin/bash

# this scipt should be added to /etc/rc.local to run on each set up

which dnsmasq 1>/dev/null 
if [ $? == 0 ]; then
  echo "dnsmasq is installed\n" 
else
  echo "dnsmasq is not installed, installing it and hostapd now\n"
  source /home/pi/piController/setup/wifiSetup.sh
fi

pip show gopigo 1>/dev/null 
if [ $? == 0 ]; then
  echo "gopigo is installed\n" 
else
  echo "gopigo is not installed, installing it and hostapd now\n"
  source /home/pi/piController/setup/gpg.sh
fi

# ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` 1>/dev/null

if [ $? == 0 ]; then
  echo "connected to the internet\n" 
else
  echo "not connected to the internet\n"
  echo "Starting hotspot"
  cp /home/pi/piController/configs/interfaces.hotspot /etc/network/interfaces
  systemctl start hostapd
  systemctl start dnsmasq
  # systemctl restart networking
  ifdown wlan0 && ifup wlan0

  echo "Running the piController app"
  /home/pi/piController/piController/main.py
fi
