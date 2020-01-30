#!/bin/bash

ssh coke@doctorbit.sytes.net -p 2202 -N -T -L 5900:localhost:5900 & 

while [ $(lsof -n -i :5900 | grep LISTEN | awk 'NR==1 {print $2}' | wc -l) != 1 ]
do
sleep 1
done

vncviewer localhost:5900 && kill -9 $(lsof -n -i :5900 | grep LISTEN | awk 'NR==1 {print $2}')
