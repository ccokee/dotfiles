#!/bin/sh
WNAME="irssi"
if ! tmux -L default attach-session -t ${WNAME}; then
    tmux new-session -d -s ${WNAME} 'irssi'
    tmux split-window -t ${WNAME} -p 12 -h 'sleep 1 && cat ~/.irssi/nicklistfifo'
    tmux select-pane -L
    "${0}"
fi
