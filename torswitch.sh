#!/bin/bash

if [ "$(rc-service tor status | awk '{print $3}')" == "stopped" ]
then
 rc-service tor start
else
 rc-service tor stop
fi
