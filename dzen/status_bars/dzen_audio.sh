#!/bin/bash

#=== Settings ===#
SLEEP=1

cblue="^fg(#92bbd0)"
cgray="^fg(#999999)"
cwhite="^fg(#ffffff)"
cnormal="^fg(#eeeeee)"
cred="^fg(#bc4547)"
cyellow="^fg(#d3b451)"
cgreen="^fg(#00aa6c)"

speaker_icon="^i($HOME/.xmonad/dzen/icons/spkr_01.xbm)"
headphone_icon="^i($HOME/.xmonad/dzen/icons/Headphone.xbm)"
mute_icon="^i($HOME/.xmonad/dzen/icons/mute.xbm)"
mpd_icon="^i($HOME/.xmonad/dzen/icons/mpd.xbm)"
bat_icon="^i($HOME/.xmonad/dzen/icons/battery.xbm)"
ac_icon="^i($HOME/.xmonad/dzen/icons/acmode.xbm)"


blinking=0
blinkcolor="${cred}"

echo "1" >> /tmp/status_audio

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
		}


#=== Loop ===#
while :; do

#battery
battery_percent=$(acpitool | grep -E "Battery" | awk '{print $5}')
battery_percent=${battery_percent:0:3}
if [ "$battery_percent" != "100" ]
then
	battery_percent=${battery_percent:0:2}
fi
ac_power=$(acpitool | grep -E "AC adapter" | awk '{print $4}')
poweric="${ac_icon}"
blinking=$(expr `date +"%s"` % 4)
if [ "$ac_power" == "online" ] 
then
	poweric="${ac_icon}"
	if [ "$battery_percent" == "100" ] 
	then
		blinkcolor="${cgreen}"
	else
		if [ "$blinking" -le "1" ] 
		then
			blinkcolor="${cred}"
		else
			blinkcolor="${cgreen}"
		fi
	fi
else
	poweric="${bat_icon}"
	if [ "$battery_percent" -lt 100 ] 
	then
	blinkcolor="${cgreen}" 
	fi
	if [ "$battery_percent" -lt 35 ] 
	then
	blinkcolor="${cyellow}"
	fi
	if [ "$battery_percent" -lt 15 ] 
	then
	blinkcolor="${cred}"
	fi
fi

battery_format=$(printf "%03s" $battery_percent | sed "s/ /0/g;s/\(^0\+\)/\1${cwhite}/")
powerstat="${blinkcolor}${poweric} ${cgray}${battery_format}${cwhite}%"

# volume
playback=$(amixer get Master | sed -rn '$s/[^[]+\[([0-9]*).*/\1/p')

if [ $playback == "0" ]
then
playback_format="000${cwhite}"
elif [ $playback == "100%" ]
then
playback_format="${white}100"
else
playback_format=$(printf "%03s" $playback | sed "s/ /0/g;s/\(^0\+\)/\1${cwhite}/")
fi

case $(cat /tmp/status_audio) in
 1)
 audio_icon=${mute_icon}
;;
 2)
 audio_icon=${headphone_icon}
;;
 3)
 audio_icon=${speaker_icon}
;;
 4)
 audio_icon=${speaker_icon}
;;
esac

volume="$(colorcho $playback)${audio_icon} ${cgray}${playback_format}${cwhite}%"

# mpd
if [ ! `mpc | grep -o "\[.*\]"` == "[paused]" ]
then
  mpc_current=$(mpc current | sed 's/AnimeNfo Radio | Serving you the best Anime music!: //')
  mpc_current=$(echo $mpc_current | sed 's/AVRO Baroque Around The Clock: //')

  mpd="${cwhite}${mpd_icon} ${cgray}${mpc_current}"
else
  mpd=""
fi

echo "$mpd $volume  $powerstat"

sleep $SLEEP; done
