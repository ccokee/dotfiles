#!/bin/bash

if [ "$(rc-service hostapd status | awk '{print $3}' )" == "stopped" ]; then
echo 1 > /tmp/hostapdswitch
#ip addr add 10.0.8.1/24 dev enp1s0
rc-service hostapd start
else
echo 0 > /tmp/hostapdswitch
#ip addr del 10.0.8.1/24 dev enp1s0
rc-service hostapd stop
fi
