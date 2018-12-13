#!/bin/bash

export color_main="^fg(#cdc5b3)"
export color_sec1="^fg(#72aca9)"
export color_sec2="^fg(#5a676b)"

export font="-*-terminus-medium-*-*-*-16-*-*-*-*-*-*-u"
#font="Anonymous Pro 16"

fg_color="#cdc5b3"
bg_color="#0e0e0e"

dzen_style="-fg $fg_color -bg $bg_color -fn $font -h 20 -e onstart=lower"

~/.xmonad/dzen/status_bars/dzen_main.sh      | dzen2 -y 0    -x 1000 -w 920  -ta r $dzen_style &
~/.xmonad/dzen/status_bars/dzen_audio.sh     | dzen2 -y 0    -x 0    -w 1000 -ta l $dzen_style &
~/.xmonad/dzen/status_bars/dzen_secondary.sh | dzen2 -y 1180 -x 1470 -w 450  -ta r $dzen_style &

