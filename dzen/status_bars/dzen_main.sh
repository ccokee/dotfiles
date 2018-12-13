#!/bin/bash

# -------------------
# SETTINGS
# -------------------

SLEEP=1

##COLORS
cblue="^fg(#92bbd0)"
cgray="^fg(#999999)"
cwhite="^fg(#ffffff)"
cnormal="^fg(#dddddd)"
cred="^fg(#bc4547)"
cyellow="^fg(#a88c29)"
cgreen="^fg(#00aa6c)"
cpurple="^fg(#9542f4)"

##
brako="${cblue}[${cgray}"
brakc="${cblue}]${cgray}"

eth_icon="^i($HOME/.xmonad/dzen/icons/eth_icon.xbm)"
wifi_icon="^i($HOME/.xmonad/dzen/icons/wifi_icon.xbm)"
vpn_icon="^i($HOME/.xmonad/dzen/icons/vpn_icon.xbm)"
net_down_icon="^i($HOME/.xmonad/dzen/icons/net_down_03.xbm)"
net_up_icon="^i($HOME/.xmonad/dzen/icons/net_up_03.xbm)"
ip_icon="^i($HOME/.xmonad/dzen/icons/wired.xbm)"
fs_icon="^i($HOME/.xmonad/dzen/icons/diskette.xbm)"
tor_icon="^i($HOME/.xmonad/dzen/icons/tor.xbm)"
hostapd_icon="^i($HOME/.xmonad/dzen/icons/hostapd_icon.xbm)"
nat_icon="^i($HOME/.xmonad/dzen/icons/natbride.xbm)"

cpu_icon="^i($HOME/.xmonad/dzen/icons/cpu.xbm)"
mem_icon="^i($HOME/.xmonad/dzen/icons/mem.xbm)"

blinking=0
blinkcolor=cred
blink=101

counter2=0
# -------------------
# FUNCTIONS
# -------------------
function wrapper {
if [ $1 -eq 0 ]
then
echo "000${cwhite}"
elif [ ${#1} -ge 3 ]
then
echo "${cwhite}$1"
else
echo $(printf "%03d" $1 | sed "s/\(^0\+\)/\1${cwhite}/")
fi
                 }

function wrapper_net {
if [ ${#1} -ge 4 ]
then
echo "${cwhite}$1"
else
echo $(printf "%04s" $1 | sed "s/ /0/g;s/\(^0\+\)/\1${cwhite}/")
fi
                     }

function colorcho {
if [ $1 -ge 0 ] && [ $1 -lt 50 ]
then
 echo "${cgreen}"
fi
if [ $1 -ge 50 ] && [ $1 -lt 75 ]
then
 echo "${cyellow}"
fi
if [ $1 -ge 75 ] && [ $1 -le 100 ]
then
 echo "${cred}"
fi
if [ $1 -eq 101 ]
then
 echo "${cwhite}"
fi
		}

### network speed ###
# Global variables
interface=enp1s0
received_bytes=""
old_received_bytes=""
transmitted_bytes=""
old_transmitted_bytes=""

# This function parses /proc/net/dev file searching for a line containing $interface data.
# Within that line, the first and ninth numbers after ':' are respectively the received and transmited bytes.
get_bytes()
{
transmitted_bytes=$(cat /sys/class/net/$interface/statistics/tx_bytes)
received_bytes=$(cat /sys/class/net/$interface/statistics/rx_bytes)
}

get_velocity()
{
    let vel=$1-$2

    if [ $vel -ge 1024 ] && [ $vel -lt 1048576 ] ;
    then
      velKB=$[vel/1024];
      echo "$(wrapper_net $velKB)K";
    elif [ $vel -ge 1048576 ];
    then
      velMB=$(echo "scale=1; $vel/1048576" | bc)
      echo "$(wrapper_net $velMB)M";
    else
      echo "$(wrapper_net $vel)B";
    fi
}

# Gets initial values.
get_bytes
old_received_bytes=$received_bytes
old_transmitted_bytes=$transmitted_bytes

# cpu
PREV_TOTAL=0
PREV_IDLE=0

counter=0
previous=0
netact=0

~/.xmonad/ipswitch.sh

# ----------------------
# LOOP
# ----------------------
while :; do

# network

if [ "$(ip addr show dev enp1s0 | sed -n 3p | awk '{print $1}')" == "inet" ]
then
interface=enp1s0
counter=$(($counter + 1))
fi

if [ "$(ip addr show dev wlp2s0 | sed -n 3p | awk '{print $1}')" == "inet" ]
then
interface=wlp2s0
counter=$(($counter + 2))
fi
if [ -d /sys/class/net/tun0 ]; then
 if [ "$(ip addr show dev tun0 | sed -n 3p | awk '{print $1}')" == "inet" ]
  then
  interface=tun0
  fi
fi



get_bytes

vel_recv=$(get_velocity $received_bytes $old_received_bytes)
vel_trans=$(get_velocity $transmitted_bytes $old_transmitted_bytes)

network_speed_down="${cgreen}${net_down_icon} ${cgray}$vel_recv"
network_speed_up="${cred}${net_up_icon} ${cgray}$vel_trans"

if [ "$interface" == "tun0" ]
then
vpn_status="${cgreen}"
else
vpn_status="${cred}"
fi

vpn="${vpn_status}${vpn_icon}${cnormal}"

if [ "$(rc-service tor status | awk '{print $3}')" == "started" ]; then
tor_status=${cpurple}
else
tor_status=${cgray}
fi

tor="${tor_status}${tor_icon}${cnormal}"

if [ "$(rc-service dnsmasq status | awk '{print $3}')" == "started" ]; then
nat_status=${cgreen}
else
nat_status=${cgray}
fi

nat="${nat_status}${nat_icon}${cnormal}"

if [ "$(rc-service hostapd status | awk '{print $3}')" == "started" ]; then
hostapd_status=${cblue}
else
hostapd_status=${cgray}
fi

hostapd="${hostapd_status}${hostapd_icon}${cnormal}"


case $counter in
1)
 conntype="${cgreen}${eth_icon} ${cred}${wifi_icon} ${cnormal}"
 ;;
2)
 conntype="${cred}${eth_icon} ${cgreen}${wifi_icon}${cnormal}"
 ;;
3)
 conntype="${cgreen}${eth_icon} ${wifi_icon}${cnormal}"
 ;;
0)
 conntye="${cred}${eth_icon} ${wifi_icon}${cnormal}"
 ;;
esac 

old_received_bytes=$received_bytes
old_transmitted_bytes=$transmitted_bytes

if [ $previous -ne $counter ]
then
 changes=1
fi

if [ $counter2 -eq 0 -o $changes -eq 1 -o $netact == 0 ] 
then
 if wget -q --spider http://google.com
 then
  ippub="${cgray}$(curl ipinfo.io/ip)"
  netact=1
 else
  blink=99
  ippub="0.0.0.0"
  netact=0
 fi
fi

if [ "$(cat /tmp/status_ip)" == "0"  ]; then
ipselect=$ippub
else
ipselect="${cgray}$(ifconfig ${interface} | sed -n 2p | awk '{print $2}')"
fi


ipbracket="^ca(1,/home/coke/.xmonad/ipswitch.sh)$(colorcho $blink)${ip_icon}${ipselect}^ca()"

# disk
root_used=$(df / | grep -Eo '[0-9]+%' | sed s/%//)
data_total=$(free | sed -n 3p | awk '{print $2}')
data_used=$(free | sed -n 3p | awk '{print $3}')
data_percent=$(($data_used * 100))
if [ "$data_used" == "0" ]
then
data_used=1
fi
data_percent=$(($data_percent / $data_total))
storage_used=$(df /dev/sda1 | grep -Eo '[0-9]+%' | sed s/%//)
homesize=$(du -hs $HOME | awk '{print $1}' | sed s/[A-Z]//)


root="$(colorcho $root_used)${fs_icon} ${cgray}ROOT $(wrapper $root_used)%"
data="$(colorcho $data_percent)${fs_icon} ${cgray}SWAP $(wrapper $data_percent)%"
storage="$(colorcho $storage_used)${fs_icon} ${cgray}BOOT $(wrapper $storage_used)%"
home="${color_sec1}${fs_icon} /home ${color_sec2}$(wrapper $homesize)G"

# cpu
CPU=(`cat /proc/stat | grep '^cpu '`) # Get the total CPU statistics.
unset CPU[0]                          # Discard the "cpu" prefix.
IDLE=${CPU[4]}                        # Get the idle CPU time.

# Calculate the total CPU time.
TOTAL=0
for VALUE in "${CPU[@]}"; do
  let "TOTAL=$TOTAL+$VALUE"
done

# Calculate the CPU usage since we last checked.
let "DIFF_IDLE=$IDLE-$PREV_IDLE"
let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"

# Remember the total and idle CPU times for the next check.
PREV_TOTAL="$TOTAL"
PREV_IDLE="$IDLE"

cpu="$(colorcho $DIFF_USAGE)${cpu_icon}${cgray} $(wrapper ${DIFF_USAGE})%"

# memory
memory_total=$(free -m | awk 'FNR == 2 {print $2}')
memory_used=$(free -m | awk 'FNR == 2 {print $3}')
memory_free_percent=$[$memory_used * 100 / $memory_total]
mem="$(colorcho $memory_free_percent)${mem_icon}${cgray} $(wrapper ${memory_free_percent})%"

echo -e "$network_speed_down $network_speed_up $ipbracket ${cgray}| $conntype ^ca(1,sudo ${HOME}/vpnswitch.sh)${vpn}^ca() ^ca(1,sudo ${HOME}/.xmonad/torswitch.sh)${tor}^ca() ^ca(1,sudo ${HOME}/.xmonad/natswitch.sh)${nat}^ca() ^ca(1,sudo {$HOME}/.xmonad/hostapdswitch.sh)${hostapd}^ca() ${cgray}| $cpu $mem ${cgray}| $root $storage $data"

previous=$counter
counter=0
counter2=$(( $counter2 + 1 ))
modulo=$(($counter2 % 2))
if [ "$modulo" == "0" -a "$netact" == "1" ]
then
   blink=101
else
   blink=1
fi
if  [ $counter2 -eq 3600 -o $changes -eq 1 ]
then
 counter2=0
 changes=0
fi
sleep $SLEEP; done
