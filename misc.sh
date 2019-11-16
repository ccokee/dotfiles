#!/bin/bash

tmux -2 new-session -d -s Misc
tmux rename-window -t Misc Audio
tmux new-window -t Misc -n Music
tmux new-window -t Misc -n cKterm

# ALSA #
tmux send-keys -t Misc:0.0 "pulsemixer" Enter

# Music # 
tmux split-window -t Misc:1 -v -p 80
tmux send-keys -t Misc:1.0 "cava" Enter
tmux send-keys -t Misc:1.1 "ncmpcpp" Enter

# cKpane #
tmux select-window -t Misc:2

tmux -2 attach-session -t Misc
