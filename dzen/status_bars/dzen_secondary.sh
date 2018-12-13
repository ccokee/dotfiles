#!/bin/bash

#=== Variables ===#
icon_path="$HOME/.xmonad/dzen/icons"

cblue="^fg(#92bbd0)"
cgray="^fg(#999999)"
cwhite="^fg(#ffffff)"
cnormal="^fg(#dddddd)"
cred="^fg(#bc4547)"
cyellow="^fg(#a88c29)"
cgreen="^fg(#00aa6c)"
cpurple="^fg(#9542f4)"
cnormal="^fg(#dddddd)"

dropbox_icon="^i($icon_path/dropbox.xbm)"
net_balance_icon="wired.xbm"
packages_icon="pacman.xbm"
rss_icon="dish.xbm"
mail_icon="mail.xbm"
weather_icon="temp.xbm"
netstorage_icon="^i($icon_path/networkstorage.xbm)"
usb_icon="^i($icon_path/usb2.xbm)"
bluetooth_icon="^i($icon_path/bluetooth.xbm)"

date_icon="^i($icon_path/date.xbm)"
clock_icon="^i($icon_path/clock.xbm)"

#=== Loop ===#
while :; do

#storage
if [ -f /tmp/status_storage ]; then
 for i in {1..5}
 do
 storage="$storage$(awk -v a="$i" '{print $a}' /tmp/status_storage)$netstorage_icon "
 done
 storage="$storage$(awk '{print $6}' /tmp/status_storage)$usb_icon"
fi

if [ -f /tmp/status_dropbox ]; then
dropbox="${cgreen}${dropbox_icon}${cgray}"
else
dropbox="${cred}${dropbox_icon}${cgray}"
fi

#bluetooth
if [ $(rc-service bluetooth status | awk '{print $3}') == "started" ]; then
bluetoo="${cblue}^ca(1,blueman-manager)${bluetooth_icon}^ca()${cgray}"
else
bluetoo="${cred}${bluetooth_icon}${cgray}"
fi

#weather
if [ -f /tmp/status_weather ]; then
weather="$(echo $(cat /tmp/status_weather))"
fi

#date
date="${cgreen}${date_icon} ${cnormal}$(date +%d) de $(date +%B)"

#clock
clock="${cgreen}${clock_icon} ${cnormal}$(date +%H:%M)"

echo "$storage $dropbox  $bluetoo  $weather $date $clock"

storage=""

sleep 1; done
