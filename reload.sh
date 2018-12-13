#!/bin/bash

dzen2 -dock -x '0' -y '0' -h '18' -w '900' -ta 'l' -fg '#999999' -bg '#000000' -fn '-*-fixed-medium-*-*-*-12-*-*-*-*-*-iso8859-1' &
~/.xmonad/dzen/status_bars/dzen_secondary.sh | dzen2 -dock -x '900' -y '0' -h '18' -w '466' -ta 'r' -fg '#999999' -bg '#000000' -fn '-*-fixed-medium-*-*-*-12-*-*-*-*-*-iso8859-1' &
~/.xmonad/dzen/status_bars/dzen_main.sh | dzen2 -dock -x '0' -w '900' -y '750' -h '18' -fg '#999999' -bg '#000000' -ta 'l' -fn '-*-fixed-medium-*-*-*-12-*-*-*-*-*-iso8859-1' &
~/.xmonad/dzen/status_bars/dzen_audio.sh | dzen2 -dock -x '900' -w '466' -y '750' -h '18' -fg '#999999' -bg '#000000' -ta 'r' -fn '-*-fixed-medium-*-*-*-12-*-*-*-*-*-iso8859-1' &
