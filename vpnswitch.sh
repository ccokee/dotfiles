#!/bin/bash

if [ "$(rc-service openvpn status | awk '{print $3}')" == "stopped" ]
then
 rc-service openvpn start
else
 rc-service openvpn stop
fi
