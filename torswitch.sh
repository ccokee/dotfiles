#!/bin/bash

if [ "$(rc-service tor status | awk '{print $3}')" == "stopped" ]
then
 rc-service tor start
 sleep 2
 rc-service openvpn.cKmtnTOR start
else
 rc-service tor stop
 rc-service openvpn.cKmtnTOR stop
fi
