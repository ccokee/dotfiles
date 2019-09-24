#!/bin/bash

coproc bluetoothctl
sleep 1
echo -e 'connect 00:22:A6:1A:20:69\nexit' >&${COPROC[1]}
