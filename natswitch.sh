#!/bin/bash

if [ "$(rc-service dnsmasq status | awk '{print $3}' )" == "stopped" ]; then
echo 1 > /tmp/natswitch
ip addr add 10.0.8.1/24 dev enp1s0
rc-service dnsmasq start
else
echo 0 > /tmp/natswitch
ip addr del 10.0.8.1/24 dev enp1s0
rc-service dnsmasq stop
fi
