#!/bin/bash


if [ ! -f /tmp/status_ip  ]; then
echo 0 > /tmp/status_ip
fi

if [ $(cat /tmp/status_ip) -eq 1 ]; then
 echo 0 > /tmp/status_ip
else
 echo 1 > /tmp/status_ip
fi
