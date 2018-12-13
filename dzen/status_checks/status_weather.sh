#!/bin/sh

cblue="^fg(#92bbd0)"
cgray="^fg(#999999)"
cwhite="^fg(#ffffff)"
cnormal="^fg(#dddddd)"
cred="^fg(#bc4547)"
cyellow="^fg(#a88c29)"
cgreen="^fg(#00aa6c)"
cpurple="^fg(#9542f4)"
cnormal="^fg(#dddddd)"

sunny="^i($HOME/.xmonad/dzen/icons/sunny.xbm)"
rainny="^i($HOME/.xmonad/dzen/icons/rainny.xbm)"
snowy="^i($HOME/.xmonad/dzen/icons/snowy.xbm)"
stormydaniels="^i($HOME/.xmonad/dzen/icons/stormydaniels.xbm)"
cloudy="^i($HOME/.xmonad/dzen/icons/cloudy.xbm)"
partially="^i($HOME/.xmonad/dzen/icons/partially.xbm)"
foggy="^i($HOME/.xmonad/dzen/icons/fog.xbm)"
sunny="^i($HOME/.xmonad/dzen/icons/sunny.xbm)"


temper=$(curl -s wttr.in/leon,spain?lang=es | sed -n 4p | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | perl -nE 'say/([0-9]+)+|([0-9]+)+-+([0-9]+)/' )
forecast=$(curl -s wttr.in/leon,spain?lang=es | sed -n 3p | sed 's/\x1B\[[0-9;]\+[A-Za-z]//g'| sed -e 's/[\"\\\/_..()\*-]//g' | awk '{print $1 " " $2}' | sed -e 's/-//')


case $(echo $forecast | awk '{print $1}') in
 Soleado)
 weaicon="${cyellow}${sunny}"
 ;;
 Cielo)
 weaicon="${cgray}${cloudy}"
 ;;
 Parcialmente)
 weaicon="${cyellow}${sunny}${cgray}${cloudy}"
 ;;
 Niebla)
 weaicon="${cgray}${foggy}"
 ;;
 Neblina)
 weaicon="${cgray}${foggy}"
 ;;
 Despejado)
 weaicon="${cyellow}${sunny}"
 ;;
 Lluvia)
 weaicon="${cgray}${rainny}"
 ;;
 Tormenta)
 weaicon="${cwhite}${stormydaniels}"
 ;;
 Nieve)
 weaicon="${cwhite}${snowy}"
 ;;
esac

echo "${weaicon}${cnormal} ${temper}°${cnormal}" > /tmp/status_weather

#Soleado
#Parcialmente
#Nuboso
#Clear
