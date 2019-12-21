#!/bin/bash

while ! wget -q --spider http://google.com
do
clear
echo "Waiting for connection"
sleep 0.5
clear
echo "Waiting for connection ."
sleep 0.5
clear
echo "Waiting for connection .."
sleep 0.5
clear
echo "Waitihg for connection ..."
done

case $1 in
1)
weechat
;;
2)
ssh -p 2202
;;
3)
ssh -p 2204
;;
4)
ssh -p 2210
;;
5)
ssh -p  2211
;;
6)
ssh -p
;;
7)
ssh -p 22
;;
8)
baresip -d -f ~/git/baresip/
;;
9)
sudo iptraf-ng -i wlp2s0
;;
10)
sudo nettop -i wlp2s0
;;
esac

exit 0

