#!/bin/bash

if [ ! -e /tmp/status_audio ]; then
 echo "1" > /tmp/status_audio
fi

case $(cat /tmp/status_audio) in
 1)
amixer -c 0 sset Master unmute
amixer -c 0 sset Speaker mute
amixer -c 0 sset Headphone unmute
 echo "2" > /tmp/status_audio
;;
 2)
amixer -c 0 sset Headphone mute
amixer -c 0 sset Speaker unmute
 echo "3" > /tmp/status_audio
;;
 3)
amixer -c 0 sset Headphone unmute
amixer -c 0 sset Speaker unmute
 echo "4" > /tmp/status_audio
;;
 4)
amixer -c 0 sset Master mute
 echo "1" > /tmp/status_audio
esac
