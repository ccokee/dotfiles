#!/bin/bash

if [ "$(rc-service openvpn status | awk '{print $3}')" == "stopped" ]
then
 rc-service openvpn.cKmtn start
else
 rc-service openvpn.cKmtn stop
fi
