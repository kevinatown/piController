#!/bin/bash

oct1=`ifconfig | grep 'inet ' | awk '{print $2}' | tail -1 | tr "." " " | awk '{ print $1 }'`
oct2=`ifconfig | grep 'inet ' | awk '{print $2}' | tail -1 | tr "." " " | awk '{ print $2 }'`
oct3=`ifconfig | grep 'inet ' | awk '{print $2}' | tail -1 | tr "." " " | awk '{ print $3 }'`
iprange=$oct1.$oct2.$oct3.*

# if [ $oct1 == '10' ]; then
# 	iprange=10.0.0.0.0/8	
# elif [ $oct1 == '172' ]; then
# 	iprange=172.16.0.0/12
# elif [ $oct1 == '192' ]; then
# 	iprange=192.168.0.0/16
# else 
# 	netadd=`ifconfig | grep 'inet ' | awk '{print $2}' | tail -1`
# 	echo ''
# 	echo 'You have a weird local network addres, contact kevin for help.'
# 	echo 'your address is:'
# 	echo $netadd
# 	echo ''
# 	exit 1
# fi

echo ''
echo 'Trying to find raspberry pi. Currently searching'
echo $iprange
echo 'This may take some time.'
echo ''

piadd=`nmap -sn $iprange | grep 'raspberrypi' | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`

if ! [ -z $piadd ]; then
	fullIp='http://'+$piadd+':8090'
	echo ''
	echo 'Pi was found at:'
	echo $piadd
	echo ''
	echo 'Please go to '+$fullIp+' from a browser.'
	echo ''
	open -a /Applications/Google\ Chrome.app $fullIp
	exit 0
else
	echo ''
	echo 'Could not find the pi by name, trying something esle'
	echo ''
	possips=`nmap -sn $iprange | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
	echo ''
	echo 'Several Chrome windows will be opened, hopefully one is the pi'
	echo ''
	echo ''
	for x in $possips; do
		ip='http://'${x}':8090'
		echo trying $ip
		echo ''
		open -a /Applications/Google\ Chrome.app ${ip}
	done

	echo ''
	echo 'If no chrome windows showed the pi site then,'
	echo 'the Pi was not found on the network.'
	echo 'Ensure that both this computer and the pi are on the same netork.'
	echo 'Then rerun this script.'
	echo ''
	exit 1
fi
