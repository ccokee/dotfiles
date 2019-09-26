#!/bin/bash

tmux -2 new-session -d -s Misc
tmux rename-window -t Misc Audio
tmux new-window -t Misc -n Music
tmux new-window -t Misc -n cKterm

# ALSA #
tmux select-window -t Misc:0
tmux split-window -v -p 50
tmux select-pane -t 0
tmux send-keys "alsamixer -c 0" Enter
tmux select-pane -t 1
tmux send-keys "alsamixer -D bluealsa" Enter

# Music # 
tmux select-window -t Misc:1
tmux split-window -v -p 80
tmux select-pane -t 0
tmux send-keys "cava" Enter
tmux select-pane -t 1
tmux send-keys "ncmpcpp" Enter

# cKpane #
tmux select-window -t Misc:2

tmux -2 attach-session -t Misc
