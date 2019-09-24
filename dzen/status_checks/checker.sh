#!/bin/bash

# ----------------
# Initial check
# ----------------
(
~/.xmonad/dzen/status_checks/status_mayhem.sh
~/.xmonad/dzen/status_checks/status_storage.sh
~/.xmonad/dzen/status_checks/status_dropbox.sh
~/.xmonad/dzen/status_checks/status_weather.sh
) &

~/.xmonad/dzen/status_checks/status_checker.sh &

#===
(while :; do

~/.xmonad/dzen/status_checks/status_weather.sh &

sleep 5m; done ) &
#===
(while :; do

~/.xmonad/dzen/status_checks/status_mayhem.sh &

sleep 5m; done ) &

#===

#===
(while :; do

~/.xmonad/dzen/status_checks/status_dropbox.sh &
~/.xmonad/dzen/status_checks/status_storage.sh &

sleep 1s; done ) &
